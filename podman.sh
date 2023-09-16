#!/bin/bash

podman run --rm -ti -v "$1":/imagebuilder/ alpine
