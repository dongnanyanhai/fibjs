#!/bin/bash

set -ev

TARGET_ARCH=${ARCH}

case "${ARCH}" in
  i386)
    TARGET_ARCH=x86
      ;;
  amd64)
    TARGET_ARCH=x64
      ;;
esac

export T_BUILD_NAME=$TRAVIS_TAG

if [[ -z $T_BUILD_NAME && $TRAVIS_BRANCH == "beta" ]]; then
  T_BUILD_NAME="$(git describe --tags)"
  echo "T_BUILD_NAME is $T_BUILD_NAME";
fi

mkdir -p ${T_BUILD_NAME}

DIST_FILE=""

if [[ $TRAVIS_OS_NAME == 'linux' ]]; then # linux
  DIST_FILE=bin/Linux_${ARCH}_release

  FIBJS_FILE=${DIST_FILE}/fibjs
  INSTALLER_FILE=${DIST_FILE}/installer.sh
  XZ_FILE=${DIST_FILE}/fibjs.xz
  GZ_FILE=${DIST_FILE}/fibjs.tar.gz

  cp ${FIBJS_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-linux-${TARGET_ARCH}
  cp ${INSTALLER_FILE} ${T_BUILD_NAME}/installer-${T_BUILD_NAME}-linux-${TARGET_ARCH}.sh
  cp ${XZ_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-linux-${TARGET_ARCH}.xz
  cp ${GZ_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-linux-${TARGET_ARCH}.tar.gz

else # darwin
  DIST_FILE=bin/Darwin_${ARCH}_release

  FIBJS_FILE=${DIST_FILE}/fibjs
  INSTALLER_FILE=${DIST_FILE}/installer.sh
  XZ_FILE=${DIST_FILE}/fibjs.xz
  GZ_FILE=${DIST_FILE}/fibjs.tar.gz

  cp ${FIBJS_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-darwin-${TARGET_ARCH}
  cp ${INSTALLER_FILE} ${T_BUILD_NAME}/installer-${T_BUILD_NAME}-darwin-${TARGET_ARCH}.sh
  cp ${XZ_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-darwin-${TARGET_ARCH}.xz
  cp ${GZ_FILE} ${T_BUILD_NAME}/fibjs-${T_BUILD_NAME}-darwin-${TARGET_ARCH}.tar.gz

  if [[ $TARGET_ARCH == 'x64' ]]; then
    echo "zip fullsrc..."
    sudo sh build clean
    zip -r ./${T_BUILD_NAME}/fullsrc.zip ./ -x *.git* ${T_BUILD_NAME} ${T_BUILD_NAME}/*
  fi
fi

exit 0;
