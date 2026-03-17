#!/usr/bin/env python3

"""
Parse the diff of the ``README.md`` tables from stdin and extract the package
version changes.

The script expects lines prefixed with:
  - "-" for old versions
  - "+" for new versions

It compares both sets and prints a reStructuredText table listing packages
with changed versions.

Typical usage:
    git diff TAG1 TAG2 -- README.md | ./tools/diff_to_table.py
"""

import re
import sys
from typing import Dict, Tuple


def parse_line(line: str) -> Tuple[str, str]:
    """
    Parse a single table row and extract package name and version.

    The input line is expected to be a markdown table row like:
        | package | version | ...     |        # for non-python packages
        | package | ...     | version | ... |  # for python packages

    It also strips markdown links from package names.

    Returns:
        (package_name, version)
    """
    cols = [c.strip() for c in line.split("|")[1:-1]]
    pkg = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", cols[0]).strip()
    if len(cols) == 3:
        version = cols[1]  # non-python packages
    else:
        version = cols[2]  # python packages
    return pkg, version


def collect_versions() -> Tuple[Dict[str, str], Dict[str, str]]:
    """
    Read stdin and collect old and new package versions.

    Returns:
        (old_versions, new_versions)
    """
    old_versions: Dict[str, str] = {}
    new_versions: Dict[str, str] = {}
    for raw_line in sys.stdin:
        line = raw_line.rstrip()
        # Only consider rows that look like markdown table entries
        if line.count("|") not in (4, 5):
            continue
        if line.startswith("-|"):
            pkg, ver = parse_line(line[1:])
            old_versions[pkg] = ver
        elif line.startswith("+|"):
            pkg, ver = parse_line(line[1:])
            new_versions[pkg] = ver
    return old_versions, new_versions


def compute_updates(
    old_versions: Dict[str, str],
    new_versions: Dict[str, str],
):
    """
    Compare old and new versions and return a sorted list of changes.

    Returns:
        List of tuples: (package, old_version, new_version)
    """
    all_pkgs = set(old_versions) | set(new_versions)
    updates = []
    for pkg in all_pkgs:
        old_ver = old_versions.get(pkg, "")
        new_ver = new_versions.get(pkg, "")
        # Only include packages where the version changed
        if old_ver != new_ver:
            updates.append((pkg, old_ver, new_ver))
    # Case-insensitive sorting for nicer output
    updates.sort(key=lambda x: x[0].casefold())
    return updates


def print_rst_table(updates):
    """
    Print the updates as a reStructuredText list-table.
    """
    print(""".. admonition:: New and updated packages in externals
   :class: dropdown

   .. list-table:: New and updated packages in externals
      :widths: 50 25 25
      :header-rows: 1

      * - package
        - old version
        - new version""")

    for pkg, old, new in updates:
        print(f"""      * - {pkg}
        - {old}
        - {new}""")


def main():
    """The entry point."""
    old_versions, new_versions = collect_versions()
    updates = compute_updates(old_versions, new_versions)
    print_rst_table(updates)


if __name__ == "__main__":
    main()
