#!/bin/bash

## Variable definition
LINUX_SIGNATURES="litecoin-${LTC_VER}-linux-signatures.asc"
LINUX_ARCHIVE="litecoin-${LTC_VER}-x86_64-linux-gnu.tar.gz"
SOURCE_CHECKSUM_FILE="source_checksum.txt"
DOWNLOAD_CHECKSUM_FILE="download_checksum.txt"

## Fetching checksum from ${LINUX_SIGNATURES} and comparing it with the checksum from the archive ${LINUX_ARCHIVE}
grep 'x86_64' ${LINUX_SIGNATURES} | awk -F ' ' '{print $1}' > ${SOURCE_CHECKSUM_FILE}
sha256sum ${LINUX_ARCHIVE} | awk -F ' ' '{print $1}' > ${DOWNLOAD_CHECKSUM_FILE}

diff ${SOURCE_CHECKSUM_FILE} ${DOWNLOAD_CHECKSUM_FILE}
if [ $? == 0 ]
  then
    echo "The downloaded archive's checksum matches the verified one"
  else
    echo "WARNING - the downloaded archive's checksum does not match the verified one"
fi
