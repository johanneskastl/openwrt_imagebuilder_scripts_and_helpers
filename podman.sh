#!/bin/bash

podman run --rm -ti -v "./install_packages_on_alpine.sh":/install_packages_on_alpine.sh -v "${PWD}":/imagebuilder/ alpine
