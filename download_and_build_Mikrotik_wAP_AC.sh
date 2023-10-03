#!/bin/bash

set -euo pipefail

export OPENWRT_VERSION="snapshots"

############################################################################################################
# MikroTik wAP AC
#
#export DOWNLOAD_URL="https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/ipq40xx/mikrotik/"
export DOWNLOAD_URL="https://downloads.openwrt.org/${OPENWRT_VERSION}/targets/ipq40xx/mikrotik/"
#export IMAGEBUILDER_FILE_NAME="openwrt-imagebuilder-${OPENWRT_VERSION}-ipq40xx-mikrotik.Linux-x86_64.tar.xz"
export SHASUMS_FILE="sha256sums_Mikrotik_wAP_AC"
export IMAGEBUILDER_FILE_NAME="openwrt-imagebuilder-ipq40xx-mikrotik.Linux-x86_64.tar.xz"
export PACKAGE_LIST="Packages_Mikrotik_wAP_AC.txt"
export PATH_TO_IMAGE_TMP="target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-ipq40xx_mikrotik/tmp/"
export PROFILE="mikrotik_wap-ac"

############################################################################################################
# Cleanup requested?
#
[[ $# == 1 ]] && [[ "$1" == "--clean" ]] && {
    echo "Cleaning up directory ./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
    rm -rf "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
}

############################################################################################################
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

############################################################################################################
# Copy files into openwrt imagebuilder directory
#
 
cp -vf build.sh "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"
cp -vf "${PACKAGE_LIST}" "./${IMAGEBUILDER_FILE_NAME/.tar.xz/}"

############################################################################################################
# Run the build inside podman
#

podman run --rm -ti -v "${PWD}":/imagebuilder/ alpine sh /imagebuilder/"${IMAGEBUILDER_FILE_NAME/.tar.xz/}"/build.sh "${PROFILE}" "${IMAGEBUILDER_FILE_NAME/.tar.xz/}" "${PATH_TO_IMAGE_TMP}" "${PACKAGE_LIST}"
