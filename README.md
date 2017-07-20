Belle II Externals
==================

This repository contains the external software needed to compile the 

To compile them just source `setup_belle2` from the
[tools](https://stash.desy.de/projects/B2/repos/tools/), go into the externals
directory and call

    make

If you want to specify if you want to build the externals in optimal or debug
mode you can either call `setopt` before running make or specify the option
directly. You can also compile both options at the same time

    make opt debug

You can specify the numbers of processes to be used for the build process using
the `BELLE2_MAKE_NPROCESSES` variable. If it's not specified it defaults to the
number of processors present in the system.

    make BELLE2_MAKE_NPROCESSES=20


Included Software Packages
--------------------------

This section lists all the software packages which are currently included in
the externals. 

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [Artistic Style (astyle)](http://astyle.sourceforge.net/)                    | 2.05.1          | MIT        |
| `BELLE_FLC`                                                                  | ?               | -          |
| [belle\_legacy](https://stash.desy.de/projects/B2G/repos/belle_legacy/)      | 1.9             | -          |
| [GNU Binutils](https://www.gnu.org/software/binutils/)                       | 2.28            | GPLv2      |
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.64            | [Boost License](http://www.boost.org/users/license.html) |
| [bzip2](http://www.bzip.org/)                                                | 1.06            | BSD-style  |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.2.0.4         | LGPLv3     |
| [CMake](https://cmake.org/)                                                  | 3.7.1           | BSD-style  |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7             | -          |
| [cppzmq](https://github.com/zeromq/cppzmq)                                   | git6c91034      | MIT-style  |
| [curl](https://curl.haxx.se/)                                                | 7.54.1          | MIT-style (see also: [License Mixing](https://curl.haxx.se/legal/licmix.html)) |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.3.4           | MPLv2      |
| [EvtGen](http://evtgen.warwick.ac.uk/)                                       | R01-04-00       | -          |
| [ExRootAnalysis](http://madgraph.hep.uiuc.edu/Downloads/ExRootAnalysis/)     | 1.1.2           | -          |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0| LGPL       |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 3.2             | GPLv3      |
| [FreeType](http://www.freetype.org/)                                         | 2.7.1           | FTL/GPLv2  |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 6.3             | GPLv2/GPLv3 + Runtime library Exception |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 7.12            | GPLv2      |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 10.01.p02       | Geant4 License |
| [git](https://git-scm.com/)                                                  | 2.13.3          | GPLv2      |
| [GSL - GNU Scientific Library](https://www.gnu.org/software/gsl/)            | 2.3             | GPLv3      |
| [Google Test](https://github.com/google/googletest)                          | 1.8.0           | BSD |
| [HepMC](http://lcgapp.cern.ch/project/simu/HepMC/)                           | 2.06.09         | GPLv2      |
| [jemalloc memory allocator](http://jemalloc.net/)                            | 5.0.1           | BSD-style  |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.4           | MIT        |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.29          | MIT        |
| [MG5\_aMC](https://launchpad.net/mg5amcnlo)                                  | 2.2.2           | [UoI-NCSA](https://opensource.org/licenses/UoI-NCSA.php) (according to launchpad.net) |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-03-07       | GPLv2      |
| [NeurobayesCppInterface](https://github.com/thomaskeck/NeurobayesCppInterface) | 627381c       | MIT        |
| [PHOTOS](http://photospp.web.cern.ch/photospp/)                              | 3.56            | partly GPLv2? |
| [PostgreSQL](http://www.postgresql.org/)                                     | 9.2.4           | [PostgreSQL License](https://opensource.org/licenses/postgresql) (similar to BSD/MIT) |
| [PYTHIA](http://home.thep.lu.se/~torbjorn/Pythia.html)                       | 8.215           | GPLv2      |
| [Python](https://www.python.org/)                                            | 3.6.2           | PSFL (BSD-style)  |
| [rave](https://github.com/rave-package/rave)                                 | 0.6.25          | GPLv2      |
| [ROOT](https://root.cern.ch/)                                                | 6.08/06         | LGPLv2.1 (GPLv3 for MathMore)  |
| [SCons](http://scons.org/)                                                   | 2.3.6           | MIT        |
| [SQLite](https://www.sqlite.org/)                                            | 3.19.3          | Public Domain |
| [Tauola](http://tauolapp.web.cern.ch/tauolapp/)                              | 1.1.4           | -          |
| libuuid, a part of [util-linux](https://www.kernel.org/pub/linux/utils/util-linux/) | 2.30     | BSD        |
| [Virtual Geometry Model (VGM)](http://ivana.home.cern.ch/ivana/VGM.html)     | 4.3             | GPLv2      |
| [XRootD](http://xrootd.org/)                                                 | 4.6.1           | LGPLv3     |
| [zeromq](http://www.zeromq.org/)                                             | 4.2.0           | LGPLv3 + static link exception, intent to move to MPLv2  |
| [zlib](http://www.zlib.net/)                                                 | 1.2.11          | MIT        |

GCC requires some additional libraries which are downloaded as part of the GCC compilation:

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [GNU MPC](http://www.multiprecision.org/)                                    | 1.0.3           | LGPLv3+    |
| [The GNU MPFR Library](http://www.mpfr.org/)                                 | 3.1.5           | LGPLv3+    |
| [The GNU Multiple Precision Arithmetic Library](https://gmplib.org/)         | 6.1.2           | LGPLv3 + GPLv2 |
| [Integer Set Library](http://isl.gforge.inria.fr/)                           | 0.18            | MIT        |

Optional Package
----------------

This section lists all optional packages. These are not compiled by default but
included for simplified access.

To compile any of these just go into the external directory and type

    make <package name>

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [Cppcheck](http://cppcheck.sourceforge.net/)                                 | 1.79            | GPLv3      |
| [Doxygen](http://www.doxygen.org)                                            | 1.8.13          | GPL        |
| [LLVM/Clang](http://llvm.org/), including libcxx and sanitizer tools         | 4.0.1           | [LLVM Release License](http://releases.llvm.org/4.0.0/LICENSE.TXT) |
| [Valgrind](http://valgrind.org/)                                             | 3.13            | GPLv2      |


Python Packages
---------------

This section lists all the python packages which are currently included in the
externals. These packages are a result of running

    pip3 install autopep8 CherryPy ipython lxml matplotlib numpy pep8 requests sphinx jupyter widgetsnbextension javascript scipy pandas keras tensorflow CommonMark

The package [sphinx-argparse](https://github.com/ribozz/sphinx-argparse/) is
included in a modified version containing some patches not yet included
upstream (found in `src/sphinx-argparse`).

All other packages are just dependencies of these and versions between them are
fixed in the externals.

| Name                                                                  | Summary                                                                                                        | Version     | License                                                      |
|-----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-------------|--------------------------------------------------------------|
| [alabaster](https://pypi.python.org/pypi/alabaster)                   | A configurable sidebar-enabled Sphinx theme                                                                    | 0.7.10      | UNKNOWN                                                      |
| [autopep8](https://pypi.python.org/pypi/autopep8)                     | A tool that automatically formats Python code to conform to the PEP 8 style guide                              | 1.3.2       | Expat License                                                |
| [Babel](https://pypi.python.org/pypi/Babel)                           | Internationalization utilities                                                                                 | 2.4.0       | BSD                                                          |
| [backports.weakref](https://pypi.python.org/pypi/backports.weakref)   | Backport of new features in Python's weakref module                                                            | 1.0rc1      | Python Software Foundation License                           |
| [bleach](https://pypi.python.org/pypi/bleach)                         | An easy safelist-based HTML-sanitizing tool.                                                                   | 2.0.0       | Apache Software License                                      |
| [certifi](https://pypi.python.org/pypi/certifi)                       | Python package for providing Mozilla's CA Bundle.                                                              | 2017.4.17   | ISC                                                          |
| [chardet](https://pypi.python.org/pypi/chardet)                       | Universal encoding detector for Python 2 and 3                                                                 | 3.0.4       | LGPL                                                         |
| [cheroot](https://pypi.python.org/pypi/cheroot)                       | Highly-optimized, pure-python HTTP server                                                                      | 5.7.0       | UNKNOWN                                                      |
| [CherryPy](https://pypi.python.org/pypi/CherryPy)                     | Object-Oriented HTTP framework                                                                                 | 11.0.0      | BSD                                                          |
| [CommonMark](https://pypi.python.org/pypi/CommonMark)                 | Python parser for the CommonMark Markdown spec                                                                 | 0.7.3       | BSD License                                                  |
| [cycler](https://pypi.python.org/pypi/cycler)                         | Composable style cycles                                                                                        | 0.10.0      | BSD                                                          |
| [decorator](https://pypi.python.org/pypi/decorator)                   | Better living through Python with decorators                                                                   | 4.1.1       | new BSD License                                              |
| [docutils](https://pypi.python.org/pypi/docutils)                     | Docutils -- Python Documentation Utilities                                                                     | 0.13.1      | public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt) |
| [entrypoints](https://pypi.python.org/pypi/entrypoints)               | Discover and load entry points from installed packages.                                                        | 0.2.3       | UNKNOWN                                                      |
| [future](https://pypi.python.org/pypi/future)                         | Clean single-source support for Python 3 and 2                                                                 | 0.16.0      | MIT                                                          |
| [html5lib](https://pypi.python.org/pypi/html5lib)                     | HTML parser based on the WHATWG HTML specification                                                             | 0.999999999 | MIT License                                                  |
| [idna](https://pypi.python.org/pypi/idna)                             | Internationalized Domain Names in Applications (IDNA)                                                          | 2.5         | BSD-like                                                     |
| [imagesize](https://pypi.python.org/pypi/imagesize)                   | Getting image size from png/jpeg/jpeg2000/gif file                                                             | 0.7.1       | MIT                                                          |
| [ipykernel](https://pypi.python.org/pypi/ipykernel)                   | IPython Kernel for Jupyter                                                                                     | 4.5.2       | BSD                                                          |
| [ipython](https://pypi.python.org/pypi/ipython)                       | IPython: Productive Interactive Computing                                                                      | 5.1.0       | BSD                                                          |
| [ipython-genutils](https://pypi.python.org/pypi/ipython-genutils)     | Vestigial utilities from IPython                                                                               | 0.2.0       | BSD                                                          |
| [ipywidgets](https://pypi.python.org/pypi/ipywidgets)                 | IPython HTML widgets for Jupyter                                                                               | 6.0.0       | BSD                                                          |
| [javascript](https://pypi.python.org/pypi/javascript)                 | The joy of javscript from Python.                                                                              | 2015.32.59  | UNKNOWN                                                      |
| [Jinja2](https://pypi.python.org/pypi/Jinja2)                         | A small but fast and easy to use stand-alone template engine written in pure python.                           | 2.9.6       | BSD                                                          |
| [jsonschema](https://pypi.python.org/pypi/jsonschema)                 | An implementation of JSON Schema validation for Python                                                         | 2.6.0       | MIT                                                          |
| [jupyter](https://pypi.python.org/pypi/jupyter)                       | Jupyter metapackage. Install all the Jupyter components in one go.                                             | 1.0.0       | BSD                                                          |
| [jupyter-client](https://pypi.python.org/pypi/jupyter-client)         | Jupyter protocol implementation and client libraries                                                           | 5.0.0       | BSD                                                          |
| [jupyter-console](https://pypi.python.org/pypi/jupyter-console)       | Jupyter terminal console                                                                                       | 5.1.0       | BSD                                                          |
| [jupyter-core](https://pypi.python.org/pypi/jupyter-core)             | Jupyter core package. A base package on which Jupyter projects rely.                                           | 4.3.0       | BSD                                                          |
| [Keras](https://pypi.python.org/pypi/Keras)                           | Deep Learning for Python                                                                                       | 2.0.6       | MIT                                                          |
| [lxml](https://pypi.python.org/pypi/lxml)                             | Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.               | 3.8.0       | UNKNOWN                                                      |
| [Markdown](https://pypi.python.org/pypi/Markdown)                     | Python implementation of Markdown.                                                                             | 2.6.8       | BSD License                                                  |
| [MarkupSafe](https://pypi.python.org/pypi/MarkupSafe)                 | Implements a XML/HTML/XHTML Markup safe string for Python                                                      | 1.0         | BSD                                                          |
| [matplotlib](https://pypi.python.org/pypi/matplotlib)                 | Python plotting package                                                                                        | 2.0.2       | BSD                                                          |
| [mccabe](https://pypi.python.org/pypi/mccabe)                         | McCabe checker, plugin for flake8                                                                              | 0.6.1       | Expat license                                                |
| [mistune](https://pypi.python.org/pypi/mistune)                       | The fastest markdown parser in pure Python                                                                     | 0.7.4       | BSD                                                          |
| [nbconvert](https://pypi.python.org/pypi/nbconvert)                   | Converting Jupyter Notebooks                                                                                   | 5.1.1       | BSD                                                          |
| [nbformat](https://pypi.python.org/pypi/nbformat)                     | The Jupyter Notebook format                                                                                    | 4.3.0       | BSD                                                          |
| [notebook](https://pypi.python.org/pypi/notebook)                     | A web-based notebook environment for interactive computing                                                     | 4.4.1       | BSD                                                          |
| [numpy](https://pypi.python.org/pypi/numpy)                           | NumPy: array processing for numbers, strings, records, and objects.                                            | 1.13.1      | BSD                                                          |
| [pandas](https://pypi.python.org/pypi/pandas)                         | Powerful data structures for data analysis, time series,and statistics                                         | 0.20.3      | BSD                                                          |
| [pandocfilters](https://pypi.python.org/pypi/pandocfilters)           | Utilities for writing pandoc filters in python                                                                 | 1.4.1       | UNKNOWN                                                      |
| [path.py](https://pypi.python.org/pypi/path.py)                       | A module wrapper for os.path                                                                                   | 10.3.1      | UNKNOWN                                                      |
| [pep8](https://pypi.python.org/pypi/pep8)                             | Python style guide checker                                                                                     | 1.7.0       | Expat license                                                |
| [pexpect](https://pypi.python.org/pypi/pexpect)                       | Pexpect allows easy control of interactive console applications.                                               | 4.2.1       | ISC license                                                  |
| [pickleshare](https://pypi.python.org/pypi/pickleshare)               | Tiny 'shelve'-like database with concurrency support                                                           | 0.7.4       | MIT                                                          |
| [portend](https://pypi.python.org/pypi/portend)                       | TCP port monitoring utilities                                                                                  | 2.1.2       | UNKNOWN                                                      |
| [prompt-toolkit](https://pypi.python.org/pypi/prompt-toolkit)         | Library for building powerful interactive command lines in Python                                              | 1.0.14      | UNKNOWN                                                      |
| [protobuf](https://pypi.python.org/pypi/protobuf)                     | Protocol Buffers                                                                                               | 3.3.0       | 3-Clause BSD License                                         |
| [ptyprocess](https://pypi.python.org/pypi/ptyprocess)                 | Run a subprocess in a pseudo terminal                                                                          | 0.5.2       | UNKNOWN                                                      |
| [pycodestyle](https://pypi.python.org/pypi/pycodestyle)               | Python style guide checker                                                                                     | 2.3.1       | Expat license                                                |
| [pydocstyle](https://pypi.python.org/pypi/pydocstyle)                 | Python docstring style checker                                                                                 | 2.0.0       | MIT                                                          |
| [pyflakes](https://pypi.python.org/pypi/pyflakes)                     | passive checker of Python programs                                                                             | 1.5.0       | MIT                                                          |
| [Pygments](https://pypi.python.org/pypi/Pygments)                     | Pygments is a syntax highlighting package written in Python.                                                   | 2.2.0       | BSD License                                                  |
| [pylama](https://pypi.python.org/pypi/pylama)                         | pylama -- Code audit tool for python                                                                           | 7.4.1       | None                                                         |
| [pyparsing](https://pypi.python.org/pypi/pyparsing)                   | Python parsing module                                                                                          | 2.2.0       | MIT License                                                  |
| [python-dateutil](https://pypi.python.org/pypi/python-dateutil)       | Extensions to the standard Python datetime module                                                              | 2.6.1       | Simplified BSD                                               |
| [pytz](https://pypi.python.org/pypi/pytz)                             | World timezone definitions, modern and historical                                                              | 2017.2      | MIT                                                          |
| [PyYAML](https://pypi.python.org/pypi/PyYAML)                         | YAML parser and emitter for Python                                                                             | 3.12        | MIT                                                          |
| [pyzmq](https://pypi.python.org/pypi/pyzmq)                           | Python bindings for 0MQ                                                                                        | 16.0.2      | LGPL+BSD                                                     |
| [qtconsole](https://pypi.python.org/pypi/qtconsole)                   | Jupyter Qt console                                                                                             | 4.2.1       | BSD                                                          |
| [requests](https://pypi.python.org/pypi/requests)                     | Python HTTP for Humans.                                                                                        | 2.18.1      | Apache 2.0                                                   |
| [scipy](https://pypi.python.org/pypi/scipy)                           | SciPy: Scientific Library for Python                                                                           | 0.19.1      | BSD                                                          |
| [simplegeneric](https://pypi.python.org/pypi/simplegeneric)           | Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)                                  | 0.8.1       | ZPL 2.1                                                      |
| [six](https://pypi.python.org/pypi/six)                               | Python 2 and 3 compatibility utilities                                                                         | 1.10.0      | MIT                                                          |
| [snowballstemmer](https://pypi.python.org/pypi/snowballstemmer)       | This package provides 16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms. | 1.2.1       | BSD                                                          |
| [Sphinx](https://pypi.python.org/pypi/Sphinx)                         | Python documentation generator                                                                                 | 1.5.3       | BSD                                                          |
| [tempora](https://pypi.python.org/pypi/tempora)                       | Objects and routines pertaining to date and time (tempora)                                                     | 1.8         | UNKNOWN                                                      |
| [tensorflow](https://pypi.python.org/pypi/tensorflow)                 | TensorFlow helps the tensors flow                                                                              | 1.2.1       | Apache 2.0                                                   |
| [terminado](https://pypi.python.org/pypi/terminado)                   | Terminals served to term.js using Tornado websockets                                                           | 0.6         | UNKNOWN                                                      |
| [testpath](https://pypi.python.org/pypi/testpath)                     | Test utilities for code working with files and commands                                                        | 0.3.1       | UNKNOWN                                                      |
| [Theano](https://pypi.python.org/pypi/Theano)                         | Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs.                                  | 0.9.0       | BSD                                                          |
| [tornado](https://pypi.python.org/pypi/tornado)                       | Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.     | 4.5.1       | http://www.apache.org/licenses/LICENSE-2.0                   |
| [traitlets](https://pypi.python.org/pypi/traitlets)                   | Traitlets Python config system                                                                                 | 4.3.1       | BSD                                                          |
| [urllib3](https://pypi.python.org/pypi/urllib3)                       | HTTP library with thread-safe connection pooling, file post, and more.                                         | 1.21.1      | MIT                                                          |
| [wcwidth](https://pypi.python.org/pypi/wcwidth)                       | Measures number of Terminal column cells of wide-character codes                                               | 0.1.7       | MIT                                                          |
| [webencodings](https://pypi.python.org/pypi/webencodings)             | Character encoding aliases for legacy web content                                                              | 0.5.1       | BSD                                                          |
| [Werkzeug](https://pypi.python.org/pypi/Werkzeug)                     | The Swiss Army knife of Python web development                                                                 | 0.12.2      | BSD                                                          |
| [wheel](https://pypi.python.org/pypi/wheel)                           | A built-package format for Python.                                                                             | 0.29.0      | MIT                                                          |
| [widgetsnbextension](https://pypi.python.org/pypi/widgetsnbextension) | IPython HTML widgets for Jupyter                                                                               | 2.0.0       | BSD                                                          |
