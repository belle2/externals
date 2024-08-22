"""
Utility to compile the requirements-*.txt file with consistent dependencies

This script takes the requirements-*.in and tries to compile a fully pinned set
of requirement files with all requirements between packages fulfilled.

To upgrade all python packages to the latest version just run it with
`--upgrade`. To just add a python package just add it unpinned to the .in and
the .txt files and run without the upgrade option.
"""

import subprocess
import re
import os
import requests
import argparse
import logging
from pathlib import Path

used_packages = set()

def get_info(name, version):
    """Get JSON information for a package from pypi"""
    req = requests.get(f"https://pypi.org/pypi/{name}/{version}/json")
    info_dict = {}
    try:
        req.raise_for_status()
        info_dict = req.json()
    except requests.exceptions.HTTPError as e:
        logging.warning(f"Error in get_info: {e}")
        logging.warning(f"Package: {name}, Version: {version}")
        logging.warning(f"Response: {req.text}")
        info_dict = {"info": {"name": name, "version": version}}

    return info_dict


def call_subprocess(commands, log_info="", shell=False):
    try:
        result = subprocess.run(commands, capture_output=True, text=True, check=True, shell=shell)
        if log_info:
            logging.info(log_info)
        logging.info(result.stdout)
    except subprocess.CalledProcessError as e:
        error_message = e.stderr if e.stderr else str(e)
        logging.error(f"Subprocess '{log_info}' failed with error: {error_message}")
        raise Exception(error_message)


def compile_requirements(python_exec, inputfile, update=False, remaining=[]):
    requirements_file = os.path.splitext(inputfile)[0] + ".txt"
    outputfile = "tmp_" + requirements_file

    pip_tools_args = [
        python_exec,
        "-m",
        "piptools",
        "compile",
        "-v",
        "--no-header",
        "--annotate",
        "--allow-unsafe",
        "-o",
        outputfile,
    ]

    if update:
        pip_tools_args += ["--upgrade"]

    pip_tools_args += [inputfile]

    if remaining:
        pip_tools_args += [f"--pip-args {' '.join(remaining)}"]

    call_subprocess(commands=pip_tools_args, log_info=f"Compiling packges for {inputfile}")
    return outputfile, requirements_file


def get_packages(lines, ignore_other_url=False):
    global used_packages

    packages = []
    for line in lines:
        if re.search(r"@", line):
            if not ignore_other_url:
                packages.append("".join(line.strip().split(" ")))
        elif re.search(r"==", line):
            packages.append(line.strip())

    unique_packages = [package for package in packages if package not in used_packages]
    used_packages.update(unique_packages)

    return unique_packages


def get_other_url_hashes(inputfile):
    packages = []
    with open(inputfile) as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if re.search(r"https://", line):
            if re.search(r"hash", lines[i + 1]):
                packages.append(line)
                packages.append(lines[i + 1])

            else:
                logging.error(f"Error in {inputfile} at line {i+1}: No hash found for package for {line}")
                raise ValueError(f"Error in {inputfile} at line {i+1}: No hash found for package for {line}")

    return packages


def get_name_version_pairs(packages):
    pairs = []
    for package in packages:
        parts = re.search(r"http.*/(.*?)-(.*?)((\\+|%2B).*)?-cp", package.strip())
        if parts is not None:
            pairs.append((parts.group(1), parts.group(2)))
            continue

        parts = re.search(r"^\s*([\w-]+)\s*==\s*(\S+)\s*(?:\\)?\s*$", package.strip())

        if parts is not None:
            pairs.append((parts.group(1), parts.group(2)))

    return pairs


def create_requirements(raw_file, requirements_file):
    # Get packages from compiled requirements
    with open(raw_file) as file:
        lines = file.readlines()

    # Ignore custom urls
    packages = get_packages(lines, ignore_other_url=True)

    # Create .txt files
    requirements_path = Path(requirements_file)
    if requirements_path.exists():
        requirements_path.unlink()

    requirements_path.touch()

    # Remove temp requirements
    raw_path = Path(raw_file)
    raw_path.unlink()

    call_subprocess(
        commands=["hashin", "-r", requirements_file] + packages, log_info=f"Preparing hashes in {requirements_file}"
    )

    # Add custom url and hashes to the requirements file
    input_file = os.path.splitext(requirements_file)[0] + ".in"
    other_url_lines = get_other_url_hashes(input_file)

    with open(requirements_file, "a") as file:
        file.writelines(other_url_lines)


