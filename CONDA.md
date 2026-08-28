Build Instructions for Conda Externals
======================================

Set up the pixi environment
---------------------------

Make sure `pixi` is installed:

    command -v pixi >/dev/null 2>&1 || wget -qO- https://pixi.sh/install.sh | sh

Source `b2setup` from the tools, and then run:

    b2install-externals --conda-externals

The following packages are built locally:
- fann2
- neurobayescppinterface
- belle_legacy

Create symlinks
---------------

Some symlinks are needed for compatibility with legacy code:

    ln -s $CONDA_PREFIX/lib/libboost_python312.so $CONDA_PREFIX/lib/libboost_python.so
    ln -s $CONDA_PREFIX/lib/libncurses.so $CONDA_PREFIX/lib/libcurses.so
    ln -s $CONDA_PREFIX/include $CONDA_PREFIX/include/root
    ln -s $CONDA_PREFIX/include/onnxruntime/core/session $CONDA_PREFIX/include/onnxruntime/core/session/onnxruntime

This will set up the pixi environment required to build basf2.
