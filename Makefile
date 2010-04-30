
# define directories
export EXTDIR := $(MAKEDIR)/externals
export EXTINCDIR := $(EXTDIR)/include
export EXTLIBDIR := $(EXTDIR)/lib/$(ARCH)
export EXTBINDIR := $(EXTDIR)/bin/$(ARCH)


# all target
all: root boost astyle clhep geant4 libxml

# clean up target
clean:
	@cd root; make clean
	@cd boost; ./bjam --clean
	@cd astyle/build/gcc; make clean

# directory creation
$(EXTINCDIR):
	@echo "create  $(EXTINCDIR)"
	@mkdir -p $(EXTINCDIR)

$(EXTLIBDIR):
	@echo "create  $(EXTLIBDIR)"
	@mkdir -p $(EXTLIBDIR)

$(EXTBINDIR):
	@echo "create  $(EXTBINDIR)"
	@mkdir -p $(EXTBINDIR)


# dependence for root build
root: root/config/Makefile.config

# root build command
root/config/Makefile.config:
	@cd root; ./configure --incdir=$(EXTINCDIR)/root --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR) \
	--prefix=$(EXTDIR) --etcdir=$(EXTDIR)/share/etc --enable-gsl-shared; make; make install

# dependence for boost build
boost: boost/project-config.jam

# boost build command
boost/project-config.jam:
	@cd boost; ./bootstrap.sh --includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR); ./bjam install

# dependence for astyle build
astyle: astyle/build/gcc/bin/astyle

# astyle build command
astyle/build/gcc/bin/astyle: $(EXTBINDIR)
	@cd astyle/build/gcc; make
	@cp astyle/build/gcc/bin/astyle $(EXTBINDIR)

# dependence for CLHEP build
clhep: CLHEP/config.log

# dependence for CLHEP download
CLHEP/configure:
	@wget -O - http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.0.4.5.tgz | tar xz
	@mv 2.0.4.5/CLHEP .
	@rmdir 2.0.4.5

# CLHEP build command
CLHEP/config.log: CLHEP/configure
	@cd CLHEP; ./configure --prefix=$(EXTDIR) \
	--includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR); make; make install

# dependence for GEANT4 build
geant4: geant4/env.sh

# dependence for GEANT4 download
geant4/Configure:
	@wget -O - http://geant4.cern.ch/support/source/geant4.9.3.tar.gz | tar xz
	@mv geant4.9.3 geant4
	@mkdir -p share/geant4/data
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4EMLOW.6.9.tar.gz | tar xz
	@cd share/geant4/data; wget -O - http://geant4.cern.ch/support/source/G4NDL.3.13.tar.gz | tar xz

# GEANT4 build command
geant4/env.sh: CLHEP/config.log geant4/Configure
	@cd geant4; ./Configure -build -d -e -s -D d_portable=y -D g4includes_flag=y \
	-D g4data=$(EXTDIR)/share/geant4/data -D g4clhep_base_dir=$(EXTDIR) \
	-D g4clhep_include_dir=$(EXTINCDIR) -D g4clhep_lib_dir=$(EXTLIBDIR)
	@-rm -rf geant4/env.*sh; cd geant4; ./Configure
	@cd geant4; . ./env.sh; cd source; G4INCLUDE=$(EXTDIR)/include/geant4 make includes dependencies=""
	@cp -a $(EXTDIR)/geant4/lib/*/* $(EXTLIBDIR)

# dependence for libxml build
libxml: libxml/config.log

# dependence for libxml download
libxml/configure:
	@wget -O - ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.6.tar.gz | tar xz
	@mv libxml2-2.7.6 libxml

# libxml build command
libxml/config.log: libxml/configure
	@cd libxml; ./configure --datarootdir=$(EXTDIR)/share \
	--includedir=$(EXTINCDIR) --libdir=$(EXTLIBDIR) --bindir=$(EXTBINDIR); make; make install
	@mv -f $(EXTINCDIR)/libxml2/libxml $(EXTINCDIR)/
	@rmdir $(EXTINCDIR)/libxml2
