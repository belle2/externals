
# define directories
export BELLE2_EXTERNALS_DIR := $(shell pwd)
export EXTDIR := $(BELLE2_EXTERNALS_DIR)
export EXTINCDIR := $(EXTDIR)/include
ifdef BELLE2_EXTERNALS_SUBDIR
  export EXTLIBDIR := $(EXTDIR)/lib/$(BELLE2_EXTERNALS_SUBDIR)
  export EXTBINDIR := $(EXTDIR)/bin/$(BELLE2_EXTERNALS_SUBDIR)
  EXTERNALS_OPTION := $(BELLE2_EXTERNALS_OPTION)
else
  export EXTLIBDIR := $(EXTDIR)/lib/$(BELLE2_SUBDIR)
  export EXTBINDIR := $(EXTDIR)/bin/$(BELLE2_SUBDIR)
  EXTERNALS_OPTION := $(BELLE2_OPTION)
endif

export EXTDIRVAR := \$${BELLE2_EXTERNALS_DIR}
export EXTINCDIRVAR := $(EXTDIRVAR)/include
export EXTLIBDIRVAR := $(EXTDIRVAR)/lib/\$${BELLE2_EXTERNALS_SUBDIR:-\$${BELLE2_SUBDIR}}
export EXTBINDIRVAR := $(EXTDIRVAR)/bin/\$${BELLE2_EXTERNALS_SUBDIR:-\$${BELLE2_SUBDIR}}

export ROOTSYS := $(EXTDIR)/root
export GENFIT := $(EXTDIRVAR)/genfit
export PATH := $(ROOTSYS)/bin:$(PATH)
export LD_LIBRARY_PATH := $(ROOTSYS)/lib:$(LD_LIBRARY_PATH)

# set number of parallel jobs to the number of processors
NPROCESSES=$(shell grep processor /proc/cpuinfo| wc -l)

# set debug or optimization options 
ifeq ($(EXTERNALS_OPTION),debug)
  export BOOST_OPTION=variant=debug
  export CXXFLAGS=-g
  export GEANT4_OPTION=-D g4debug=y
  export ROOT_OPTION=
  export ROOTBUILD=debug
  export EVTGEN_OPTION=--enable-debug
else 
ifeq ($(EXTERNALS_OPTION),opt)
  export BOOST_OPTION=variant=release
  export CXXFLAGS=-O3
  export GEANT4_OPTION=-D g4debug=n
  export ROOT_OPTION=
  export ROOTBUILD=
  export EVTGEN_OPTION=
else # intel
  export CC=icc
  export CXX=icpc
  export CXXCPP=icc -E
  export FC=ifort
  export AR=xiar
  export LD=xild
  export BOOST_OPTION=variant=release toolset=intel
  export GEANT4_OPTION=-D g4debug=n -D g4compiler=icc
  export ROOT_OPTION=linuxicc
  ifeq ($(shell uname -m),x86_64)
    export ROOT_OPTION=linuxx8664icc
  endif
  export ROOTBUILD=
  export EVTGEN_OPTION=
endif
endif

# check for graphics packages
GL_XMU_EXISTS=$(shell pkg-config --exists gl xmu; echo $$?)
ifeq ($(GL_XMU_EXISTS),0)
  GEANT4_OPTION+= -D g4vis_build_openglx_driver='y' -D g4vis_use_openglx='y'
endif


# all target
all: dirs gtest boost clhep geant4 root vgm geant4_vmc genfit evtgen

# clean up target
clean: gtest.clean boost.clean clhep.clean geant4.clean root.clean vgm.clean geant4_vmc.clean genfit.clean evtgen.clean

# remove only target files
touch: gtest.touch boost.touch clhep.touch geant4.touch root.touch vgm.touch geant4_vmc.touch genfit.touch evtgen.touch

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
	@cd boost; ./bootstrap.sh --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR); ./bjam install -j$(NPROCESSES) $(BOOST_OPTION)

# boost clean command
boost.clean:
	@echo "cleaning boost"
	@cd boost; ./bjam --clean $(BOOST_OPTION)
	@rm -f boost/project-config.jam

