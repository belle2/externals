#!/bin/bash

check_archive() {
  # check if file exists
  [ -f ${EXTSRCDIR}/${FILENAME} ] || return 1
  # if so, check if the checksum matches
  if [ -z $BELLE2_EXTERNALS_IGNORE_CHECKSUM ]; then
    cat ${BELLE2_EXTERNALS_DIR}/sha256sum.txt | grep ${FILENAME} | sha256sum -c -
    if [ $? -ne 0 ]; then
      echo "could not verify ${FILENAME}, if you know what you're doing set"\
        "\$BELLE2_EXTERNALS_IGNORE_CHECKSUM=1 to ignore the checksum verification";
      return 1;
    fi
  fi
}

get_archive () {
  URL=$1
  shift
  # only download if not present or wrong checksum
  check_archive
  if [ $? -ne 0 ]; then
    wget --tries=3 -O ${EXTSRCDIR}/${FILENAME} "$@" ${URL} || return 1
    # check again
    check_archive || return 1
  fi

  # if we don't need to extract then all is done
  if [ -n "$DOWNLOAD_ONLY" ]; then
      return 0;
  fi

  # get file extension
  EXTENSION=`echo ${URL} | awk -F. '{print $NF}'`
  # extract in temp dir and move to final destination name
  TMPDIR=`mktemp -d belle2_tmp.XXXX`
  EXTRACT="tar zxf"
  if [ "${EXTENSION}" == "zip" ]; then
    EXTRACT="unzip"
  elif [ "${EXTENSION}" == "bz2" ]; then
    EXTRACT="tar xjf"
  fi

  pushd ${TMPDIR} &> /dev/null
  # extract file
  ${EXTRACT} ${EXTSRCDIR}/${FILENAME}
  # Remove old dir
  rm -fr ${DIRNAME}
  # Rename the directory in the tmpdir to what we want
  mv -T * ${DIRNAME}
  popd &> /dev/null
  rm -fr ${TMPDIR}
}

get_svn () {
  URL=$1
  COMMAND=`echo ${URL} | awk -F: '{print $2}'`
  REVISION=`echo ${URL} | awk -F: '{print $3}'`
  LINK=`echo ${URL} | sed 's;svn:\w*:\w*:;;'`
  svn ${COMMAND} -r${REVISION} ${LINK} ${DIRNAME}
}

if [ $# -lt 2 ]; then
  echo "Usage: $0 DIRNAME FILENAME [URL...]"
  exit 1
fi

echo "Downloading $1 ..."
DIRNAME=${EXTSRCDIR}/$1
FILENAME=$2
shift 2
RESULT=1

if [ -z "$USE_BELLE2SERVER" ]; then
    while [ $# -gt 0 ]; do
        URL=$1
        PROTOCOL=`echo ${URL} | awk -F: '{print $1}'`
        shift
        if [ "${PROTOCOL}" = "svn" ]; then
            get_svn $URL
        else
            get_archive ${URL}
        fi
        RESULT=$?
        if [ "${RESULT}" = "0" ]; then
            break
        fi
    done
fi

# if none succeeded use the Belle II web server
if [ "${RESULT}" -ne "0" ]; then
  get_archive https://belle2.cc.kek.jp/download/${FILENAME} --user=belle2 --password=Aith4tee
  RESULT=$?
fi

# return error code
exit ${RESULT}
