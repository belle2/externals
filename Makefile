# define directories
export BELLE2_EXTERNALS_DIR := $(shell pwd)
export BELLE2_EXTERNALS_SUBDIR := $(BELLE2_ARCH)/$(BELLE2_EXTERNALS_OPTION)
export PATCHDIR := $(BELLE2_EXTERNALS_DIR)
export EXTDIR := $(BELLE2_EXTERNALS_DIR)/$(BELLE2_EXTERNALS_SUBDIR)
export EXTSRCDIR := $(BELLE2_EXTERNALS_DIR)/src
export EXTBUILDDIR := $(BELLE2_EXTERNALS_DIR)/build/$(BELLE2_EXTERNALS_SUBDIR)
export EXTINCDIR := $(EXTDIR)/include
export EXTLIBDIR := $(EXTDIR)/lib
export EXTBINDIR := $(EXTDIR)/bin
export ROOTSYS := $(EXTDIR)/root

# download script to get and extract sources
export DOWNLOAD := $(BELLE2_EXTERNALS_DIR)/download.sh

# base packages we don't want to compile in debug mode anyway so we compile
# them with option common
COMMON_PACKAGES=gcc binutils bzip2 gdb python libxml2 cmake boost gtest pkg-config

# python packages to be included with the python package
PYTHON_PACKAGES=ipython==4.0.0 numpy==1.9.2 pep8==1.5.7 autopep8==1.1
#SCons==2.3.0

# external packages
PACKAGES=clhep geant4 postgresql libpqxx neurobayes xrootd root nbplugin fastbdt vgm \
         rave MillepedeII hepmc pythia photos tauola evtgen phokhara madgraph cry flc \
         eigen vc nsm2 belle_legacy curl

export LANG=C

# set number of parallel jobs to the number of processors
ifeq ($(shell uname),Darwin)
  NPROCESSES=$(shell sysctl -n hw.ncpu 2> /dev/null)
else
  NPROCESSES=$(shell grep "physical id.*0" /proc/cpuinfo 2> /dev/null | wc -l)
  ifeq ($(NPROCESSES),0)
    NPROCESSES=$(shell grep processor /proc/cpuinfo 2> /dev/null | wc -l)
  endif
endif
ifdef BELLE2_MAKE_NPROCESSES
  NPROCESSES=$(BELLE2_MAKE_NPROCESSES)
endif
ifeq ($(NPROCESSES),0)
  NPROCESSES=1
endif

# set debug or optimization options
ifeq ($(BELLE2_EXTERNALS_OPTION),debug)
  export CXXFLAGS=-g
  export BOOST_OPTION=variant=debug
  export CLHEP_OPTION=-DCMAKE_BUILD_TYPE=RelWithDebInfo
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=RelWithDebInfo
  export XROOTD_OPTION=-DCMAKE_BUILD_TYPE=RelWithDebInfo
  export ROOT_OPTION=
  export ROOTBUILD=debug
  export PYTHIA_OPTION=--enable-debug
  export EVTGEN_OPTION=--enable-debug
  export VC_OPTION=-DCMAKE_BUILD_TYPE=RelWithDebInfo
else
# make if (option=opt or option=common) using the filter: filter will only
# return common or opt if they are in the EXTERNALS_OPTION so if the option is
# anything else we get an empty string
ifneq (, $(filter $(BELLE2_EXTERNALS_OPTION), common opt))
  export CXXFLAGS=-O3
  export BOOST_OPTION=variant=release
  export CLHEP_OPTION=-DCMAKE_BUILD_TYPE=Release
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=Release -DGEANT4_BUILD_STORE_TRAJECTORY=OFF -DGEANT4_BUILD_VERBOSE_CODE=OFF
  export XROOTD_OPTION=-DCMAKE_BUILD_TYPE=Release
  export ROOT_OPTION=
  export ROOTBUILD=
  export PYTHIA_OPTION=
  export EVTGEN_OPTION=
  export VC_OPTION=-DCMAKE_BUILD_TYPE=Release
else
ifeq ($(BELLE2_EXTERNALS_OPTION),intel)
  export CC=icc
  export CXX=icpc
  export CXXCPP=icc -E
  export FC=ifort
  export AR=xiar
  export LD=xild
  export BOOST_OPTION=variant=release toolset=intel
  export CLHEP_OPTION=-DCMAKE_BUILD_TYPE=Release
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icc
  export XROOTD_OPTION=-DCMAKE_BUILD_TYPE=Release
  export ROOT_OPTION=linuxicc
  ifeq ($(shell uname -m),x86_64)
    export ROOT_OPTION=linuxx8664icc
  endif
  export ROOTBUILD=
  export PYTHIA_OPTION=
  export EVTGEN_OPTION=
  export VC_OPTION=-DCMAKE_BUILD_TYPE=Release
else
  $(error Unknown externals build option. Please source the setup_belle2 script.)
endif
endif
endif

ifdef ORACLE_HOME
  ROOT_OPTION += --with-oracle-libdir=$(ORACLE_HOME) --with-oracle-incdir=$(ORACLE_HOME)/sdk/include/
endif
ROOT_OPTION += --with-pgsql-libdir=$(EXTLIBDIR) --with-pgsql-incdir=$(EXTINCDIR)/pgsql/

# check for graphics packages
GL_XMU_EXISTS=$(shell pkg-config --exists gl xmu 2> /dev/null; echo $$?)
ifeq ($(GL_XMU_EXISTS),0)
  GEANT4_OPTION+= -D g4vis_build_openglx_driver='y' -D g4vis_use_openglx='y'
endif

ALL_TARGETS=
# if option is set to common we compile the common and python packages only
ifeq ($(BELLE2_EXTERNALS_OPTION),common)
  $(info compiling common packages)
  ALL_TARGETS=$(COMMON_PACKAGES) $(PYTHON_PACKAGES)
else
  # make sure that common targets are not called directly
  # this is still not 100% correct as someone could call make
  # Linux_x86_64/opt/bin/ld but in that case I think they probably deserve to
  # run into problems or know what they are doing anyway
  COMMON_GOALS:=$(filter $(MAKECMDGOALS), $(COMMON_PACKAGES))
  COMMON_GOALS+=$(filter $(MAKECMDGOALS), $(foreach package,$(COMMON_PACKAGES),$(package).touch))
  COMMON_GOALS+=$(filter $(MAKECMDGOALS), $(foreach package,$(COMMON_PACKAGES),$(package).src))
  COMMON_GOALS+=$(filter $(MAKECMDGOALS), $(foreach package,$(COMMON_PACKAGES),$(package).clean))
  COMMON_GOALS:=$(strip $(COMMON_GOALS))
  ifneq (,$(COMMON_GOALS))
    $(error The following targets are only valid in common mode: $(COMMON_GOALS).\
        You have to call "make BELLE2_EXTERNALS_OPTION=common $(COMMON_GOALS)")
  endif

  # otherwise let's take the stuff from common and build software packages
  ALL_TARGETS=common $(PACKAGES)
  $(info compiling packages with option $(BELLE2_EXTERNALS_OPTION))

  CMAKE=$(BELLE2_EXTERNALS_DIR)/$(BELLE2_ARCH)/common/bin/cmake
  # add opt path as fallback for debug externals
  export PATH := $(BELLE2_EXTERNALS_DIR)/$(BELLE2_ARCH)/common/bin:$(PATH)
  ifeq ($(shell uname),Darwin)
    export DYLD_LIBRARY_PATH := $(BELLE2_EXTERNALS_DIR)/$(BELLE2_ARCH)/common/lib:$(DYLD_LIBRARY_PATH)
  else
    export LD_LIBRARY_PATH := $(BELLE2_EXTERNALS_DIR)/$(BELLE2_ARCH)/common/lib:$(LD_LIBRARY_PATH)
  endif
