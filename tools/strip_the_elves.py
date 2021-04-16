#!/usr/bin/env python3

"""
Command line utility to find all elf binaries in a given folder and strip them.
If they have debug information it will be split into separate files.

The separate files fill be placed in a `.debug` directory in the same directory
as the binary itself. This is the simplest way for gdb and other tools to find
this info automatically and not polluting the PATH with debug files.

This script doesn't handle hard links correctly because we know we replace
hardlinks by softlinks before running it. We could expand this if necessary.
"""

import os
import pathlib
import sys
import stat
import re
import argparse
import subprocess
import logging
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor as PoolExecutor
from contextlib import contextmanager

@contextmanager
def make_writable(filename):
    """Make ELF files temporarily writable for stripping or debuglinking"""
    # check permissions
    mode = stat.S_IMODE(filename.stat().st_mode)
    # make writeable
    filename.chmod(mode | stat.S_IWUSR)
    # run context
    yield filename
    # and reset permissions
    filename.chmod(mode)

class ElfStripper:
    ELF_TYPE = re.compile(r'^\s+Type:\s*(\S*)', re.M)
    ELF_SECTION = re.compile(r'^\s+\[\s*\d*\]\s+(\S*)', re.M)

    def __init__(self, compress):
        #: arguments to strip. The -R are copied from https://github.com/gentoo/portage/blob/master/bin/estrip
        self.__strip = ["objcopy", "--strip-unneeded", "-R", ".comment", "-R", ".GCC.command.line", "-R", ".note.gnu.gold-version"]
        #: arguments when splitting debug output
        self.__split = ["objcopy", "--only-keep-debug"]
        if compress:
            self.__split.append("--compress-debug-sections")
        #: arguments to add a debuglink to split debug info
        self.__add_debuglink = ["objcopy", "--add-gnu-debuglink"]

    def get_fileinfo(self, filename):
        """Return a tuple with parsed output from readelf

        * the type of the binary from the ELF header (EXEC, DYN, REL, ...)
        * a set with all section names available in the file

        On error return None, {}
        """
        try:
            output = subprocess.check_output(['readelf', '-hSW', filename], stderr=subprocess.DEVNULL, encoding="utf8")
            elftype = self.ELF_TYPE.search(output).group(1)
            elfsections = {e[1] for e in self.ELF_SECTION.finditer(output) if e[1] != 'NULL'}
            return elftype, elfsections
        except subprocess.CalledProcessError:
            # most likely not an elf file
            pass
        except Exception as e:
            logging.debug(f"Exception reading elf for '{filename}'", exc_info=e)
            logging.warn(f"Problem reading elf information for '{filename}': {e}")
        return None, {}

    def strip(self, filename):
        """Strip all unneeded symbols"""
        logging.info(f"stripping {filename}")
        try:
            with make_writable(filename):
                subprocess.check_call(self.__strip + [str(filename)])
        except Exception as e:
            logging.error(f"Problem stripping {filename}: {e}")
            return None
        return filename

    def split_debuginfo(self, filename):
        """Split the debuging information from the file and then strip the file itself"""
        logging.info(f"splitting debug info for {filename}")
        try:
            # Must split the file & add debuglink in the current directory
            # per https://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html
            debugfilename = f"{filename.name}.dbg"
            debugfile = filename.parent / debugfilename
            subprocess.check_call(self.__split + [str(filename), str(debugfile)])
            with make_writable(filename):
                subprocess.check_call(self.__add_debuglink + [debugfilename, str(filename.name)], cwd=filename.parent)

            # move the debug file to its final location
            debugdir = filename.parent / ".debug"
            debugdir.mkdir(exist_ok=True)
            debugfile.rename(debugdir / debugfilename)
            debugfile = debugdir / debugfilename

            # only allow reading debug files
            debugfile.chmod(0o444)
        except Exception as e:
            logging.error(f"Problem splitting debug info for {filename}: {e}")
            return None
        # ok we split debug info, now let's definitely strip the original one
        return self.strip(filename), debugfile

    def __call__(self, filename):
        elftype, sections = self.get_fileinfo(filename)
        # let's not strip .a or .o files or anything not an elf ... just
        # executables and dynamic libraries.
        if elftype not in ["EXEC", "DYN"]:
            logging.debug(f"{filename} not executable or shared library")
            return None

        # OK check if we have something which looks like debug info and if yes
        # split it
        if '.debug_info' in sections or '.debug_line' in sections:
            return self.split_debuginfo(filename)
        # otherwise just strip ... unless it is already stripped, aka no symbol
        # table in the file
        elif '.symtab' in sections:
            return self.strip(filename)
        else:
            # nothing to do
            logging.debug(f"{filename} already stripped")
            return None


class DWZRunner:
    def __init__(self, binary):
        self.__binary = binary

    def __call__(self, files):
        """Run dwz on a list of files in a directory"""
        logging.info(f"Running dwz in {files[0].parent}")
        try:
            common = []
            extra = []
            # if we have multiple debug files created we can try to let dwz move
            # repeated debug info in a common file
            if len(files) > 1:
                common = [files[0].parent / "common.dwz"]
                extra = ["-rm"] + common

            subprocess.check_call([self.__binary, "-qh"] + extra + [str(e) for e in files])
            # return the list of files plus the common file if any was created
            return common + files
        except Exception as e:
            logging.error(f"Problem running dwz: {e}")
            # so let's assume the files have not been modified
            return files

    def compress_debug(self, filename):
        """dwz doesn't work with compressed debug sections (yet). So we need to
        create the debug files uncompressed and then later after dwz is done
        just compress them. Done in an extra function here so that we can
        actuall use multi threading for this"""
        if not filename.is_file():
            return
        try:
            logging.info(f"compress debug sections in {filename}")
            subprocess.check_call(["objcopy", "--compress-debug-sections", str(filename)])
        except Exception as e:
            logging.error(f"Problem compressing debug sections in {filename}: {e}")


