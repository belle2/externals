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

| Software Package                                                             | Version          |
|------------------------------------------------------------------------------|------------------|
| [Artistic Style (astyle)](http://astyle.sourceforge.net/)                    | 2.05.1           |
| `BELLE_FLC`                                                                  | ?                |
| [belle\_legacy](https://stash.desy.de/projects/B2G/repos/belle_legacy/)      | 1.9              |
| [GNU Binutils](https://www.gnu.org/software/binutils/)                       | 2.27             |
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.63             |
| [bzip2](http://www.bzip.org/)                                                | 1.06             |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.2.0.4          |
| [CMake](https://cmake.org/)                                                  | 3.7.1            |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7              |
| [cppzmq](https://github.com/zeromq/cppzmq)                                   | git6c91034       |
| [curl](https://curl.haxx.se/)                                                | 7.52.1           |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.3.1            |
| [EvtGen](http://evtgen.warwick.ac.uk/)                                       | R01-04-00        |
| [ExRootAnalysis](http://madgraph.hep.uiuc.edu/Downloads/ExRootAnalysis/)     | 1.1.2            |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0 |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 3.2              |
| [FreeType](http://www.freetype.org/)                                         | 2.7.1            |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 6.3              |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 7.12             |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 10.01.p02        |
| [git](https://git-scm.com/)                                                  | 2.11.0           |
| [Google Test](https://github.com/google/googletest)                          | 1.8.0            |
| [HepMC](http://lcgapp.cern.ch/project/simu/HepMC/)                           | 2.06.09          |
| [jemalloc memory allocator](http://jemalloc.net/)                            | 4.4.0            |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.4            |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.29           |
| [MG5\_aMC](https://launchpad.net/mg5amcnlo)                                  | 2.2.2            |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-03-04        |
| [NeurobayesCppInterface](https://github.com/thomaskeck/NeurobayesCppInterface) | d1cf3d2        |
| `nsm2`                                                                       | 2.1.9.27         |
| [PHOTOS](http://photospp.web.cern.ch/photospp/)                              | 3.56             |
| [PostgreSQL](http://www.postgresql.org/)                                     | 9.2.4            |
| [PYTHIA](http://home.thep.lu.se/~torbjorn/Pythia.html)                       | 8.215            |
| [Python](https://www.python.org/)                                            | 3.5.2            |
| [rave](https://github.com/rave-package/rave)                                 | 0.6.25           |
| [ROOT](https://root.cern.ch/)                                                | 6.08/06          |
| [SCons](http://scons.org/)                                                   | 2.3.6            |
| [SQLite](https://www.sqlite.org/)                                            | 3.16.2           |
| [Tauola](http://tauolapp.web.cern.ch/tauolapp/)                              | 1.1.4            |
| [Virtual Geometry Model (VGM)](http://ivana.home.cern.ch/ivana/VGM.html)     | 4.3              |
| [XRootD](http://xrootd.org/)                                                 | 4.5.0            |
| [zeromq](http://www.zeromq.org/)                                             | 4.2.0            |
| [zlib](http://www.zlib.net/)                                                 | 1.2.11           |

GCC requires some additional libraries which are downloaded as part of the GCC compilation:

| Software Package                                                             | Version          |
|------------------------------------------------------------------------------|------------------|
| [GNU MPC](http://www.multiprecision.org/)                                    | 1.0.3            |
| [The GNU MPFR Library](http://www.mpfr.org/)                                 | 3.1.5            |
| [The GNU Multiple Precision Arithmetic Library](https://gmplib.org/)         | 6.1.2            |
| [Integer Set Library](http://isl.gforge.inria.fr/)                           | 0.18             |

Optional Package
----------------

This section lists all optional packages. These are not compiled by default but
included for simplified access.

To compile any of these just go into the external directory and type

    make <package name>

| Software Package                                                             | Version          |
|------------------------------------------------------------------------------|------------------|
| [Cppcheck](http://cppcheck.sourceforge.net/)                                 | 1.77             |
| [Doxygen](http://www.doxygen.org)                                            | 1.8.13           |
| [LLVM/Clang](http://llvm.org/), including libcxx and sanitizer tools         | 3.9.1            |
| [Valgrind](http://valgrind.org/)                                             | 3.12             |


Python Packages
---------------

This section lists all the python packages which are currently included in the
externals.

| Name                                                              | Summary                                                                                          | Version |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|---------|
| [autopep8](https://pypi.python.org/pypi/autopep8)                 | A tool that automatically formats Python code to conform to the PEP 8 style guide                | 1.2.4   |
| [cheroot](https://pypi.python.org/pypi/cheroot)                   | Highly-optimized, pure-python HTTP server                                                        | 5.1.0   |
| [CherryPy](https://pypi.python.org/pypi/CherryPy)                 | Object-Oriented HTTP framework                                                                   | 10.1.1  |
| [cycler](https://pypi.python.org/pypi/cycler)                     | Composable style cycles                                                                          | 0.10.0  |
| [decorator](https://pypi.python.org/pypi/decorator)               | Better living through Python with decorators                                                     | 4.0.11  |
| [ipython](https://pypi.python.org/pypi/ipython)                   | IPython: Productive Interactive Computing                                                        | 5.1.0   |
| [ipython-genutils](https://pypi.python.org/pypi/ipython-genutils) | Vestigial utilities from IPython                                                                 | 0.1.0   |
| [lxml](https://pypi.python.org/pypi/lxml)                         | Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API. | 3.7.3   |
| [matplotlib](https://pypi.python.org/pypi/matplotlib)             | Python plotting package                                                                          | 2.0.0   |
| [numpy](https://pypi.python.org/pypi/numpy)                       | NumPy: array processing for numbers, strings, records, and objects.                              | 1.12.0  |
| [path.py](https://pypi.python.org/pypi/path.py)                   | A module wrapper for os.path                                                                     | 10.1    |
| [pep8](https://pypi.python.org/pypi/pep8)                         | Python style guide checker                                                                       | 1.7.0   |
| [pexpect](https://pypi.python.org/pypi/pexpect)                   | Pexpect allows easy control of interactive console applications.                                 | 4.2.1   |
| [pickleshare](https://pypi.python.org/pypi/pickleshare)           | Tiny 'shelve'-like database with concurrency support                                             | 0.7.4   |
| [portend](https://pypi.python.org/pypi/portend)                   | TCP port monitoring utilities                                                                    | 1.8     |
| [prompt-toolkit](https://pypi.python.org/pypi/prompt-toolkit)     | Library for building powerful interactive command lines in Python                                | 1.0.13  |
| [ptyprocess](https://pypi.python.org/pypi/ptyprocess)             | Run a subprocess in a pseudo terminal                                                            | 0.5.1   |
| [Pygments](https://pypi.python.org/pypi/Pygments)                 | Pygments is a syntax highlighting package written in Python.                                     | 2.2.0   |
| [pyparsing](https://pypi.python.org/pypi/pyparsing)               | Python parsing module                                                                            | 2.1.10  |
| [python-dateutil](https://pypi.python.org/pypi/python-dateutil)   | Extensions to the standard Python datetime module                                                | 2.6.0   |
| [pytz](https://pypi.python.org/pypi/pytz)                         | World timezone definitions, modern and historical                                                | 2016.10 |
| [requests](https://pypi.python.org/pypi/requests)                 | Python HTTP for Humans.                                                                          | 2.13.0  |
| [simplegeneric](https://pypi.python.org/pypi/simplegeneric)       | Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)                    | 0.8.1   |
| [six](https://pypi.python.org/pypi/six)                           | Python 2 and 3 compatibility utilities                                                           | 1.10.0  |
| [tempora](https://pypi.python.org/pypi/tempora)                   | Objects and routines pertaining to date and time (tempora)                                       | 1.6.1   |
| [traitlets](https://pypi.python.org/pypi/traitlets)               | Traitlets Python config system                                                                   | 4.3.1   |
| [wcwidth](https://pypi.python.org/pypi/wcwidth)                   | Measures number of Terminal column cells of wide-character codes                                 | 0.1.7   |

These packages are a result of running

    pip3 install autopep8 CherryPy ipython lxml matplotlib numpy pep8 requests

All other packages are just dependencies of these and versions between them are
fixed in the externals.
