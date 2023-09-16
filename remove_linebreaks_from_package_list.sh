#!/bin/bash

[[ $# == 1 ]] || {
    echo "Filename as only argument is missing..."
    exit 1
}

FILE="$1"
OUTPUT_FILE="${FILE/_with_linebreaks/}"

perl -p -e 's/\n/ /' "${FILE}" > "${OUTPUT_FILE}" || exit 11
sed -i 's/\s*$//g' "${OUTPUT_FILE}"
echo "" >> "${OUTPUT_FILE}"
