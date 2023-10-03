#!/bin/bash

set -euo pipefail

############################################################################################################
#
#
export env_file='env_Mikrotik_wAP_AC'
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
#
#
./download.sh

############################################################################################################
# Run the build inside podman
#

echo ""
echo "Starting build.sh in podman container"
podman run --rm -ti -v "${PWD}":/imagebuilder/ alpine sh /imagebuilder/"${IMAGEBUILDER_DIR_NAME}"/build.sh "${PROFILE}" "${IMAGEBUILDER_DIR_NAME}" "${PATH_TO_IMAGE_TMP}" "${PACKAGE_LIST}"
echo "Finished build in podman container"

exit 0
