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
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.68            | [Boost License](http://www.boost.org/users/license.html) |
| [bzip2](http://www.bzip.org/)                                                | 1.06            | BSD-style  |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.2.0.4         | LGPLv3     |
| [CMake](https://cmake.org/)                                                  | 3.12.2          | BSD-style  |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7             | -          |
| [cppzmq](https://github.com/zeromq/cppzmq)                                   | 4.3.0           | MIT-style  |
| [curl](https://curl.haxx.se/)                                                | 7.61.1          | MIT-style (see also: [License Mixing](https://curl.haxx.se/legal/licmix.html)) |
| [davix](https://dmc.web.cern.ch/projects/davix/home)                         | 0.6.6           | LGPLv2     |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.3.5           | MPLv2      |
| [EOS](https://eos.github.io/) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.886055.svg)](https://doi.org/10.5281/zenodo.886055) | 0.0+git2a4e9d8 | GPLv2 |
| [EPICS](https://epics.anl.gov/index.php)                                     | 7.0.1.1         | [EPICS License](https://epics.anl.gov/license/open.php?product=EPICS+Base) |
| [EvtGen](http://evtgen.warwick.ac.uk/)                                       | R01-04-00       | -          |
| [ExRootAnalysis](http://madgraph.hep.uiuc.edu/Downloads/ExRootAnalysis/)     | 1.1.2           | -          |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0| LGPL       |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 5.2             | GPLv3      |
| [FFTW3](http://fftw.org/)                                                    | 3.3.8           | GPL        |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 8.2             | GPLv2/GPLv3 + Runtime library Exception |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 8.1.1           | GPLv2      |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 10.01.p02       | Geant4 License |
| [git](https://git-scm.com/)                                                  | 2.19.0          | GPLv2      |
| [GSL - GNU Scientific Library](https://www.gnu.org/software/gsl/)            | 2.5             | GPLv3      |
| [Google Test](https://github.com/google/googletest)                          | 1.8.1           | BSD |
| [HDF5](https://www.hdfgroup.org/)                                            | 1.10.1          | BSD |
| [HepMC](http://lcgapp.cern.ch/project/simu/HepMC/)                           | 2.06.09         | GPLv2      |
| [jemalloc memory allocator](http://jemalloc.net/)                            | 5.1.0           | BSD-style  |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.8           | MIT        |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.32          | MIT        |
| [Madgraph MG5\_aMC](https://launchpad.net/mg5amcnlo)                         | 2.6.3.2         | [UoI-NCSA](https://opensource.org/licenses/UoI-NCSA.php) (according to launchpad.net) |
| Madgraph [MGISR](https://github.com/qliphy/MGISR)                            | 8e324ea         | BSD        |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-03-08       | GPLv2      |
| [NeurobayesCppInterface](https://github.com/thomaskeck/NeurobayesCppInterface) | c7d36c5       | MIT        |
| [PHOTOS](http://photospp.web.cern.ch/photospp/)                              | 3.56            | partly GPLv2? |
| [PostgreSQL](http://www.postgresql.org/)                                     | 9.2.4           | [PostgreSQL License](https://opensource.org/licenses/postgresql) (similar to BSD/MIT) |
| [PYTHIA](http://home.thep.lu.se/~torbjorn/Pythia.html)                       | 8.215           | GPLv2      |
| [Python](https://www.python.org/)                                            | 3.6.2           | PSFL (BSD-style)  |
| [rave](https://github.com/rave-package/rave)                                 | 0.6.25          | GPLv2      |
| [ROOT](https://root.cern.ch/)                                                | 6.08/06         | LGPLv2.1 (GPLv3 for MathMore)  |
| [SQLite](https://www.sqlite.org/)                                            | 3.25.0          | Public Domain |
| [Tauola](http://tauolapp.web.cern.ch/tauolapp/)                              | 1.1.4           | -          |
| libuuid, a part of [util-linux](https://www.kernel.org/pub/linux/utils/util-linux/) | 2.32.1   | BSD        |
| [Virtual Geometry Model (VGM)](http://ivana.home.cern.ch/ivana/VGM.html)     | 4.3             | GPLv2      |
| [XRootD](http://xrootd.org/)                                                 | 4.8.4           | LGPLv3     |
| [yaml-cpp](https://github.com/jbeder/yaml-cpp)                               | 0.6.2           | MIT        |
| [zeromq](http://www.zeromq.org/)                                             | 4.2.5           | LGPLv3 + static link exception, intent to move to MPLv2  |
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

    pip3 install autopep8 CherryPy ipython lxml matplotlib numpy pep8 requests sphinx jupyter widgetsnbextension scipy pandas keras tensorflow CommonMark metakernel tables h5py seaborn uproot histbook Theano scikit-learn pylama
    pip3 install root-numpy root-pandas

The package [sphinx-argparse](https://github.com/ribozz/sphinx-argparse/) is
included in a modified version containing some patches not yet included
upstream (found in `src/sphinx-argparse`).

All other packages are just dependencies of these and versions between them are
fixed in the externals.

| Name                                                                                        | Summary                                                                                                        | Version   | License                                                      |
|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------------------|
| [absl-py](https://pypi.python.org/pypi/absl-py)                                             | Abseil Python Common Libraries, see https://github.com/abseil/abseil-py.                                       | 0.4.1     | Apache 2.0                                                   |
| [alabaster](https://pypi.python.org/pypi/alabaster)                                         | A configurable sidebar-enabled Sphinx theme                                                                    | 0.7.11    | UNKNOWN                                                      |
| [astor](https://pypi.python.org/pypi/astor)                                                 | Read/rewrite/write Python ASTs                                                                                 | 0.7.1     | BSD-3-Clause                                                 |
| [autopep8](https://pypi.python.org/pypi/autopep8)                                           | A tool that automatically formats Python code to conform to the PEP 8 style guide                              | 1.4       | Expat License                                                |
| [Babel](https://pypi.python.org/pypi/Babel)                                                 | Internationalization utilities                                                                                 | 2.6.0     | BSD                                                          |
| [backcall](https://pypi.python.org/pypi/backcall)                                           | Specifications for callback functions passed in to an API                                                      | 0.1.0     | BSD                                                          |
| [backports.functools-lru-cache](https://pypi.python.org/pypi/backports.functools-lru-cache) | backports.functools_lru_cache                                                                                  | 1.5       | UNKNOWN                                                      |
| [bleach](https://pypi.python.org/pypi/bleach)                                               | An easy safelist-based HTML-sanitizing tool.                                                                   | 2.1.4     | Apache Software License                                      |
| [certifi](https://pypi.python.org/pypi/certifi)                                             | Python package for providing Mozilla's CA Bundle.                                                              | 2018.8.24 | MPL-2.0                                                      |
| [chardet](https://pypi.python.org/pypi/chardet)                                             | Universal encoding detector for Python 2 and 3                                                                 | 3.0.4     | LGPL                                                         |
| [cheroot](https://pypi.python.org/pypi/cheroot)                                             | Highly-optimized, pure-python HTTP server                                                                      | 6.5.2     | UNKNOWN                                                      |
| [CherryPy](https://pypi.python.org/pypi/CherryPy)                                           | Object-Oriented HTTP framework                                                                                 | 18.0.1    | UNKNOWN                                                      |
| [commonmark](https://pypi.python.org/pypi/commonmark)                                       | Python parser for the CommonMark Markdown spec                                                                 | 0.8.1     | BSD-3-Clause                                                 |
| [cycler](https://pypi.python.org/pypi/cycler)                                               | Composable style cycles                                                                                        | 0.10.0    | BSD                                                          |
| [decorator](https://pypi.python.org/pypi/decorator)                                         | Better living through Python with decorators                                                                   | 4.3.0     | new BSD License                                              |
| [defusedxml](https://pypi.python.org/pypi/defusedxml)                                       | XML bomb protection for Python stdlib modules                                                                  | 0.5.0     | PSFL                                                         |
| [docutils](https://pypi.python.org/pypi/docutils)                                           | Docutils -- Python Documentation Utilities                                                                     | 0.14      | public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt) |
| [entrypoints](https://pypi.python.org/pypi/entrypoints)                                     | Discover and load entry points from installed packages.                                                        | 0.2.3     | UNKNOWN                                                      |
| [future](https://pypi.python.org/pypi/future)                                               | Clean single-source support for Python 3 and 2                                                                 | 0.16.0    | MIT                                                          |
| [gast](https://pypi.python.org/pypi/gast)                                                   | Python AST that abstracts the underlying Python version                                                        | 0.2.0     | BSD 3-Clause                                                 |
| [grpcio](https://pypi.python.org/pypi/grpcio)                                               | HTTP/2-based RPC framework                                                                                     | 1.15.0    | Apache License 2.0                                           |
| [h5py](https://pypi.python.org/pypi/h5py)                                                   | Read and write HDF5 files from Python                                                                          | 2.8.0     | BSD                                                          |
| [histbook](https://pypi.python.org/pypi/histbook)                                           | Versatile, high-performance histogram toolkit for Numpy.                                                       | 1.2.3     | BSD 3-clause                                                 |
| [html5lib](https://pypi.python.org/pypi/html5lib)                                           | HTML parser based on the WHATWG HTML specification                                                             | 1.0.1     | MIT License                                                  |
| [idna](https://pypi.python.org/pypi/idna)                                                   | Internationalized Domain Names in Applications (IDNA)                                                          | 2.7       | BSD-like                                                     |
| [imagesize](https://pypi.python.org/pypi/imagesize)                                         | Getting image size from png/jpeg/jpeg2000/gif file                                                             | 1.1.0     | MIT                                                          |
| [ipykernel](https://pypi.python.org/pypi/ipykernel)                                         | IPython Kernel for Jupyter                                                                                     | 4.9.0     | BSD                                                          |
| [ipython](https://pypi.python.org/pypi/ipython)                                             | IPython: Productive Interactive Computing                                                                      | 6.5.0     | BSD                                                          |
| [ipython-genutils](https://pypi.python.org/pypi/ipython-genutils)                           | Vestigial utilities from IPython                                                                               | 0.2.0     | BSD                                                          |
| [ipywidgets](https://pypi.python.org/pypi/ipywidgets)                                       | IPython HTML widgets for Jupyter                                                                               | 7.4.2     | BSD                                                          |
| [jaraco.functools](https://pypi.python.org/pypi/jaraco.functools)                           | jaraco.functools                                                                                               | 1.20      | UNKNOWN                                                      |
| [jedi](https://pypi.python.org/pypi/jedi)                                                   | An autocompletion tool for Python that can be used for text editors.                                           | 0.12.1    | MIT                                                          |
| [Jinja2](https://pypi.python.org/pypi/Jinja2)                                               | A small but fast and easy to use stand-alone template engine written in pure python.                           | 2.10      | BSD                                                          |
| [jsonschema](https://pypi.python.org/pypi/jsonschema)                                       | An implementation of JSON Schema validation for Python                                                         | 2.6.0     | MIT                                                          |
| [jupyter](https://pypi.python.org/pypi/jupyter)                                             | Jupyter metapackage. Install all the Jupyter components in one go.                                             | 1.0.0     | BSD                                                          |
| [jupyter-client](https://pypi.python.org/pypi/jupyter-client)                               | Jupyter protocol implementation and client libraries                                                           | 5.2.3     | BSD                                                          |
| [jupyter-console](https://pypi.python.org/pypi/jupyter-console)                             | Jupyter terminal console                                                                                       | 5.2.0     | BSD                                                          |
| [jupyter-core](https://pypi.python.org/pypi/jupyter-core)                                   | Jupyter core package. A base package on which Jupyter projects rely.                                           | 4.4.0     | BSD                                                          |
| [Keras](https://pypi.python.org/pypi/Keras)                                                 | Deep Learning for humans                                                                                       | 2.2.2     | MIT                                                          |
| [Keras-Applications](https://pypi.python.org/pypi/Keras-Applications)                       | Reference implementations of popular deep learning models                                                      | 1.0.4     | MIT                                                          |
| [Keras-Preprocessing](https://pypi.python.org/pypi/Keras-Preprocessing)                     | Easy data preprocessing and data augmentation for deep learning models                                         | 1.0.2     | MIT                                                          |
| [kiwisolver](https://pypi.python.org/pypi/kiwisolver)                                       | A fast implementation of the Cassowary constraint solver                                                       | 1.0.1     | UNKNOWN                                                      |
| [lxml](https://pypi.python.org/pypi/lxml)                                                   | Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.               | 4.2.5     | BSD                                                          |
| [Markdown](https://pypi.python.org/pypi/Markdown)                                           | Python implementation of Markdown.                                                                             | 2.6.11    | BSD License                                                  |
| [MarkupSafe](https://pypi.python.org/pypi/MarkupSafe)                                       | Implements a XML/HTML/XHTML Markup safe string for Python                                                      | 1.0       | BSD                                                          |
| [matplotlib](https://pypi.python.org/pypi/matplotlib)                                       | Python plotting package                                                                                        | 2.2.3     | BSD                                                          |
| [mccabe](https://pypi.python.org/pypi/mccabe)                                               | McCabe checker, plugin for flake8                                                                              | 0.6.1     | Expat license                                                |
| [metakernel](https://pypi.python.org/pypi/metakernel)                                       | Metakernel for Jupyter                                                                                         | 0.20.14   | UNKNOWN                                                      |
| [mistune](https://pypi.python.org/pypi/mistune)                                             | The fastest markdown parser in pure Python                                                                     | 0.8.3     | BSD                                                          |
| [more-itertools](https://pypi.python.org/pypi/more-itertools)                               | More routines for operating on iterables, beyond itertools                                                     | 4.3.0     | MIT                                                          |
| [nbconvert](https://pypi.python.org/pypi/nbconvert)                                         | Converting Jupyter Notebooks                                                                                   | 5.4.0     | BSD                                                          |
| [nbformat](https://pypi.python.org/pypi/nbformat)                                           | The Jupyter Notebook format                                                                                    | 4.4.0     | BSD                                                          |
| [notebook](https://pypi.python.org/pypi/notebook)                                           | A web-based notebook environment for interactive computing                                                     | 5.6.0     | BSD                                                          |
| [numexpr](https://pypi.python.org/pypi/numexpr)                                             | Fast numerical expression evaluator for NumPy                                                                  | 2.6.8     | MIT                                                          |
| [numpy](https://pypi.python.org/pypi/numpy)                                                 | NumPy: array processing for numbers, strings, records, and objects.                                            | 1.15.1    | BSD                                                          |
| [packaging](https://pypi.python.org/pypi/packaging)                                         | Core utilities for Python packages                                                                             | 17.1      | BSD or Apache License, Version 2.0                           |
| [pandas](https://pypi.python.org/pypi/pandas)                                               | Powerful data structures for data analysis, time series, and statistics                                        | 0.23.4    | BSD                                                          |
| [pandocfilters](https://pypi.python.org/pypi/pandocfilters)                                 | Utilities for writing pandoc filters in python                                                                 | 1.4.2     | UNKNOWN                                                      |
| [parso](https://pypi.python.org/pypi/parso)                                                 | A Python Parser                                                                                                | 0.3.1     | MIT                                                          |
| [pep8](https://pypi.python.org/pypi/pep8)                                                   | Python style guide checker                                                                                     | 1.7.1     | Expat license                                                |
| [pexpect](https://pypi.python.org/pypi/pexpect)                                             | Pexpect allows easy control of interactive console applications.                                               | 4.6.0     | ISC license                                                  |
| [pickleshare](https://pypi.python.org/pypi/pickleshare)                                     | Tiny 'shelve'-like database with concurrency support                                                           | 0.7.4     | MIT                                                          |
| [portend](https://pypi.python.org/pypi/portend)                                             | TCP port monitoring utilities                                                                                  | 2.3       | UNKNOWN                                                      |
| [prometheus-client](https://pypi.python.org/pypi/prometheus-client)                         | Python client for the Prometheus monitoring system.                                                            | 0.3.1     | Apache Software License 2.0                                  |
| [prompt-toolkit](https://pypi.python.org/pypi/prompt-toolkit)                               | Library for building powerful interactive command lines in Python                                              | 1.0.15    | UNKNOWN                                                      |
| [protobuf](https://pypi.python.org/pypi/protobuf)                                           | Protocol Buffers                                                                                               | 3.6.1     | 3-Clause BSD License                                         |
| [ptyprocess](https://pypi.python.org/pypi/ptyprocess)                                       | Run a subprocess in a pseudo terminal                                                                          | 0.6.0     | UNKNOWN                                                      |
| [pycodestyle](https://pypi.python.org/pypi/pycodestyle)                                     | Python style guide checker                                                                                     | 2.4.0     | Expat license                                                |
| [pydocstyle](https://pypi.python.org/pypi/pydocstyle)                                       | Python docstring style checker                                                                                 | 2.1.1     | MIT                                                          |
| [pyflakes](https://pypi.python.org/pypi/pyflakes)                                           | passive checker of Python programs                                                                             | 2.0.0     | MIT                                                          |
| [Pygments](https://pypi.python.org/pypi/Pygments)                                           | Pygments is a syntax highlighting package written in Python.                                                   | 2.2.0     | BSD License                                                  |
| [pylama](https://pypi.python.org/pypi/pylama)                                               | pylama -- Code audit tool for python                                                                           | 7.4.3     | None                                                         |
| [pyparsing](https://pypi.python.org/pypi/pyparsing)                                         | Python parsing module                                                                                          | 2.2.1     | MIT License                                                  |
| [python-dateutil](https://pypi.python.org/pypi/python-dateutil)                             | Extensions to the standard Python datetime module                                                              | 2.7.3     | Dual License                                                 |
| [pytz](https://pypi.python.org/pypi/pytz)                                                   | World timezone definitions, modern and historical                                                              | 2018.5    | MIT                                                          |
| [PyYAML](https://pypi.python.org/pypi/PyYAML)                                               | YAML parser and emitter for Python                                                                             | 3.13      | MIT                                                          |
| [pyzmq](https://pypi.python.org/pypi/pyzmq)                                                 | Python bindings for 0MQ                                                                                        | 17.1.2    | LGPL+BSD                                                     |
| [qtconsole](https://pypi.python.org/pypi/qtconsole)                                         | Jupyter Qt console                                                                                             | 4.4.1     | BSD                                                          |
| [requests](https://pypi.python.org/pypi/requests)                                           | Python HTTP for Humans.                                                                                        | 2.19.1    | Apache 2.0                                                   |
| [scikit-learn](https://pypi.python.org/pypi/scikit-learn)                                   | A set of python modules for machine learning and data mining                                                   | 0.19.2    | new BSD                                                      |
| [scipy](https://pypi.python.org/pypi/scipy)                                                 | SciPy: Scientific Library for Python                                                                           | 1.1.0     | BSD                                                          |
| [scons](https://pypi.python.org/pypi/scons)                                                 | Open Source next-generation build tool.                                                                        | 3.0.1     | UNKNOWN                                                      |
| [seaborn](https://pypi.python.org/pypi/seaborn)                                             | seaborn: statistical data visualization                                                                        | 0.9.0     | BSD (3-clause)                                               |
| [Send2Trash](https://pypi.python.org/pypi/Send2Trash)                                       | Send file to trash natively under Mac OS X, Windows and Linux.                                                 | 1.5.0     | BSD License                                                  |
| [simplegeneric](https://pypi.python.org/pypi/simplegeneric)                                 | Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)                                  | 0.8.1     | ZPL 2.1                                                      |
| [six](https://pypi.python.org/pypi/six)                                                     | Python 2 and 3 compatibility utilities                                                                         | 1.11.0    | MIT                                                          |
| [snowballstemmer](https://pypi.python.org/pypi/snowballstemmer)                             | This package provides 16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms. | 1.2.1     | BSD                                                          |
| [Sphinx](https://pypi.python.org/pypi/Sphinx)                                               | Python documentation generator                                                                                 | 1.8.0     | BSD                                                          |
| [sphinxcontrib-websupport](https://pypi.python.org/pypi/sphinxcontrib-websupport)           | Sphinx API for Web Apps                                                                                        | 1.1.0     | BSD                                                          |
| [tables](https://pypi.python.org/pypi/tables)                                               | Hierarchical datasets for Python                                                                               | 3.4.4     | BSD 2-Clause                                                 |
| [tempora](https://pypi.python.org/pypi/tempora)                                             | Objects and routines pertaining to date and time (tempora)                                                     | 1.13      | UNKNOWN                                                      |
| [tensorboard](https://pypi.python.org/pypi/tensorboard)                                     | TensorBoard lets you watch Tensors Flow                                                                        | 1.10.0    | Apache 2.0                                                   |
| [tensorflow](https://pypi.python.org/pypi/tensorflow)                                       | TensorFlow is an open source machine learning framework for everyone.                                          | 1.10.1    | Apache 2.0                                                   |
| [termcolor](https://pypi.python.org/pypi/termcolor)                                         | ANSII Color formatting for output in terminal.                                                                 | 1.1.0     | MIT                                                          |
| [terminado](https://pypi.python.org/pypi/terminado)                                         | Terminals served to xterm.js using Tornado websockets                                                          | 0.8.1     | UNKNOWN                                                      |
| [testpath](https://pypi.python.org/pypi/testpath)                                           | Test utilities for code working with files and commands                                                        | 0.3.1     | UNKNOWN                                                      |
| [Theano](https://pypi.python.org/pypi/Theano)                                               | Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs.                                  | 1.0.2     | BSD                                                          |
| [tornado](https://pypi.python.org/pypi/tornado)                                             | Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.     | 5.1.1     | http://www.apache.org/licenses/LICENSE-2.0                   |
| [traitlets](https://pypi.python.org/pypi/traitlets)                                         | Traitlets Python config system                                                                                 | 4.3.2     | BSD                                                          |
| [uproot](https://pypi.python.org/pypi/uproot)                                               | ROOT I/O in pure Python and Numpy.                                                                             | 2.9.11    | BSD 3-clause                                                 |
| [urllib3](https://pypi.python.org/pypi/urllib3)                                             | HTTP library with thread-safe connection pooling, file post, and more.                                         | 1.23      | MIT                                                          |
| [wcwidth](https://pypi.python.org/pypi/wcwidth)                                             | Measures number of Terminal column cells of wide-character codes                                               | 0.1.7     | MIT                                                          |
| [webencodings](https://pypi.python.org/pypi/webencodings)                                   | Character encoding aliases for legacy web content                                                              | 0.5.1     | BSD                                                          |
| [Werkzeug](https://pypi.python.org/pypi/Werkzeug)                                           | The comprehensive WSGI web application library.                                                                | 0.14.1    | BSD                                                          |
| [wheel](https://pypi.python.org/pypi/wheel)                                                 | A built-package format for Python.                                                                             | 0.31.1    | MIT                                                          |
| [widgetsnbextension](https://pypi.python.org/pypi/widgetsnbextension)                       | IPython HTML widgets for Jupyter                                                                               | 3.4.2     | BSD                                                          |
| [zc.lockfile](https://pypi.python.org/pypi/zc.lockfile)                                     | Basic inter-process locks                                                                                      | 1.3.0     | ZPL 2.1                                                      |
