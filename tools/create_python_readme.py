#!/usr/bin/env python3

"""
This script will loop over all installed pip packages except pip and setuptools
and create a requirements file including hashes
"""

import pip


def externals_packages():
    """Get the list of packages from the requirement file"""
    packages = set()
    for line in open("pip-requirements.txt"):
        if line.find("==") > 0:
            packages.add(line.split("==")[0].strip())
    return packages


def get_link(name):
    """return markdown link to pypi"""
    return "[{0}](https://pypi.python.org/pypi/{0})".format(name)


if __name__ == "__main__":
    wanted = externals_packages()
    wanted.remove("pip")
    wanted.remove("setuptools")
    infos = list(pip.commands.show.search_packages_info(wanted))
    for i in infos:
        i["link"] = get_link(i["name"])
        if i["license"] is None:
            i["license"] = "None"
    widths = {}
    for key, minwidth in ("link", 4), ("summary", 7), ("version", 7), ("license", 7):
        widths["max_"+key] = max(minwidth, max(len(e[key]) for e in infos))

    print("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} | {license:{max_license}} |".format(link="Name", summary="Summary", version="Version", license="License", **widths))
    print("|-{link:-<{max_link}}-|-{summary:-<{max_summary}}-|-{version:-<{max_version}}-|-{license:-<{max_license}}-|".format(link="", summary="", version="", license="", **widths))
    for i in sorted(infos, key=lambda x: x['name'].lower()):
        print("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} | {license:{max_license}} |".format(**i, **widths))
