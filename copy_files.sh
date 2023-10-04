#!/bin/bash

set -euo pipefail

############################################################################################################
# Load variables
#
source "${env_file}"

############################################################################################################
# Copy files into openwrt imagebuilder directory
#

echo ""
echo "Copy files into imagebuilder directory"
cp -vf build.sh "./${IMAGEBUILDER_DIR_NAME}"
cp -vf "${PACKAGE_LIST}" "./${IMAGEBUILDER_DIR_NAME}"
