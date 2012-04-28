
# define directories
export BELLE2_EXTERNALS_DIR := $(shell pwd)
export EXTDIR := $(BELLE2_EXTERNALS_DIR)
export EXTINCDIR := $(EXTDIR)/include
export EXTLIBDIR := $(EXTDIR)/lib/$(BELLE2_EXTERNALS_SUBDIR)
export EXTBINDIR := $(EXTDIR)/bin/$(BELLE2_EXTERNALS_SUBDIR)
ifdef BELLE2_EXTERNALS_OPTION
  EXTERNALS_OPTION := $(BELLE2_EXTERNALS_OPTION)
else
  EXTERNALS_OPTION := $(BELLE2_OPTION)
endif

export EXTDIRVAR := \$${BELLE2_EXTERNALS_DIR}
export EXTINCDIRVAR := $(EXTDIRVAR)/include
export EXTLIBDIRVAR := $(EXTDIRVAR)/lib/\$${BELLE2_EXTERNALS_SUBDIR}
export EXTBINDIRVAR := $(EXTDIRVAR)/bin/\$${BELLE2_EXTERNALS_SUBDIR}

export ROOTSYS := $(EXTDIR)/build/root/$(BELLE2_EXTERNALS_SUBDIR)
export GENFIT := $(EXTDIRVAR)/genfit
export PATH := $(ROOTSYS)/bin:$(PATH)
ifeq ($(shell uname),Darwin)
  export DYLD_LIBRARY_PATH := $(ROOTSYS)/lib:$(DYLD_LIBRARY_PATH)
else
  export LD_LIBRARY_PATH := $(ROOTSYS)/lib:$(LD_LIBRARY_PATH)
endif

# set cmake command
CMAKE=cmake
CMAKE_EXISTS=$(shell which cmake 2> /dev/null; echo $$?)
ifneq ($(CMAKE_EXISTS),0)
  CMAKE=$(EXTDIR)/cmake/bin/cmake
endif


# set number of parallel jobs to the number of processors
ifeq ($(shell uname),Darwin)
  NPROCESSES=$(shell sysctl -n hw.ncpu 2> /dev/null)
else
  NPROCESSES=$(shell grep processor /proc/cpuinfo 2> /dev/null | wc -l)
endif
ifeq ($(NPROCESSES),0)
  NPROCESSES=1
endif

# set debug or optimization options 
ifeq ($(EXTERNALS_OPTION),debug)
  export BOOST_OPTION=variant=debug
  export CXXFLAGS=-g
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=RelWithDebInfo
  export ROOT_OPTION=
  export ROOTBUILD=debug
  export PYTHIA_OPTION=--enable-debug
  export EVTGEN_OPTION=--enable-debug
else 
ifeq ($(EXTERNALS_OPTION),opt)
  export BOOST_OPTION=variant=release
  export CXXFLAGS=-O3
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=Release
  export ROOT_OPTION=
  export ROOTBUILD=
  export PYTHIA_OPTION=
  export EVTGEN_OPTION=
else
ifeq ($(EXTERNALS_OPTION),intel)
  export CC=icc
  export CXX=icpc
  export CXXCPP=icc -E
  export FC=ifort
  export AR=xiar
  export LD=xild
  export BOOST_OPTION=variant=release toolset=intel
  export GEANT4_OPTION=-DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icc
  export ROOT_OPTION=linuxicc
  ifeq ($(shell uname -m),x86_64)
    export ROOT_OPTION=linuxx8664icc
  endif
  export ROOTBUILD=
  export PYTHIA_OPTION=
  export EVTGEN_OPTION=
else
  $(error Unknown externals build option. Please source the setup_belle2.(c)sh script.)
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


# all target
all: dirs cmake gtest boost clhep geant4 mysql mysql-connector-c++ postgresql libpqxx root vgm geant4_vmc genfit hepmc pythia photos tauola evtgen rave