endif

# check whether geant4 data files are already installed
GEANT4_DATA_EXISTS=$(shell test -d $(EXTDIR)/share/Geant4-9.6.2/data/G4EMLOW6.32; echo $$?)
ifneq ($(GEANT4_DATA_EXISTS),0)
  GEANT4_OPTION+= -DGEANT4_INSTALL_DATA=ON
endif

# now add path for current option
export PATH := $(ROOTSYS)/bin:$(EXTBINDIR):$(PATH)
ifeq ($(shell uname),Darwin)
  export DYLD_LIBRARY_PATH := $(ROOTSYS)/lib:$(EXTLIBDIR):$(DYLD_LIBRARY_PATH)
else
  export LD_LIBRARY_PATH := $(ROOTSYS)/lib:$(EXTLIBDIR):$(LD_LIBRARY_PATH)
endif

# directory we want to create
DIRECTORIES=$(EXTSRCDIR) $(EXTBUILDDIR) $(EXTLIBDIR) $(EXTBINDIR)
# directories we want to share between all options
SHARED_DIRECTORIES=$(EXTINCDIR) $(EXTDIR)/share

# all targets (in this order)
all: $(DIRECTORIES) $(SHARED_DIRECTORIES) $(ALL_TARGETS) relocatable_fixes

# get source code of all packages
src: $(DIRECTORIES) $(SHARED_DIRECTORIES) $(foreach package,$(ALL_TARGETS),$(package).src)

# clean up targets
clean: $(foreach package,$(ALL_TARGETS),$(package).clean)

# remove only target files
touch: $(foreach package,$(ALL_TARGETS),$(package).touch)

# common packages, make sure they are compiled first
common:
	$(MAKE) BELLE2_EXTERNALS_OPTION=common

# pkg config wrapper using correct paths and being relocatable (if .pc files are fixed)
pkg-config: $(EXTBINDIR)/pkg-config

$(EXTBINDIR)/pkg-config:
	install pkg-config $@

