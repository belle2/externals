#!/bin/bash
NAME=$1
FILE=${2:-$1}
rm -fr src/${FILE}* src/${NAME}
make ${NAME}.src BELLE2_EXTERNALS_IGNORE_CHECKSUM=1
cp sha256sum.txt sha256sum.bak
grep -v "src/${FILE}" sha256sum.bak > sha256sum.txt
sha256sum -b src/${FILE}?* >> sha256sum.txt
make sort_checksum
