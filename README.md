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
| [belle\_legacy](https://stash.desy.de/projects/B2G/repos/belle_legacy/)      | 1.7              |
| [GNU Binutils](https://www.gnu.org/software/binutils/)                       | 2.26             |
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.61             |
| [bzip2](http://www.bzip.org/)                                                | 1.06             |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.2.0.4          |
| [CMake](https://cmake.org/)                                                  | 3.5.2            |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7              |
| [curl](https://curl.haxx.se/)                                                | 7.49.1           |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.2.8            |
| [EvtGen](http://evtgen.warwick.ac.uk/)                                       | R01-04-00        |
| [ExRootAnalysis](http://madgraph.hep.uiuc.edu/Downloads/ExRootAnalysis/)     | 1.1.2            |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0 |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 3.2              |
| [FreeType](http://www.freetype.org/)                                         | 2.6.3            |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 6.2              |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 7.11             |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 10.01.p02        |
| [git](https://git-scm.com/)                                                  | 2.9.0            |
| [Google Test](https://github.com/google/googletest)                          | 1.8.0            |
| [HepMC](http://lcgapp.cern.ch/project/simu/HepMC/)                           | 2.06.09          |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.4            |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.29           |
| [MG5\_aMC](https://launchpad.net/mg5amcnlo)                                  | 2.2.2            |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-03-04        |
| [NeuroBayes](http://neurobayes.phi-t.de/)                                    | 3.7.0            |
| `nsm2`                                                                       | 2.1.9.27         |
| [PHOTOS](http://photospp.web.cern.ch/photospp/)                              | 3.56             |
| [PostgreSQL](http://www.postgresql.org/)                                     | 9.2.4            |
| [PYTHIA](http://home.thep.lu.se/~torbjorn/Pythia.html)                       | 8.215            |
| [Python](https://www.python.org/)                                            | 3.5.2            |
| [rave](https://github.com/rave-package/rave)                                 | 0.6.25           |
| [ROOT](https://root.cern.ch/)                                                | 6.06/08          |
| [SCons](http://scons.org/)                                                   | 2.3.6            |
| [SQLite](https://www.sqlite.org/)                                            | 3.13             |
| [Tauola](http://tauolapp.web.cern.ch/tauolapp/)                              | 1.1.4            |
| [Virtual Geometry Model (VGM)](http://ivana.home.cern.ch/ivana/VGM.html)     | 4.3              |
| [XRootD](http://xrootd.org/)                                                 | 4.3.0            |
| [zlib](http://www.zlib.net/)                                                 | 1.2.8            |

GCC requires some additional libraries which are downloaded as part of the GCC compilation:

| Software Package                                                             | Version          |
|------------------------------------------------------------------------------|------------------|
| [GNU MPC](http://www.multiprecision.org/)                                    | 1.0.3            |
| [The GNU MPFR Library](http://www.mpfr.org/)                                 | 3.1.5            |
| [The GNU Multiple Precision Arithmetic Library](https://gmplib.org/)         | 6.1.1            |
| [Integer Set Library](http://isl.gforge.inria.fr/)                           | 0.17.1           |

Optional Package
----------------

This section lists all optional packages. These are not compiled by default but
included for simplified access.

To compile any of these just go into the external directory and type

    make <package name>

| Software Package                                                             | Version          |
|------------------------------------------------------------------------------|------------------|
| [Cppcheck](http://cppcheck.sourceforge.net/)                                 | 1.75             |
| [Doxygen](http://www.doxygen.org)                                            | 1.8.11           |
| [LLVM/Clang](http://llvm.org/)                                               | 3.9.0            |
| [Valgrind](http://valgrind.org/)                                             | 3.11             |


Python Packages
---------------

This section lists all the python packages which are currently included in the
externals

| Python Package                                                               | Version          |
|------------------------------------------------------------------------------|------------------|
| [autopep8 ](https://pypi.python.org/pypi/autopep8 )                          | 1.2.1a0          |
| [CherryPy](https://pypi.python.org/pypi/CherryPy)                            | 4.0.0            |
| [cycler](https://pypi.python.org/pypi/cycler)                                | 0.10.0           |
| [decorator](https://pypi.python.org/pypi/decorator)                          | 4.0.4            |
| [ipython](https://pypi.python.org/pypi/ipython)                              | 4.0.0            |
| [ipython-genutils](https://pypi.python.org/pypi/ipython-genutils)            | 0.1.0            |
| [lxml](https://pypi.python.org/pypi/lxml)                                    | 3.4.4            |
| [matplotlib](https://pypi.python.org/pypi/matplotlib)                        | 1.5.1            |
| [numpy](https://pypi.python.org/pypi/numpy)                                  | 1.9.2            |
| [path.py](https://pypi.python.org/pypi/path.py)                              | 8.1.1            |
| [pep8](https://pypi.python.org/pypi/pep8)                                    | 1.6.3a0          |
| [pexpect](https://pypi.python.org/pypi/pexpect)                              | 3.3              |
| [pickleshare](https://pypi.python.org/pypi/pickleshare)                      | 0.5              |
| [pip](https://pypi.python.org/pypi/pip)                                      | 7.1.2            |
| [pyparsing](https://pypi.python.org/pypi/pyparsing)                          | 2.1.0            |
| [python-dateutil](https://pypi.python.org/pypi/python-dateutil)              | 2.5.0            |
| [pytz](https://pypi.python.org/pypi/pytz)                                    | 2015.7           |
| [requests](https://pypi.python.org/pypi/requests)                            | 2.7.0            |
| [setuptools](https://pypi.python.org/pypi/setuptools)                        | 18.2             |
| [setuptools-scm](https://pypi.python.org/pypi/setuptools-scm)                | 1.7.0            |
| [simplegeneric](https://pypi.python.org/pypi/simplegeneric)                  | 0.8.1            |
| [six](https://pypi.python.org/pypi/six)                                      | 1.10.0           |
| [traitlets](https://pypi.python.org/pypi/traitlets)                          | 4.0.0            |