relocatable_fixes:
	@#Fix absolute paths in .pc files
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTLIBDIR)/pkgconfig/*.pc
	@#Fix absolute paths in pip packages
	@$(BELLE2_EXTERNALS_DIR)/python_relocate.py

# create directories
$(DIRECTORIES):
	@echo "create $@"
	@mkdir -p $@

# create shared directories
$(SHARED_DIRECTORIES):
	@echo "create shared $@"
	@mkdir -p $(BELLE2_EXTERNALS_DIR)/`basename $@`
	@# TODO: make relpath dynamic?
	@cd `dirname $@` && ln -sf ../../`basename $@`

binutils: $(EXTBINDIR)/ld
binutils.src: $(EXTSRCDIR)/binutils/src

$(EXTSRCDIR)/binutils/src:
	@echo "downloading binutils"
	@mkdir -p $(EXTSRCDIR)/binutils
	@cd $(EXTSRCDIR)/binutils && $(DOWNLOAD) binutils-2.25.1.tar.gz http://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.gz
	@cd $(EXTSRCDIR)/binutils && mv binutils-2.25.1 src

$(EXTBINDIR)/ld: $(EXTSRCDIR)/binutils/src
	@echo "building binutils"
	@mkdir -p $(EXTSRCDIR)/binutils/build
	#note: avoid propagating CXXFLAGS by explicitly unsetting in sub-shell (works in posix and csh)
	@cd $(EXTSRCDIR)/binutils/build && unset CXXFLAGS && ../src/configure --disable-werror --disable-multilib\
	    --enable-shared --prefix=$(EXTDIR) && make tooldir=$(EXTDIR) -j $(NPROCESSES) &&\
	    make tooldir=$(EXTDIR) -j $(NPROCESSES) install
	@rm -rf $(EXTSRCDIR)/binutils/build

binutils.clean:
	@echo "cleaning binutils"
	@-cd $(EXTSRCDIR)/binutils/build && make distclean
	@rm -rf $(EXTSRCDIR)/binutils

gcc: $(EXTBINDIR)/gcc
gcc.src: $(EXTSRCDIR)/gcc/src

$(EXTSRCDIR)/gcc/src:
	@echo "downloading GCC"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) gcc-4.9.2-contrib.tar.bz2
	@mkdir -p $(EXTSRCDIR)/gcc
	@mv $(EXTSRCDIR)/gcc-4.9.2 $(EXTSRCDIR)/gcc/src

$(EXTBINDIR)/gcc: $(EXTSRCDIR)/gcc/src
	@echo "building gcc"
	@mkdir -p $(EXTSRCDIR)/gcc/build
	#note: avoid propagating CXXFLAGS by explicitly unsetting in sub-shell (works in posix and csh)
	@cd $(EXTSRCDIR)/gcc/build && unset CXXFLAGS && ../src/configure --disable-multilib --prefix=$(EXTDIR) \
	    --enable-languages=c,c++,fortran &&\
	    make -j $(NPROCESSES) && make install
	@rm -rf $(EXTSRCDIR)/gcc/build

gcc.clean:
	@echo "cleaning gcc"
	@rm -rf $(EXTSRCDIR)/gcc
	#@rm -rf $(EXTDIR)/gcc

libxml2: $(EXTBINDIR)/xml2-config
libxml2.src: $(EXTSRCDIR)/libxml2

libxml2.clean:
	@rm -fr $(EXTSRCDIR)/libxml

libxml2.touch:
	@rm $(EXTBINDIR)/xml2-config

$(EXTSRCDIR)/libxml2:
	@cd $(EXTSRCDIR) && $(DOWNLOAD) libxml2-2.9.2.tar.gz ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz
	@mv $(EXTSRCDIR)/libxml2-2.9.2/ $@

$(EXTBINDIR)/xml2-config: $(EXTSRCDIR)/libxml2
	@cd $< && ./configure --prefix=$(EXTDIR) --enable-silent-rules --with-python=$(EXTBINDIR)/python3 &&\
	    make -j $(NPROCESSES) && make install
	@#Fix absolute path in xml2-config and lib/xml2Conf.sh
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $@
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTLIBDIR)/xml2Conf.sh

bzip2: $(EXTBINDIR)/bzip2
bzip2.src: $(EXTSRCDIR)/bzip2

bzip2.clean:
	@rm -fr $(EXTSRCDIR)/bzip2

bzip2.touch:
	@rm -fr $(EXTBINDIR)/bzip2

$(EXTSRCDIR)/bzip2:
	@cd $(EXTSRCDIR) && $(DOWNLOAD) bzip2-1.0.6.tar.gz http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
	@mv $(EXTSRCDIR)/bzip2-1.0.6 $@

$(EXTBINDIR)/bzip2: $(EXTSRCDIR)/bzip2
	cd $< && make -f Makefile-libbz2_so && mv libbz2.so* $(EXTLIBDIR)
	cd $< && make install PREFIX=$(EXTDIR)

python: $(EXTBINDIR)/python3
python.src: $(EXTSRCDIR)/python

python.clean:
	@rm -fr $(EXTSRCDIR)/python

python.touch:
	@rm -fr $(EXTBINDIR)/python3

$(EXTSRCDIR)/python:
	@cd $(EXTSRCDIR) && $(DOWNLOAD) Python-3.4.3.tgz https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
	@mv $(EXTSRCDIR)/Python-3.4.3 $@

$(EXTBINDIR)/python3: $(EXTSRCDIR)/python
	@echo "building python"
	@echo `which g++`
	@cd $< && ./configure --enable-shared --prefix=$(EXTDIR) --with-ensurepip=install --with-cxx-main=g++ && \
	    make -j $(NPROCESSES) && make install

$(PYTHON_PACKAGES): python
	@$(EXTBINDIR)/pip3 -q --disable-pip-version-check install $@

gdb: $(EXTBINDIR)/gdb
gdb.src: $(EXTSRCDIR)/gdb

$(EXTSRCDIR)/gdb:
	@echo "downloading gdb"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) gdb-7.8.2.tar.gz http://ftp.gnu.org/gnu/gdb/gdb-7.8.2.tar.gz
	@mv $(EXTSRCDIR)/gdb-7.8.2 $(EXTSRCDIR)/gdb

$(EXTBINDIR)/gdb: $(EXTSRCDIR)/gdb
	@echo "building gdb"
	#note: avoid propagating CXXFLAGS by explicitly unsetting in sub-shell (works in posix and csh)
	#note: GDB must be built inside source directory, otherwise it wants to build info manuals (makeinfo might not be installed)
	@cd $(EXTSRCDIR)/gdb && unset CXXFLAGS && $(EXTSRCDIR)/gdb/configure --prefix=$(EXTDIR) --with-python=python3 && \
	    make -j $(NPROCESSES) && make -j $(NPROCESSES) install

gdb.clean:
	@echo "cleaning gdb"
	@-cd $(EXTSRCDIR)/gdb && make distclean
	@rm -rf $(EXTSRCDIR)/gdb


# dependencies for cmake
cmake: $(EXTBINDIR)/cmake
cmake.src: $(EXTSRCDIR)/cmake/bootstrap

# cmake download
$(EXTSRCDIR)/cmake/bootstrap:
	@echo "downloading cmake"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) cmake-2.8.6.tar.gz http://www.cmake.org/files/v2.8/cmake-2.8.6.tar.gz
	@mv $(EXTSRCDIR)/cmake-2.8.6 $(EXTSRCDIR)/cmake

# cmake build
$(EXTBINDIR)/cmake: $(EXTSRCDIR)/cmake/bootstrap
	@echo "building cmake"
	@cd $(EXTSRCDIR)/cmake && ./bootstrap --prefix=$(EXTDIR) && \
	    sed -i 's/BUILD_CursesDialog\:BOOL=ON/BUILD_CursesDialog\:BOOL=OFF/g' CMakeCache.txt && \
	    make -j $(NPROCESSES) && make install

# cmake clean
cmake.clean:
	@echo "cleaning cmake"
	@cd $(EXTSRCDIR)/cmake && make clean
	@rm -f $(EXTBINDIR)/cmake

# cmake touch
cmake.touch:
	@rm -f $(EXTBINDIR)/cmake


# dependencies for google test
gtest: $(EXTLIBDIR)/libgtest.a
gtest.src: $(EXTSRCDIR)/gtest/README

# google test download
$(EXTSRCDIR)/gtest/README:
	@echo "downloading gtest"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) gtest-1.6.0.tar.gz http://googletest.googlecode.com/files/gtest-1.6.0.zip
	@mv $(EXTSRCDIR)/gtest-1.6.0 $(EXTSRCDIR)/gtest
	@chmod -R u+w $(EXTSRCDIR)/gtest

# google test build
$(EXTLIBDIR)/libgtest.a: $(EXTSRCDIR)/gtest/README
	@echo "building gtest"
	@mkdir -p $(EXTINCDIR)/gtest/internal
	@cp -a $(EXTSRCDIR)/gtest/include/gtest/*.h $(EXTINCDIR)/gtest/
	@cp -a $(EXTSRCDIR)/gtest/include/gtest/internal/*.h $(EXTINCDIR)/gtest/internal/
	@mkdir -p $(EXTBUILDDIR)/gtest
	$(CXX) -I$(EXTINCDIR) -I$(EXTSRCDIR)/gtest -c $(EXTSRCDIR)/gtest/src/gtest-all.cc -o $(EXTBUILDDIR)/gtest/gtest-all.o
	$(CXX) -I$(EXTINCDIR) -I$(EXTSRCDIR)/gtest -c $(EXTSRCDIR)/gtest/src/gtest_main.cc -o $(EXTBUILDDIR)/gtest/gtest_main.o
	@$(AR) -rv $(EXTLIBDIR)/libgtest.a $(EXTBUILDDIR)/gtest/gtest-all.o $(EXTBUILDDIR)/gtest/gtest_main.o

# google test clean
gtest.clean:
	@echo "cleaning gtest"
	@rm -rf $(EXTBUILDDIR)/gtest $(EXTINCDIR)/gtest $(EXTLIBDIR)/libgtest.a

# google test touch
gtest.touch:
	@rm -f $(EXTLIBDIR)/libgtest.a


# dependencies for boost
boost: $(EXTLIBDIR)/libboost_system.so
boost.src: $(EXTSRCDIR)/boost/INSTALL

# boost download
$(EXTSRCDIR)/boost/INSTALL:
	@echo "downloading boost"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) boost_1_57_0.tar.gz http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz
	@mv $(EXTSRCDIR)/boost_1_57_0 $(EXTSRCDIR)/boost

# boost build
$(EXTLIBDIR)/libboost_system.so: $(EXTSRCDIR)/boost/INSTALL
	@echo "building boost"
	@cd $(EXTSRCDIR)/boost && ./bootstrap.sh --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --without-icu && \
	    ./b2 install --disable-icu --build-dir=$(EXTBUILDDIR) -j$(NPROCESSES) $(BOOST_OPTION)

# boost clean
boost.clean:
	@echo "cleaning boost"
	@-cd $(EXTSRCDIR)/boost && ./b2 --clean $(BOOST_OPTION)
	@rm -rf $(EXTINCDIR)/boost $(EXTLIBDIR)/libboost_* $(EXTBUILDDIR)/boost

# boost touch
boost.touch:
	@rm -f $(EXTLIBDIR)/libboost_system.so


# dependencies for CLHEP
clhep: $(EXTBINDIR)/clhep-config
clhep.src: $(EXTSRCDIR)/CLHEP

# CLHEP download
$(EXTSRCDIR)/CLHEP:
	@echo "downloading CLHEP"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) clhep-2.1.3.1.tgz http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.3.1.tgz
	@mv $(EXTSRCDIR)/2.1.3.1/CLHEP $(EXTSRCDIR)/
	@rmdir $(EXTSRCDIR)/2.1.3.1

# CLHEP build
$(EXTBINDIR)/clhep-config: $(CMAKE) $(EXTSRCDIR)/CLHEP
	@echo "building CLHEP"
	@mkdir -p $(EXTBUILDDIR)/CLHEP
	@cd $(EXTBUILDDIR)/CLHEP && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) $(CLHEP_OPTION) $(EXTSRCDIR)/CLHEP && \
	    make -j $(NPROCESSES) && make install

# CLHEP clean
clhep.clean:
	@echo "cleaning CLHEP"
	@rm -rf $(EXTBUILDDIR)/CLHEP $(EXTDIR)/CLHEP $(EXTLIBDIR)/libCLHEP* $(EXTBINDIR)/clhep-config

# CLHEP touch
clhep.touch:
	@rm -f $(EXTBINDIR)/clhep-config


# dependencies for GEANT4
geant4: $(EXTBINDIR)/geant4.sh
geant4.src: $(EXTSRCDIR)/geant4

# GEANT4 download
$(EXTSRCDIR)/geant4:
	@echo "downloading geant4"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) geant4.9.6.p02.tar.gz http://geant4.cern.ch/support/source/geant4.9.6.p02.tar.gz
	@mv $(EXTSRCDIR)/geant4.9.6.p02 $(EXTSRCDIR)/geant4

# GEANT4 build
$(EXTBINDIR)/geant4.sh: $(CMAKE) $(EXTBINDIR)/clhep-config $(EXTSRCDIR)/geant4
	@echo "building geant4"
	@mkdir -p $(EXTBUILDDIR)/geant4
	@cd $(EXTBUILDDIR)/geant4 && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) $(GEANT4_OPTION) \
	    -DCLHEP_ROOT_DIR=$(EXTDIR) -DCLHEP_INCLUDE_DIR=$(EXTINCDIR) -DCLHEP_LIBRARY=$(EXTLIBDIR) \
	    -DGEANT4_USE_G3TOG4=ON -DGEANT4_USE_SYSTEM_EXPAT=OFF $(EXTSRCDIR)/geant4 &&\
	    make -j $(NPROCESSES) && make install
	@# Fix absolute path in geant4-config
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTBINDIR)/geant4-config
	@# Also fix geant4make just to be safe
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTDIR)/share/Geant4-9.6.2/geant4make/geant4make.*

# GEANT4 clean
geant4.clean:
	@echo "cleaning geant4"
	@-cd $(EXTBUILDDIR)/geant4 && make clean
	@rm -rf $(EXTBUILDDIR)/geant4 $(EXTDIR)/geant4 $(EXTDIR)/share/Geant4-9.6.2 $(EXTINCDIR)/Geant4 $(EXTLIBDIR)/libG4*.so $(EXTBINDIR)/geant4*

# GEANT4 touch command
geant4.touch:
	@rm -f $(EXTBINDIR)/geant4.sh


# dependencies for PostgreSql
postgresql: $(EXTBINDIR)/psql
postgresql.src: $(EXTSRCDIR)/postgresql/configure

# PostgreSql download
$(EXTSRCDIR)/postgresql/configure:
	@echo "downloading PostgreSql"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) postgresql-9.2.4.tar.gz http://ftp.postgresql.org/pub/source/v9.2.4/postgresql-9.2.4.tar.gz
	@mv $(EXTSRCDIR)/postgresql-9.2.4 $(EXTSRCDIR)/postgresql

# PostgreSql build
$(EXTBINDIR)/psql: $(EXTSRCDIR)/postgresql/configure
	@echo "building PostgreSql"
	@cd $(EXTSRCDIR)/postgresql && ./configure --prefix=$(EXTDIR) \
	    --includedir=$(EXTINCDIR)/pgsql/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) &&\
	    make -j $(NPROCESSES) && make install

# PostgreSql clean
postgresql.clean:
	@echo "cleaning PostgreSql"
	@cd $(EXTSRCDIR)/postgresql && make clean
	@rm -rf $(EXTINCDIR)/pgsql $(EXTBINDIR)/psql

# PostgreSql touch
postgresql.touch:
	@rm -f $(EXTBINDIR)/psql


# dependencies for libpqxx
libpqxx: $(EXTBINDIR)/pqxx-config
libpqxx.src: $(EXTSRCDIR)/libpqxx/configure

# libpqxx download
$(EXTSRCDIR)/libpqxx/configure:
	@echo "downloading libpqxx"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) libpqxx-4.0.tar.gz http://pqxx.org/download/software/libpqxx/libpqxx-4.0.tar.gz
	@mv $(EXTSRCDIR)/libpqxx-4.0 $(EXTSRCDIR)/libpqxx

# libpqxx build
$(EXTBINDIR)/pqxx-config: $(EXTSRCDIR)/libpqxx/configure
	@echo "building libpqxx"
	@cd $(EXTSRCDIR)/libpqxx && PG_CONFIG=$(EXTBINDIR)/pg_config ./configure --enable-shared \
	    --prefix=$(EXTDIR) --includedir=$(EXTINCDIR)/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) &&\
	    make -j $(NPROCESSES) && make install
	@#Fix absolute path in pqxx-config
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $@

# libpqxx clean
libpqxx.clean:
	@echo "cleaning libpqxx"
	@cd $(EXTSRCDIR)/libpqxx && make clean
	@rm -rf $(EXTINCDIR)/pqxx $(EXTBINDIR)/pqxx-config

# libpqxx touch
libpqxx.touch:
	@rm -f $(EXTBINDIR)/pqxx-config


# dependencies for NeuroBayes
neurobayes: $(EXTLIBDIR)/libNeuroBayesExpertCPP.so
neurobayes.src: $(EXTSRCDIR)/neurobayes/TMVAPlugin/README

# NeuroBayes download
$(EXTSRCDIR)/neurobayes/TMVAPlugin/README:
	@echo "downloading NeuroBayes"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) NeuroBayes_3.7.0_nbpluginfix.tgz
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && patch -Np1 < $(PATCHDIR)/neurobayes.patch

# NeuroBayes build
$(EXTLIBDIR)/libNeuroBayesExpertCPP.so: $(EXTSRCDIR)/neurobayes/TMVAPlugin/README
	@echo "building NeuroBayes"
	@mkdir -p $(EXTINCDIR)/neurobayes && cp $(EXTSRCDIR)/neurobayes/include/* $(EXTINCDIR)/neurobayes/
	@$(CXX) $(CXXFLAGS) -c -fPIC -I$(EXTINCDIR)/neurobayes -o $(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.o \
	    $(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.cc
	@$(CXX) -shared -o $(EXTLIBDIR)/libNeuroBayesTeacherCPP.so $(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.o
	@cp $(EXTSRCDIR)/neurobayes/`uname -m`/* $(EXTLIBDIR)/

# NeuroBayes clean command
neurobayes.clean:
	@echo "cleaning NeuroBayes"
	@rm -rf $(EXTLIBDIR)/libNeuroBayesExpertCPP.so $(EXTLIBDIR)/libdsa.so $(EXTINCDIR)/neurobayes

# NeuroBayes touch command
neurobayes.touch:
	@rm -f $(EXTLIBDIR)/libNeuroBayesExpertCPP.so


# dependencies for xrootd
xrootd: $(EXTBINDIR)/xrootd
xrootd.src: $(EXTSRCDIR)/xrootd

# xrootd download
$(EXTSRCDIR)/xrootd:
	@echo "downloading xrootd"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) xrootd-3.2.7.tar.gz http://xrootd.org/download/v3.2.7/xrootd-3.2.7.tar.gz
	@mv $(EXTSRCDIR)/xrootd-3.2.7 $(EXTSRCDIR)/xrootd

# xrootd build
$(EXTBINDIR)/xrootd: $(CMAKE) $(EXTSRCDIR)/xrootd
	@echo "building xrootd"
	@mkdir -p $(EXTBUILDDIR)/xrootd
	@cd $(EXTBUILDDIR)/xrootd && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) $(XROOTD_OPTION) $(EXTSRCDIR)/xrootd &&\
	    make -j $(NPROCESSES) && make install

# xrootd clean command
xrootd.clean:
	@echo "cleaning xrootd"
	@-cd $(EXTBUILDDIR)/xrootd && make clean
	@rm -rf $(EXTBUILDDIR)/xrootd $(EXTDIR)/xrootd $(EXTINCDIR)/xrootd $(EXTLIBDIR)/libXrd* $(EXTBINDIR)/xrd* $(EXTBINDIR)/xrootd

# root touch command
xrootd.touch:
	@rm -f $(EXTBINDIR)/xrootd


# dependencies for root
root: $(ROOTSYS)/bin/root
root.src: $(EXTSRCDIR)/root/README

# root download
$(EXTSRCDIR)/root/README: $(EXTSRCDIR)/neurobayes/TMVAPlugin/README
	@echo "downloading root"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) root_v6.04.02.source.tar.gz https://root.cern.ch/download/root_v6.04.02.source.tar.gz
	@mv $(EXTSRCDIR)/root-6.04.02 $(EXTSRCDIR)/root
	@cp $(EXTSRCDIR)/neurobayes/TMVAPlugin/addinMethod/MethodPlugins.cxx $(EXTSRCDIR)/root/tmva/tmva/src/

# root build
$(ROOTSYS)/bin/root: $(CMAKE) $(EXTSRCDIR)/root/README
	@echo "building root"
	@# make root/include directory a symlink to include/root
	@mkdir -p $(EXTINCDIR)/root $(ROOTSYS)
	@# FIXME: dynamic relpath?
	@cd $(ROOTSYS) && ln -sf ../../../include/root include
	@# now compile root and install into ROOTSYS
	@mkdir -p $(EXTBUILDDIR)/root
	@cd $(EXTBUILDDIR)/root && $(EXTSRCDIR)/root/configure --fail-on-missing \
	    --with-xrootd=$(EXTDIR) --with-pgsql-incdir=$(EXTINCDIR)/pgsql --with-pgsql-libdir=$(EXTLIBDIR) \
	    --disable-mysql --with-python-libdir=$(BELLE2_TOOLS)/python/lib --enable-gsl_shared --enable-roofit\
	    $(ROOT_OPTION) $(ROOT_EXTA_OPTION) && \
	    make -j $(NPROCESSES) && make install
	@mkdir -p $(EXTDIR)/share/root/tmva && cp -a $(EXTSRCDIR)/root/tutorials/tmva/* $(EXTDIR)/share/root/tmva

# root clean command
root.clean:
	@echo "cleaning root"
	@-cd $(EXTBUILDDIR)/root && make clean
	@rm -rf $(EXTBUILDDIR)/root $(ROOTSYS) $(EXTDIR)/share/root

# root touch command
root.touch:
	@rm -f $(ROOTSYS)/bin/root


# dependencies for NeuroBayes TMVA plugin
nbplugin: $(ROOTSYS)/lib/libTMVANeuroBayes.so
nbplugin.src: $(EXTSRCDIR)/neurobayes/TMVAPlugin/README

# NeuroBayes TMVA plugin build
$(ROOTSYS)/lib/libTMVANeuroBayes.so: $(EXTLIBDIR)/libNeuroBayesExpertCPP.so $(ROOTSYS)/bin/root
	@echo "buildng NeuroBayes TMVA plugin"
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && make NEUROBAYES_INC=$(EXTINCDIR)/neurobayes NEUROBAYES_LIB=$(EXTLIBDIR) &&\
	    make install
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && cp TMVA_NeuroBayes_Dict_rdict.pcm $(ROOTSYS)/lib/

# NeuroBayes TMVA plugin clean command
nbplugin.clean:
	@echo "cleaning NeuroBayes TMVA plugin"
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && make clean
	@rm -f $(ROOTSYS)/lib/libTMVANeuroBayes.so
	@rm -f $(ROOTSYS)/lib/TMVA_NeuroBayes_Dict_rdict.pcm

# NeuroBayes TMVA plugin touch command
nbplugin.touch:
	@rm -f $(ROOTSYS)/lib/libTMVANeuroBayes.so


# dependencies for FastBDT TMVA plugin
fastbdt: $(ROOTSYS)/lib/libTMVAFastBDT.so
fastbdt.src: $(EXTSRCDIR)/FastBDT/Makefile

# FastBDT download
$(EXTSRCDIR)/FastBDT/Makefile:
	@echo "downloading FastBDT"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) FastBDT-1.2.tar.gz

# FastBDT TMVA plugin build
$(ROOTSYS)/lib/libTMVAFastBDT.so: $(EXTSRCDIR)/FastBDT/Makefile $(ROOTSYS)/bin/root
	@echo "building FastBDT TMVA plugin"
	@cd $(EXTSRCDIR)/FastBDT && make && make install
	@cd $(EXTSRCDIR)/FastBDT && cp TMVA_FastBDT_Dict_rdict.pcm $(ROOTSYS)/lib/

# FastBDT TMVA plugin clean command
fastbdt.clean:
	@echo "cleaning FastBDT TMVA plugin"
	@cd $(EXTSRCDIR)/FastBDT && make clean
	@rm -f $(ROOTSYS)/lib/libTMVAFastBDT.so
	@rm -f $(ROOTSYS)/lib/TMVA_FastBDT_Dict_rdict.pcm

# FastBDT TMVA plugin touch command
fastbdt.touch:
	@rm -f $(ROOTSYS)/lib/libTMVAFastBDT.so


# dependencies for vgm
vgm: $(EXTLIBDIR)/libBaseVGM.so
vgm.src: $(EXTSRCDIR)/vgm

# vgm download
$(EXTSRCDIR)/vgm:
	@echo "downloading VGM"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) vgm-v3-06.tar.gz svn:export:730:https://vgm.svn.sourceforge.net/svnroot/vgm/tags/v3-06/vgm
	@cd $(EXTSRCDIR)/vgm && patch -Np0 < $(PATCHDIR)/vgm.patch

# vgm build
$(EXTLIBDIR)/libBaseVGM.so: $(CMAKE) $(EXTSRCDIR)/vgm
	@echo "building VGM"
	@mkdir -p $(EXTBUILDDIR)/vgm
	@cd $(EXTBUILDDIR)/vgm && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) -DGeant4_DIR=$(EXTBUILDDIR)/geant4\
	    -DCLHEP_INCLUDE_DIR=$(EXTINCDIR)/CLHEP -DCLHEP_LIBRARY_DIR=$(EXTLIBDIR) -DROOT_DIR=$(ROOTSYS)\
	    -DROOT_INCLUDE_DIR=$(ROOTSYS)/include -DROOT_LIBRARY_DIR=$(ROOTSYS)/lib -DWITH_TEST=OFF $(EXTSRCDIR)/vgm &&\
	    make install

# vgm clean
vgm.clean:
	@echo "cleaning VGM"
	@rm -rf $(EXTBUILDDIR)/vgm $(EXTDIR)/vgm $(EXTINCDIR)/vgm $(EXTLIBDIR)/lib*VGM.so

# vgm touch
vgm.touch:
	@rm -f $(EXTLIBDIR)/libBaseVGM.so


# dependencies for rave
rave: $(EXTLIBDIR)/libRaveBase.so
rave.src: $(EXTSRCDIR)/rave/README

# rave download
$(EXTSRCDIR)/rave/README:
	@echo "downloading rave"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) rave-0.6.24.tar.gz http://www.hepforge.org/archive/rave/rave-0.6.24.tar.gz
	@mv $(EXTSRCDIR)/rave-0.6.24 $(EXTSRCDIR)/rave
	@rm -rf $(EXTSRCDIR)/rave/src/boost $(EXTSRCDIR)/rave/src/ROOT/*/Math
	@cd $(EXTSRCDIR)/rave/src && ln -s ../../../include/boost boost
	@cd $(EXTSRCDIR)/rave/src/ROOT/genvector && ln -fs $(ROOTSYS)/include/Math Math
	@cd $(EXTSRCDIR)/rave/src/ROOT/mathcore && ln -fs $(ROOTSYS)/include/Math Math
	@cd $(EXTSRCDIR)/rave/src/ROOT/smatrix && ln -fs $(ROOTSYS)/include/Math Math
	@cd $(EXTSRCDIR)/rave/ && patch -p0 -i $(PATCHDIR)/rave-template-fix.patch

