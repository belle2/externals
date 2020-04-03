#!/usr/bin/env python3

"""
Make python installation relocatable which mainly involves fixing the shebang
in scripts installed by pip and making directories in .pth and .egg-link files
in the path relative.

Mostly stolen from virtualenv but slightly adapted to our needs
"""

import sys
import os
import itertools
import re


def fixup_scripts(path):
    """Go through a directory and make the #!...python shebang line relocatable
    by replacing an absolute path to the interpreter with a short version with
    the correct version
    """
    re_shebang = re.compile("^#!.*python.*")
    new_shebang = "#!/usr/bin/env python%d.%d%s" % (sys.version_info.major, sys.version_info.minor, sys.abiflags)
    for filename in os.listdir(path):
        filename = os.path.join(path, filename)
        if not os.path.isfile(filename):
            # ignore subdirs, e.g. .svn ones.
            continue

        # FIXME: same for madgraph
        if os.path.basename(filename) == "mg5_aMC":
            continue

        with open(filename, 'rb') as f:
            try:
                lines = f.read().decode('utf-8').splitlines()
            except UnicodeDecodeError:
                # This is probably a binary program instead
                # of a script, so just ignore it.
                continue

        if not lines:
            # empty file, continue
            continue

        old_shebang = lines[0].strip()
        if old_shebang != new_shebang and re_shebang.match(old_shebang):
            # has a python shebang which is different from what it should be, fix it
            # print("%s: changing shebang from '%s' to '%s'" % (filename, old_shebang, new_shebang))
            print("making %s relocatable" % filename)
            lines[0] = new_shebang
            with open(filename, 'wb') as f:
                f.write("\n".join(lines).encode('utf-8'))


def fixup_pth_and_egg_link(basedir):
    """Makes .pth and .egg-link files use relative paths"""
    for path in sys.path:
        if not path or not os.path.isdir(path):
            continue
        path = os.path.normcase(os.path.abspath(path))
        if not path.startswith(basedir):
            # print('Skipping system (non-environment) directory %s' % path)
            continue

        fixup_scripts(path)
        for filename in os.listdir(path):
            filename = os.path.join(path, filename)
            if filename.endswith('.pth'):
                if not os.access(filename, os.W_OK):
                    print('Cannot write .pth file %s, skipping' % filename)
                else:
                    fixup_pth_file(filename)
            if filename.endswith('.egg-link'):
                if not os.access(filename, os.W_OK):
                    print('Cannot write .egg-link file %s, skipping' % filename)
                else:
                    fixup_egg_link(filename)


def fixup_pth_file(filename):
    """Fix up .pth files which name additional directories to be included in the path"""
    lines = []
    prev_lines = []
    f = open(filename)
    prev_lines = f.readlines()
    f.close()
    for line in prev_lines:
        line = line.strip()
        if (not line or line.startswith('#') or line.startswith('import ') or os.path.abspath(line) != line):
            lines.append(line + "\n")
        else:
            new_value = make_relative_path(filename, line)
            if line != new_value:
                print('Rewriting path %s as %s (in %s)' % (line, new_value, filename))
            lines.append(new_value + "\n")
    if lines == prev_lines:
        # print('No changes to .pth file %s' % filename)
        return
    print('Making paths in .pth file %s relative' % filename)
    f = open(filename, 'w')
    f.writelines(lines)
    f.close()


def fixup_egg_link(filename):
    """Fix up .egg-link files which could exist to link to other directories."""
    f = open(filename)
    link = f.readline().strip()
    f.close()
    if os.path.abspath(link) != link:
        print('Link in %s already relative' % filename)
        return
    new_link = make_relative_path(filename, link)
    print('Rewriting link %s in %s as %s' % (link, filename, new_link))
    f = open(filename, 'w')
    f.write(new_link)
    f.close()


def make_relative_path(source, dest, dest_is_directory=True):
    """
    Make a filename relative, where the filename is dest, and it is
    being referred to from the filename source.

        >>> make_relative_path('/usr/share/something/a-file.pth',
        ...                    '/usr/share/another-place/src/Directory')
        '../another-place/src/Directory'
        >>> make_relative_path('/usr/share/something/a-file.pth',
        ...                    '/home/user/src/Directory')
        '../../../home/user/src/Directory'
        >>> make_relative_path('/usr/share/a-file.pth', '/usr/share/')
        '.'
    """
    source = os.path.dirname(source)
    if not dest_is_directory:
        dest_filename = os.path.basename(dest)
        dest = os.path.dirname(dest)

    dest = os.path.normpath(os.path.abspath(dest))
    source = os.path.normpath(os.path.abspath(source))
    return os.path.relpath(dest, source)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: %s $PREFIX [$BINDIR] [additional dirs...]" % sys.argv[0])
        sys.exit(1)
    basedir = os.path.abspath(sys.argv[1])
    # fix absolute links and references in the full sys.path that is inside the base dir
    fixup_pth_and_egg_link(basedir)
    # amd also fixup scripts in bin dir
    for path in sys.argv[2:]:
        path = os.path.normcase(os.path.abspath(path))
        if not path.startswith(basedir):
            # print('Skipping system (non-environment) directory %s' % path)
            continue
        fixup_scripts(path)
