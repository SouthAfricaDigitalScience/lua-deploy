#!/bin/bash -e
# build script for Lua

. /etc/profile.d/modules.sh
module add ci
module add readline
SOURCE_FILE=${NAME}-${VERSION}.tar.gz

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  wget http://www.lua.org/ftp/$SOURCE_FILE -O $SRC_DIR/$SOURCE_FILE
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi
tar xzf  ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
# no out of source builds for Lua - doesn't use autotools either.
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}
cd ${WORKSPACE}/${NAME}-${VERSION}
# Set the install dir
sed -i 's@^INSTALL_TOP.*$@INSTALL_TOP= ${SOFT_DIR}@g' Makefile
echo "Readline is at ${READLINE_DIR}"
export LDFLAGS="-L${READLINE_DIR}/lib -Wl,-export-dynamic"
export CFLAGS="-I${READLINE_DIR}/include"
makelinux
