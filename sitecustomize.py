#!/usr/bin/env python3.6m

import os
import site
try:
    from site import getsitepackages
except ImportError:
    import sys

    def getsitepackages(prefixes):
        """Minimal copy of site.getsitepackages due to https://github.com/pypa/virtualenv/issues/355"""
        sitepackages = []

        for prefix in prefixes:
            if os.sep == '/':
                sitepackages.append(os.path.join(prefix, "lib",
                                                 "python%d.%d" % sys.version_info[:2],
                                                 "site-packages"))
            else:
                sitepackages.append(prefix)
                sitepackages.append(os.path.join(prefix, "lib", "site-packages"))

        return sitepackages

# make sure the corresponding opt/debug part of the externals is also in the path
if "BELLE2_EXTERNALS_DIR" in os.environ:

    for site_dir in getsitepackages([os.path.expandvars("$BELLE2_EXTERNALS_DIR/$BELLE2_EXTERNALS_SUBDIR")]):
        if os.path.exists(site_dir):
            site.addsitedir(site_dir)

# add the python-packages in the release or local directory to the path
for var in ("BELLE2_RELEASE_DIR", "BELLE2_LOCAL_DIR"):
    if var in os.environ:
        local_packages = os.path.join(os.environ[var], "python-packages")
        if os.path.exists(local_packages):
            site.addsitedir(local_packages)