# rave build
$(EXTLIBDIR)/libRaveBase.so: $(EXTSRCDIR)/rave/README
	@echo "building rave"
	@cd $(EXTSRCDIR)/rave && CLHEPPATH=$(EXTDIR) CLHEPLIBPATH=$(EXTLIBDIR) CLHEP_VECTORLIBPATH=$(EXTLIBDIR) \
	    CLHEP_MATRIXLIBPATH=$(EXTLIBDIR) CXXFLAGS="-std=c++11 $(CXXFLAGS)" ./configure \
	    --disable-java --prefix=$(EXTDIR) --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR)\
	    --with-clhep=$(EXTDIR) --with-clhep-libdir=$(EXTLIBDIR) --with-boost=$(EXTDIR)
	@cd $(EXTSRCDIR)/rave && make -j $(NPROCESSES) && make install
	@#Fix absolute path in .cmake file/RaveConfig.cmake:
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$$ENV{BELLE2_EXTERNALS_DIR}:g" $(EXTDIR)/share/rave/RaveConfig.cmake

# rave clean
rave.clean:
	@echo "cleaning rave"
	@cd $(EXTSRCDIR)/rave && make clean
	@rm -rf $(EXTLIBDIR)/libRave* $(EXTINCDIR)/rave

# rave touch
rave.touch:
	@rm -f $(EXTLIBDIR)/libRaveBase.so