# clean up target
clean: gtest.clean boost.clean clhep.clean geant4.clean mysql.clean mysql-connector-c++.clean postgresql.clean libpqxx.clean root.clean vgm.clean geant4_vmc.clean genfit.clean hepmc.clean pythia.clean photos.clean tauola.clean evtgen.clean rave.clean

# remove only target files
touch: gtest.touch boost.touch clhep.touch geant4.touch mysql.touch mysql-connector-c++.touch postgresql.touch libpqxx.touch root.touch vgm.touch geant4_vmc.touch genfit.touch hepmc.touch pythia.touch photos.touch tauola.touch evtgen.touch rave.touch

# directory creation
dirs: $(EXTINCDIR) $(EXTLIBDIR) $(EXTBINDIR)

$(EXTINCDIR):
	@echo "create  $(EXTINCDIR)"
	@mkdir -p $(EXTINCDIR)

$(EXTLIBDIR):
	@echo "create  $(EXTLIBDIR)"
	@mkdir -p $(EXTLIBDIR)

$(EXTBINDIR):
	@echo "create  $(EXTBINDIR)"
	@mkdir -p $(EXTBINDIR)


# dependency for cmake build
cmake: cmake/bin/cmake

# dependency for cmake download
cmake/bootstrap:
	@echo "downloading cmake"
	@$(EXTDIR)/download.sh cmake-2.8.6.tar.gz http://www.cmake.org/files/v2.8/cmake-2.8.6.tar.gz
	@mv cmake-2.8.6 cmake

# cmake build command
cmake/bin/cmake: cmake/bootstrap
	@echo "building cmake"
	@cd cmake && ./bootstrap && make

# cmake clean command
cmake.clean:
	@echo "cleaning cmake"
	@cd cmake && make clean

# cmake touch command
cmake.touch:
	@rm -f cmake/bin/cmake


# dependence for google test build
gtest: $(EXTLIBDIR)/libgtest.a

