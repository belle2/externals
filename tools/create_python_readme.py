#!/usr/bin/env python3

"""
This script will loop over all installed pip packages except pip and setuptools
and create a requirements file including hashes
"""

import pip


def get_link(name):
    """return markdown link to pypi"""
    return "[{0}](https://pypi.python.org/pypi/{0})".format(name)

if __name__ == "__main__":
    pkg = [e.project_name for e in pip.get_installed_distributions() if e.project_name not in ["pip", "setuptools"]]
    infos = list(pip.commands.show.search_packages_info(pkg))
    for i in infos:
        i["link"] = get_link(i["name"])
    widths = {}
    for key, minwidth in ("link", 4), ("summary", 7), ("version", 7):
        widths["max_"+key] = max(minwidth, max(len(e[key]) for e in infos))

    print("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} |".format(link="Name", summary="Summary", version="Version", **widths))
    print("|-{link:-<{max_link}}-|-{summary:-<{max_summary}}-|-{version:-<{max_version}}-|".format(link="", summary="", version="", **widths))
    for i in sorted(infos, key=lambda x: x['name'].lower()):
        print("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} |".format(**i, **widths))