def scantree(path, excluded):
    """Recursively yield DirEntry objects for given directory."""
    for entry in os.scandir(path):
        if entry.is_symlink():
            continue
        if entry.is_dir():
            if entry.name not in excluded:
                yield from scantree(entry.path, excluded)
        else:
            yield entry


if __name__ == "__main__":
    # ok, overwrite locale to make sure parsing of output works
    os.environ['LC_ALL'] = 'C'

    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("target_dir", help="Target Directory to look for elf objects to strip")
    parser.add_argument("-j", "--threads", type=int, default=1, help="Number of threads to use")
    parser.add_argument("-e", "--exclude", default=[], action="append",
                        help="Filename relative to TARGET_DIR which should not be stripped")
    parser.add_argument("--exclusion-file", help="A file containing one file per line "
                        "(relative to TARGET_DIR) that should not be stripped")
    parser.add_argument("-c", "--compress", default=False, action="store_true",
                        help="If true compress debug sections using zlib")
    parser.add_argument("--use-dwz", default=False, action="store_true",
                        help="If given use the dwz utility to compress the created "
                        "debug information. Implies --compress. If dwz cannot be "
                        "found it will fall back to just --compress")
    parser.add_argument("--dwz-binary", help="Specify the location of the dwz binary. Implies --use-dwz")
    # default log levels are evenly spaced so we just add/subtract them due to
    # laziness :D
    parser.add_argument("-v", "--verbose", dest="log_level", default=[logging.INFO],
                        action="append_const", const=-logging.DEBUG,
                        help="Increase verbosity by one level, can be given multiple times")
    parser.add_argument("-q", "--quiet", dest="log_level", action="append_const", const=logging.DEBUG,
                        help="Decrease verbosity by one level, can be given multiple times")

    # parse arguments and setup logging
    args = parser.parse_args()
    logging.basicConfig(level=max(logging.DEBUG, min(logging.ERROR, sum(args.log_level))),
                        format="[%(levelname)s] %(message)s")

    # non negative number of threads please
    if args.threads < 1:
        logging.critical("Number of threads must be at least 1")
        sys.exit(1)

    # load exclusion file and add to exclusion arguments if given
    if args.exclusion_file is not None:
        try:
            args.exclude += (e.strip() for e in open(args.exlusion_file).readlines())
        except Exception as e:
            logging.critical(f"problem with exclusion file {args.exclusion_files}: {e}")
            sys.exit(1)

    # check if target_dir is actually a directory
    target_dir = pathlib.Path(args.target_dir).absolute()
    if not target_dir.is_dir():
        logging.critical(f"'{target_dir}' is not a directory")
        sys.exit(1)

    # make sure dwz is usable if so desired
    if args.dwz_binary is not None:
        args.use_dwz = True
        args.dwz_binary = os.path.abspath(args.dwz_binary)
    elif args.use_dwz:
        # and find it if necessary
        import shutil
        args.dwz_binary = shutil.which("dwz")
        if args.dwz_binary is None:
            logging.warn("couldn't find dwz executable, falling back to normal compression")
            args.compress = True
            args.use_dwz = False

    # ok, final round: make sure we can call dwz
    if args.use_dwz:
        try:
            subprocess.check_call([args.dwz_binary, '-v'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except Exception as e:
            logging.critical(f"error executing dwz: {e}")
            sys.exit(1)
        # don't do both: only use dwz so no need to compress when stripping
        args.compress = False

    # change into target dir to make sure all following operations can be logged
    # relative to that
    os.chdir(target_dir)
    # and create a list of all files excluding files in .debug directories and
    # __pycache__ dirs
    all_files = [pathlib.Path(e.path) for e in scantree(".", [".debug", "__pycache__"])]
    # filter excluded
    all_files = [e for e in all_files if str(e) not in args.exclude]

    # ok great, these are all candidates for stripping but only if they're elf
    # binaries and contain debug info. But this requires actually reading the
    # files and executing programs so do it in threads
    stripper = ElfStripper(args.compress)
    dwz = DWZRunner(args.dwz_binary)
    debug_dirs = defaultdict(list)
    with PoolExecutor(max_workers=args.threads or 1) as pool:
        results = pool.map(stripper, all_files)
        # consume results to trigger exceptions
        for e in results:
            # if it returned a tuple it means we have created debug info files
            # so fill a dictionary with all the files created per directory. We
            # let dwz optimize all files in one directory together and create
            # one common debug info file in each
            if isinstance(e, tuple):
                stripped, debug = e
                debug_dirs[debug.parent].append(debug)

        # if we created at least one debug dir try to run dwz
        if debug_dirs and args.use_dwz:
            # run dwz once for all files in each directory
            result = pool.map(dwz, debug_dirs.values())
            # and create a flat list of all debug files
            all_debug_files = sum(result, [])
            # compress them all and consume iterator to fire any pending exception
            final = list(pool.map(dwz.compress_debug, all_debug_files))