# google test build command
$(EXTLIBDIR)/libgtest.a:
	@echo "building gtest"
	@mkdir -p $(EXTINCDIR)/gtest/internal
	@cp -a $(EXTDIR)/gtest/include/gtest/*.h $(EXTINCDIR)/gtest/
	@cp -a $(EXTDIR)/gtest/include/gtest/internal/*.h $(EXTINCDIR)/gtest/internal/
	$(CXX) -I$(EXTINCDIR) -Igtest -c gtest/src/gtest-all.cc -o gtest/src/gtest-all.o
	$(CXX) -I$(EXTINCDIR) -Igtest -c gtest/src/gtest_main.cc -o gtest/src/gtest_main.o
	@$(AR) -rv $(EXTLIBDIR)/libgtest.a gtest/src/gtest-all.o gtest/src/gtest_main.o

# google test clean command
gtest.clean:
	@echo "cleaning gtest"
	@rm -rf $(EXTINCDIR)/gtest
	@rm -f gtest/src/*.o
	@rm -f $(EXTLIBDIR)/libgtest.a

# google test touch command
gtest.touch:
	@rm -f $(EXTLIBDIR)/libgtest.a


# dependence for boost build
boost: boost/project-config.jam

# boost build command
boost/project-config.jam:
	@echo "building boost"
	@cd boost && ./bootstrap.sh --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) && ./bjam install -j$(NPROCESSES) $(BOOST_OPTION)

# boost clean command
boost.clean:
	@echo "cleaning boost"
	@cd boost && ./bjam --clean $(BOOST_OPTION)
	@rm -f boost/project-config.jam

# boost touch command
boost.touch:
	@rm -f boost/project-config.jam


# dependency for CLHEP build
clhep: CLHEP/config.log

# dependency for CLHEP download
CLHEP/configure:
	@echo "downloading CLHEP"
	@$(EXTDIR)/download.sh clhep-2.1.1.0.tgz http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.1.0.tgz
	@mv 2.1.1.0/CLHEP .
	@rmdir 2.1.1.0

# CLHEP build command
CLHEP/config.log: CLHEP/configure
	@echo "building CLHEP"
	@cd CLHEP && ./configure --prefix=$(EXTDIRVAR) \
	--includedir=$(EXTINCDIRVAR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) && make -j $(NPROCESSES) && make install

# CLHEP clean command
clhep.clean:
	@echo "cleaning CLHEP"
	@cd CLHEP && make clean
	@rm -f CLHEP/config.log

# CLHEP touch command
clhep.touch:
	@rm -f CLHEP/config.log


# dependency for GEANT4 build
geant4: geant4/build/Makefile

# dependency for GEANT4 download
geant4/CMakeLists.txt:
	@echo "downloading geant4"
	@$(EXTDIR)/download.sh geant4.9.5.p01.tar.gz http://geant4.cern.ch/support/source/geant4.9.5.p01.tar.gz
	@mv geant4.9.5.p01 geant4

# GEANT4 build command
geant4/build/Makefile: cmake/bin/cmake CLHEP/config.log geant4/CMakeLists.txt
	@echo "building geant4"
	@mkdir -p geant4/build
	@-cd geant4 && patch -Np0 < ../geant4.patch
	@cd geant4/build && $(CMAKE) \
	-DCLHEP_ROOT_DIR=$(EXTDIRVAR) -DCLHEP_INCLUDE_DIR=$(EXTINCDIR) -DCLHEP_LIBRARY=$(EXTLIBDIR) \
	-DCMAKE_INSTALL_INCLUDEDIR=$(EXTINCDIR) -DCMAKE_INSTALL_BINDIR=$(EXTBINDIR) \
	-DCMAKE_INSTALL_LIBDIR=$(EXTLIBDIR) -DCMAKE_INSTALL_DATAROOTDIR=$(EXTDIR)/share .. \
	-DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_G3TOG4=ON \
	&& make -j $(NPROCESSES) && make install
	@sed -f geant4.sed $(EXTBINDIR)/geant4-config > geant4-config \
	&& mv geant4-config $(EXTBINDIR)/ && chmod a+x $(EXTBINDIR)/geant4-config
	@sed -f geant4.sed $(EXTBINDIR)/geant4.csh > geant4.csh && mv geant4.csh $(EXTBINDIR)/

# GEANT4 clean command
geant4.clean:
	@echo "cleaning geant4"
	@-cd geant4/build && make clean
	@rm -rf geant4/build share/Geant4-9.5.0 include/Geant4 $(EXTLIBDIR)/libG4*.so $(EXTBINDIR)/geant4*

# GEANT4 touch command
geant4.touch:
	@rm -f geant4/build/Makefile


# dependency for MySql build
mysql: mysql/build/install_manifest.txt

# dependence for MySql download
mysql/CMakeLists.txt:
	@echo "downloading MySql"
	@$(EXTDIR)/download.sh mysql-5.5.22.tar.gz http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.22.tar.gz/from/http://sunsite.informatik.rwth-aachen.de/mysql/
	@mv mysql-5.5.22 mysql

# MySql build command
mysql/build/install_manifest.txt: cmake/bin/cmake mysql/CMakeLists.txt
	@echo "building MySql"
	@mkdir -p mysql/build; cd mysql/build && $(CMAKE) -DCMAKE_INSTALL_PREFIX=../exe .. && make && make install
	@cp -a mysql/exe/lib/* $(EXTLIBDIR)/ # copy the libraries
	@cp -a mysql/exe/bin/* $(EXTBINDIR)/ # copy the binaries
	@mkdir -p $(EXTINCDIR)/mysql && cp -a mysql/exe/include/* $(EXTINCDIR)/mysql/  # copy the include files

# MySql clean command
mysql.clean:
	@echo "cleaning MySql"
	@cd mysql/build && make clean
	@rm -f mysql/build/install_manifest.txt

# MySql touch command
mysql.touch:
	@rm -f mysql/build/install_manifest.txt


# dependency for mysql-connector-c++ build
mysql-connector-c++: mysql-connector-c++/install_manifest.txt

# dependence for mysql-connector-c++ download
mysql-connector-c++/CMakeLists.txt:
	@echo "downloading mysql-connector-c++"
	@$(EXTDIR)/download.sh mysql-connector-c++-1.1.0.tar.gz http://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-1.1.0.tar.gz/from/http://sunsite.informatik.rwth-aachen.de/mysql/
	@mv mysql-connector-c++-1.1.0 mysql-connector-c++

# mysql-connector-c++ build command
mysql-connector-c++/install_manifest.txt: cmake/bin/cmake mysql-connector-c++/CMakeLists.txt
	@echo "building mysql-connector-c++"
	@cd mysql-connector-c++; $(CMAKE) -DCMAKE_INSTALL_PREFIX=exe -DBOOST_ROOT:STRING=$(EXTINCDIR) \
	-DMYSQL_CONFIG_EXECUTABLE:FILEPATH=$(EXTBINDIR)/mysql_config . && $(CMAKE) -L && make && make install
	@cp -a mysql-connector-c++/exe/lib/* $(EXTLIBDIR)/ # copy the libraries
	@mkdir -p $(EXTINCDIR)/mysql && cp -a mysql-connector-c++/exe/include/* $(EXTINCDIR)/mysql/
	@cd $(EXTINCDIR) && ln -sf mysql/cppconn . # link the include files

# mysql-connector-c++ clean command
mysql-connector-c++.clean:
	@echo "cleaning mysql-connector-c++"
	@cd mysql-connector-c++ && make clean

# mysql-connector-c++ touch command
mysql-connector-c++.touch:
	@rm -f mysql-connector-c++/install_manifest.txt


# dependency for PostgreSql build
postgresql: postgresql/config.log	

# dependency for PostgreSql download
postgresql/configure:
	@echo "downloading PostgreSql"
	@$(EXTDIR)/download.sh postgresql-9.1.2.tar.gz http://ftp.postgresql.org/pub/source/v9.1.2/postgresql-9.1.2.tar.gz
	@mv postgresql-9.1.2 postgresql

# PostgreSql build command
postgresql/config.log: postgresql/configure
	@echo "building PostgreSql"
	@cd postgresql && ./configure --prefix=$(EXTDIRVAR) \
	--includedir=$(EXTINCDIR)/pgsql/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) && make && make install

# PostgreSql clean command
postgresql.clean:
	@echo "cleaning PostgreSql"
	@cd postgresql && make clean
	@rm -f postgresql/config.log

# PostgreSql touch command
postgresql.touch:
	@rm -f postgresql/config.log


# dependency for libpqxxl build
libpqxx: libpqxx/config.log

# dependence for libpqxx download
libpqxx/configure:
	@echo "downloading libpqxx"
	@$(EXTDIR)/download.sh libpqxx-4.0.tar.gz http://pqxx.org/download/software/libpqxx/libpqxx-4.0.tar.gz
	@mv libpqxx-4.0 libpqxx

# libpqxx build command
libpqxx/config.log: libpqxx/configure
	@echo "building libpqxx"
	@cd libpqxx && ./configure --enable-shared --prefix=$(EXTDIR) \
	--includedir=$(EXTINCDIR)/ --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) PG_CONFIG=$(EXTBINDIR)/pg_config && make && make install

# libpqxx clean command
libpqxx.clean:
	@echo "cleaning libpqxx"
	@cd libpqxx && make clean
	@rm -f libpqxx/config.log

# libpqxx touch command
libpqxx.touch:
	@rm -f libpqxx/config.log


# dependence for root build
root: root/config/Makefile.config

# root build command
root/config/Makefile.config:
	@echo "building root"
	@-cd root && patch -Np0 < ../root.patch
	@mkdir -p $(ROOTSYS) && cd $(ROOTSYS) && ln -sf ../../../../root/* .
	@cd $(ROOTSYS) && ./configure $(ROOT_OPTION) --enable-gsl-shared --enable-roofit --disable-xrootd && make -j $(NPROCESSES)
	@mkdir -p $(EXTINCDIR)/root
	@cp -a $(ROOTSYS)/include/* $(EXTINCDIR)/root

# root clean command
root.clean:
	@echo "cleaning root"
	@mkdir -p $(ROOTSYS) && cd $(ROOTSYS) && ln -sf ../../../../root/* .
	@cd $(ROOTSYS) && make clean
	@rm -f root/config/Makefile.config

# root touch command
root.touch:
	@rm -f root/config/Makefile.config


# dependence for vgm build
VGM_INCLUDES=$(subst vgm/packages/,include/vgm/,$(subst /include,,$(wildcard vgm/packages/*/include)))
vgm: vgm/tmp/Linux-g++/BaseVGM_common/obj.last $(VGM_INCLUDES)