# dependencies for MillepedeII
MillepedeII: $(EXTBINDIR)/pede
MillepedeII.src: $(EXTSRCDIR)/MillepedeII/WIKI

# MillepedeII download
$(EXTSRCDIR)/MillepedeII/WIKI:
	@echo "downloading MillepedeII"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) MillepedeII_V04-03-00.tgz svn:checkout:140:http://svnsrv.desy.de/public/MillepedeII/tags/V04-03-00
	@mv $(EXTSRCDIR)/V04-03-00 $(EXTSRCDIR)/MillepedeII

# MillepedeII build
$(EXTBINDIR)/pede: $(EXTSRCDIR)/MillepedeII/WIKI
	@echo "building MillepedeII"
	@cd $(EXTSRCDIR)/MillepedeII && make pede
	@cp $(EXTSRCDIR)/MillepedeII/pede $(EXTBINDIR)/

# MillepedeII clean
MillepedeII.clean:
	@echo "cleaning MillepedeII"
	@cd $(EXTSRCDIR)/MillepedeII && make clean
	@rm -f $(EXTSRCDIR)/pede $(EXTBINDIR)/pede

# MillepedeII touch
MillepedeII.touch:
	@rm -f $(EXTBINDIR)/pede


# dependencies for HepMC
hepmc: $(EXTLIBDIR)/libHepMC.so
hepmc.src: $(EXTSRCDIR)/hepmc

