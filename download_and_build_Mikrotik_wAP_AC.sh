#!/bin/bash

set -euo pipefail

############################################################################################################
#
#
source env_Mikrotik_wAP_AC

[[ -z "${PROFILE}" ]] && {
    echo "PROFILE is not defined..."
    exit 3
}

[[ -z "${PACKAGE_LIST}" ]] && {
    echo "PACKAGE_LIST is not defined..."
    exit 5
}

[[ -z "${IMAGEBUILDER_DIR_NAME}" ]] && {
    echo "IMAGEBUILDER_DIR_NAME is not defined..."
    exit 7
}

[[ -z "${PATH_TO_IMAGE_TMP}" ]] && {
    echo "PATH_TO_IMAGE_TMP is not defined..."
    exit 9
}

############################################################################################################
# Cleanup requested?
#
[[ $# == 1 ]] && [[ "$1" == "--clean" ]] && {
    echo "Cleaning up directory ./${IMAGEBUILDER_DIR_NAME}"
    rm -rf "./${IMAGEBUILDER_DIR_NAME}"
}

############################################################################################################
# Download and unpack
#

if [[ -d "./${IMAGEBUILDER_DIR_NAME}" ]]
then
   echo "Directory is already existing..."
else
    echo "Downloading files..."

    [[ -f ./"${SHASUMS_FILE}" ]] || wget "${DOWNLOAD_URL}/sha256sums" -O ./"${SHASUMS_FILE}"  || exit 5
    [[ -f "./${IMAGEBUILDER_FILE_NAME}" ]] || wget "${DOWNLOAD_URL}/${IMAGEBUILDER_FILE_NAME}" || exit 7

    echo "Validating checksum..."
    grep "${IMAGEBUILDER_FILE_NAME}" "${SHASUMS_FILE}" | sha256sum -c - || exit 11
    
    [[ -d "./${IMAGEBUILDER_DIR_NAME}" ]] || {

        echo "Unpackaging archive"
        tar xf "${IMAGEBUILDER_FILE_NAME}" || exit 13
    }
fi

############################################################################################################
# Copy files into openwrt imagebuilder directory
#
 
cp -vf build.sh "./${IMAGEBUILDER_DIR_NAME}"
cp -vf "${PACKAGE_LIST}" "./${IMAGEBUILDER_DIR_NAME}"

############################################################################################################
# Run the build inside podman
#

podman run --rm -ti -v "${PWD}":/imagebuilder/ alpine sh /imagebuilder/"${IMAGEBUILDER_DIR_NAME}"/build.sh "${PROFILE}" "${IMAGEBUILDER_DIR_NAME}" "${PATH_TO_IMAGE_TMP}" "${PACKAGE_LIST}"
