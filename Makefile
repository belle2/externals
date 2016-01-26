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
COMMON_PACKAGES:=pkg-config-wrapper gcc binutils zlib bzip2 libxml2 libxslt \
    python gdb cmake boost gtest eigen astyle scons madgraph

# external packages
PACKAGES:=clhep geant4 postgresql libpqxx neurobayes xrootd root nbplugin fastbdt \
    vgm rave MillepedeII hepmc pythia photos tauola evtgen phokhara cry exrootanalysis \
    flc vc nsm2 belle_legacy curl fann

# python packages to be included with the python package. This list is created
# from pip3 freeze to include all dependencies. In addition to pip3 freeze,
# setuptools-scm is needed to install some packages. Normally pip installs it
# on the fly and removes it later but this doesn't work if internet connection
# is off.  So to be able to install without internet after make src we install
# it manually
export PYTHON_PACKAGES:=autopep8==1.2.1a0 CherryPy==4.0.0 decorator==4.0.4 ipython==4.0.0 \
    ipython-genutils==0.1.0 lxml==3.4.4 numpy==1.9.2 path.py==8.1.1 pep8==1.6.3a0 \
    pexpect==3.3 pickleshare==0.5 requests==2.7.0 simplegeneric==0.8.1 setuptools-scm==1.7.0  \
    traitlets==4.0.0

# extern archives we cannot get from pypi. Or in the case of simplegeneric,
# there doesn't seem to be a .tar.gz so we need to specifiy the archive name
# manually. Form is package==version?url[?archive_name]
export PYTHON_EXTERN_ARCHIVES:=\
    autopep8==1.2.1a0?https://github.com/hhatto/autopep8/tarball/7244270035 \
    pep8==1.6.3a0?https://github.com/PyCQA/pep8/tarball/b1bde9f2bb \
    simplegeneric==0.8.1?https://pypi.python.org/packages/source/s/simplegeneric/simplegeneric-0.8.1.zip?simplegeneric-0.8.1.zip

# check if any of the big "do all" targets is supplied on the commmand line
DIRTARGETS=$(strip $(filter opt debug intel,$(MAKECMDGOALS)))
# if so, dirs will create the targets for all specified targets, otherwise just
# for common and the current option
ifeq (,$(DIRTARGETS))
    DIRTARGETS=$(BELLE2_EXTERNALS_OPTION)
endif

# as default, compile the currently set option.
# The semi-colon is important to make sure that these empty requisite targets
# are not passed to sub make with the catch all pattern rule below
all: $(BELLE2_EXTERNALS_OPTION) ;

# make the directories for all options we need
dirs:
	@$(foreach option,common $(DIRTARGETS),$(MAKE) -f Makefile.targets \
	    BELLE2_EXTERNALS_OPTION=$(option) dirs &&) true

# common needs to compile the common packages. And we need directories first
common: dirs
	@$(MAKE) -f Makefile.targets $(COMMON_PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# compile specifically in given mode
opt debug intel: common
	@$(MAKE) -f Makefile.targets $(PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# let touch, src and clean only run on the non-common stuff to avoid expensive
# recompilation of common packages by mistake.
touch: $(foreach package,$(PACKAGES),$(package).touch) ;
src: dirs $(foreach package,$(COMMON_PACKAGES) $(PACKAGES),$(package).src) ;
clean: $(foreach package,$(PACKAGES),$(package).clean) ;

# make all targets and src targets depend on dirs, otherwise some symlinks
# might not be created, e.g. when creating a new checkout and running make gcc
$(COMMON_PACKAGES) $(foreach package,$(COMMON_PACKAGES),$(package).src): dirs
$(PACKAGES) $(foreach package,$(PACKAGES),$(package).src): dirs

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

# minimal rules to get fixstyle running: we just need python3 with pep8 +
# autopep8 and astyle and we just use the system compiler
fixstyle: override PYTHON_PACKAGES:=$(filter pep8% autopep8%, $(PYTHON_PACKAGES))
fixstyle:
	@$(MAKE) -f Makefile.targets dirs python astyle relocatable_fixes BELLE2_EXTERNALS_OPTION=common