def find_markers(lines):
    start_marker = None
    end_marker = None
    for i, line in enumerate(lines):
        # Account for empty lines
        if line.startswith("[//]: # (START PYTHON_PKG)"):
            start_marker = i + 2
        if line.startswith("[//]: # (END PYTHON_PKG)"):
            end_marker = i - 2
    if start_marker is None or end_marker is None:
        logging.error("Cannot find markers")
        raise ValueError("Cannot find markers")

    return start_marker, end_marker


def get_package_information(name, version):
    json_data = get_info(name, version)
    json_info = json_data.get("info", {})
    license = json_info.get("license", "")

    # Special cases:
    # - No license key info given
    # - Entire license text in info license
    # => Check for license information in classifier
    if not license or len(license) > 20:
        for classifier in json_info.get("classifiers", []):
            if classifier.startswith("License :: "):
                license = classifier.split("License :: ")[1].split(" :: ")[-1].split("License")[0]
        # Case: No license in classifier, only long license information
        if license is not None and len(license) > 20:
            license = license.split(" ")[0]
            logging.warning(
                f"{json_data['info'].get('name', '')} seems to have only a long license text. Setting license to first word in the license text to '{license}'. Please verify."
            )

    # Last check of None type license
    if license is None:
        license = ""

    summary = json_info.get("summary", "")
    # Some explicitly return None
    summary = summary if summary is not None else ""

    # Get first sentence of summary 
    idx = 0
    split_string = re.split(f'({re.escape(". ")})', summary)
    for i in range(len(split_string)-1):
        if split_string[i].endswith(". ") and split_string[i+1][0].isupper():
            idx = i
            break

    summary = "".join(split_string[:idx]) if idx > 0 else summary

    return {
        "Name": f"[{json_info.get('name', '')}]({json_info.get('project_url', '')})",
        "Summary": summary,
        "Version": json_info.get("version", ""),
        "License": license,
    }


def packages_to_markdown(python_table):
    # Get column headers from the keys of the first dictionary
    headers = list(python_table[0].keys())

    # Create Markdown table header
    markdown_table = ["| " + " | ".join(headers) + " |\n"]
    markdown_table += ["| " + " | ".join(["-" * len(header) for header in headers]) + " |\n"]

    # Add rows
    for row in python_table:
        markdown_table += ["| " + " | ".join([row[header] for header in headers]) + " |\n"]

    return markdown_table


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--upgrade",
        default=False,
        action="store_true",
        help="If present update all packages to the "
        "latest possible version. Otherwise just determine missing dependencies when addding new packages",
    )
    parser.add_argument(
        "--python",
        default="python3",
        action="store",
        help="Path to the python executable to use in the requirements creation",
    )
    parser.add_argument(
        "--loglevel",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        default="INFO",
        help="Set the logging level",
    )
    args, remaining = parser.parse_known_args()

    # Set logging level
    logging.basicConfig(level=args.loglevel)

    # Check that the python executable is present
    python_exec = args.python
    call_subprocess(commands=[python_exec, "--version"], log_info=f"Using this python: {python_exec}")

    # Make sure pip-tools are installed
    call_subprocess(commands=[python_exec, "-m", "pip", "install", "pip-tools"])

    # Make sure hashin is installed
    call_subprocess(commands=[python_exec, "-m", "pip", "install", "hashin"])

    # Compile the requirements
    base_outputfile, base_requirements = compile_requirements(
        python_exec=python_exec, inputfile="requirements-base.in", update=args.upgrade, remaining=remaining
    )
    core_outputfile, core_requirements = compile_requirements(
        python_exec=python_exec, inputfile="requirements-core.in", update=args.upgrade, remaining=remaining
    )

    # Create requirements files
    lines = []
    for outputfile, requirements in zip([base_outputfile, core_outputfile], [base_requirements, core_requirements]):
        create_requirements(outputfile, requirements)

        # Get actual packages
        with open(requirements) as file:
            lines += file.readlines()

    # Create information table for README
    logging.info("Starting README update")
    packages = get_packages(lines)
    package_pairs = get_name_version_pairs(packages)
    package_table = [get_package_information(*pair) for pair in package_pairs]
    markdown_table = packages_to_markdown(package_table)

    # Get README lines without old table
    with open("README.md", "r") as file:
        old_lines = file.readlines()
        start, end = find_markers(old_lines)

    # Write new package table into README
    with open("README.md", "w") as file:
        file.writelines(old_lines[:start] + markdown_table + old_lines[end + 1 :])
