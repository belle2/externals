Belle II Externals
==================

This repository contains the external software needed to compile the Belle II software.

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
| [GNU Binutils](https://www.gnu.org/software/binutils/)                       | 2.31.1          | GPLv2      |
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.64            | [Boost License](http://www.boost.org/users/license.html) |
| [bzip2](http://www.bzip.org/)                                                | 1.06            | BSD-style  |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.2.0.4         | LGPLv3     |
| [CMake](https://cmake.org/)                                                  | 3.12.2          | BSD-style  |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7             | -          |
| [cppzmq](https://github.com/zeromq/cppzmq)                                   | git6c91034      | MIT-style  |
| [curl](https://curl.haxx.se/)                                                | 7.61.1          | MIT-style (see also: [License Mixing](https://curl.haxx.se/legal/licmix.html)) |
| [davix](https://dmc.web.cern.ch/projects/davix/home)                         | 0.6.6           | LGPLv2     |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.3.4           | MPLv2      |
| [EOS](https://eos.github.io/) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.886055.svg)](https://doi.org/10.5281/zenodo.886055) | 0.0+git2a4e9d8 | GPLv2 |
| [EPICS](https://epics.anl.gov/index.php)                                     | 7.0.1.1         | [EPICS License](https://epics.anl.gov/license/open.php?product=EPICS+Base) |
| [EvtGen](http://evtgen.warwick.ac.uk/)                                       | R01-04-00       | -          |
| [ExRootAnalysis](http://madgraph.hep.uiuc.edu/Downloads/ExRootAnalysis/)     | 1.1.2           | -          |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0| LGPL       |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 5.2             | GPLv3      |
| [FFTW3](http://fftw.org/)                                                    | 3.3.7           | GPL        |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 8.2             | GPLv2/GPLv3 + Runtime library Exception |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 8.0.1           | GPLv2      |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 10.01.p02       | Geant4 License |
| [git](https://git-scm.com/)                                                  | 2.19.0          | GPLv2      |
| [GSL - GNU Scientific Library](https://www.gnu.org/software/gsl/)            | 2.3             | GPLv3      |
| [Google Test](https://github.com/google/googletest)                          | 1.8.0           | BSD |
| [HDF5](https://www.hdfgroup.org/)                                            | 1.10.1          | BSD |
| [HepMC](http://lcgapp.cern.ch/project/simu/HepMC/)                           | 2.06.09         | GPLv2      |
| [jemalloc memory allocator](http://jemalloc.net/)                            | 5.0.1           | BSD-style  |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.8           | MIT        |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.32          | MIT        |
| [Madgraph MG5\_aMC](https://launchpad.net/mg5amcnlo)                         | 2.6.1           | [UoI-NCSA](https://opensource.org/licenses/UoI-NCSA.php) (according to launchpad.net) |
| Madgraph [MGISR](https://github.com/qliphy/MGISR)                            | 8e324ea         | BSD        |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-03-08       | GPLv2      |
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
| [XRootD](http://xrootd.org/)                                                 | 4.7.1           | LGPLv3     |
| [yaml-cpp](https://github.com/jbeder/yaml-cpp)                               | 0.5.3           | MIT        |
| [zeromq](http://www.zeromq.org/)                                             | 4.2.1           | LGPLv3 + static link exception, intent to move to MPLv2  |
| [zlib](http://www.zlib.net/)                                                 | 1.2.11          | MIT        |

GCC requires some additional libraries which are downloaded as part of the GCC compilation:

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [GNU MPC](http://www.multiprecision.org/)                                    | 1.1.0           | LGPLv3+    |
| [The GNU MPFR Library](http://www.mpfr.org/)                                 | 4.0.1           | LGPLv3+    |
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
| [LLVM/Clang](http://llvm.org/), including libcxx and sanitizer tools         | 5.0.1           | [LLVM Release License](http://releases.llvm.org/4.0.0/LICENSE.TXT) |
| [Valgrind](http://valgrind.org/)                                             | 3.13            | GPLv2      |


Python Packages
---------------

This section lists all the python packages which are currently included in the
externals. These packages are a result of running

    pip3 install autopep8 CherryPy ipython lxml matplotlib numpy pep8 requests sphinx jupyter widgetsnbextension scipy pandas keras tensorflow CommonMark metakernel
    pip3 install root-numpy root-pandas

The package [sphinx-argparse](https://github.com/ribozz/sphinx-argparse/) is
included in a modified version containing some patches not yet included
upstream (found in `src/sphinx-argparse`).

All other packages are just dependencies of these and versions between them are
fixed in the externals.

| Name                                                                              | Summary                                                                                                        | Version   | License                                                      |
|-----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------------------|
| [alabaster](https://pypi.python.org/pypi/alabaster)                               | A configurable sidebar-enabled Sphinx theme                                                                    | 0.7.10    | UNKNOWN                                                      |
| [autopep8](https://pypi.python.org/pypi/autopep8)                                 | A tool that automatically formats Python code to conform to the PEP 8 style guide                              | 1.3.4     | Expat License                                                |
| [Babel](https://pypi.python.org/pypi/Babel)                                       | Internationalization utilities                                                                                 | 2.5.3     | BSD                                                          |
| [bleach](https://pypi.python.org/pypi/bleach)                                     | An easy whitelist-based HTML-sanitizing tool.                                                                  | 1.5.0     | Apache Software License                                      |
| [certifi](https://pypi.python.org/pypi/certifi)                                   | Python package for providing Mozilla's CA Bundle.                                                              | 2018.1.18 | MPL-2.0                                                      |
| [chardet](https://pypi.python.org/pypi/chardet)                                   | Universal encoding detector for Python 2 and 3                                                                 | 3.0.4     | LGPL                                                         |
| [cheroot](https://pypi.python.org/pypi/cheroot)                                   | Highly-optimized, pure-python HTTP server                                                                      | 6.0.0     | UNKNOWN                                                      |
| [CherryPy](https://pypi.python.org/pypi/CherryPy)                                 | Object-Oriented HTTP framework                                                                                 | 14.0.0    | BSD                                                          |
| [CommonMark](https://pypi.python.org/pypi/CommonMark)                             | Python parser for the CommonMark Markdown spec                                                                 | 0.7.4     | BSD-3-Clause                                                 |
| [cycler](https://pypi.python.org/pypi/cycler)                                     | Composable style cycles                                                                                        | 0.10.0    | BSD                                                          |
| [decorator](https://pypi.python.org/pypi/decorator)                               | Better living through Python with decorators                                                                   | 4.2.1     | new BSD License                                              |
| [docutils](https://pypi.python.org/pypi/docutils)                                 | Docutils -- Python Documentation Utilities                                                                     | 0.14      | public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt) |
| [entrypoints](https://pypi.python.org/pypi/entrypoints)                           | Discover and load entry points from installed packages.                                                        | 0.2.3     | UNKNOWN                                                      |
| [future](https://pypi.python.org/pypi/future)                                     | Clean single-source support for Python 3 and 2                                                                 | 0.16.0    | MIT                                                          |
| [html5lib](https://pypi.python.org/pypi/html5lib)                                 | HTML parser based on the WHATWG HTML specification                                                             | 0.9999999 | MIT License                                                  |
| [idna](https://pypi.python.org/pypi/idna)                                         | Internationalized Domain Names in Applications (IDNA)                                                          | 2.6       | BSD-like                                                     |
| [imagesize](https://pypi.python.org/pypi/imagesize)                               | Getting image size from png/jpeg/jpeg2000/gif file                                                             | 1.0.0     | MIT                                                          |
| [ipykernel](https://pypi.python.org/pypi/ipykernel)                               | IPython Kernel for Jupyter                                                                                     | 4.8.2     | BSD                                                          |
| [ipython](https://pypi.python.org/pypi/ipython)                                   | IPython: Productive Interactive Computing                                                                      | 6.2.1     | BSD                                                          |
| [ipython-genutils](https://pypi.python.org/pypi/ipython-genutils)                 | Vestigial utilities from IPython                                                                               | 0.2.0     | BSD                                                          |
| [ipywidgets](https://pypi.python.org/pypi/ipywidgets)                             | IPython HTML widgets for Jupyter                                                                               | 7.1.2     | BSD                                                          |
| [jedi](https://pypi.python.org/pypi/jedi)                                         | An autocompletion tool for Python that can be used for text editors.                                           | 0.11.1    | MIT                                                          |
| [Jinja2](https://pypi.python.org/pypi/Jinja2)                                     | A small but fast and easy to use stand-alone template engine written in pure python.                           | 2.10      | BSD                                                          |
| [jsonschema](https://pypi.python.org/pypi/jsonschema)                             | An implementation of JSON Schema validation for Python                                                         | 2.6.0     | MIT                                                          |
| [jupyter](https://pypi.python.org/pypi/jupyter)                                   | Jupyter metapackage. Install all the Jupyter components in one go.                                             | 1.0.0     | BSD                                                          |
| [jupyter-client](https://pypi.python.org/pypi/jupyter-client)                     | Jupyter protocol implementation and client libraries                                                           | 5.2.2     | BSD                                                          |
| [jupyter-console](https://pypi.python.org/pypi/jupyter-console)                   | Jupyter terminal console                                                                                       | 5.2.0     | BSD                                                          |
| [jupyter-core](https://pypi.python.org/pypi/jupyter-core)                         | Jupyter core package. A base package on which Jupyter projects rely.                                           | 4.4.0     | BSD                                                          |
| [Keras](https://pypi.python.org/pypi/Keras)                                       | Deep Learning for humans                                                                                       | 2.1.4     | MIT                                                          |
| [lxml](https://pypi.python.org/pypi/lxml)                                         | Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.               | 4.1.1     | BSD                                                          |
| [Markdown](https://pypi.python.org/pypi/Markdown)                                 | Python implementation of Markdown.                                                                             | 2.6.11    | BSD License                                                  |
| [MarkupSafe](https://pypi.python.org/pypi/MarkupSafe)                             | Implements a XML/HTML/XHTML Markup safe string for Python                                                      | 1.0       | BSD                                                          |
| [matplotlib](https://pypi.python.org/pypi/matplotlib)                             | Python plotting package                                                                                        | 2.1.2     | BSD                                                          |
| [mccabe](https://pypi.python.org/pypi/mccabe)                                     | McCabe checker, plugin for flake8                                                                              | 0.6.1     | Expat license                                                |
| [metakernel](https://pypi.python.org/pypi/metakernel)                             | Metakernel for Jupyter                                                                                         | 0.20.14   | UNKNOWN                                                      |
| [mistune](https://pypi.python.org/pypi/mistune)                                   | The fastest markdown parser in pure Python                                                                     | 0.8.3     | BSD                                                          |
| [more-itertools](https://pypi.python.org/pypi/more-itertools)                     | More routines for operating on iterables, beyond itertools                                                     | 4.1.0     | MIT                                                          |
| [nbconvert](https://pypi.python.org/pypi/nbconvert)                               | Converting Jupyter Notebooks                                                                                   | 5.3.1     | BSD                                                          |
| [nbformat](https://pypi.python.org/pypi/nbformat)                                 | The Jupyter Notebook format                                                                                    | 4.4.0     | BSD                                                          |
| [notebook](https://pypi.python.org/pypi/notebook)                                 | A web-based notebook environment for interactive computing                                                     | 5.4.0     | BSD                                                          |
| [numpy](https://pypi.python.org/pypi/numpy)                                       | NumPy: array processing for numbers, strings, records, and objects.                                            | 1.14.1    | BSD                                                          |
| [packaging](https://pypi.python.org/pypi/packaging)                               | Core utilities for Python packages                                                                             | 16.8      | BSD or Apache License, Version 2.0                           |
| [pandas](https://pypi.python.org/pypi/pandas)                                     | Powerful data structures for data analysis, time series,and statistics                                         | 0.22.0    | BSD                                                          |
| [pandocfilters](https://pypi.python.org/pypi/pandocfilters)                       | Utilities for writing pandoc filters in python                                                                 | 1.4.2     | UNKNOWN                                                      |
| [parso](https://pypi.python.org/pypi/parso)                                       | A Python Parser                                                                                                | 0.1.1     | MIT                                                          |
| [pep8](https://pypi.python.org/pypi/pep8)                                         | Python style guide checker                                                                                     | 1.7.1     | Expat license                                                |
| [pexpect](https://pypi.python.org/pypi/pexpect)                                   | Pexpect allows easy control of interactive console applications.                                               | 4.4.0     | ISC license                                                  |
| [pickleshare](https://pypi.python.org/pypi/pickleshare)                           | Tiny 'shelve'-like database with concurrency support                                                           | 0.7.4     | MIT                                                          |
| [portend](https://pypi.python.org/pypi/portend)                                   | TCP port monitoring utilities                                                                                  | 2.2       | UNKNOWN                                                      |
| [prompt-toolkit](https://pypi.python.org/pypi/prompt-toolkit)                     | Library for building powerful interactive command lines in Python                                              | 1.0.15    | UNKNOWN                                                      |
| [protobuf](https://pypi.python.org/pypi/protobuf)                                 | Protocol Buffers                                                                                               | 3.5.1     | 3-Clause BSD License                                         |
| [ptyprocess](https://pypi.python.org/pypi/ptyprocess)                             | Run a subprocess in a pseudo terminal                                                                          | 0.5.2     | UNKNOWN                                                      |
| [pycodestyle](https://pypi.python.org/pypi/pycodestyle)                           | Python style guide checker                                                                                     | 2.3.1     | Expat license                                                |
| [pydocstyle](https://pypi.python.org/pypi/pydocstyle)                             | Python docstring style checker                                                                                 | 2.0.0     | MIT                                                          |
| [pyflakes](https://pypi.python.org/pypi/pyflakes)                                 | passive checker of Python programs                                                                             | 1.5.0     | MIT                                                          |
| [Pygments](https://pypi.python.org/pypi/Pygments)                                 | Pygments is a syntax highlighting package written in Python.                                                   | 2.2.0     | BSD License                                                  |
| [pylama](https://pypi.python.org/pypi/pylama)                                     | pylama -- Code audit tool for python                                                                           | 7.4.1     | None                                                         |
| [pyparsing](https://pypi.python.org/pypi/pyparsing)                               | Python parsing module                                                                                          | 2.2.0     | MIT License                                                  |
| [python-dateutil](https://pypi.python.org/pypi/python-dateutil)                   | Extensions to the standard Python datetime module                                                              | 2.6.1     | Simplified BSD                                               |
| [pytz](https://pypi.python.org/pypi/pytz)                                         | World timezone definitions, modern and historical                                                              | 2018.3    | MIT                                                          |
| [PyYAML](https://pypi.python.org/pypi/PyYAML)                                     | YAML parser and emitter for Python                                                                             | 3.12      | MIT                                                          |
| [pyzmq](https://pypi.python.org/pypi/pyzmq)                                       | Python bindings for 0MQ                                                                                        | 17.0.0    | LGPL+BSD                                                     |
| [qtconsole](https://pypi.python.org/pypi/qtconsole)                               | Jupyter Qt console                                                                                             | 4.3.1     | BSD                                                          |
| [requests](https://pypi.python.org/pypi/requests)                                 | Python HTTP for Humans.                                                                                        | 2.18.4    | Apache 2.0                                                   |
| [root-numpy](https://pypi.python.org/pypi/root-numpy)                             | The interface between ROOT and NumPy                                                                           | 4.7.3     | new BSD                                                      |
| [root-pandas](https://pypi.python.org/pypi/root-pandas)                           | Read and save DataFrames from and to ROOT files                                                                | 0.3.1     | MIT                                                          |
| [scikit-learn](https://pypi.python.org/pypi/scikit-learn)                         | A set of python modules for machine learning and data mining                                                   | 0.18.2    | new BSD                                                      |
| [scipy](https://pypi.python.org/pypi/scipy)                                       | SciPy: Scientific Library for Python                                                                           | 1.0.0     | BSD                                                          |
| [seaborn](https://pypi.python.org/pypi/seaborn)                                   | Seaborn: statistical data visualization                                                                        | 0.8       | BSD (3-clause)                                               |
| [Send2Trash](https://pypi.python.org/pypi/Send2Trash)                             | Send file to trash natively under Mac OS X, Windows and Linux.                                                 | 1.5.0     | BSD License                                                  |
| [simplegeneric](https://pypi.python.org/pypi/simplegeneric)                       | Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)                                  | 0.8.1     | ZPL 2.1                                                      |
| [six](https://pypi.python.org/pypi/six)                                           | Python 2 and 3 compatibility utilities                                                                         | 1.11.0    | MIT                                                          |
| [snowballstemmer](https://pypi.python.org/pypi/snowballstemmer)                   | This package provides 16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms. | 1.2.1     | BSD                                                          |
| [Sphinx](https://pypi.python.org/pypi/Sphinx)                                     | Python documentation generator                                                                                 | 1.7.1     | BSD                                                          |
| [sphinxcontrib-websupport](https://pypi.python.org/pypi/sphinxcontrib-websupport) | Sphinx API for Web Apps                                                                                        | 1.0.1     | BSD                                                          |
| [tempora](https://pypi.python.org/pypi/tempora)                                   | Objects and routines pertaining to date and time (tempora)                                                     | 1.10      | UNKNOWN                                                      |
| [tensorflow](https://pypi.python.org/pypi/tensorflow)                             | TensorFlow helps the tensors flow                                                                              | 1.3.0     | Apache 2.0                                                   |
| [tensorflow-tensorboard](https://pypi.python.org/pypi/tensorflow-tensorboard)     | TensorBoard lets you watch Tensors Flow                                                                        | 0.1.8     | Apache 2.0                                                   |
| [terminado](https://pypi.python.org/pypi/terminado)                               | Terminals served to xterm.js using Tornado websockets                                                          | 0.8.1     | UNKNOWN                                                      |
| [testpath](https://pypi.python.org/pypi/testpath)                                 | Test utilities for code working with files and commands                                                        | 0.3.1     | UNKNOWN                                                      |
| [Theano](https://pypi.python.org/pypi/Theano)                                     | Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs.                                  | 0.9.0     | BSD                                                          |
| [tornado](https://pypi.python.org/pypi/tornado)                                   | Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.     | 4.5.3     | http://www.apache.org/licenses/LICENSE-2.0                   |
| [traitlets](https://pypi.python.org/pypi/traitlets)                               | Traitlets Python config system                                                                                 | 4.3.2     | BSD                                                          |
| [urllib3](https://pypi.python.org/pypi/urllib3)                                   | HTTP library with thread-safe connection pooling, file post, and more.                                         | 1.22      | MIT                                                          |
| [wcwidth](https://pypi.python.org/pypi/wcwidth)                                   | Measures number of Terminal column cells of wide-character codes                                               | 0.1.7     | MIT                                                          |
| [Werkzeug](https://pypi.python.org/pypi/Werkzeug)                                 | The comprehensive WSGI web application library.                                                                | 0.14.1    | BSD                                                          |
| [wheel](https://pypi.python.org/pypi/wheel)                                       | A built-package format for Python.                                                                             | 0.30.0    | MIT                                                          |
| [widgetsnbextension](https://pypi.python.org/pypi/widgetsnbextension)             | IPython HTML widgets for Jupyter                                                                               | 3.1.4     | BSD                                                          |
