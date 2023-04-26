#!/bin/bash
set -e
cd `dirname $0`
cd ..
rm -fr src/python-packages .pip-certchain.pem
make python-packages.src root-python-packages.src
cd src/python-packages
rsync -avzP . software.belle2.org:/var/www/html/download/python-packages