# HepMC download
$(EXTSRCDIR)/hepmc:
	@echo "downloading HepMC"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) HepMC-2.06.09.tar.gz http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz
	@mv $(EXTSRCDIR)/HepMC-2.06.09 $(EXTSRCDIR)/hepmc

# HepMC build
$(EXTLIBDIR)/libHepMC.so: $(CMAKE) $(EXTSRCDIR)/hepmc
	@echo "building HepMC"
	@mkdir -p $(EXTBUILDDIR)/hepmc
	@cd $(EXTBUILDDIR)/hepmc && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) \
	    -Dmomentum:STRING=GEV -Dlength:STRING=CM $(EXTSRCDIR)/hepmc && \
	    make -j $(NPROCESSES) && make install

# HepMC clean
hepmc.clean:
	@echo "cleaning HepMC"
	@-cd $(EXTBUILDDIR)/hepmc && make clean
	@rm -rf $(EXTDIR)/hepmc $(EXTBUILDDIR)/hepmc $(EXTLIBDIR)/libHepMC* $(EXTLIBDIR)/libhepmC* $(EXTINCDIR)/HepMC

# HepMC touch
hepmc.touch:
	@rm -f $(EXTLIBDIR)/libHepMC.so


# dependencies for Pythia
pythia: $(EXTLIBDIR)/libpythia8.so
pythia.src: $(EXTSRCDIR)/pythia/configure

# Pythia download
$(EXTSRCDIR)/pythia/configure:
	@echo "downloading Pythia"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) pythia8209.tgz http://home.thep.lu.se/~torbjorn/pythia8/pythia8209.tgz
	@mv $(EXTSRCDIR)/pythia8209 $(EXTSRCDIR)/pythia
	@cd $(EXTSRCDIR)/pythia && patch -Np0 < $(PATCHDIR)/pythia.patch

# Pythia build
$(EXTLIBDIR)/libpythia8.so: $(EXTSRCDIR)/pythia/configure
	@echo "building Pythia"
	@cd $(EXTSRCDIR)/pythia && ./configure --prefix=$(EXTDIR) --enable-shared\
	    --with-hepmc3=$(EXTDIR) $(PYTHIA_OPTION) &&\
	    make -j $(NPROCESSES) && make install
	@#Fix absolute path in pythia8-config and make it executable
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTBINDIR)/pythia8-config
	@sed -i "s:\$$PREFIX/Makefile.inc:\$$PREFIX/share/Pythia8/examples/Makefile.inc:g" $(EXTBINDIR)/pythia8-config
	@chmod a+x $(EXTBINDIR)/pythia8-config

# Pythia clean
pythia.clean:
	@echo "cleaning Pythia"
	@cd $(EXTSRCDIR)/pythia && make clean
	@rm -rf $(EXTDIR)/pythia $(EXTLIBDIR)/libpythia* $(EXTINCDIR)/Pythia8* $(EXTDIR)/share/pythia

# Pythia touch
pythia.touch:
	@rm -f $(EXTLIBDIR)/libpythia8.so


# dependencies for Photos
photos: $(EXTLIBDIR)/libPhotosCxxInterface.so
photos.src: $(EXTSRCDIR)/PHOTOS/configure

# Photos download
$(EXTSRCDIR)/PHOTOS/configure:
	@echo "downloading Photos"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) PHOTOS.3.56.tar.gz http://photospp.web.cern.ch/photospp/resources/PHOTOS.3.56/PHOTOS.3.56.tar.gz
	@cd $(EXTSRCDIR)/PHOTOS && patch -Np0 < $(PATCHDIR)/photos.patch

# Photos build
$(EXTLIBDIR)/libPhotosCxxInterface.so: $(EXTSRCDIR)/PHOTOS/configure
	@echo "building Photos"
	@cd $(EXTSRCDIR)/PHOTOS && ./configure --prefix=$(EXTDIR) --with-hepmc=$(EXTDIR) &&\
	    make && make install

# Photos clean
photos.clean:
	@echo "cleaning Photos"
	@cd $(EXTSRCDIR)/PHOTOS && make clean
	@rm -rf $(EXTDIR)/photos $(EXTLIBDIR)/libPhotos* $(EXTINCDIR)/Photos

# Photos touch
photos.touch:
	@rm -f $(EXTLIBDIR)/libPhotosCxxInterface.so


# dependencies for Tauola
tauola: $(EXTLIBDIR)/libTauolaCxxInterface.so
tauola.src: $(EXTSRCDIR)/TAUOLA/configure

# Tauola download
$(EXTSRCDIR)/TAUOLA/configure:
	@echo "downloading Tauola"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) TAUOLA.1.1.4.tar.gz http://tauolapp.web.cern.ch/tauolapp/resources/TAUOLA.1.1.4/TAUOLA.1.1.4.tar.gz

