# define directories
export BELLE2_EXTERNALS_DIR := $(shell pwd)
export EXTDIR := $(BELLE2_EXTERNALS_DIR)
export EXTSRCDIR := $(EXTDIR)/src
export EXTBUILDDIR := $(EXTDIR)/build/$(BELLE2_EXTERNALS_SUBDIR)
export EXTINCDIR := $(EXTDIR)/include
export EXTLIBDIR := $(EXTDIR)/lib/$(BELLE2_EXTERNALS_SUBDIR)
export EXTBINDIR := $(EXTDIR)/bin/$(BELLE2_EXTERNALS_SUBDIR)

export ROOTSYS := $(EXTDIR)/root/$(BELLE2_EXTERNALS_SUBDIR)
export PATH := $(ROOTSYS)/bin:$(PATH)
ifeq ($(shell uname),Darwin)
  export DYLD_LIBRARY_PATH := $(ROOTSYS)/lib:$(DYLD_LIBRARY_PATH)
else
  export LD_LIBRARY_PATH := $(ROOTSYS)/lib:$(LD_LIBRARY_PATH)
endif

export LANG=C

# set cmake command
CMAKE=$(EXTDIR)/cmake/bin/cmake
export PATH := $(EXTDIR)/cmake/bin:$(PATH)

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
ifeq ($(BELLE2_EXTERNALS_OPTION),opt)
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

# check whether geant4 data files are already installed
GEANT4_DATA_EXISTS=$(shell test -d share/Geant4-10.0.1/data/G4EMLOW6.35; echo $$?)
ifneq ($(GEANT4_DATA_EXISTS),0)
  GEANT4_OPTION+= -DGEANT4_INSTALL_DATA=ON
endif

# check for graphics packages
GL_XMU_EXISTS=$(shell pkg-config --exists gl xmu 2> /dev/null; echo $$?)
ifeq ($(GL_XMU_EXISTS),0)
  GEANT4_OPTION+= -D g4vis_build_openglx_driver='y' -D g4vis_use_openglx='y'
endif


# external packages
PACKAGES=gtest boost clhep geant4 postgresql libpqxx neurobayes xrootd root nbplugin fastbdt vgm rave MillepedeII hepmc pythia photos tauola evtgen flc eigen vc nsm2

# all targets
all: dirs cmake $(PACKAGES)

# get source code of all packages
src: dirs $(foreach package,$(PACKAGES),$(package).src)

# clean up targets
clean: $(foreach package,$(PACKAGES),$(package).clean)

# remove only target files
touch: $(foreach package,$(PACKAGES),$(package).touch)

# directory creation
dirs: $(EXTSRCDIR) $(EXTBUILDDIR) $(EXTINCDIR) $(EXTLIBDIR) $(EXTBINDIR)

$(EXTSRCDIR):
	@echo "create  $(EXTSRCDIR)"
	@mkdir -p $(EXTSRCDIR)

$(EXTBUILDDIR):
	@echo "create  $(EXTBUILDDIR)"
	@mkdir -p $(EXTBUILDDIR)

$(EXTINCDIR):
	@echo "create  $(EXTINCDIR)"
	@mkdir -p $(EXTINCDIR)

$(EXTLIBDIR):
	@echo "create  $(EXTLIBDIR)"
	@mkdir -p $(EXTLIBDIR)

$(EXTBINDIR):
	@echo "create  $(EXTBINDIR)"
	@mkdir -p $(EXTBINDIR)


# dependencies for cmake
cmake: $(EXTDIR)/cmake/bin/cmake
cmake.src: $(EXTSRCDIR)/cmake/bootstrap

# cmake download
$(EXTSRCDIR)/cmake/bootstrap:
	@echo "downloading cmake"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh cmake-2.8.6.tar.gz http://www.cmake.org/files/v2.8/cmake-2.8.6.tar.gz
	@mv $(EXTSRCDIR)/cmake-2.8.6 $(EXTSRCDIR)/cmake

