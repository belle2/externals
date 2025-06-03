# shut up sub makes
MAKEFLAGS+=-s

# make sure this file is not executed in parallel
.NOTPARALLEL:

# downloading now checks the sha256sum of the downloaded files. If you want to
# skip this (to upgrade packages or if sha256sum is not installed on your
# system) then comment out the following line
# export BELLE2_EXTERNALS_IGNORE_CHECKSUM=1

# check if BELLE2_EXTERNALS_OPTION is what we expect it to be
ifeq (,$(strip $(filter $(BELLE2_EXTERNALS_OPTION),opt debug intel)))
    $(error Unknown externals build option. Please source the b2setup script.)
endif
# and also BELLE2_ARCH is important
ifeq (,$(BELLE2_ARCH))
    $(error Architecture not defined. Please source the b2setup script.)
endif

# in case we compile on EL7, we need additional packages
EL7_PACKAGES :=
ifeq ($(shell b2install-print-os),el 7)
	EL7_PACKAGES := openssl libmd libbsd
endif

# base packages we don't want to compile in debug mode anyway so we compile
# them with option common
COMMON_PACKAGES:=pkg-config-wrapper ninja zlib bzip2 xz lz4 gmp mpfr mpc isl gcc binutils $(EL7_PACKAGES) \
    curl git libxml2 libxslt cmake sqlite hdf5 libffi python python-packages gdb boost gtest libonnxruntime eigen astyle \
    madgraph zeromq cppzmq jemalloc gsl libuuid fftw3 yaml-cpp epics rclone git-lfs \
    Vc VecCore VecGeom clhep geant4 postgresql neurobayes xrootd davix nlohmann_json tbb root fastbdt vgm rave \
    MillepedeII hepmc pythia photos tauola evtgen cry \
    flc belle_legacy fann hammer pandoc fastjet roounfold functionalplus frugally-deep \
    whizard

COMMON_OPTIONAL:=clang cppcheck valgrind doxygen

# external packages which we compile in opt and debug mode ... but for now we don't
# do this anymore so keep an empty list of packages
PACKAGES:=

# check if any of the big "do all" targets is supplied on the command line
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

# define target "optionals" for building all optional packages
optionals: $(COMMON_OPTIONAL) ;

# make the directories for all options we need
dirs:
	@$(foreach option,common $(DIRTARGETS),$(MAKE) -f Makefile.targets \
	    BELLE2_EXTERNALS_OPTION=$(option) dirs &&) true

# common needs to compile the common packages. And we need directories first
common: dirs ;
	@$(MAKE) -f Makefile.targets $(COMMON_PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# compile specifically in given mode
opt debug intel: common ;
	@$(MAKE) -f Makefile.targets $(PACKAGES) relocatable_fixes BELLE2_EXTERNALS_OPTION=$@

# let touch, src and clean only run on the non-common stuff to avoid expensive
# recompilation of common packages by mistake.
touch: ;
	@$(MAKE) -f Makefile.targets $(foreach package,$(PACKAGES),$(package).touch)
src: dirs ;
	@$(MAKE) -f Makefile.targets $(foreach package,$(COMMON_PACKAGES) $(PACKAGES),$(package).src) ;
clean: ;
	@$(MAKE) -f Makefile.targets $(foreach package,$(PACKAGES),$(package).clean) ;

# make all targets and src targets depend on dirs, otherwise some symlinks
# might not be created, e.g. when creating a new checkout and running make gcc
$(COMMON_PACKAGES) $(foreach package,$(COMMON_PACKAGES) $(COMMON_OPTIONAL),$(package).src): dirs
$(PACKAGES) $(foreach package,$(PACKAGES),$(package).src): dirs

# so far so good, just running make should now do the correct thing but we want
# to be able to call make gcc and he should do the correct thing. So every
# other target we just pass to the sub make but we override the
# BELLE2_EXTERNALS_OPTION for the $(COMMON_PACKAGES) targets
$(COMMON_PACKAGES) $(COMMON_OPTIONAL): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES) $(COMMON_OPTIONAL),$(package).touch): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES) $(COMMON_OPTIONAL),$(package).src): override BELLE2_EXTERNALS_OPTION=common
$(foreach package,$(COMMON_PACKAGES) $(COMMON_OPTIONAL),$(package).clean): override BELLE2_EXTERNALS_OPTION=common

# all targets not otherwise defined are executed with the option they got by
# calling make on the targets file. Specifying the option here is not
# necessary but helps with debugging
%:
	@$(MAKE) -f Makefile.targets $@ relocatable_fixes BELLE2_EXTERNALS_OPTION=$(BELLE2_EXTERNALS_OPTION)

# make new checksum file
checksum:
	sha256sum -b $(sort $(foreach ext,zip bz2 gz tgz xz,$(wildcard src/*.$(ext)))) > sha256sum.txt

sort_checksum:
	LC_ALL=C sort -u -f -k 2 -o sha256sum.txt sha256sum.txt

# minimal rules to get fixstyle running: we just need python3 with all packages
# and astyle and we just use the system compiler
fixstyle:
	@$(MAKE) -f Makefile.targets dirs python python-packages astyle relocatable_fixes BELLE2_EXTERNALS_OPTION=common