# Tauola build
$(EXTLIBDIR)/libTauolaCxxInterface.so: $(EXTSRCDIR)/TAUOLA/configure
	@echo "building Tauola"
	@cd $(EXTSRCDIR)/TAUOLA && ./configure --prefix=$(EXTDIR) --with-hepmc=$(EXTDIR) && make && make install

# Tauola clean
tauola.clean:
	@echo "cleaning Tauola"
	@cd $(EXTSRCDIR)/TAUOLA && make clean
	@rm -rf $(EXTDIR)/tauola $(EXTLIBDIR)/libTauola* $(EXTINCDIR)/Tauola

# Tauola touch
tauola.touch:
	@rm -f $(EXTLIBDIR)/libTauolaCxxInterface.so


# dependencies for EvtGen
evtgen: $(EXTLIBDIR)/libEvtGen.so
evtgen.src: $(EXTSRCDIR)/evtgen/configure

# EvtGen download
$(EXTSRCDIR)/evtgen/configure:
	@echo "downloading EvtGen"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) EvtGen.R01-04-00.tar.gz http://evtgen.warwick.ac.uk/static/srcrep/R01-04-00/EvtGen.R01-04-00.tar.gz
	@mv $(EXTSRCDIR)/EvtGen/R01-04-00 $(EXTSRCDIR)/evtgen
	@rmdir $(EXTSRCDIR)/EvtGen
	@cd $(EXTSRCDIR)/evtgen && patch -Np0 < $(PATCHDIR)/evtgen.patch

# EvtGen build
$(EXTLIBDIR)/libEvtGen.so: $(EXTSRCDIR)/evtgen/configure
	@echo "building EvtGen"
	@cd $(EXTSRCDIR)/evtgen && ./configure --prefix=$(EXTDIR) --hepmcdir=$(EXTDIR) --pythiadir=$(EXTDIR) \
	    --photosdir=$(EXTDIR) --tauoladir=$(EXTDIR) $(EVTGEN_OPTION) &&\
	    make -j $(NPROCESSES) lib_shared  && make all install

# EvtGen clean
evtgen.clean:
	@echo "cleaning EvtGen"
	@cd $(EXTSRCDIR)/evtgen && make clean
	@rm -rf $(EXTDIR)/evtgen $(EXTLIBDIR)/libEvtGen* $(EXTINCDIR)/evtgen $(EXTDIR)/share/evtgen

# EvtGen touch
evtgen.touch:
	@rm -f $(EXTLIBDIR)/libEvtGen.so


# dependencies for Phokhara
phokhara: $(EXTLIBDIR)/libeemmg5.so
phokhara.src: $(EXTSRCDIR)/phokhara/Makefile

# Phokhara download
$(EXTSRCDIR)/phokhara/Makefile:
	@echo "downloading Phokhara"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) PH9.1b.tar.gz http://ific.uv.es/~rodrigo/phokhara/PH9.1b.tar.gz
	@mv $(EXTSRCDIR)/PH9.1 $(EXTSRCDIR)/phokhara
	@cd $(EXTSRCDIR)/phokhara/eemmg-lib && rm -f */*.o && make clean
	@cd $(EXTSRCDIR)/phokhara && patch -Np0 < $(PATCHDIR)/phokhara.patch

# Phokhara build
$(EXTLIBDIR)/libeemmg5.so: $(EXTSRCDIR)/phokhara/Makefile
	@echo "building Phokhara"
	@cd $(EXTSRCDIR)/phokhara/eemmg-lib && make
	@cp $(EXTSRCDIR)/phokhara/eemmg-lib/lib*.so $(EXTLIBDIR)/
	@mkdir -p $(EXTDIR)/share/phokhara && cp $(EXTSRCDIR)/phokhara/const_and_model_paramall9.1.dat $(EXTDIR)/share/phokhara/

# Phokhara clean
phokhara.clean:
	@echo "cleaning Phokhara"
	@cd $(EXTSRCDIR)/phokhara/eemmg-lib && make clean
	@rm -rf $(EXTSRCDIR)/phokhara/eemmg-lib/*/*.o $(EXTLIBDIR)/libeemmg*.so $(EXTLIBDIR)/libqcdloop1.so $(EXTLIBDIR)/libpjfry.so

# Phokhara touch
phokhara.touch:
	@rm -f $(EXTLIBDIR)/libeemmg5.so


# dependencies for MadGraph
madgraph: $(EXTDIR)/madgraph/bin/mg5 $(EXTLIBDIR)/libExRootAnalysis.so
madgraph.src: $(EXTDIR)/madgraph/bin/mg5 $(EXTSRCDIR)/ExRootAnalysis/Makefile

# MadGraph developer's kit installation
$(EXTDIR)/madgraph/bin/mg5:
	@echo "downloading MadGraph"
	@cd $(EXTDIR) && $(DOWNLOAD) MG5_aMC_v2.2.2.tar.gz
	@mv $(EXTDIR)/MG5_aMC_v2_2_2 $(EXTDIR)/madgraph

# MadGraph ExRootAnalysis download
$(EXTSRCDIR)/ExRootAnalysis/Makefile:
	@echo "downloading ExRootAnalysis"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) ExRootAnalysis_V1.1.2.tar.gz

# MadGraph ExRootAnalysis build
$(EXTLIBDIR)/libExRootAnalysis.so: $(EXTSRCDIR)/ExRootAnalysis/Makefile
	@echo "building ExRootAnalysis"
	@cd $(EXTSRCDIR)/ExRootAnalysis && make
	@cp $(EXTSRCDIR)/ExRootAnalysis/lib*.so $(EXTLIBDIR)/
	@cp $(EXTSRCDIR)/ExRootAnalysis/Ex*Converter $(EXTBINDIR)/
	@cp -a $(EXTSRCDIR)/ExRootAnalysis/ExRootAnalysis $(EXTINCDIR)/

# MadGraph clean
madgraph.clean:
	@echo "cleaning MadGraph"
	@cd $(EXTSRCDIR)/ExRootAnalysis && make clean
	@rm -rf $(EXTLIBDIR)/libExRootAnalysis.so $(EXTBINDIR)/Ex*Converter $(EXTINCDIR)/ExRootAnalysis

# MadGraph touch
madgraph.touch:
	@rm -f $(EXTLIBDIR)/libExRootAnalysis.so


# dependencies for CRY
cry: $(EXTLIBDIR)/libCRY.a
cry.src: $(EXTSRCDIR)/cry/configure

# CRY download
$(EXTSRCDIR)/cry/README:
	@echo "downloading CRY"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) cry_v1.7.tar.gz http://nuclear.llnl.gov/simulation/cry_v1.7.tar.gz
	@mv $(EXTSRCDIR)/cry_v1.7 $(EXTSRCDIR)/cry
	@cd $(EXTSRCDIR)/cry && patch -Np0 < $(PATCHDIR)/cry.patch

