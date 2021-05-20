#!/bin/bash
cd `dirname $0`
cd ..
echo "Local:"
sha256sum -c --quiet sha256sum.txt 2>/dev/null #|| exit 1
echo "Server:"
SERVERCHECK=`cat sha256sum.txt | sed 's/\*src.*\//\*/' | ssh b2-master "cd /var/www/html/download && sha256sum -c --quiet 2> /dev/null"`
UPLOAD=""
while read line; do
    echo $line
    filename=`cut -d ':' -f1 <<< "$line"`
    UPLOAD="$UPLOAD $filename"
done <<< "$SERVERCHECK"

cd src && scp $UPLOAD b2-master:/var/www/html/download
