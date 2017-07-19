[![Build Status](https://travis-ci.org/ribozz/sphinx-argparse.svg?branch=master)](https://travis-ci.org/ribozz/sphinx-argparse) [![Documentation Status](https://readthedocs.org/projects/sphinx-argparse/badge/?version=stable)](http://sphinx-argparse.readthedocs.org/) [![PyPI version](https://badge.fury.io/py/sphinx-argparse.svg)](https://badge.fury.io/py/sphinx-argparse) [Install with conda](https://anaconda.org/conda-forge/sphinx-argparse/badges/installer/conda.svg) [Conda downloads](https://anaconda.org/conda-forge/sphinx-argparse/badges/downloads.svg)

sphinx-argparse
===============

A sphinx extension that automatically documents argparse commands and options.

For installation and usage details see the [documentation](http://sphinx-argparse.readthedocs.org/en/latest/).

Changelog & contributors
========================

0.2.0
-----

- Section titles can now be used in tables of contents and linked to. The title itself is also used as the anchor. In the case of repeated names `_replicateX`, where `X` is a number, is prepended to ensure that all titles are uniquely linkable. This was bug #46.

0.1.17
------

- Fixed handling of argument groups (this was bug #49). Thanks to @croth1 for reporting this bug. Note that now position arguments (also known as required arguments) within argument groups are now also handled correctly.

0.1.16
------

- Added a `:nodefaultconst:` directive, which is similar to the `:nodefault:` directive, but applies only to `store_true`, `store_false`, and `store_const` (e.g., it will hide the "=True" part in the output, since that can be misleading to users).
- Fixed various typos (thanks to users mikeantonacci, brondsem, and tony)
- Format specifiers (e.g., `%(prog)s` and `%(default)s`) are now filled in (if possible) in help sections. If there's a missing keyword, then nothing will be filled in. This was issue #27.
- The package is now a bit more robust to incorrectly spelling module names (#39, courtesy of Gabriel Falcão)
- Added support for argparse groups (thanks to Fidel Ramirez)

0.1.15
------

- Fixed malformed docutils DOM in manpages (Matt Boyer)


0.1.14
------

- Support for aliasing arguments #22 (Campbell Barton)
- Support for nested arguments #23 (Campbell Barton)
- Support for subcommand descriptions #24 (Campbell Barton)
- Improved parsing of content of `epilog` and `description` #25 (Louis - https://github.com/paternal)
- Added 'passparser' option (David Hoese)

0.1.13
------

- Bugfix: Choices are not always strings (Robert Langlois)
- Polished small mistakes in usage documentation (Dean Malmgren)
- Started to improve man-pages support (Zygmunt Krynicki)

0.1.12
------

- Improved error reporting (James Anderson)

0.1.11
------

- Fixed stupid bug, prevented things working on py3 (Alex Rudakov)
- added tox configuration for tests

0.1.10
------

- Remove the ugly new line in the end of usage string (Vadim Markovtsev)
- Issue #9 Display argument choises (Proposed by Felix-neko, done by Alex Rudakov)
- :ref: syntax for specifying path to parser instance. Issue #7 (Proposed by David Cottrell, Implemented by Alex Rudakov)
- Updated docs to read the docs theme

0.1.9
-----

Fix problem with python version comparison, when python reports it as "2.7.5+" (Alex Rudakov)

0.1.8
-----

Argparse is not required anymore separate module as of python 2.7 (Mike Gleen)

0.1.7
-----

-- Nothing -- Created by axident.

0.1.6
-----

Adding :nodefault: directive that skips default values for options (Stephen Tridgell)

0.1.5
-----

Fix issue: epilog is ignored (James Anderson - https://github.com/jamesra)

0.1.4
-----

Fix issue #3: ==SUPPRESS== in option list with no default value

0.1.2
-----

Fix issue with subcommands (by Tony Narlock - https://github.com/tony)

0.1.1
-----

Initial version
