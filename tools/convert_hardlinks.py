#!/usr/bin/env python3

"""
Convert hardlinks to softlinks as CVMFS seems to have problems with hardlinks

Call as
    convert_hardlinks.py [DIRECTORY...]

to convert all hardlinks found in directory to softlinks. The script will fail
if not all links to a given file kann be found in DIRECTORY
"""

import os
import sys
from collections import defaultdict

# remember all filenames pointing to a given inode
links = defaultdict(list)
# and the amount of links the inode should have
counts = {}
# now walk through all specified directories and look for files with a link
# count > 1
for argument in sys.argv[1:]:
    for dirname, dirnames, filenames in os.walk(argument):
        for filename in filenames:
            full_path = os.path.abspath(os.path.join(dirname, filename))
            try:
                stat = os.stat(full_path, follow_symlinks=False)
            except FileNotFoundError:
                print("Warning: cannot stat %s, broken link?" % full_path)
                continue
            if stat.st_nlink > 1:
                # found a hardlink, remember inode -> [filenames,...] and the
                # amount of links we should find
                links[stat.st_ino].append(full_path)
                counts[stat.st_ino] = stat.st_nlink

# now we now all hardlinks so convert them to softlinks
for inode, files in links.items():
    if len(files) != counts[inode]:
        print(
            "ERROR: inode %d has link count %d but only %d links have been found"
            % (inode, counts[inode], len(files))
        )
        for filename in files:
            print(filename)
        sys.exit(1)
    # sort the links. We will pick the first as source for all links. In
    # principle it's not important which order we choose but when sorting by
    # reverse it happens that the more specific filenames (like
    # x86_64-unknown-linux-gnu-gcc-ar) will be used as source for the more
    # general ones (gcc-ar)
    files.sort(reverse=True)
    source = files.pop(0)
    # now create relative symlinks for all targets
    for target in files:
        target_dir, target_fnm = os.path.split(target)
        rel_source = os.path.relpath(source, target_dir)
        print("Replacing %s by symlink to %s" % (os.path.relpath(target), rel_source))
        os.unlink(target)
        os.symlink(rel_source, target)
