#!/bin/bash

set -euo pipefail

export OPENWRT_VERSION="22.03.5"

#
# TP-Link WRT1900ACS
#
export DOWNLOAD_URL="https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/mvebu/cortexa9/"
export IMAGEBUILDER_FILE_NAME="openwrt-imagebuilder-${OPENWRT_VERSION}-mvebu-cortexa9.Linux-x86_64.tar.xz"
export PACKAGE_LIST="Packages_WRT1900ACS.txt"
export PATH_TO_IMAGE_TMP="target-arm_cortex-a9+vfpv3-d16_musl_eabi/linux-mvebu_cortexa9/tmp"
export PROFILE="linksys_wrt1900acs"
export SHASUMS_FILE="sha256sums_wrt1900acs"

#
# Download and unpack
#

if [[ -d "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}" ]]
then
   echo "Directory is already existing..."
else
    echo "Downloading files..."

    [[ -f ./"${SHASUMS_FILE}" ]] || wget "${DOWNLOAD_URL}/sha256sums" -O ./"${SHASUMS_FILE}"  || exit 5
    [[ -f "./${IMAGEBUILDER_FILE_NAME}" ]] || wget "${DOWNLOAD_URL}/${IMAGEBUILDER_FILE_NAME}" || exit 7

    echo "Validating checksum..."
    grep "${IMAGEBUILDER_FILE_NAME}" "${SHASUMS_FILE}" | sha256sum -c - || exit 11
    
    [[ -d "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}" ]] || {

        echo "Unpackaging archive"
        tar xf "${IMAGEBUILDER_FILE_NAME}" || exit 13
    }
fi

#
# Copy files into openwrt imagebuilder directory
#
 
cp -vf build.sh "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
cp -vf "${PACKAGE_LIST}" "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"

#
# Run the build inside podman
#

podman run --rm -ti -v "${PWD}":/imagebuilder/ alpine sh /imagebuilder/"${IMAGEBUILDER_FILE_NAME/.tar.xz/}"/build.sh "${PROFILE}" "${IMAGEBUILDER_FILE_NAME/.tar.xz/}" "${PATH_TO_IMAGE_TMP}" "${PACKAGE_LIST}"
