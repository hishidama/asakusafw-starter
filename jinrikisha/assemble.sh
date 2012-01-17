#!/bin/bash
set -e
set -x

########################################
# Check and Initialize
########################################

if [ -z "$RIKISHA_ARCHIVE_HOME" ]; then
  echo "RIKISHA_ARCHIVE_HOME が設定されていません。"
  exit 1
fi

. "$(dirname $0)/VERSION"
cd $(dirname $0)

rm -fr target
mkdir target

########################################
# Make Sphinx Document
########################################
cd docs/ja
make clean html
cd ../..

########################################
# Package 
########################################
for _PLATFORM in "$@"; do
  echo "$_PLATFORM 版のアーカイブを作成します."

  mkdir "target/jinrikisha-$_PLATFORM"

  if [ $BUILD_ID ]; then
    echo _BUILD_ID=$BUILD_ID > "target/jinrikisha-$_PLATFORM"/.buildinfo
  fi

  cp LICENSE VERSION "target/jinrikisha-$_PLATFORM"
  cp -r common/* "target/jinrikisha-$_PLATFORM"
  cp -r "$RIKISHA_ARCHIVE_HOME"/common/* "target/jinrikisha-$_PLATFORM"
  
  mkdir "target/jinrikisha-$_PLATFORM/docs"
  cp -r docs/ja/build/html/* "target/jinrikisha-$_PLATFORM/docs"

  cp -r "$_PLATFORM"/* "target/jinrikisha-$_PLATFORM"
  cp -r "$RIKISHA_ARCHIVE_HOME/$_PLATFORM"/* "target/jinrikisha-$_PLATFORM"

  tar -C target -czvf "jinrikisha-${_PLATFORM}-${_RIKISHA_VERSION}.tar.gz" jinrikisha-ubuntu
  mv "jinrikisha-${_PLATFORM}-${_RIKISHA_VERSION}.tar.gz" target
  echo "$_PLATFORM 版のアーカイブを作成しました: target/jinrikisha-${_PLATFORM}-${_RIKISHA_VERSION}.tar.gz"

done