# boost touch command
boost.touch:
	@rm -f boost/project-config.jam


# dependence for CLHEP build
clhep: CLHEP/config.log

# dependence for CLHEP download
CLHEP/configure:
	@echo "downloading CLHEP"
	@wget -O - http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.0.1.tgz | tar xz
	@mv 2.1.0.1/CLHEP .
	@rmdir 2.1.0.1

# CLHEP build command
CLHEP/config.log: CLHEP/configure
	@echo "building CLHEP"
	@cd CLHEP; ./configure --prefix=$(EXTDIRVAR) \
	--includedir=$(EXTINCDIRVAR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR); make -j $(NPROCESSES); make install

# CLHEP clean command
clhep.clean:
	@echo "cleaning CLHEP"
	@cd CLHEP; make clean
	@rm -f CLHEP/config.log

# CLHEP touch command
clhep.touch:
	@rm -f CLHEP/config.log


# dependence for GEANT4 build
geant4: geant4/env.sh

# dependence for GEANT4 download
geant4/Configure:
	@echo "downloading geant4"
	@wget -O - http://geant4.cern.ch/support/source/geant4.9.4.p01.tar.gz | tar xz
	@mv geant4.9.4.p01 geant4
	@mkdir -p share/geant4/data
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4EMLOW.6.19.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4NDL.3.14.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4PhotonEvaporation.2.1.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4RadioactiveDecay.3.3.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4NEUTRONXS.1.0.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4PII.1.2.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz | tar xz

# GEANT4 build command
geant4/env.sh: CLHEP/config.log geant4/Configure
	@echo "building geant4"
	@cd geant4; sed 's;test "x$$g4query_conf" != "xyes";false;g' Configure > Configure.new; \
	mv Configure.new Configure; chmod a+x Configure
	@-rm geant4/.config/bin/Linux-g++/config.sh
	@cd geant4; ./Configure -build -d -e -s -D d_portable='define' -D g4includes_flag=y \
	-D g4granular='y' -D g4wlib_build_g3tog4='y' -D g4wlib_use_g3tog4='y' \
	$(GEANT4_OPTION) -D g4data=$(EXTDIRVAR)/share/geant4/data -D g4clhep_base_dir=$(EXTDIR) \
	-D g4clhep_include_dir=$(EXTINCDIRVAR) -D g4clhep_lib_dir=$(EXTLIBDIRVAR) \
	-D g4install=$(EXTDIRVAR)/geant4 -D g4make_jobs='$(NPROCESSES)'
	@-rm -rf geant4/env.*sh; cd geant4; ./Configure $(GEANT4_OPTION)
	@sed -f geant4.sed -e "s;${BELLE2_EXTERNALS_DIR};\${BELLE2_EXTERNALS_DIR};g" geant4/env.sh > env.new; mv env.new geant4/env.sh
	@sed -f geant4.sed -e "s;${BELLE2_EXTERNALS_DIR};\${BELLE2_EXTERNALS_DIR};g" geant4/env.csh > env.new; mv env.new geant4/env.csh
	@bash -c ". geant4/env.sh; cd geant4/source; G4INCLUDE=$(EXTDIRVAR)/include/geant4 make includes dependencies=\"\""
	@cp -a $(EXTDIR)/geant4/lib/*/* $(EXTLIBDIR)

# GEANT4 clean command
geant4.clean:
	@echo "cleaning geant4"
	@cd geant4; rm -rf tmp lib bin .config
	@rm -f geant4/env.sh geant4/env.csh

# GEANT4 touch command
geant4.touch:
	@rm -f geant4/env.sh


# dependence for root build
root: root/config/Makefile.config

# root build command
root/config/Makefile.config:
	@echo "building root"
	@-cd root; patch -Np0 < ../root.patch
	@cd root; ./configure $(ROOT_OPTION) --enable-gsl-shared --enable-roofit; make -j $(NPROCESSES)
	@mkdir -p $(EXTINCDIR)/root
	@cp -a $(EXTDIR)/root/include/* $(EXTINCDIR)/root
	@cp -a $(EXTDIR)/root/lib/* $(EXTLIBDIR)

# root clean command
root.clean:
	@echo "cleaning root"
	@cd root; make clean
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
	@-cd vgm; patch -Np0 < ../vgm.patch
	@cd vgm/packages; VGM_INSTALL=$(EXTDIR)/vgm VGM_SYSTEM=Linux-g++ \
	CLHEP_BASE_DIR=$(EXTDIR) G4INSTALL=$(EXTDIR)/geant4 ROOTSYS=$(EXTDIR)/root CPPFLAGS=-I$(EXTINCDIR)/geant4 \
	make
	@cp -a vgm/lib/Linux-g++/* $(EXTLIBDIR) 

# vgm include directories
include/vgm/%: vgm/packages/%/include
	@mkdir -p include/vgm
	@cp -a $</$(subst include/vgm/,,$@) include/vgm/

# vgm clean command
vgm.clean:
	@echo "cleaning VGM"
	@cd vgm; rm -rf tmp lib

# vgm touch command
vgm.touch:
	@rm -f vgm/tmp/Linux-g++/BaseVGM_common/obj.last


# dependence for geant4_vmc build
geant4_vmc: geant4_vmc/include/g4root/TG4RootNavMgr.h

# geant4_vmc build command
geant4_vmc/include/g4root/TG4RootNavMgr.h:
	@echo "building geant4_vmc"
	@cd geant4_vmc; VGM_INSTALL=$(EXTDIR)/vgm USE_VGM=1 ROOTSYS=$(EXTDIR)/root \
	CLHEP_BASE_DIR=$(EXTDIR) G4INSTALL=$(EXTDIR)/geant4 G4INCLUDE=$(EXTDIR)/geant4/include \
	make CXXOPTS=-fPIC -j $(NPROCESSES)
	@-rm -rf $(EXTINCDIR)/geant4_vmc
	@cp -a geant4_vmc/include $(EXTINCDIR)/geant4_vmc 
	@cp -af geant4_vmc/lib/*/* $(EXTLIBDIR) 

