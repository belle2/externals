# shut up sub makes
MAKEFLAGS+=-s

# base packages we don't want to compile in debug mode anyway so we compile
# them with option common
COMMON_PACKAGES:=gcc binutils bzip2 python gdb libxml2 cmake boost gtest \
   pkg-config eigen

# external packages
PACKAGES:=clhep geant4 postgresql libpqxx neurobayes xrootd root nbplugin fastbdt \
    vgm rave MillepedeII hepmc pythia photos tauola evtgen phokhara madgraph cry \
    flc vc nsm2 belle_legacy curl relocatable_fixes

# python packages to be included with the python package
export PYTHON_PACKAGES:=ipython==4.0.0 numpy==1.9.2 pep8==1.5.7 autopep8==1.1

# override option for common targets
$(COMMON_PACKAGES): BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).touch): BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).src): BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES),$(package).clean): BELLE2_EXTERNALS_OPTION=common

# supplying two BELLE2_EXTERNAL_OPTION targets (opt, debug, intel) will not
# work, only the first one will be made. Soo, let's check for that and throw an
# error
OPTION_GOALS:=$(filter $(MAKECMDGOALS),opt intel debug)
OPTION_GOALS_COUNT=$(shell python -c 'if len("$(OPTION_GOALS)".strip().split())>1: print("many")')
ifneq (,$(OPTION_GOALS_COUNT))
    $(error Only one of opt, debug, intel can be supplied at once)
endif

# as default, compile all, first make directories, then common, then fix
# relocatable issues.  
# The semi-colon is important to make sure that these empty requisite targets
# are not passed to sub make with the catch all pattern rule below
all: common $(PACKAGES) relocatable_fixes ; 
# common needs to compile the common packages. And we need directories first
common: dirs $(COMMON_PACKAGES) ;

# compile specifically in opt
opt: BELLE2_EXTERNALS_OPTION=opt
opt: all ;

# compile specifically in debug
debug: BELLE2_EXTERNALS_OPTION=debug
debug: all ;

# compile specifically in intel
intel: BELLE2_EXTERNALS_OPTION=intel
intel: all ;

touch: $(foreach package,$(PACKAGES),$(package).touch) ;
src: $(foreach package,$(PACKAGES),$(package).src) ;
clean: $(foreach package,$(PACKAGES),$(package).clean) ;

# targets we ant to execute for both options
dirs relocatable_fixes:
	@$(MAKE) -f Makefile.targets $@ BELLE2_EXTERNALS_OPTION=common
	@$(MAKE) -f Makefile.targets $@ BELLE2_EXTERNALS_OPTION=$(BELLE2_EXTERNALS_OPTION)

# all else get executed with the option they got. Specifying the option here is
# not necessary but helps with debugging
%:
	@$(MAKE) -f Makefile.targets $@ BELLE2_EXTERNALS_OPTION=$(BELLE2_EXTERNALS_OPTION)
