#!/bin/bash

set -euo pipefail

############################################################################################################
#
#
{
    [[ "$#" == "1" ]] && [[ -f "${1}" ]]
} || {
    echo "Please use the name of the env file as only argument. Aborting..."
    exit 1
}

export env_file="${1}"
source "${env_file}"

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
#
#
./download.sh

############################################################################################################
# Run the build inside podman
#

echo ""
echo "Starting build.sh in podman container"
podman run --rm -ti -v "${PWD}":/imagebuilder/ --env-file env_Mikrotik_wAP_AC openwrt-imagebuilder:alpine-latest sh /imagebuilder/"${IMAGEBUILDER_DIR_NAME}"/build.sh
echo "Finished build in podman container"

exit 0
