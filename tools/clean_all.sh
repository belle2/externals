#!/bin/sh
cd `dirname $0`
cd ..
rm -fr build include share Linux_x86_64
find src/* -maxdepth 0 -type d ! \( -name python-packages -o -name sphinx-argparse \) -exec rm -fr {} +
