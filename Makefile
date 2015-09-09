# shut up sub makes
MAKEFLAGS+=-s

# downloading now checks the sha256sum of the downloaded files. If you want to
# skip this (to upgrade packages or if sha256sum is not installed on your
# system) then comment out the following line
# export BELLE2_EXTERNALS_IGNORE_CHECKSUM=1

# check if BELLE2_EXTERNALS_OPTION is what we expect it to be
ifeq (,$(strip $(filter $(BELLE2_EXTERNALS_OPTION),opt debug intel)))
    $(error Unknown externals build option. Please source the setup_belle2 script.)
endif
# and also BELLE2_ARCH is important
ifeq (,$(BELLE2_ARCH))
    $(error Architecture not defined. Please source the setup_belle2 script.)
endif

# base packages we don't want to compile in debug mode anyway so we compile
# them with option common
COMMON_PACKAGES:=gcc binutils zlib bzip2 python gdb libxml2 cmake boost gtest \
    pkg-config-wrapper eigen astyle scons

# external packages
PACKAGES:=clhep geant4 postgresql libpqxx neurobayes xrootd root nbplugin fastbdt \
    vgm rave MillepedeII hepmc pythia photos tauola evtgen phokhara madgraph cry \
    flc vc nsm2 belle_legacy curl fann

# python packages to be included with the python package
export PYTHON_PACKAGES:=ipython==4.0.0 numpy==1.9.2 pep8==1.5.7 autopep8==1.1

# as default, compile the currently set option.
# The semi-colon is important to make sure that these empty requisite targets
# are not passed to sub make with the catch all pattern rule below
all: $(BELLE2_EXTERNALS_OPTION) ;

# common needs to compile the common packages. And we need directories first
common:
	@$(MAKE) -f Makefile.targets dirs $(COMMON_PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# compile specifically in given mode
opt debug intel: common
	@$(MAKE) -f Makefile.targets dirs $(PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# let touch, src and clean only run on the non-common stuff to avoid expensive
# recompilation of common packages by mistake.
touch: $(foreach package,$(PACKAGES),$(package).touch) ;
src: $(foreach package,$(COMMON_PACKAGES) $(PACKAGES),$(package).src) ;
clean: $(foreach package,$(PACKAGES),$(package).clean) ;

# so far so good, just running make should now do the correct thing but we want
# to be able to call make gcc and he should do the correct thing. So every
# other target we just pass to the sub make but we override the
# BELLE2_EXTERNALS_OPTION for the $(COMMON_PACKAGES) targets
$(COMMON_PACKAGES): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).touch): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).src): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).clean): override BELLE2_EXTERNALS_OPTION=common

# all targets not otherwise defined re executed with the option they got by
# calling make on the targets file.  Specifying the option here is not
# necessary but helps with debugging
%:
	@$(MAKE) -f Makefile.targets $@ BELLE2_EXTERNALS_OPTION=$(BELLE2_EXTERNALS_OPTION)

# make new checksum file
checksum:
	sha256sum -b $(sort $(foreach ext,zip bz2 gz tgz,$(wildcard src/*.$(ext)))) > sha256sum.txt