# cmake build
$(EXTDIR)/cmake/bin/cmake: $(EXTSRCDIR)/cmake/bootstrap
	@echo "building cmake"
	@cd $(EXTSRCDIR)/cmake && ./bootstrap --prefix=$(EXTDIR)/cmake && sed -i 's/BUILD_CursesDialog\:BOOL=ON/BUILD_CursesDialog\:BOOL=OFF/g' CMakeCache.txt && make -j $(NPROCESSES) && make install

# cmake clean
cmake.clean:
	@echo "cleaning cmake"
	@cd $(EXTSRCDIR)/cmake && make clean
	@rm -f $(EXTDIR)/cmake/bin/cmake

# cmake touch
cmake.touch:
	@rm -f $(EXTDIR)/cmake/bin/cmake


# dependencies for google test
gtest: $(EXTLIBDIR)/libgtest.a
gtest.src: $(EXTSRCDIR)/gtest/README

# google test download
$(EXTSRCDIR)/gtest/README:
	@echo "downloading gtest"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh gtest-1.6.0.tar.gz http://googletest.googlecode.com/files/gtest-1.6.0.zip
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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh boost_1_55_0.tar.gz http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz
	@mv $(EXTSRCDIR)/boost_1_55_0 $(EXTSRCDIR)/boost

# boost build
$(EXTLIBDIR)/libboost_system.so: $(EXTSRCDIR)/boost/INSTALL
	@echo "building boost"
	@cd $(EXTSRCDIR)/boost && ./bootstrap.sh --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) && ./b2 install --build-dir=$(EXTBUILDDIR) -j$(NPROCESSES) $(BOOST_OPTION)

# boost clean
boost.clean:
	@echo "cleaning boost"
	@-cd $(EXTSRCDIR)/boost && ./b2 --clean $(BOOST_OPTION)
	@rm -rf $(EXTINCDIR)/boost $(EXTLIBDIR)/libboost_*

# boost touch
boost.touch:
	@rm -f $(EXTLIBDIR)/libboost_system.so


# dependencies for CLHEP
clhep: $(EXTBINDIR)/clhep-config
clhep.src: $(EXTSRCDIR)/CLHEP

# CLHEP download
$(EXTSRCDIR)/CLHEP:
	@echo "downloading CLHEP"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh clhep-2.1.4.1.tgz http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.4.1.tgz
	@mv $(EXTSRCDIR)/2.1.4.1/CLHEP $(EXTSRCDIR)/
	@rmdir $(EXTSRCDIR)/2.1.4.1

