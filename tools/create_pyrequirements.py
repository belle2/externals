#!/usr/bin/env python3

"""
This script will loop over all installed pip packages except pip and setuptools
and create a requirements file including hashes
"""

import tempfile
import sys
import pip
import os
from contextlib import contextmanager

@contextmanager
def clean_working_directory():
    """Context manager to create a temporary directory and directly us it as
    current working directory"""
    dirname = os.getcwd()
    try:
        with tempfile.TemporaryDirectory() as tempdir:
            os.chdir(tempdir)
            yield tempdir
    finally:
        os.chdir(dirname)

if __name__ == "__main__":
    download_args = ['download', '--disable-pip-version-check', '-d', '.', '--no-deps']
    with open(sys.argv[1], "w") as output:
        for pkg in sorted(pip.get_installed_distributions(), key=lambda x: x.project_name.lower()):
            # skip pip
            if pkg.project_name in ["pip", "setuptools"]:
                continue
            name = "%s==%s" % (pkg.project_name, pkg.version)
            lines = [name]
            with clean_working_directory():
                # download
                pip.main(download_args + [name, "--no-binary=:all:"])
                pip.main(download_args + [name])
                for filename in os.listdir():
                    hash = pip.commands.hash._hash_of_file(filename, "sha256")
                    lines.append("--hash=sha256:%s" % hash)
            print(" \\\n    ".join(lines), file=output)
