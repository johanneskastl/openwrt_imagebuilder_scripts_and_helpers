#!/bin/sh

##################################################################################
##################################################################################
##################################################################################

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

apk add argp-standalone asciidoc bash bc binutils bzip2 cdrkit coreutils \
  diffutils elfutils-dev findutils flex musl-fts-dev g++ gawk gcc gettext git \
  grep gzip intltool libxslt linux-headers make musl-libintl musl-obstack-dev \
  ncurses-dev openssl-dev patch perl python3-dev rsync tar \
  unzip util-linux wget zlib-dev || exit 11
 
# missing dependency workaround (libtinfo is not installable by any APK package,
# but can be simulated via libncurses (see: https://stackoverflow.com/a/41517423 )
# w/o this - ERROR: package/boot/uboot-mvebu failed to build (build variant: clearfog)
[ -e /usr/lib/libtinfo.so ] || ln -s /usr/lib/libncurses.so /usr/lib/libtinfo.so 