# geant4_vmc clean command
geant4_vmc.clean:
	@echo "cleaning geant4_vmc"
	@cd geant4_vmc; rm -rf tmp lib include

# geant4_vmc touch command
geant4_vmc.touch:
	@rm -f geant4_vmc/include/g4root/TG4RootNavMgr.h


# dependence for genfit build
genfit: include/genfit/RKTrackRep.h

# genfit build command
include/genfit/RKTrackRep.h:
	@echo "building genfit"
	@cd genfit; SCONSFLAGS="" scons
	@cp genfit/lib/* $(EXTLIBDIR)/ # copy the libraries
	@cp -r genfit/include/* $(EXTINCDIR)/ # copy the installed files

# genfit clean command
genfit.clean:
	@echo "cleaning genfit"
	@cd genfit; SCONSFLAGS="" scons -c
	@rm -f include/genfit/RKTrackRep.h

# genfit touch command
genfit.touch:
	@rm -f include/genfit/RKTrackRep.h


# dependence for EvtGen build
evtgen: evtgen/config.mk

# dependence for EvtGen download
evtgen/configure:
	@echo "downloading EvtGen"
	@wget -O - http://service-spi.web.cern.ch/service-spi/external/MCGenerators/distribution/evtgenlhc-9.1-src.tgz | tar xz
	@mv evtgenlhc/9.1 evtgen
	@cd evtgen; patch -Np0 < ../evtgen.patch
	@rmdir evtgenlhc

# EvtGen build command
evtgen/config.mk: evtgen/configure
	@echo "building EvtGen"
	@cd evtgen; ./configure --lcgplatform=x86_64-slc5-gcc43-opt $(EVTGEN_OPTION); make
	@cd evtgen; cp lib/* $(EXTLIBDIR)/; mkdir $(EXTINCDIR)/evtgen; cp -r EvtGen* $(EXTINCDIR)/evtgen

# EvtGen clean command
evtgen.clean:
	@echo "cleaning EvtGen"
	@cd evtgen; make clean
	@rm -f evtgen/config.mk

# EvtGen touch command
evtgen.touch:
	@rm -f evtgen/config.mk