# CLHEP build
$(EXTBINDIR)/clhep-config: $(CMAKE) $(EXTSRCDIR)/CLHEP
	@echo "building CLHEP"
	@mkdir -p $(EXTBUILDDIR)/CLHEP
	@cd $(EXTBUILDDIR)/CLHEP && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/CLHEP $(CLHEP_OPTION) $(EXTSRCDIR)/CLHEP && make -j $(NPROCESSES) && make install
	@cp -a $(EXTDIR)/CLHEP/include/CLHEP $(EXTINCDIR)/
	@cp -a $(EXTDIR)/CLHEP/lib/* $(EXTLIBDIR)/
	@cp $(EXTDIR)/CLHEP/bin/* $(EXTBINDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh geant4.10.00.p01.tar.gz http://geant4.cern.ch/support/source/geant4.10.00.p01.tar.gz
	@mv $(EXTSRCDIR)/geant4.10.00.p01 $(EXTSRCDIR)/geant4

# GEANT4 build
$(EXTBINDIR)/geant4.sh: $(CMAKE) $(EXTBINDIR)/clhep-config $(EXTSRCDIR)/geant4
	@echo "building geant4"
	@mkdir -p $(EXTBUILDDIR)/geant4
	@cd $(EXTBUILDDIR)/geant4 && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/geant4 $(GEANT4_OPTION) \
	-DCLHEP_ROOT_DIR=$(EXTDIR) -DCLHEP_INCLUDE_DIR=$(EXTINCDIR) -DCLHEP_LIBRARY=$(EXTLIBDIR) \
	-DGEANT4_USE_G3TOG4=ON -DGEANT4_USE_SYSTEM_EXPAT=OFF $(EXTSRCDIR)/geant4 && make -j $(NPROCESSES) && make install
	@cp -a $(EXTDIR)/geant4/include/Geant4 $(EXTINCDIR)/
	@cp -a $(EXTDIR)/geant4/lib*/* $(EXTLIBDIR)/
	@cp -a $(EXTDIR)/geant4/bin/* $(EXTBINDIR)/
	@cp -a $(EXTDIR)/geant4/share $(EXTDIR)/
	@sed -f geant4.sed -i $(EXTBINDIR)/geant4-config
	@sed -f geant4.sed -i $(EXTBINDIR)/geant4.sh
	@sed -f geant4.sed -i $(EXTBINDIR)/geant4.csh

# GEANT4 clean
geant4.clean:
	@echo "cleaning geant4"
	@-cd $(EXTBUILDDIR)/geant4 && make clean
	@rm -rf $(EXTBUILDDIR)/geant4 $(EXTDIR)/geant4 $(EXTDIR)/share/Geant4-10.0.1 $(EXTINCDIR)/Geant4 $(EXTLIBDIR)/libG4*.so $(EXTBINDIR)/geant4*

# GEANT4 touch command
geant4.touch:
	@rm -f $(EXTBINDIR)/geant4.sh


# dependencies for PostgreSql
postgresql: $(EXTBINDIR)/psql
postgresql.src: $(EXTSRCDIR)/postgresql/configure

# PostgreSql download
$(EXTSRCDIR)/postgresql/configure:
	@echo "downloading PostgreSql"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh postgresql-9.2.4.tar.gz http://ftp.postgresql.org/pub/source/v9.2.4/postgresql-9.2.4.tar.gz
	@mv $(EXTSRCDIR)/postgresql-9.2.4 $(EXTSRCDIR)/postgresql

# PostgreSql build
$(EXTBINDIR)/psql: $(EXTSRCDIR)/postgresql/configure
	@echo "building PostgreSql"
	@cd $(EXTSRCDIR)/postgresql && ./configure --prefix=$(EXTDIR) \
	--includedir=$(EXTINCDIR)/pgsql/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) && make -j $(NPROCESSES) && make install

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh libpqxx-4.0.tar.gz http://pqxx.org/download/software/libpqxx/libpqxx-4.0.tar.gz
	@mv $(EXTSRCDIR)/libpqxx-4.0 $(EXTSRCDIR)/libpqxx

# libpqxx build
$(EXTBINDIR)/pqxx-config: $(EXTSRCDIR)/libpqxx/configure
	@echo "building libpqxx"
	@cd $(EXTSRCDIR)/libpqxx && PG_CONFIG=$(EXTBINDIR)/pg_config ./configure --enable-shared --prefix=$(EXTDIR) \
	--includedir=$(EXTINCDIR)/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) && make -j $(NPROCESSES) && make install

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh NeuroBayes_3.7.0_nbpluginfix.tgz

# NeuroBayes build
$(EXTLIBDIR)/libNeuroBayesExpertCPP.so: $(EXTSRCDIR)/neurobayes/TMVAPlugin/README
	@echo "building NeuroBayes"
	@mkdir -p $(EXTINCDIR)/neurobayes && cp $(EXTSRCDIR)/neurobayes/include/* $(EXTINCDIR)/neurobayes/
	$(CXX) $(CXXFLAGS) -c -fPIC -I$(EXTINCDIR)/neurobayes -o $(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.o \
	$(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.cc
	$(CXX) -shared -o $(EXTLIBDIR)/libNeuroBayesTeacherCPP.so $(EXTSRCDIR)/neurobayes/src/NeuroBayesTeacherDummy.o
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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh xrootd-3.2.7.tar.gz http://xrootd.org/download/v3.2.7/xrootd-3.2.7.tar.gz
	@mv $(EXTSRCDIR)/xrootd-3.2.7 $(EXTSRCDIR)/xrootd

# xrootd build
$(EXTBINDIR)/xrootd: $(CMAKE) $(EXTSRCDIR)/xrootd
	@echo "building xrootd"
	@mkdir -p $(EXTBUILDDIR)/xrootd
	@cd $(EXTBUILDDIR)/xrootd && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/xrootd $(XROOTD_OPTION) $(EXTSRCDIR)/xrootd && make install
	@cp -a $(EXTDIR)/xrootd/include/* $(EXTINCDIR)/
	@cp -a $(EXTDIR)/xrootd/lib*/* $(EXTLIBDIR)/
	@cp $(EXTDIR)/xrootd/bin/* $(EXTBINDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh root_v5.34.21.source.tar.gz ftp://root.cern.ch/root/root_v5.34.21.source.tar.gz
	@cp $(EXTSRCDIR)/neurobayes/TMVAPlugin/addinMethod/MethodPlugins.cxx $(EXTSRCDIR)/root/tmva/src/

# root build
$(ROOTSYS)/bin/root: $(CMAKE) $(EXTSRCDIR)/root/README
	@echo "building root"
	@mkdir -p $(EXTBUILDDIR)/root
	@cd $(EXTBUILDDIR)/root && $(EXTSRCDIR)/root/configure --with-xrootd=$(EXTDIR)/xrootd \
	--with-pgsql-incdir=$(EXTINCDIR)/pgsql --with-pgsql-libdir=$(EXTLIBDIR) \
	--disable-mysql --with-python-libdir=$(BELLE2_TOOLS)/python/lib --enable-gsl_shared --enable-roofit $(ROOT_OPTION) && \
	make -j $(NPROCESSES) && make install
	@mkdir -p $(EXTINCDIR)/root && cp -a $(ROOTSYS)/include/* $(EXTINCDIR)/root

# root clean command
root.clean:
	@echo "cleaning root"
	@-cd $(EXTBUILDDIR)/root && make clean
	@rm -rf $(EXTBUILDDIR)/root $(ROOTSYS)

# root touch command
root.touch:
	@rm -f $(ROOTSYS)/bin/root


# dependencies for NeuroBayes TMVA plugin
nbplugin: $(ROOTSYS)/lib/libTMVANeuroBayes.so

# NeuroBayes TMVA plugin build
$(ROOTSYS)/lib/libTMVANeuroBayes.so: $(EXTLIBDIR)/libNeuroBayesExpertCPP.so $(ROOTSYS)/bin/root
	@echo "building NeuroBayes TMVA plugin"
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && make NEUROBAYES_INC=$(EXTINCDIR)/neurobayes NEUROBAYES_LIB=$(EXTLIBDIR) && make install

# NeuroBayes TMVA plugin clean command
nbplugin.clean:
	@echo "cleaning NeuroBayes TMVA plugin"
	@cd $(EXTSRCDIR)/neurobayes/TMVAPlugin && make clean
	@rm -f $(ROOTSYS)/lib/libTMVANeuroBayes.so

# NeuroBayes TMVA plugin touch command
nbplugin.touch:
	@rm -f $(ROOTSYS)/lib/libTMVANeuroBayes.so


# dependencies for FastBDT TMVA plugin
fastbdt: $(ROOTSYS)/lib/libTMVAFastBDT.so
fastbdt.src: $(ROOTSYS)/lib/libTMVAFastBDT.so

# FastBDT download
$(EXTSRCDIR)/FastBDT/Makefile:
	@echo "downloading FastBDT"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh FastBDT.tar.gz

# FastBDT TMVA plugin build
$(ROOTSYS)/lib/libTMVAFastBDT.so: $(EXTSRCDIR)/FastBDT/Makefile $(ROOTSYS)/bin/root
	@echo "building FastBDT TMVA plugin"
	@cd $(EXTSRCDIR)/FastBDT && make && make install

# FastBDT TMVA plugin clean command
fastbdt.clean:
	@echo "cleaning FastBDT TMVA plugin"
	@cd $(EXTSRCDIR)/FastBDT && make clean
	@rm -f $(ROOTSYS)/lib/libTMVAFastBDT.so

# FastBDT TMVA plugin touch command
fastbdt.touch:
	@rm -f $(ROOTSYS)/lib/libTMVAFastBDT.so


# dependencies for vgm
vgm: $(EXTLIBDIR)/libBaseVGM.so
vgm.src: $(EXTSRCDIR)/vgm

# vgm download
$(EXTSRCDIR)/vgm:
	@echo "downloading VGM"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh vgm-v3-06.tar.gz svn:export:730:https://vgm.svn.sourceforge.net/svnroot/vgm/tags/v3-06/vgm
	@cd $(EXTSRCDIR)/vgm && patch -Np0 < $(EXTDIR)/vgm.patch

# vgm build
$(EXTLIBDIR)/libBaseVGM.so: $(CMAKE) $(EXTSRCDIR)/vgm
	@echo "building VGM"
	@mkdir -p $(EXTBUILDDIR)/vgm
	@cd $(EXTBUILDDIR)/vgm && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/vgm -DGeant4_DIR=$(EXTBUILDDIR)/geant4 -DCLHEP_INCLUDE_DIR=$(EXTINCDIR)/CLHEP -DCLHEP_LIBRARY_DIR=$(EXTLIBDIR) -DROOT_DIR=$(ROOTSYS) -DROOT_INCLUDE_DIR=$(ROOTSYS)/include -DROOT_LIBRARY_DIR=$(ROOTSYS)/lib -DWITH_TEST=OFF $(EXTSRCDIR)/vgm && make install
	@cp -a $(EXTDIR)/vgm/include $(EXTINCDIR)/vgm
	@cp -a $(EXTDIR)/vgm/lib/* $(EXTLIBDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh rave-0.6.16.tar.gz http://www.hepforge.org/archive/rave/rave-0.6.16.tar.gz
	@mv $(EXTSRCDIR)/rave-0.6.16 $(EXTSRCDIR)/rave
	@-cd $(EXTSRCDIR)/rave && patch -Np0 < $(EXTDIR)/rave.patch
	@rm -rf $(EXTSRCDIR)/rave/src/boost $(EXTSRCDIR)/rave/src/ROOT/*/Math
	@cd $(EXTSRCDIR)/rave/src && ln -s ../../../include/boost boost
	@cd $(EXTSRCDIR)/rave/src/ROOT/genvector && ln -s ../../../../../include/root/Math Math
	@cd $(EXTSRCDIR)/rave/src/ROOT/mathcore && ln -s ../../../../../include/root/Math Math
	@cd $(EXTSRCDIR)/rave/src/ROOT/smatrix && ln -s ../../../../../include/root/Math Math

