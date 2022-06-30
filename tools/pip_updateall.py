#!/usr/bin/env python3

"""
This script will loop over all installed pip packages and update them to the
latest available version
"""

import pkg_resources
import subprocess

if __name__ == "__main__":
    pip_args = ["pip", "install", "-U", "--upgrade-strategy=only-if-needed"]
    for pkg in sorted(pkg_resources.working_set, key=lambda x: x.project_name.lower()):
        # skip pip
        if pkg.project_name in ["pip", "setuptools"]:
            continue
        subprocess.run(["python3", "-m", *pip_args, *[pkg.project_name]])