# vgm build command
vgm/tmp/Linux-g++/BaseVGM_common/obj.last:
	@echo "building VGM"
	@-cd vgm && patch -Np0 < ../vgm.patch
	@cd vgm/packages && PATH=$(PATH):$(EXTBINDIR) VGM_INSTALL=$(EXTDIR)/vgm VGM_SYSTEM=Linux-g++ \
	CLHEP_BASE_DIR=$(EXTDIR) make
	@cp -a vgm/lib/Linux-g++/* $(EXTLIBDIR) 

# vgm include directories
include/vgm/%: vgm/packages/%/include
	@mkdir -p include/vgm
	@cp -a $</$(subst include/vgm/,,$@) include/vgm/ && rm -rf include/vgm/*/.svn include/vgm/*/*/.svn

# vgm clean command
vgm.clean:
	@echo "cleaning VGM"
	@rm -rf vgm/tmp vgm/lib $(EXTLIBDIR)/lib*GM.so include/vgm

# vgm touch command
vgm.touch:
	@rm -f vgm/tmp/Linux-g++/BaseVGM_common/obj.last


# dependence for geant4_vmc build
geant4_vmc: geant4_vmc/include/g4root/TG4RootNavMgr.h

# geant4_vmc build command
geant4_vmc/include/g4root/TG4RootNavMgr.h:
	@echo "building geant4_vmc"
	@cd geant4_vmc && PATH=$(PATH):$(EXTBINDIR) VGM_INSTALL=$(EXTDIR)/vgm USE_VGM=1 \
	CLHEP_BASE_DIR=$(EXTDIR) \
	make CXXOPTS=-fPIC -j $(NPROCESSES)
	@-rm -rf $(EXTINCDIR)/geant4_vmc
	@cp -a geant4_vmc/include $(EXTINCDIR)/geant4_vmc 
	@cp -af geant4_vmc/lib/*/* $(EXTLIBDIR) 

# geant4_vmc clean command
geant4_vmc.clean:
	@echo "cleaning geant4_vmc"
	@cd geant4_vmc && rm -rf tmp lib include

# geant4_vmc touch command
geant4_vmc.touch:
	@rm -f geant4_vmc/include/g4root/TG4RootNavMgr.h


# dependence for genfit build
genfit: include/genfit/RKTrackRep.h

# genfit build command
include/genfit/RKTrackRep.h:
	@echo "building genfit"
	@cd genfit && SCONSFLAGS="" scons
	@cp genfit/lib/* $(EXTLIBDIR)/ # copy the libraries
	@cp -r genfit/include/* $(EXTINCDIR)/ # copy the installed files

# genfit clean command
genfit.clean:
	@echo "cleaning genfit"
	@cd genfit && SCONSFLAGS="" scons -c
	@rm -f include/genfit/RKTrackRep.h

# genfit touch command
genfit.touch:
	@rm -f include/genfit/RKTrackRep.h


# dependency for HepMC build
hepmc: include/HepMC/Version.h

# dependency for HepMC download
hepmc/README:
	@echo "downloading HepMC"
	@$(EXTDIR)/download.sh HepMC-2.06.08.tar.gz http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.08.tar.gz
	@mv HepMC-2.06.08 hepmc

# HepMC build command
include/HepMC/Version.h: hepmc/README
	@echo "building HepMC"
	@mkdir -p build/hepmc && cd build/hepmc && ../../cmake/bin/cmake -DCMAKE_INSTALL_PREFIX=$(EXTDIR)/hepmc -Dmomentum:STRING=GEV -Dlength:STRING=CM $(EXTDIR)/hepmc && make -j $(NPROCESSES) install
	@cp hepmc/lib/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/HepMC && cp hepmc/include/HepMC/* $(EXTINCDIR)/HepMC/

# HepMC clean command
hepmc.clean:
	@echo "cleaning HepMC"
	@cd build/hepmc && make clean
	@rm -rf $(EXTLIBDIR)/libHepMC* $(EXTINCDIR)/HepMC

# HepMC touch command
hepmc.touch:
	@rm -f include/HepMC/Version.h


# dependency for Pythia build
pythia: include/pythia/Pythia.h

# dependency for Pythia download
pythia/configure:
	@echo "downloading Pythia"
	@$(EXTDIR)/download.sh pythia8160.tgz http://home.thep.lu.se/~torbjorn/pythia8/pythia8160.tgz
	@mv pythia8160 pythia

# Pythia build command
include/pythia/Pythia.h: pythia/configure
	@echo "building Pythia"
	@cd pythia && ./configure --enable-shared --with-hepmc=$(EXTDIR)/hepmc $(PYTHIA_OPTION) && make -j $(NPROCESSES)
	@cp pythia/lib/lib* pythia/lib/archive/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/pythia && cp pythia/include/* $(EXTINCDIR)/pythia/
	@mkdir -p share/pythia && cp pythia/xmldoc/* share/pythia/ && chmod u+w share/pythia/*

# Pythia clean command
pythia.clean:
	@echo "cleaning Pythia"
	@cd pythia && make clean
	@rm -rf $(EXTLIBDIR)/libpythia* $(EXTINCDIR)/pythia share/pythia

# Pythia touch command
pythia.touch:
	@rm -f include/pythia/Pythia.h


# dependency for Photos build
photos: include/PHOTOS/Photos.h

# dependency for Photos download
PHOTOS/configure:
	@echo "downloading Photos"
	@$(EXTDIR)/download.sh PHOTOS.3.3.tar.gz http://hibiscus.if.uj.edu.pl/~przedzinski/PHOTOS.3.3/PHOTOS.3.3.tar.gz

# Photos build command
include/PHOTOS/Photos.h: PHOTOS/configure
	@echo "building Photos"
	@-cd PHOTOS && patch -Np0 < ../photos.patch
	@cd PHOTOS && ./configure --with-hepmc=$(EXTDIR)/hepmc && make
	@cp PHOTOS/lib/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/PHOTOS && cp PHOTOS/include/Photos/* $(EXTINCDIR)/PHOTOS/
	@rm -rf include/PHOTOS/Photos; cd include/PHOTOS && ln -sf . Photos

# Photos clean command
photos.clean:
	@echo "cleaning Photos"
	@cd PHOTOS && make clean
	@rm -rf $(EXTLIBDIR)/libPhotos* $(EXTINCDIR)/PHOTOS

# Photos touch command
photos.touch:
	@rm -f include/PHOTOS/Photos.h


# dependency for Tauola build
tauola: include/TAUOLA/Tauola.h

# dependency for Tauola download
TAUOLA/configure:
	@echo "downloading Tauola"
	@$(EXTDIR)/download.sh TAUOLA.1.0.6.tar.gz http://hibiscus.if.uj.edu.pl/~przedzinski/TAUOLA.1.0.6/TAUOLA.1.0.6.tar.gz

# Tauola build command
include/TAUOLA/Tauola.h: TAUOLA/configure
	@echo "building Tauola"
	@cd TAUOLA && ./configure --with-hepmc=$(EXTDIR)/hepmc && make
	@cp TAUOLA/lib/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/TAUOLA && cp TAUOLA/include/Tauola/*.h $(EXTINCDIR)/TAUOLA/
	@cd TAUOLA/include && ln -sf Tauola/*.h .

# Tauola clean command
tauola.clean:
	@echo "cleaning Tauola"
	@cd TAUOLA && make clean
	@rm -rf $(EXTLIBDIR)/libTauola* $(EXTINCDIR)/TAUOLA

# Tauola touch command
tauola.touch:
	@rm -f include/TAUOLA/Tauola.h


# dependency for EvtGen build
evtgen: evtgen/config.mk

# EvtGen build command
evtgen/config.mk:
	@echo "building EvtGen"
	@cd evtgen && ./configure --hepmcdir=$(EXTDIR)/hepmc --pythiadir=$(EXTDIR)/pythia --photosdir=$(EXTDIR)/PHOTOS --tauoladir=$(EXTDIR)/TAUOLA $(EVTGEN_OPTION) && make -j $(NPROCESSES)
	@cp evtgen/lib/lib* evtgen/lib/archive/* $(EXTLIBDIR)/
	@mkdir -p $(EXTINCDIR)/evtgen && cp -r evtgen/EvtGen* $(EXTINCDIR)/evtgen/ && rm -rf $(EXTINCDIR)/evtgen/*/.svn
	@mkdir -p share/evtgen && cp evtgen/evt.pdl share/evtgen/ && cp evtgen/DECAY_2010.DEC share/evtgen/DECAY.DEC