# CRY build
$(EXTLIBDIR)/libCRY.a: $(EXTSRCDIR)/cry/README
	@echo "building CRY"
	@cd $(EXTSRCDIR)/cry && make
	@cp $(EXTSRCDIR)/cry/lib/libCRY.* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/cry && cp -a $(EXTSRCDIR)/cry/src/*.h $(EXTINCDIR)/cry/

# CRY clean
cry.clean:
	@echo "cleaning CRY"
	@cd $(EXTSRCDIR)/cry && make clean
	@rm -rf $(EXTLIBDIR)/libCRY.* $(EXTINCDIR)/cry

# CRY touch
cry.touch:
	@rm -f $(EXTLIBDIR)/libCRY.a


# dependencies for FLC
flc: $(EXTLIBDIR)/libComplexPDF.so
flc.src: $(EXTSRCDIR)/FLC/README

# FLC download
$(EXTSRCDIR)/FLC/README:
	@echo "downloading FLC"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) BELLE_FLC_1.1.tar.gz http://www-ekp.physik.uni-karlsruhe.de/~mprim/BELLE_FLC/BELLE_FLC_1.1.tar.gz
	@mv $(EXTSRCDIR)/BELLE_FLC_1.1 $(EXTSRCDIR)/FLC
	@cd $(EXTSRCDIR)/FLC && patch -Np0 < $(PATCHDIR)/FLC.patch

# FLC build
$(EXTLIBDIR)/libComplexPDF.so: $(EXTSRCDIR)/FLC/README
	@echo "building FLC"
	@cd $(EXTSRCDIR)/FLC && ./make.sh -j $(NPROCESSES) CXX=$(CXX) OPT=$(CXXFLAGS) OPT+=-I$(ROOTSYS)/include BOOST_INC=-I$(EXTINCDIR) BOOST_LIB=-L$(EXTLIBDIR)
	@cp $(EXTSRCDIR)/FLC/lib/* $(EXTLIBDIR)/
	@cp -a $(EXTSRCDIR)/FLC/include $(EXTINCDIR)

# flc clean
flc.clean:
	@echo "cleaning FLC"
	@cd $(EXTSRCDIR)/FLC && ./make.sh clean
	@rm -rf $(EXTLIBDIR)/lib*ComplexPDF.so $(EXTINCDIR)

# flc touch command
flc.touch:
	@rm -rf $(EXTLIBDIR)/libComplexPDF.so



# dependencies for eigen
eigen: $(EXTINCDIR)/Eigen/Eigen
eigen.src: $(EXTSRCDIR)/eigen/INSTALL

# eigen download
$(EXTSRCDIR)/eigen/INSTALL:
	@echo "downloading eigen"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) eigen_3.2.0.tar.gz http://bitbucket.org/eigen/eigen/get/3.2.0.tar.gz
	@mv $(EXTSRCDIR)/eigen-eigen-ffa86ffb5570 $(EXTSRCDIR)/eigen

# eigen build
$(EXTINCDIR)/Eigen/Eigen: $(EXTSRCDIR)/eigen/INSTALL
	@echo "installing eigen"
	@cp -a $(EXTSRCDIR)/eigen/Eigen $(EXTINCDIR)/

# eigen clean
eigen.clean:
	@echo "cleaning eigen"
	@rm -rf $(EXTINCDIR)/Eigen

# eigen touch
eigen.touch:
	@rm -rf $(EXTSRCDIR)/Eigen/Eigen


# dependencies for vc
vc: $(EXTLIBDIR)/libVc.a
vc.src: $(EXTSRCDIR)/vc

# vc download
$(EXTSRCDIR)/vc:
	@echo "downloading vc"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) Vc-0.7.1.tar.gz http://code.compeng.uni-frankfurt.de/attachments/download/161/Vc-0.7.1.tar.gz
	@mv $(EXTSRCDIR)/Vc-0.7.1 $(EXTSRCDIR)/vc

# vc build
$(EXTLIBDIR)/libVc.a: $(EXTSRCDIR)/vc
	@echo "installing vc"
	@mkdir -p $(EXTBUILDDIR)/vc
	@cd $(EXTBUILDDIR)/vc && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR) -DBUILD_TESTING=OFF $(VC_OPTION) $(EXTSRCDIR)/vc &&\
	    make -j $(NPROCESSES) && make install
	@#Fix absolute path in .cmake file/RaveConfig.cmake:
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$$ENV{BELLE2_EXTERNALS_DIR}:g" $(EXTLIBDIR)/cmake/Vc/VcConfig.cmake

# vc clean
vc.clean:
	@echo "cleaning vc"
	@rm -rf $(EXTBUILDDIR)/vc $(EXTINCDIR)/Vc $(EXTLIBDIR)/libVc.a

# vc touch
vc.touch:
	@rm -rf $(EXTLIBDIR)/libVc.a


# dependencies for nsm2
nsm2: $(EXTBINDIR)/nsmd2
nsm2.src: $(EXTSRCDIR)/nsm2

# nsm2 download
$(EXTSRCDIR)/nsm2:
	@echo "downloading nsm2"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) nsm2.1.9.27.tgz

# nsm2 build
$(EXTBINDIR)/nsmd2: $(EXTSRCDIR)/nsm2
	@echo "installing nsm2"
	@mkdir -p $(EXTBUILDDIR)/nsm2
	@cd $(EXTSRCDIR)/nsm2 && make && make install

# nsm2 clean
nsm2.clean:
	@echo "cleaning nsm2"
	@cd $(EXTSRCDIR)/nsm2 && make clean
	@rm -rf $(EXTINCDIR)/nsm2 $(EXTBINDIR)/nsm*2 $(EXTLIBDIR)/libnsm2*

# nsm2 touch
nsm2.touch:
	@rm -rf $(EXTBINDIR)/nsmd2


# dependencies for belle_legacy
belle_legacy: $(EXTLIBDIR)/libbelle_legacy.so
belle_legacy.src: $(EXTSRCDIR)/belle_legacy

# belle_legacy download
$(EXTSRCDIR)/belle_legacy:
	@echo "downloading belle_legacy"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) belle_legacy-1.3.tgz svn:checkout:18674:https://belle2.cc.kek.jp/svn/groups/belle_legacy

# belle_legacy build
$(EXTLIBDIR)/libbelle_legacy.so: $(EXTSRCDIR)/belle_legacy
	@echo "installing belle_legacy"
	@cd $(EXTSRCDIR)/belle_legacy && make -j $(NPROCESSES) &&\
	    make BELLE2_EXTERNALS_DIR=$(EXTDIR) BELLE2_EXTERNALS_SUBDIR="" install

# belle_legacy clean
belle_legacy.clean:
	@echo "cleaning belle_legacy"
	@cd $(EXTSRCDIR)/belle_legacy && make clean
	@rm -rf $(EXTINCDIR)/belle_legacy $(EXTDIR)/share/belle_legacy $(EXTLIBDIR)/libbelle_legacy.*

# belle_legacy touch
belle_legacy.touch:
	@rm -rf $(EXTLIBDIR)/libbelle_legacy.so


# dependencies for curl
curl: $(EXTLIBDIR)/libcurl.so
curl.src: $(EXTSRCDIR)/curl/README

# curl download
$(EXTSRCDIR)/curl/README:
	@echo "downloading curl"
	@cd $(EXTSRCDIR) && $(DOWNLOAD) curl-7.41.0.tar.gz http://curl.haxx.se/download/curl-7.41.0.tar.gz
	@mv $(EXTSRCDIR)/curl-7.41.0 $(EXTSRCDIR)/curl

# curl build
$(EXTLIBDIR)/libcurl.so: $(EXTSRCDIR)/curl/README
	@echo "building curl"
	@cd $(EXTSRCDIR)/curl && ./configure --prefix=$(EXTDIR) --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR)\
	    --bindir=$(EXTBINDIR) --datarootdir=$(EXTDIR)/share/curl &&\
	    make -j $(NPROCESSES) && make install
	@#Fix absolute path in curl-config
	@sed -i "s:$(BELLE2_EXTERNALS_DIR):\$${BELLE2_EXTERNALS_DIR}:g" $(EXTBINDIR)/curl-config

# curl clean
curl.clean:
	@echo "cleaning curl"
	@cd $(EXTSRCDIR)/curl && make uninstall && make clean
	@rm -rf $(EXTINCDIR)/curl $(EXTDIR)/share/curl


# curl touch
curl.touch:
	@rm -rf $(EXTLIBDIR)/libcurl.so
