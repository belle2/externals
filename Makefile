
# all target
all: root boost astyle

# clean up target
clean:
	@cd root; make clean
	@cd boost; ./bjam --clean
	@cd astyle/build/gcc; make clean

# dependence for root build
root: root/config/Makefile.config

# root build command
root/config/Makefile.config:
	@cd root; ./configure; make

# dependence for boost build
boost: boost/project-config.jam

# boost build command
boost/project-config.jam:
	@cd boost; ./bootstrap.sh; ./bjam

# dependence for astyle build
astyle: astyle/build/gcc/bin/astyle

# astyle build command
astyle/build/gcc/bin/astyle:
	@cd astyle/build/gcc; make
	@-mkdir -p $(BINDIR)
	@cp astyle/build/gcc/bin/astyle $(BINDIR)