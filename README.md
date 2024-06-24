basf2 Externals
===============

This repository contains the code to download and build the external software used by
the [Belle II Analysis Software Framework (basf2)](https://github.com/belle2/basf2).

Most users should be able to just install precompiled versions and should not need to
recompile the externals by hand. Please check the
[documentation](https://software.belle2.org/development/sphinx/build/tools_doc/installation-tools.html).

Included Software Packages
--------------------------

This section lists all the software packages which are currently included in the
externals.

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [Artistic Style (astyle)](http://astyle.sourceforge.net/)                    | 3.1             | MIT        |
| [bazel](https://bazel.build/)                                                | 0.26.1          | Apache 2.0 |
| `BELLE_FLC`                                                                  | ?               | -          |
| [belle\_legacy](https://gitlab.desy.de/belle2/software/belle_legacy/)        | 1.11            | -          |
| [GNU Binutils](https://www.gnu.org/software/binutils/)                       | 2.41            | GPLv2      |
| [Boost C++ Libraries](http://www.boost.org/)                                 | 1.78            | [Boost License](http://www.boost.org/users/license.html) |
| [bzip2](https://www.sourceware.org/bzip2/)                                   | 1.08            | BSD-style  |
| [clhep](http://proj-clhep.web.cern.ch/proj-clhep/)                           | 2.4.7.1         | LGPLv3     |
| [CMake](https://cmake.org/)                                                  | 3.28.3          | BSD-style  |
| [Cosmic-ray Shower Library (CRY)](http://nuclear.llnl.gov/simulation/)       | 1.7             | -          |
| [cppzmq](https://github.com/zeromq/cppzmq)                                   | 4.7.1           | MIT-style  |
| [curl](https://curl.haxx.se/)                                                | 7.77.0          | MIT-style (see also: [License Mixing](https://curl.haxx.se/legal/licmix.html)) |
| [davix](https://github.com/cern-fts/davix)                                   | 0.8.6           | LGPLv2     |
| [Eigen](http://eigen.tuxfamily.org/)                                         | 3.4.0           | MPLv2      |
| [EPICS](https://epics.anl.gov/index.php)                                     | 7.0.5           | [EPICS License](https://epics.anl.gov/license/open.php?product=EPICS+Base) |
| [EvtGen](https://evtgen.hepforge.org/)                                       | R02-00-00       | GPLv3      |
| [FANN](http://leenissen.dk/fann/wp/)                                         | 2.2.0+git8ae6bb0| LGPL       |
| [FastBDT](https://github.com/thomaskeck/FastBDT)                             | 5.2             | GPLv3      |
| [FastJet](http://fastjet.fr/)                                                | 3.3.4           | GPLv2 (and others) |
| [FFTW3](http://fftw.org/)                                                    | 3.3.9           | GPL        |
| [Frugally-deep](https://github.com/Dobiasd/frugally-deep)                    | 0.15.19-p0      | MIT        |
| [FunctionalPlus](https://github.com/Dobiasd/FunctionalPlus)                  | 0.2.18-p0       | [Boost Software License](http://www.boost.org/users/license.html) |
| [GCC, the GNU Compiler Collection](https://gcc.gnu.org/)                     | 14.1.0          | GPLv2/GPLv3 + Runtime library Exception |
| [GDB: The GNU Project Debugger](https://www.gnu.org/software/gdb/)           | 14.2            | GPLv2      |
| [Geant4](http://geant4.web.cern.ch/geant4/)                                  | 11.2.1          | Geant4 License |
| [git](https://git-scm.com/)                                                  | 2.31.0          | GPLv2      |
| [git-lfs](https://git-lfs.github.com/)                                       | 2.13.2          | MIT        |
| [GMP, The GNU Multiple Precision Arithmetic Library](https://gmplib.org/)    | 6.2.1           | LGPLv3 + GPLv2 |
| [GSL - GNU Scientific Library](https://www.gnu.org/software/gsl/)            | 2.6             | GPLv3      |
| [Google Test](https://github.com/google/googletest)                          | 1.10.0          | BSD        |
| [Hammer](https://hammer.physics.lbl.gov/)                                    | 1.4.1           | GPLv3      |
| [HDF5](https://www.hdfgroup.org/)                                            | 1.12.0          | BSD        |
| [HepMC](https://ep-dep-sft.web.cern.ch/project/hepmc)                        | 2.06.11         | GPLv2      |
| [Integer Set Library](https://libisl.sourceforge.io/)                        | 0.26            | MIT        |
| [jemalloc memory allocator](http://jemalloc.net/)                            | 5.2.1           | BSD-style  |
| [libffi](https://github.com/libffi/libffi)                                   | 3.3             | BSD-style  |
| [Libxml2](http://www.xmlsoft.org)                                            | 2.9.13          | MIT        |
| [Libxslt](http://xmlsoft.org/libxslt/)                                       | 1.1.35          | MIT        |
| [LZ4](https://lz4.github.io/lz4/)                                            | 1.9.3           | BSD + GPLv2 |
| [Madgraph MG5\_aMC](https://launchpad.net/mg5amcnlo)                         | 3.4.0           | [UoI-NCSA](https://opensource.org/licenses/UoI-NCSA.php) (according to launchpad.net) |
| [Millepede-II](http://www.desy.de/~kleinwrt/MP2/doc/html/index.html)         | V04-16-03       | LGPLv2     |
| [GNU MPC](http://www.multiprecision.org/)                                    | 1.2.1           | LGPLv3+    |
| [The GNU MPFR Library](http://www.mpfr.org/)                                 | 4.1.0           | LGPLv3+    |
| [NeurobayesCppInterface](https://github.com/thomaskeck/NeurobayesCppInterface) | c7d36c5       | MIT        |
| [Ninja](https://github.com/ninja-build/ninja)                                | 1.10.2          | Apache v2  |
| [nlohmann/json](https://github.com/nlohmann/json/): JSON for Modern C++      | 3.10.5          | MIT        |
| [pandoc](https://pandoc.org)                                                 | 2.12            | GPLv2 or later |
| [PHOTOS](https://gitlab.cern.ch/photospp/photospp/)                          | 3.64            | MIT        |
| [PostgreSQL](http://www.postgresql.org/) interface                           | 13.2            | [PostgreSQL License](https://opensource.org/licenses/postgresql) (similar to BSD/MIT) |
| [PYTHIA](https://pythia.org/)                                                | 8.215           | GPLv2      |
| [Python](https://www.python.org/)                                            | 3.8.8           | PSFL (BSD-style) |
| [PyTorch](https://pytorch.org/)                                              | 2.2.2           | BSD        |
| [rave](https://github.com/rave-package/rave)                                 | 0.6.25          | GPLv2      |
| [rclone](https://rclone.org/)                                                | v1.54.1         | MIT        |
| [ROOT](https://root.cern.ch/)                                                | 6.26/14         | LGPLv2.1 (GPLv3 for MathMore)  |
| [RooUnfold](https://gitlab.cern.ch/RooUnfold/RooUnfold)                      | 3.0.0           | -          |
| [SQLite](https://www.sqlite.org/)                                            | 3.35.1          | Public Domain |
| [Tauola](http://tauolapp.web.cern.ch/tauolapp/)                              | 1.1.8           | -          |
| [TBB](https://oneapi-src.github.io/oneTBB/)                                  | 2021.9.0        | Apache 2.0 |
| libuuid, a part of [util-linux](https://www.kernel.org/pub/linux/utils/util-linux/) | 2.35.1   | BSD        |
| [Vc](https://github.com/VcDevel/Vc) SIMD Vector Classes for C++              | 1.4.5           | BSD        |
| [VecCore](https://github.com/root-project/veccore) SIMD Vectorization Library | 0.8.1          | Apache v2  |
| [VecGeom](https://gitlab.cern.ch/VecGeom/VecGeom) Vectorized Geometry        | 1.2.8           | Apache v2  |
| [Virtual Geometry Model (VGM)](https://vmc-project.github.io/vgm-documentation/)     | 5.2     | GPLv2      |
| [WHIZARD](https://whizard.hepforge.org/)                                     | 3.1.2           | GPLv2      |
| [XRootD](http://xrootd.org/)                                                 | 5.6.1           | LGPLv3     |
| [xz](https://tukaani.org/xz/)                                                | 5.2.5           | Public Domain + GPLv2+ |
| [yaml-cpp](https://github.com/jbeder/yaml-cpp)                               | 0.6.3           | MIT        |
| [zeromq](http://www.zeromq.org/)                                             | 4.3.4           | LGPLv3 + static link exception, intent to move to MPLv2  |
| [zlib](http://www.zlib.net/)                                                 | 1.2.12          | MIT        |

Optional Package
----------------

This section lists all optional packages. These are not compiled by default but included
for simplified access.

To compile any of these just go into the external directory and type

    make <package name>

| Software Package                                                             | Version         | License    |
|------------------------------------------------------------------------------|-----------------|------------|
| [Cppcheck](http://cppcheck.sourceforge.net/)                                 | 2.6             | GPLv3      |
| [Doxygen](http://www.doxygen.org)                                            | 1.9.6           | GPL        |
| [LLVM/Clang](http://llvm.org/), including libcxx and sanitizer tools         | 18.1.6          | [Apache 2 License with LLVM Exceptions](http://releases.llvm.org/18.1.6/LICENSE.TXT) |
| [Valgrind](http://valgrind.org/)                                             | 3.17.0          | GPLv2      |


Python Packages
---------------

This section lists all the python packages which are currently included in the
externals. Basically, these are a result of running

    pip3 install -U pip setuptools wheel
    pip3 install autopep8 awkward awkward-pandas boost-histogram CherryPy click CommonMark cython cymove dgl docutils \
                 eoshep flake8 file-read-backwards gitpython h5py iminuit ipython ipywidgets jira jupyter jupytext keras \
                 lightgbm lxml matplotlib metakernel mysql-connector-python nbsphinx pandas plothist pyarrow pycodestyle \
                 pyhepmc PyJWT pylama pytest python-gitlab pytorch-ignite pytorch-lightning requests rise scikit-learn \
                 scipy scons seaborn sly sphinx sphinx-book-theme sphinx-codeautolink sphinxcontrib-programoutput \
                 splinter sweights tables tabulate tqdm tensorflow tensorflow-probability Theano torch torch-cluster \
                 torch-geometric torch-scatter torch-sparse torch-spline-conv torchaudio torchvision uncertainties uproot \
                 uproot3 xgboost zstandard

All other packages are just dependencies of these and versions between them are fixed in
the externals. The actual dependencies are determined using `pip-compile` from
[pip-tools](https://github.com/jazzband/pip-tools/), see
`tools/create_python_requirements.py` for details.

The package [sphinx-argparse](https://github.com/ribozz/sphinx-argparse/) is included in
a modified version containing some patches not yet included upstream (found in
`src/sphinx-argparse`).


[//]: # (START PYTHON_PKG)

| Name | Summary | Version | License |
| ---- | ------- | ------- | ------- |
| [wheel](https://pypi.org/project/wheel/) | A built-package format for Python | 0.43.0 | MIT  |
| [pip](https://pypi.org/project/pip/) | The PyPA recommended tool for installing Python packages. | 24.1 | MIT |
| [setuptools](https://pypi.org/project/setuptools/) | Easily download, build, install, upgrade, and uninstall Python packages | 70.1.0 | MIT  |
| [absl-py](https://pypi.org/project/absl-py/) | Abseil Python Common Libraries, see https://github.com/abseil/abseil-py. | 2.1.0 | Apache 2.0 |
| [accessible-pygments](https://pypi.org/project/accessible-pygments/) | A collection of accessible pygments styles | 0.0.5 | BSD-3-Clause |
| [aiohttp](https://pypi.org/project/aiohttp/) | Async http client/server framework (asyncio) | 3.9.5 | Apache 2 |
| [aiosignal](https://pypi.org/project/aiosignal/) | aiosignal: a list of registered asynchronous callbacks | 1.3.1 | Apache 2.0 |
| [alabaster](https://pypi.org/project/alabaster/) | A light, configurable Sphinx theme | 0.7.16 | BSD  |
| [anyio](https://pypi.org/project/anyio/) | High level compatibility layer for multiple asynchronous event loop implementations | 4.4.0 | MIT |
| [argon2-cffi](https://pypi.org/project/argon2-cffi/) | Argon2 for Python | 23.1.0 | MIT  |
| [argon2-cffi-bindings](https://pypi.org/project/argon2-cffi-bindings/) | Low-level CFFI bindings for Argon2 | 21.2.0 | MIT |
| [arrow](https://pypi.org/project/arrow/) | Better dates & times for Python | 1.3.0 | Apache Software  |
| [asttokens](https://pypi.org/project/asttokens/) | Annotate AST trees with source code positions | 2.4.1 | Apache 2.0 |
| [astunparse](https://pypi.org/project/astunparse/) | An AST unparser for Python | 1.6.3 | BSD |
| [async-lru](https://pypi.org/project/async-lru/) | Simple LRU cache for asyncio | 2.0.4 | MIT License |
| [attrs](https://pypi.org/project/attrs/) | Classes Without Boilerplate | 23.2.0 | MIT  |
| [autocommand](https://pypi.org/project/autocommand/) | A library to create a command-line program from a function | 2.2.2 | LGPLv3 |
| [autopep8](https://pypi.org/project/autopep8/) | A tool that automatically formats Python code to conform to the PEP 8 style guide | 2.3.1 | MIT  |
| [awkward](https://pypi.org/project/awkward/) | Manipulate JSON-like data with NumPy-like idioms. | 2.6.5 | BSD-3-Clause |
| [awkward-cpp](https://pypi.org/project/awkward-cpp/) | CPU kernels and compiled extensions for Awkward Array | 34 | BSD-3-Clause |
| [awkward-pandas](https://pypi.org/project/awkward-pandas/) | Awkward Array Pandas Extension | 2023.8.0 | BSD  |
| [awkward0](https://pypi.org/project/awkward0/) | Manipulate arrays of complex data structures as easily as Numpy. | 0.15.5 | BSD 3-clause |
| [Babel](https://pypi.org/project/Babel/) | Internationalization utilities | 2.15.0 | BSD-3-Clause |
| [beautifulsoup4](https://pypi.org/project/beautifulsoup4/) | Screen-scraping library | 4.12.3 | MIT License |
| [bleach](https://pypi.org/project/bleach/) | An easy safelist-based HTML-sanitizing tool. | 6.1.0 | Apache Software  |
| [blosc2](https://pypi.org/project/blosc2/) | Python wrapper for the C-Blosc2 library | 2.7.0 | BSD-3-Clause |
| [boost-histogram](https://pypi.org/project/boost-histogram/) | The Boost::Histogram Python wrapper. | 1.4.1 | BSD-3-Clause |
| [cachetools](https://pypi.org/project/cachetools/) | Extensible memoizing collections and decorators | 5.3.3 | MIT |
| [certifi](https://pypi.org/project/certifi/) | Python package for providing Mozilla's CA Bundle. | 2024.6.2 | MPL-2.0 |
| [cffi](https://pypi.org/project/cffi/) | Foreign Function Interface for Python calling C code. | 1.16.0 | MIT |
| [charset-normalizer](https://pypi.org/project/charset-normalizer/) | The Real First Universal Charset Detector | 3.3.2 | MIT |
| [cheroot](https://pypi.org/project/cheroot/) | Highly-optimized, pure-python HTTP server | 10.0.1 | BSD  |
| [CherryPy](https://pypi.org/project/CherryPy/) | Object-Oriented HTTP framework | 18.10.0 | BSD  |
| [click](https://pypi.org/project/click/) | Composable command line interface toolkit | 8.1.7 | BSD-3-Clause |
| [cloudpickle](https://pypi.org/project/cloudpickle/) | Pickler class to extend the standard pickle.Pickler functionality | 3.0.0 | BSD-3-Clause |
| [comm](https://pypi.org/project/comm/) | Jupyter Python Comm implementation, for usage in ipykernel, xeus-python etc. | 0.2.2 | BSD  |
| [commonmark](https://pypi.org/project/commonmark/) | Python parser for the CommonMark Markdown spec | 0.9.1 | BSD-3-Clause |
| [contourpy](https://pypi.org/project/contourpy/) | Python library for calculating contours of 2D quadrilateral grids | 1.2.1 | BSD  |
| [cramjam](https://pypi.org/project/cramjam/) | Thin Python bindings to de/compression algorithms in Rust | 2.8.3 | MIT |
| [cycler](https://pypi.org/project/cycler/) | Composable style cycles | 0.12.1 | BSD  |
| [cymove](https://pypi.org/project/cymove/) | std::move wrapper for cython | 1.0.2 | MIT |
| [Cython](https://pypi.org/project/Cython/) | The Cython compiler for writing C extensions in the Python language. | 3.0.10 | Apache-2.0 |
| [debugpy](https://pypi.org/project/debugpy/) | An implementation of the Debug Adapter Protocol for Python | 1.8.1 | MIT |
| [decorator](https://pypi.org/project/decorator/) | Decorators for Humans | 5.1.1 | new BSD License |
| [defusedxml](https://pypi.org/project/defusedxml/) | XML bomb protection for Python stdlib modules | 0.7.1 | PSFL |
| [dgl](https://pypi.org/project/dgl/) | Deep Graph Library | 2.1.0 | APACHE |
| [dm-tree](https://pypi.org/project/dm-tree/) | Tree is a library for working with nested data structures. | 0.1.8 | Apache 2.0 |
| [docutils](https://pypi.org/project/docutils/) | Docutils -- Python Documentation Utilities | 0.21.2 | Public Domain |
| [dynesty](https://pypi.org/project/dynesty/) | A dynamic nested sampling package for computing Bayesian posteriors and evidences. | 2.1.3 | MIT |
| [eoshep](https://pypi.org/project/eoshep/) | EOS -- A HEP program for Flavor Observables | 1.0.11 | GPLv2 |
| [executing](https://pypi.org/project/executing/) | Get the currently executing AST node of a frame, and other information | 2.0.1 | MIT |
| [fastjsonschema](https://pypi.org/project/fastjsonschema/) | Fastest Python implementation of JSON schema | 2.20.0 | BSD |
| [file-read-backwards](https://pypi.org/project/file-read-backwards/) | Memory efficient way of reading files line-by-line from the end of file | 3.1.0 | MIT license |
| [filelock](https://pypi.org/project/filelock/) | A platform independent file lock. | 3.15.4 | The Unlicense |
| [flake8](https://pypi.org/project/flake8/) | the modular source code checker: pep8 pyflakes and co | 7.1.0 | MIT |
| [flatbuffers](https://pypi.org/project/flatbuffers/) | The FlatBuffers serialization format for Python | 24.3.25 | Apache 2.0 |
| [fonttools](https://pypi.org/project/fonttools/) | Tools to manipulate font files | 4.53.0 | MIT |
| [fqdn](https://pypi.org/project/fqdn/) | Validates fully-qualified domain names against RFC 1123, so that they are acceptable to modern bowsers | 1.5.1 | MPL 2.0 |
| [frozenlist](https://pypi.org/project/frozenlist/) | A list-like structure which implements collections.abc.MutableSequence | 1.4.1 | Apache 2 |
| [gast](https://pypi.org/project/gast/) | Python AST that abstracts the underlying Python version | 0.5.4 | BSD 3-Clause |
| [gitdb](https://pypi.org/project/gitdb/) | Git Object Database | 4.0.11 | BSD License |
| [GitPython](https://pypi.org/project/GitPython/) | GitPython is a Python library used to interact with Git repositories | 3.1.43 | BSD-3-Clause |
| [google-pasta](https://pypi.org/project/google-pasta/) | pasta is an AST-based Python refactoring library | 0.2.0 | Apache 2.0 |
| [grpcio](https://pypi.org/project/grpcio/) | HTTP/2-based RPC framework | 1.64.1 | Apache License 2.0 |
| [h11](https://pypi.org/project/h11/) | A pure-Python, bring-your-own-I/O implementation of HTTP/1.1 | 0.14.0 | MIT |
| [h5py](https://pypi.org/project/h5py/) | Read and write HDF5 files from Python | 3.11.0 | BSD-3-Clause |
| [httpcore](https://pypi.org/project/httpcore/) | A minimal low-level HTTP client. | 1.0.5 | BSD  |
| [httpx](https://pypi.org/project/httpx/) | The next generation HTTP client. | 0.27.0 | BSD  |
| [idna](https://pypi.org/project/idna/) | Internationalized Domain Names in Applications (IDNA) | 3.7 | BSD  |
| [imagesize](https://pypi.org/project/imagesize/) | Getting image size from png/jpeg/jpeg2000/gif file | 1.4.1 | MIT |
| [iminuit](https://pypi.org/project/iminuit/) | Jupyter-friendly Python frontend for MINUIT2 in C++ | 2.26.0 | MIT  |
| [importlib-metadata](https://pypi.org/project/importlib-metadata/) | Read metadata from Python packages | 7.2.0 | Apache Software  |
| [inflect](https://pypi.org/project/inflect/) | Correctly generate plurals, singular nouns, ordinals, indefinite articles | 7.3.0 | MIT  |
| [iniconfig](https://pypi.org/project/iniconfig/) | brain-dead simple config-ini parsing | 2.0.0 | MIT  |
| [ipykernel](https://pypi.org/project/ipykernel/) | IPython Kernel for Jupyter | 6.29.4 | BSD  |
| [ipython](https://pypi.org/project/ipython/) | IPython: Productive Interactive Computing | 8.25.0 | BSD-3-Clause |
| [ipywidgets](https://pypi.org/project/ipywidgets/) | Jupyter interactive widgets | 8.1.3 | BSD 3-Clause License |
| [isoduration](https://pypi.org/project/isoduration/) | Operations with ISO 8601 durations | 20.11.0 | ISC  |
| [jedi](https://pypi.org/project/jedi/) | An autocompletion tool for Python that can be used for text editors. | 0.19.1 | MIT |
| [Jinja2](https://pypi.org/project/Jinja2/) | A very fast and expressive template engine. | 3.1.4 | BSD  |
| [jira](https://pypi.org/project/jira/) | Python library for interacting with JIRA via REST APIs. | 3.8.0 | BSD-2-Clause |
| [joblib](https://pypi.org/project/joblib/) | Lightweight pipelining with Python functions | 1.4.2 | BSD 3-Clause |
| [json5](https://pypi.org/project/json5/) | A Python implementation of the JSON5 data format. | 0.9.25 | Apache Software  |
| [jsonpointer](https://pypi.org/project/jsonpointer/) | Identify specific nodes in a JSON document (RFC 6901) | 3.0.0 | Modified BSD License |
| [jsonschema-specifications](https://pypi.org/project/jsonschema-specifications/) | The JSON Schema meta-schemas and vocabularies, exposed as a Registry | 2023.12.1 | MIT |
| [jupyter](https://pypi.org/project/jupyter/) | Jupyter metapackage | 1.0.0 | BSD |
| [jupyter-client](https://pypi.org/project/jupyter-client/) | Jupyter protocol implementation and client libraries | 8.6.2 | BSD  |
| [jupyter-console](https://pypi.org/project/jupyter-console/) | Jupyter terminal console | 6.6.3 | BSD  |
| [jupyter-core](https://pypi.org/project/jupyter-core/) | Jupyter core package | 5.7.2 | BSD  |
| [jupyter-events](https://pypi.org/project/jupyter-events/) | Jupyter Event System library | 0.10.0 | BSD  |
| [jupyter-lsp](https://pypi.org/project/jupyter-lsp/) | Multi-Language Server WebSocket proxy for Jupyter Notebook/Lab server | 2.2.5 | BSD-3-Clause |
| [jupyter-server](https://pypi.org/project/jupyter-server/) | The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications. | 2.14.1 | BSD  |
| [jupyter-server-terminals](https://pypi.org/project/jupyter-server-terminals/) | A Jupyter Server Extension Providing Terminals. | 0.5.3 | BSD  |
| [jupyterlab](https://pypi.org/project/jupyterlab/) | JupyterLab computational environment | 4.2.2 | BSD  |
| [jupyterlab-pygments](https://pypi.org/project/jupyterlab-pygments/) | Pygments theme using JupyterLab CSS variables | 0.3.0 | BSD  |
| [jupyterlab-server](https://pypi.org/project/jupyterlab-server/) | A set of server components for JupyterLab and JupyterLab like applications. | 2.27.2 | BSD  |
| [jupyterlab-widgets](https://pypi.org/project/jupyterlab-widgets/) | Jupyter interactive widgets for JupyterLab | 3.0.11 | BSD-3-Clause |
| [jupytext](https://pypi.org/project/jupytext/) | Jupyter notebooks as Markdown documents, Julia, Python or R scripts | 1.16.2 | MIT  |
| [keras](https://pypi.org/project/keras/) | Multi-backend Keras. | 3.3.3 | Apache License 2.0 |
| [kiwisolver](https://pypi.org/project/kiwisolver/) | A fast implementation of the Cassowary constraint solver | 1.4.5 | BSD  |
| [libclang](https://pypi.org/project/libclang/) | Clang Python Bindings, mirrored from the official LLVM repo: https://github.com/llvm/llvm-project/tree/main/clang/bindings/python, to make the installation process easier. | 18.1.1 | Apache License 2.0 |
| [lightgbm](https://pypi.org/project/lightgbm/) | LightGBM Python Package | 4.4.0 | MIT  |
| [lightning-utilities](https://pypi.org/project/lightning-utilities/) | Lightning toolbox for across the our ecosystem. | 0.11.2 | Apache-2.0 |
| [lxml](https://pypi.org/project/lxml/) | Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API. | 5.2.2 | BSD-3-Clause |
| [Markdown](https://pypi.org/project/Markdown/) | Python implementation of John Gruber's Markdown. | 3.6 | BSD  |
| [markdown-it-py](https://pypi.org/project/markdown-it-py/) | Python port of markdown-it | 3.0.0 | MIT  |
| [MarkupSafe](https://pypi.org/project/MarkupSafe/) | Safely add untrusted strings to HTML/XML markup. | 2.1.5 | BSD-3-Clause |
| [matplotlib](https://pypi.org/project/matplotlib/) | Python plotting package | 3.9.0 | PSF |
| [matplotlib-inline](https://pypi.org/project/matplotlib-inline/) | Inline Matplotlib backend for Jupyter | 0.1.7 | BSD  |
| [mccabe](https://pypi.org/project/mccabe/) | McCabe checker, plugin for flake8 | 0.7.0 | Expat license |
| [mdit-py-plugins](https://pypi.org/project/mdit-py-plugins/) | Collection of plugins for markdown-it-py | 0.4.1 | MIT  |
| [mdurl](https://pypi.org/project/mdurl/) | Markdown URL utilities | 0.1.2 | MIT  |
| [metakernel](https://pypi.org/project/metakernel/) |  | 0.30.2 | BSD  |
| [mistune](https://pypi.org/project/mistune/) | A sane and fast Markdown parser with useful plugins and renderers | 3.0.2 | BSD-3-Clause |
| [ml-dtypes](https://pypi.org/project/ml-dtypes/) |  | 0.3.2 | Apache Software  |
| [more-itertools](https://pypi.org/project/more-itertools/) | More routines for operating on iterables, beyond itertools | 10.3.0 | MIT  |
| [mpmath](https://pypi.org/project/mpmath/) | Python library for arbitrary-precision floating-point arithmetic | 1.3.0 | BSD |
| [msgpack](https://pypi.org/project/msgpack/) | MessagePack serializer | 1.0.8 | Apache 2.0 |
| [multidict](https://pypi.org/project/multidict/) | multidict implementation | 6.0.5 | Apache 2 |
| [mysql-connector-python](https://pypi.org/project/mysql-connector-python/) | MySQL driver written in Python | 8.4.0 | GNU General Public  |
| [namex](https://pypi.org/project/namex/) | A simple utility to separate the implementation of your Python package and its public API surface. | 0.0.8 | Apache License 2.0 |
| [nbclient](https://pypi.org/project/nbclient/) | A client library for executing notebooks | 0.10.0 | BSD  |
| [nbconvert](https://pypi.org/project/nbconvert/) | Converting Jupyter Notebooks (.ipynb files) to other formats.  Output formats include asciidoc, html, latex, markdown, pdf, py, rst, script.  nbconvert can be used both as a Python library (`import nbconvert`) or as a command line tool (invoked as `jupyter nbconvert ...`). | 7.16.4 | BSD  |
| [nbformat](https://pypi.org/project/nbformat/) | The Jupyter Notebook format | 5.10.4 | BSD  |
| [nbsphinx](https://pypi.org/project/nbsphinx/) | Jupyter Notebook Tools for Sphinx | 0.9.4 | MIT |
| [ndindex](https://pypi.org/project/ndindex/) | A Python library for manipulating indices of ndarrays. | 1.8 | MIT |
| [nest-asyncio](https://pypi.org/project/nest-asyncio/) | Patch asyncio to allow nested event loops | 1.6.0 | BSD |
| [networkx](https://pypi.org/project/networkx/) | Python package for creating and manipulating graphs and networks | 3.3 | BSD  |
| [notebook](https://pypi.org/project/notebook/) | Jupyter Notebook - A web-based notebook environment for interactive computing | 7.2.1 | BSD  |
| [notebook-shim](https://pypi.org/project/notebook-shim/) | A shim layer for notebook traits and config | 0.2.4 | BSD  |
| [numexpr](https://pypi.org/project/numexpr/) | Fast numerical expression evaluator for NumPy | 2.10.1 | MIT  |
| [numpy](https://pypi.org/project/numpy/) | Fundamental package for array computing in Python | 1.26.4 | BSD  |
| [oauthlib](https://pypi.org/project/oauthlib/) | A generic, spec-compliant, thorough implementation of the OAuth request-signing logic | 3.2.2 | BSD |
| [opt-einsum](https://pypi.org/project/opt-einsum/) | Optimizing numpys einsum function | 3.3.0 | MIT |
| [optree](https://pypi.org/project/optree/) | Optimized PyTree Utilities. | 0.11.0 | Apache Software  |
| [overrides](https://pypi.org/project/overrides/) | A decorator to automatically detect mismatch when overriding a method. | 7.7.0 | Apache License 2.0 |
| [packaging](https://pypi.org/project/packaging/) | Core utilities for Python packages | 24.1 | BSD  |
| [pandas](https://pypi.org/project/pandas/) | Powerful data structures for data analysis, time series, and statistics | 2.2.2 | BSD  |
| [pandocfilters](https://pypi.org/project/pandocfilters/) | Utilities for writing pandoc filters in python | 1.5.1 | BSD-3-Clause |
| [parso](https://pypi.org/project/parso/) | A Python Parser | 0.8.4 | MIT |
| [pexpect](https://pypi.org/project/pexpect/) | Pexpect allows easy control of interactive console applications. | 4.9.0 | ISC license |
| [pillow](https://pypi.org/project/pillow/) | Python Imaging Library (Fork) | 10.3.0 | HPND |
| [platformdirs](https://pypi.org/project/platformdirs/) | A small Python package for determining appropriate platform-specific dirs, e.g. a `user data dir`. | 4.2.2 | MIT  |
| [plothist](https://pypi.org/project/plothist/) | Plot histograms in a scalable way and a beautiful style. | 1.2.4 | BSD  |
| [pluggy](https://pypi.org/project/pluggy/) | plugin and hook calling mechanisms for python | 1.5.0 | MIT |
| [portend](https://pypi.org/project/portend/) | TCP port monitoring and discovery | 3.2.0 | MIT  |
| [prometheus-client](https://pypi.org/project/prometheus-client/) | Python client for the Prometheus monitoring system. | 0.20.0 | Apache Software  |
| [prompt-toolkit](https://pypi.org/project/prompt-toolkit/) | Library for building powerful interactive command lines in Python | 3.0.47 | BSD  |
| [protobuf](https://pypi.org/project/protobuf/) |  | 4.25.3 | 3-Clause BSD License |
| [psutil](https://pypi.org/project/psutil/) | Cross-platform lib for process and system monitoring in Python. | 6.0.0 | BSD-3-Clause |
| [ptyprocess](https://pypi.org/project/ptyprocess/) | Run a subprocess in a pseudo terminal | 0.7.0 | ISC  |
| [pure-eval](https://pypi.org/project/pure-eval/) | Safely evaluate AST nodes without side effects | 0.2.2 | MIT |
| [py-cpuinfo](https://pypi.org/project/py-cpuinfo/) | Get CPU info with pure Python | 9.0.0 | MIT |
| [pyarrow](https://pypi.org/project/pyarrow/) | Python library for Apache Arrow | 16.1.0 | Apache Software  |
| [pycodestyle](https://pypi.org/project/pycodestyle/) | Python style guide checker | 2.12.0 | MIT |
| [pycparser](https://pypi.org/project/pycparser/) | C parser in Python | 2.22 | BSD-3-Clause |
| [pydata-sphinx-theme](https://pypi.org/project/pydata-sphinx-theme/) | Bootstrap-based Sphinx theme from the PyData community | 0.15.3 | BSD  |
| [pydocstyle](https://pypi.org/project/pydocstyle/) | Python docstring style checker | 6.3.0 | MIT |
| [pyflakes](https://pypi.org/project/pyflakes/) | passive checker of Python programs | 3.2.0 | MIT |
| [Pygments](https://pypi.org/project/Pygments/) | Pygments is a syntax highlighting package written in Python. | 2.18.0 | BSD-2-Clause |
| [pyhepmc](https://pypi.org/project/pyhepmc/) | Pythonic interface to the HepMC3 C++ library licensed under LGPL-v3. | 2.13.4 | BSD 3-Clause License |
| [PyJWT](https://pypi.org/project/PyJWT/) | JSON Web Token implementation in Python | 2.8.0 | MIT |
| [pylama](https://pypi.org/project/pylama/) | Code audit tool for python | 8.4.1 | MIT |
| [pyparsing](https://pypi.org/project/pyparsing/) | pyparsing module - Classes and methods to define and execute parsing grammars | 3.1.2 | MIT  |
| [pypmc](https://pypi.org/project/pypmc/) | A toolkit for adaptive importance sampling featuring implementations of variational Bayes, population Monte Carlo, and Markov chains. | 1.2.3 | GPLv2 |
| [pytest](https://pypi.org/project/pytest/) | pytest: simple powerful testing with Python | 8.2.2 | MIT |
| [python-dateutil](https://pypi.org/project/python-dateutil/) | Extensions to the standard Python datetime module | 2.9.0.post0 | Dual License |
| [python-gitlab](https://pypi.org/project/python-gitlab/) | A python wrapper for the GitLab API | 4.6.0 | LGPL-3.0-or-later |
| [python-json-logger](https://pypi.org/project/python-json-logger/) | A python library adding a json log formatter | 2.0.7 | BSD |
| [pytorch-ignite](https://pypi.org/project/pytorch-ignite/) | A lightweight library to help with training neural networks in PyTorch. | 0.5.0.post2 | BSD |
| [pytorch-lightning](https://pypi.org/project/pytorch-lightning/) | PyTorch Lightning is the lightweight PyTorch wrapper for ML researchers | 2.3.0 | Apache-2.0 |
| [pytz](https://pypi.org/project/pytz/) | World timezone definitions, modern and historical | 2024.1 | MIT |
| [PyYAML](https://pypi.org/project/PyYAML/) | YAML parser and emitter for Python | 6.0.1 | MIT |
| [pyzmq](https://pypi.org/project/pyzmq/) | Python bindings for 0MQ | 26.0.3 | BSD  |
| [qtconsole](https://pypi.org/project/qtconsole/) | Jupyter Qt console | 5.5.2 | BSD |
| [QtPy](https://pypi.org/project/QtPy/) | Provides an abstraction layer on top of the various Qt bindings (PyQt5/6 and PySide2/6). | 2.4.1 | MIT |
| [referencing](https://pypi.org/project/referencing/) | JSON Referencing + Python | 0.35.1 | MIT  |
| [requests](https://pypi.org/project/requests/) | Python HTTP for Humans. | 2.32.3 | Apache-2.0 |
| [requests-oauthlib](https://pypi.org/project/requests-oauthlib/) | OAuthlib authentication support for Requests. | 2.0.0 | ISC |
| [requests-toolbelt](https://pypi.org/project/requests-toolbelt/) | A utility belt for advanced users of python-requests | 1.0.0 | Apache 2.0 |
| [rfc3339-validator](https://pypi.org/project/rfc3339-validator/) | A pure python RFC3339 validator | 0.1.4 | MIT license |
| [rfc3986-validator](https://pypi.org/project/rfc3986-validator/) | Pure python rfc3986 validator | 0.1.1 | MIT license |
| [rich](https://pypi.org/project/rich/) | Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal | 13.7.1 | MIT |
| [rise](https://pypi.org/project/rise/) | Reveal.js - Jupyter/IPython Slideshow Extension | 5.7.1 | BSD-3-Clause |
| [rpds-py](https://pypi.org/project/rpds-py/) | Python bindings to Rust's persistent data structures (rpds) | 0.18.1 | MIT |
| [scikit-learn](https://pypi.org/project/scikit-learn/) | A set of python modules for machine learning and data mining | 1.5.0 | new BSD |
| [scipy](https://pypi.org/project/scipy/) | Fundamental algorithms for scientific computing in Python | 1.13.1 | BSD  |
| [SCons](https://pypi.org/project/SCons/) | Open Source next-generation build tool. | 4.7.0 | MIT |
| [seaborn](https://pypi.org/project/seaborn/) | Statistical data visualization | 0.13.2 | BSD  |
| [Send2Trash](https://pypi.org/project/Send2Trash/) | Send file to trash natively under Mac OS X, Windows and Linux | 1.8.3 | BSD License |
| [six](https://pypi.org/project/six/) | Python 2 and 3 compatibility utilities | 1.16.0 | MIT |
| [sly](https://pypi.org/project/sly/) | SLY - Sly Lex Yacc | 0.4 | BSD |
| [smmap](https://pypi.org/project/smmap/) | A pure Python implementation of a sliding window memory map manager | 5.0.1 | BSD |
| [sniffio](https://pypi.org/project/sniffio/) | Sniff out which async library your code is running under | 1.3.1 | MIT OR Apache-2.0 |
| [snowballstemmer](https://pypi.org/project/snowballstemmer/) | This package provides 29 stemmers for 28 languages generated from Snowball algorithms. | 2.2.0 | BSD-3-Clause |
| [soupsieve](https://pypi.org/project/soupsieve/) | A modern CSS selector implementation for Beautiful Soup. | 2.5 | MIT  |
| [Sphinx](https://pypi.org/project/Sphinx/) | Python documentation generator | 7.3.7 | BSD  |
| [sphinx-book-theme](https://pypi.org/project/sphinx-book-theme/) | A clean book theme for scientific explanations and documentation with Sphinx | 1.1.3 | BSD  |
| [sphinx-codeautolink](https://pypi.org/project/sphinx-codeautolink/) | Automatic links from code examples to reference documentation. | 0.15.2 | MIT |
| [sphinxcontrib-applehelp](https://pypi.org/project/sphinxcontrib-applehelp/) | sphinxcontrib-applehelp is a Sphinx extension which outputs Apple help books | 1.0.8 | BSD  |
| [sphinxcontrib-devhelp](https://pypi.org/project/sphinxcontrib-devhelp/) | sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp documents | 1.0.6 | BSD  |
| [sphinxcontrib-htmlhelp](https://pypi.org/project/sphinxcontrib-htmlhelp/) | sphinxcontrib-htmlhelp is a sphinx extension which renders HTML help files | 2.0.5 | BSD  |
| [sphinxcontrib-jsmath](https://pypi.org/project/sphinxcontrib-jsmath/) | A sphinx extension which renders display math in HTML via JavaScript | 1.0.1 | BSD |
| [sphinxcontrib-programoutput](https://pypi.org/project/sphinxcontrib-programoutput/) | Sphinx extension to include program output | 0.17 | BSD |
| [sphinxcontrib-qthelp](https://pypi.org/project/sphinxcontrib-qthelp/) | sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp documents | 1.0.7 | BSD  |
| [sphinxcontrib-serializinghtml](https://pypi.org/project/sphinxcontrib-serializinghtml/) | sphinxcontrib-serializinghtml is a sphinx extension which outputs "serialized" HTML files (json and pickle) | 1.1.10 | BSD  |
| [splinter](https://pypi.org/project/splinter/) | browser abstraction for web acceptance testing | 0.21.0 | BSD |
| [stack-data](https://pypi.org/project/stack-data/) | Extract data from python stack frames and tracebacks for informative displays | 0.6.3 | MIT |
| [sweights](https://pypi.org/project/sweights/) | Tools for producing sweights using classic methods or custom orthogonal weight functions (COWs) and for correcting covariance matrices for weighted data fits. | 1.0.0 | "MIT" |
| [sympy](https://pypi.org/project/sympy/) | Computer algebra system (CAS) in Python | 1.12.1 | BSD |
| [tables](https://pypi.org/project/tables/) | Hierarchical datasets for Python | 3.9.2 | BSD 3-Clause License |
| [tabulate](https://pypi.org/project/tabulate/) | Pretty-print tabular data | 0.9.0 | MIT |
| [tempora](https://pypi.org/project/tempora/) | Objects and routines pertaining to date and time (tempora) | 5.6.0 | MIT  |
| [tensorboard](https://pypi.org/project/tensorboard/) | TensorBoard lets you watch Tensors Flow | 2.16.2 | Apache 2.0 |
| [tensorboard-data-server](https://pypi.org/project/tensorboard-data-server/) | Fast data loading for TensorBoard | 0.7.2 | Apache 2.0 |
| [tensorflow](https://pypi.org/project/tensorflow/) | TensorFlow is an open source machine learning framework for everyone. | 2.16.1 | Apache 2.0 |
| [tensorflow-io-gcs-filesystem](https://pypi.org/project/tensorflow-io-gcs-filesystem/) | TensorFlow IO | 0.37.0 | Apache Software  |
| [tensorflow-probability](https://pypi.org/project/tensorflow-probability/) | Probabilistic modeling and statistical inference in TensorFlow | 0.24.0 | Apache 2.0 |
| [termcolor](https://pypi.org/project/termcolor/) | ANSI color formatting for output in terminal | 2.4.0 | MIT |
| [terminado](https://pypi.org/project/terminado/) | Tornado websocket backend for the Xterm.js Javascript terminal emulator library. | 0.18.1 | BSD  |
| [Theano](https://pypi.org/project/Theano/) | Optimizing compiler for evaluating mathematical expressions on CPUs and GPUs. | 1.0.5 | BSD |
| [threadpoolctl](https://pypi.org/project/threadpoolctl/) | threadpoolctl | 3.5.0 | BSD-3-Clause |
| [tinycss2](https://pypi.org/project/tinycss2/) | A tiny CSS parser | 1.3.0 | BSD  |
| [torch-geometric](https://pypi.org/project/torch-geometric/) | Graph Neural Network Library for PyTorch | 2.5.3 | MIT  |
| [torchdata](https://pypi.org/project/torchdata/) | Composable data loading modules for PyTorch | 0.7.1 | BSD |
| [torchmetrics](https://pypi.org/project/torchmetrics/) | PyTorch native Metrics | 1.4.0.post0 | Apache-2.0 |
| [tornado](https://pypi.org/project/tornado/) | Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed. | 6.4.1 | Apache-2.0 |
| [tqdm](https://pypi.org/project/tqdm/) | Fast, Extensible Progress Meter | 4.66.4 | MPL-2.0 AND MIT |
| [traitlets](https://pypi.org/project/traitlets/) | Traitlets Python configuration system | 5.14.3 | BSD  |
| [typeguard](https://pypi.org/project/typeguard/) | Run-time type checker for Python | 4.3.0 | MIT |
| [types-python-dateutil](https://pypi.org/project/types-python-dateutil/) | Typing stubs for python-dateutil | 2.9.0.20240316 | Apache-2.0 license |
| [typing-extensions](https://pypi.org/project/typing-extensions/) | Backported and Experimental Type Hints for Python 3.8+ | 4.12.2 | PSF |
| [tzdata](https://pypi.org/project/tzdata/) | Provider of IANA time zone data | 2024.1 | Apache-2.0 |
| [uncertainties](https://pypi.org/project/uncertainties/) | calculations with values with uncertainties, error propagation | 3.2.1 | Revised BSD License |
| [uproot](https://pypi.org/project/uproot/) | ROOT I/O in pure Python and NumPy. | 5.3.7 | BSD  |
| [uproot3](https://pypi.org/project/uproot3/) | ROOT I/O in pure Python and Numpy. | 3.14.4 | BSD 3-clause |
| [uproot3-methods](https://pypi.org/project/uproot3-methods/) | Pythonic mix-ins for ROOT classes. | 0.10.1 | BSD 3-clause |
| [uri-template](https://pypi.org/project/uri-template/) | RFC 6570 URI Template Processor | 1.3.0 | MIT License |
| [urllib3](https://pypi.org/project/urllib3/) | HTTP library with thread-safe connection pooling, file post, and more. | 2.2.2 | MIT  |
| [wcwidth](https://pypi.org/project/wcwidth/) | Measures the displayed width of unicode strings in a terminal | 0.2.13 | MIT |
| [webcolors](https://pypi.org/project/webcolors/) | A library for working with the color formats defined by HTML and CSS. | 24.6.0 | BSD-3-Clause |
| [webencodings](https://pypi.org/project/webencodings/) | Character encoding aliases for legacy web content | 0.5.1 | BSD |
| [websocket-client](https://pypi.org/project/websocket-client/) | WebSocket client for Python with low level API options | 1.8.0 | Apache-2.0 |
| [Werkzeug](https://pypi.org/project/Werkzeug/) | The comprehensive WSGI web application library. | 3.0.3 | BSD  |
| [widgetsnbextension](https://pypi.org/project/widgetsnbextension/) | Jupyter interactive widgets for Jupyter Notebook | 4.0.11 | BSD 3-Clause License |
| [wrapt](https://pypi.org/project/wrapt/) | Module for decorators, wrappers and monkey patching. | 1.16.0 | BSD |
| [xgboost](https://pypi.org/project/xgboost/) | XGBoost Python Package | 1.7.6 | Apache-2.0 |
| [yarl](https://pypi.org/project/yarl/) | Yet another URL library | 1.9.4 | Apache-2.0 |
| [zipp](https://pypi.org/project/zipp/) | Backport of pathlib-compatible object wrapper for zip files | 3.19.2 | MIT  |
| [zstandard](https://pypi.org/project/zstandard/) | Zstandard bindings for Python | 0.22.0 | BSD |

[//]: # (END PYTHON_PKG)
