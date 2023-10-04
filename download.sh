#!/bin/bash

set -euo pipefail

############################################################################################################
# Load variables
#
source "${env_file}"

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