# EvtGen clean command
evtgen.clean:
	@echo "cleaning EvtGen"
	@cd evtgen && make clean
	@rm -rf evtgen/config.mk $(EXTLIBDIR)/libEvtGen* $(EXTINCDIR)/evtgen share/evtgen

# EvtGen touch command
evtgen.touch:
	@rm -f evtgen/config.mk


# dependency for rave build
rave: include/rave/Vertex.h

# rave download command
rave/configure:
	@echo "downloading rave"
	@$(EXTDIR)/download.sh rave-0.6.7.tar.gz http://www.hepforge.org/archive/rave/rave-0.6.7.tar.gz
	@mv rave-0.6.7 rave
	@rm -rf rave/src/boost rave/src/ROOT/*/Math
	@cd rave/src && ln -s $(EXTINCDIR)/boost boost
	@cd rave/src/ROOT/genvector && ln -s $(EXTINCDIR)/root/Math Math
	@cd rave/src/ROOT/mathcore && ln -s $(EXTINCDIR)/root/Math Math
	@cd rave/src/ROOT/smatrix && ln -s $(EXTINCDIR)/root/Math Math

# rave configure command
rave/config.status: rave/configure
	@cd rave && CLHEPPATH=$(EXTDIR) CLHEPLIBPATH=$(EXTLIBDIR) CLHEP_VECTORLIBPATH=$(EXTLIBDIR) CLHEP_MATRIXLIBPATH=$(EXTLIBDIR) ./configure --disable-java --prefix=$(EXTDIR) --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) --with-clhep=$(EXTDIR)

# rave build command
include/rave/Vertex.h: rave/config.status
	@echo "building rave"
	@cd rave && make -j $(NPROCESSES) && make install

# rave clean command
rave.clean:
	@echo "cleaning rave"
	@cd rave && make uninstall && make clean
	@rm -f rave/config.status

# rave touch command
rave.touch:
	@rm -f rave/config.status
