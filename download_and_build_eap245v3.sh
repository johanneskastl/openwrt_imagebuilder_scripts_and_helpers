#!/bin/bash

set -euo pipefail

export OPENWRT_VERSION="22.03.5"

#
# TP-Link EAP245v3
#
export DOWNLOAD_URL="https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/ath79/generic/"
export IMAGEBUILDER_FILE_NAME="openwrt-imagebuilder-${OPENWRT_VERSION}-ath79-generic.Linux-x86_64.tar.xz"
export PACKAGE_LIST="Packages_EAP245v3.txt"
export PATH_TO_IMAGE_TMP="target-mips_24kc_musl/linux-ath79_generic/tmp/"
export PROFILE="tplink_eap245-v3"
export SHASUMS_FILE="sha256sums_eap245v3"

#
# Cleanup requested?
#
[[ $# == 1 ]] && [[ "$1" == "--clean" ]] && {
    echo "Cleaning up directory ./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
    rm -rf "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
}

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
