#!/usr/bin/env python3

import subprocess
import sys
import re
import os
import requests


def get_info(name, version):
    """Get JSON information for a package from pypi"""
    req = requests.get(f"https://pypi.org/pypi/{name}/{version}/json")
    return req.json()


if __name__ == "__main__":
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
    # and compile the requirements.txt
    subprocess.run(["pip-compile", '-v', "--no-header", "--annotate", "--upgrade", "--allow-unsafe" , "-o", "requirements.txt"] + files)

    found = {}
    infos = []

    # now lets go through it and find all packages (and their annotations)
    with open("requirements.txt") as f:
        for line in f:
            if not line.strip() or line.startswith("#"):
                continue

            m = re.match("^(.*?)==(.*?)\s*(#.*)?$", line)
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
                # did we find the package? if so delete from list
                if n in found:
                    out.write(found[n])
                    del found[n]
                else:
                    out.write(l)

            # last file, put in all the remaining packages
            if i == len(files)-1:
                for n,c in sorted(found.items()):
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
