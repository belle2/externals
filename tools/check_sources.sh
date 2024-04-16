#!/bin/bash
cd `dirname $0`
cd ..
echo "Local:"
sha256sum -c --quiet sha256sum.txt 2>/dev/null
echo "Server:"
SERVERCHECK=`cat sha256sum.txt | sed 's/\*src.*\//\*/' | ssh software.belle2.org "cd /belle2/download && sha256sum -c --quiet 2> /dev/null"`
UPLOAD=""
if [[ -n "$SERVERCHECK" ]]; then
    while read line; do
        echo $line
        filename=`cut -d ':' -f1 <<< "$line"`
        UPLOAD="$UPLOAD $filename"
    done <<< "$SERVERCHECK"
fi

if [[ -n "$UPLOAD" ]]; then
    echo "will upload $UPLOAD"
    read -p "Are you sure? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd src && scp $UPLOAD software.belle2.org:/belle2/download
    fi
else
    echo "Nothing to upload"
fi
