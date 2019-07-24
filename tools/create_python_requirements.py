#!/usr/bin/env python3

"""
Utility to compile the requirements-*.txt file with consistent dependencies

This script takes the requirements-*.in and tries to compile a fully pinned set
of requirement files with all requirements between packages fulfilled.

To upgrade all python packages to the latest version just run it with
`--upgrade`. To just add a python package just add it unpinned to the .in and
the .txt files and run without the upgrade option.
"""

import subprocess
import sys
import re
import os
import requests
import argparse


def get_annotations(filename):
    """Get the `# via package` annotations from previously pinned requirements.txt files"""
    result = {}
    pkg = re.compile(r"^(.*?)==(.*?)\s*\\?$")
    comment = re.compile(r"#\s*(.*)$")
    with open(filename) as f:
        package = None
        for line in f:
            m = pkg.match(line)
            if m:
                package = m.groups()
            m = comment.search(line)
            if m:
                result[package[0]] = m.group(1)
    return result


def get_info(name, version):
    """Get JSON information for a package from pypi"""
    req = requests.get(f"https://pypi.org/pypi/{name}/{version}/json")
    return req.json()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--upgrade", default=False, action="store_true", help="If present update all packages to the "
                        "latest possible version. Otherwise just determine missing dependencies when addding new packages")
    args, remaining = parser.parse_known_args()
    # make sure root is setup, otherwise root-numpy fails horribly
    subprocess.run("which root-config", shell=True)

    # Read the existing README.md and split at python package list table
    old = open("README.md").readlines()
    start_marker = None
    end_marker = None
    for i, l in enumerate(old):
        if l.startswith("[//]: # (START PYTHON_PKG)"):
            start_marker = i
        if l.startswith("[//]: # (END PYTHON_PKG)"):
            end_marker = i
    if start_marker is None or end_marker is None:
        raise ValueError("cannot find markers")

    # input files
    files = ["requirements-base.in", "requirements-root.in", "requirements-core.in"]
    # make sure pip-tools are installed
    subprocess.run(["pip3", "install", "--user", "pip-tools"])
    # if we run in non-upgrade mode we provide all existing versions which make
    # pip-compile loose the dependency annotation which we don't want. So save
    # those annotations and put them back in
    existing_dependencies = {}
    # and compile the requirements.txt
    if not args.upgrade:
        processed_files = [os.path.splitext(e)[0] + ".txt" for e in files]
        for f in processed_files:
            existing_dependencies.update(get_annotations(f))
        subprocess.run(["pip-compile", '-v', "--no-header", "--annotate", "--allow-unsafe", "-o", "requirements.txt"] +
                       processed_files + remaining)
    else:
        subprocess.run(["pip-compile", '-v', "--no-header", "--annotate", "--upgrade", "--allow-unsafe", "-o", "requirements.txt"] +
                       files + remaining)

    found = {}
    infos = []

    # now lets go through it and find all packages (and their annotations)
    with open("requirements.txt") as f:
        for line in f:
            if not line.strip() or line.startswith("#"):
                continue

            m = re.match(r"^(.*?)==(.*?)\s*(#.*)?$", line)
            if m:
                name = m.group(1)
                version = m.group(2)
                comment = m.group(3)
                print(f"Obtain info for {name}=={version}")
                json_data = get_info(name, version)
                # make list of all checksums
                content = []
                for f in json_data["urls"]:
                    try:
                        sha256 = f["digests"]["sha256"]
                        content.append(f"    --hash=sha256:{sha256}")
                    except KeyError:
                        pass
                # sort by checksum and insert package requirement
                content.sort()
                content.insert(0, f"{name}=={version}")
                # add dependency comment if present
                if comment:
                    content.append(f"    {comment}")
                # or take from previous run
                elif name in existing_dependencies:
                    content.append(f"    # {existing_dependencies[name]}")
                # make it one string
                found[name] = " \\\n".join(content) + "\n"
                # and remember package information
                info = json_data["info"]
                info["link"] = f"[{info['name']}]({info['project_url']})"
                if info["license"] is None:
                    info["license"] = ""
                infos.append(info)

    print("Update requirement files")
    for i, filename in enumerate(files):
        content = open(filename).readlines()
        with open(os.path.splitext(filename)[0] + ".txt", "w") as out:
            for l in content:
                n = l.strip().lower()
                if n.find("==") >= 0:
                    n, v = n.split("==")
                # did we find the package? if so delete from list
                if n in found:
                    out.write(found[n])
                    del found[n]
                else:
                    out.write(l)

            # last file, put in all the remaining packages
            if i == len(files)-1:
                for n, c in sorted(found.items()):
                    out.writelines(c)

    print("Update readme")
    widths = {}
    for key, minwidth in ("link", 4), ("summary", 7), ("version", 7), ("license", 7):
        widths["max_"+key] = max(minwidth, max(len(e[key]) for e in infos))

    table = ["\n"]
    table.append("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} | {license:{max_license}} |\n".format(link="Name", summary="Summary", version="Version", license="License", **widths))
    table.append("|-{link:-<{max_link}}-|-{summary:-<{max_summary}}-|-{version:-<{max_version}}-|-{license:-<{max_license}}-|\n".format(link="", summary="", version="", license="", **widths))
    for i in sorted(infos, key=lambda x: x['name'].lower()):
        table.append("| {link:{max_link}} | {summary:{max_summary}} | {version:{max_version}} | {license:{max_license}} |\n".format(**i, **widths))

    table.append("\n")

    with open("README.md", "w") as f:
        f.writelines(old[:start_marker+1] + table + old[end_marker:])