# rave build
$(EXTLIBDIR)/libRaveBase.so: $(EXTSRCDIR)/rave/README
	@echo "building rave"
	@cd $(EXTSRCDIR)/rave && CLHEPPATH=$(EXTDIR) CLHEPLIBPATH=$(EXTLIBDIR) CLHEP_VECTORLIBPATH=$(EXTLIBDIR) CLHEP_MATRIXLIBPATH=$(EXTLIBDIR) ./configure \
	--disable-java --prefix=$(EXTDIR) --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) --with-clhep=$(EXTDIR) --with-clhep-libdir=$(EXTLIBDIR) --with-boost=$(EXTDIR)
	@cd $(EXTSRCDIR)/rave && make -j $(NPROCESSES) && make install

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh MillepedeII_V04-02-00.tgz svn:checkout:124:http://svnsrv.desy.de/public/MillepedeII/tags/V04-02-00
	@mv $(EXTSRCDIR)/V04-02-00 $(EXTSRCDIR)/MillepedeII

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh HepMC-2.06.09.tar.gz http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz
	@mv $(EXTSRCDIR)/HepMC-2.06.09 $(EXTSRCDIR)/hepmc

# HepMC build
$(EXTLIBDIR)/libHepMC.so: $(CMAKE) $(EXTSRCDIR)/hepmc
	@echo "building HepMC"
	@mkdir -p $(EXTBUILDDIR)/hepmc
	@cd $(EXTBUILDDIR)/hepmc && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/hepmc -Dmomentum:STRING=GEV -Dlength:STRING=CM $(EXTSRCDIR)/hepmc && \
	make -j $(NPROCESSES) && make install
	@cp $(EXTDIR)/hepmc/lib/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/HepMC && cp $(EXTDIR)/hepmc/include/HepMC/* $(EXTINCDIR)/HepMC/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh pythia8183.tgz http://home.thep.lu.se/~torbjorn/pythia8/pythia8183.tgz
	@mv $(EXTSRCDIR)/pythia8183 $(EXTSRCDIR)/pythia

# Pythia build
$(EXTLIBDIR)/libpythia8.so: $(EXTSRCDIR)/pythia/configure
	@echo "building Pythia"
	@cd $(EXTSRCDIR)/pythia && ./configure --prefix=$(EXTDIR)/pythia --enable-shared --with-hepmc=$(EXTDIR)/hepmc $(PYTHIA_OPTION) && make -j $(NPROCESSES) && make install
	@cp $(EXTDIR)/pythia/lib/lib* $(EXTDIR)/pythia/lib/archive/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/Pythia8 && cp $(EXTDIR)/pythia/include/Pythia8/* $(EXTINCDIR)/Pythia8/
	@mkdir -p $(EXTDIR)/share/pythia && cp $(EXTDIR)/pythia/xmldoc/* $(EXTDIR)/share/pythia/ && chmod u+w $(EXTDIR)/share/pythia/*

# Pythia clean
pythia.clean:
	@echo "cleaning Pythia"
	@cd $(EXTSRCDIR)/pythia && make clean
	@rm -rf $(EXTDIR)/pythia $(EXTLIBDIR)/libpythia* $(EXTINCDIR)/Pythia8 $(EXTDIR)/share/pythia

# Pythia touch
pythia.touch:
	@rm -f $(EXTLIBDIR)/libpythia8.so


# dependencies for Photos
photos: $(EXTLIBDIR)/libPhotosCxxInterface.so
photos.src: $(EXTSRCDIR)/PHOTOS/configure

# Photos download
$(EXTSRCDIR)/PHOTOS/configure:
	@echo "downloading Photos"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh PHOTOS.3.54.tar.gz http://photospp.web.cern.ch/photospp/resources/PHOTOS.3.54/PHOTOS.3.54.tar.gz
	@cd $(EXTSRCDIR)/PHOTOS && patch -Np0 < $(EXTDIR)/photos.patch

# Photos build
$(EXTLIBDIR)/libPhotosCxxInterface.so: $(EXTSRCDIR)/PHOTOS/configure
	@echo "building Photos"
	@cd $(EXTSRCDIR)/PHOTOS && ./configure --prefix=$(EXTDIR)/photos --with-hepmc=$(EXTDIR)/hepmc && make && make install
	@cp $(EXTDIR)/photos/lib/* $(EXTLIBDIR)/
	@cp -a $(EXTDIR)/photos/include/Photos $(EXTINCDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh TAUOLA.1.1.4.tar.gg  http://tauolapp.web.cern.ch/tauolapp/resources/TAUOLA.1.1.4/TAUOLA.1.1.4.tar.gz

# Tauola build
$(EXTLIBDIR)/libTauolaCxxInterface.so: $(EXTSRCDIR)/TAUOLA/configure
	@echo "building Tauola"
	@cd $(EXTSRCDIR)/TAUOLA && ./configure --prefix=$(EXTDIR)/tauola --with-hepmc=$(EXTDIR)/hepmc && make && make install
	@cp $(EXTDIR)/tauola/lib/* $(EXTLIBDIR)/
	@cp -a $(EXTDIR)/tauola/include/Tauola $(EXTINCDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh EvtGen.R01-03-00.tar.gz http://evtgen.warwick.ac.uk/static/srcrep/R01-03-00/EvtGen.R01-03-00.tar.gz
	@mv $(EXTSRCDIR)/EvtGen/R01-03-00 $(EXTSRCDIR)/evtgen
	@rmdir $(EXTSRCDIR)/EvtGen
	@cd $(EXTSRCDIR)/evtgen && patch -Np0 < $(EXTDIR)/evtgen.patch

# EvtGen build
$(EXTLIBDIR)/libEvtGen.so: $(EXTSRCDIR)/evtgen/configure
	@echo "building EvtGen"
	@cd $(EXTSRCDIR)/evtgen && ./configure --prefix=$(EXTDIR)/evtgen --hepmcdir=$(EXTDIR)/hepmc --pythiadir=$(EXTDIR)/pythia --photosdir=$(EXTDIR)/photos --tauoladir=$(EXTDIR)/tauola $(EVTGEN_OPTION) && make -j $(NPROCESSES) lib_shared  && make all install
	@cp $(EXTDIR)/evtgen/lib/lib* $(EXTDIR)/evtgen/lib/archive/* $(EXTLIBDIR)/
	@rm -rf $(EXTINCDIR)/evtgen && cp -a $(EXTDIR)/evtgen/include $(EXTINCDIR)/evtgen
	@mkdir -p $(EXTDIR)/share/evtgen && cp $(EXTDIR)/evtgen/share/evt.pdl $(EXTDIR)/share/evtgen/ && cp $(EXTDIR)/evtgen/share/DECAY_2010.DEC $(EXTDIR)/share/evtgen/DECAY.DEC

# EvtGen clean
evtgen.clean:
	@echo "cleaning EvtGen"
	@cd $(EXTSRCDIR)/evtgen && make clean
	@rm -rf $(EXTDIR)/evtgen $(EXTLIBDIR)/libEvtGen* $(EXTINCDIR)/evtgen $(EXTDIR)/share/evtgen

# EvtGen touch
evtgen.touch:
	@rm -f $(EXTLIBDIR)/libEvtGen.so


# dependencies for FLC
flc: $(EXTLIBDIR)/libComplexPDF.so
flc.src: $(EXTSRCDIR)/FLC/README

# FLC download
$(EXTSRCDIR)/FLC/README:
	@echo "downloading FLC"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh BELLE_FLC_1.1.tar.gz http://www-ekp.physik.uni-karlsruhe.de/~mprim/BELLE_FLC/BELLE_FLC_1.1.tar.gz
	@mv $(EXTSRCDIR)/BELLE_FLC_1.1 $(EXTSRCDIR)/FLC
	@cd $(EXTSRCDIR)/FLC && patch -Np0 < $(EXTDIR)/FLC.patch

# FLC build
$(EXTLIBDIR)/libComplexPDF.so: $(EXTSRCDIR)/FLC/README
	@echo "building FLC"
	@cd $(EXTSRCDIR)/FLC && ./make.sh -j $(NPROCESSES) CXX=$(CXX) OPT=$(CXXFLAGS) OPT+=-I$(ROOTSYS)/include BOOST_INC=-I$(EXTINCDIR) BOOST_LIB=-L$(EXTLIBDIR)
	@cp $(EXTSRCDIR)/FLC/lib/* $(EXTLIBDIR)/
	@cp -a $(EXTSRCDIR)/FLC/include $(EXTINCDIR)/FLC

# flc clean
flc.clean:
	@echo "cleaning FLC"
	@cd $(EXTSRCDIR)/FLC && ./make.sh clean
	@rm -rf $(EXTLIBDIR)/lib*ComplexPDF.so $(EXTINCDIR)/FLC

# flc touch command
flc.touch:
	@rm -rf $(EXTLIBDIR)/libComplexPDF.so



# dependencies for eigen
eigen: $(EXTINCDIR)/Eigen/Eigen
eigen.src: $(EXTSRCDIR)/eigen/INSTALL

# eigen download
$(EXTSRCDIR)/eigen/INSTALL:
	@echo "downloading eigen"
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh eigen_3.2.0.tar.gz http://bitbucket.org/eigen/eigen/get/3.2.0.tar.gz
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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh Vc-0.7.1.tar.gz http://code.compeng.uni-frankfurt.de/attachments/download/161/Vc-0.7.1.tar.gz
	@mv $(EXTSRCDIR)/Vc-0.7.1 $(EXTSRCDIR)/vc

# vc build
$(EXTLIBDIR)/libVc.a: $(EXTSRCDIR)/vc
	@echo "installing vc"
	@mkdir -p $(EXTBUILDDIR)/vc
	@cd $(EXTBUILDDIR)/vc && $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/vc -DBUILD_TESTING=OFF $(VC_OPTION) $(EXTSRCDIR)/vc && make -j $(NPROCESSES) && make install
	@cp -a $(EXTDIR)/vc/include/Vc $(EXTINCDIR)/
	@cp -a $(EXTDIR)/vc/lib/lib* $(EXTLIBDIR)/

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
	@cd $(EXTSRCDIR) && $(EXTDIR)/download.sh nsm2.1.9.27.tgz

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
