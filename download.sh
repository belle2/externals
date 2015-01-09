#!/bin/bash

# check number of arguments
if [ $# -lt 1 ]; then
  exit 1
fi

# get base file name
FILE_NAME=$1
shift

# try given download urls
RESULT=1
while [ $# -gt 0 ]; do
  URL=$1
  PROTOCOL=`echo ${URL} | awk -F: '{print $1}'`
  EXTENSION=`echo ${URL} | awk -F. '{print $NF}'`
  shift
  if [ "${PROTOCOL}" = "svn" ]; then
    COMMAND=`echo ${URL} | awk -F: '{print $2}'`
    REVISION=`echo ${URL} | awk -F: '{print $3}'`
    LINK=`echo ${URL} | sed 's;svn:\w*:\w*:;;'`
    svn ${COMMAND} -r${REVISION} ${LINK}
  else
    if [ "${EXTENSION}" = "zip" ]; then
      tmp=`mktemp  /tmp/belle2_tmp.XXXX`
      rm -f $tmp
      wget -O $tmp --tries=3 ${URL}
      unzip $tmp
      rm -f $tmp
    else
      wget -O - --tries=3 ${URL} | tar xz
    fi
  fi
  RESULT=$?
  if [ "${RESULT}" = "0" ]; then
    break
  fi
done

# if none succeeded use the Belle II web server
if [ "${RESULT}" -ne "0" ]; then
  wget -O - --tries=3 --user=belle2 --password=Aith4tee https://belle2.cc.kek.jp/download/${FILE_NAME} | tar xz
  RESULT=$?
fi

# return error code
exit ${RESULT}
