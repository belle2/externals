#!/usr/bin/env python3

"""
This script will loop over all installed pip packages and update them to the
latest available version
"""

import pip

if __name__ == "__main__":
    pip_args = ['install', '-U']
    for pkg in sorted(pip.get_installed_distributions(), key=lambda x: x.project_name.lower()):
        # skip pip
        if pkg.project_name in ["pip", "setuptools"]:
            continue
        pip.main(pip_args + [pkg.project_name])
