# Scripts and helpers for the OpenWRT imagebuilder

This repository contains the scripts and helpers I need to build custom images for my

- OpenWRT Router (WRT1900ACS)
- OpenWRT Access Point (TP-Link EAP245v3)

It contains a Makefile, that has some targets:

- `clean` cleans up everything
  - `clean_eap245v3` cleans up all EAP245v3 related files
  - `clean_wrt1900acs` cleans up all WRT1900ACS related files
- `container` builds the container image using Podman
- `eap245v3` builds an image for the EAP245v3
- `wrt1900acs` builds and image for the WRT1900ACS
- `all`

The `all` target does the cleanup, builds the container image and then builds images for both devices.
