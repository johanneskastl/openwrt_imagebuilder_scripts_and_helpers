#!/bin/sh

PROFILE="$1"
export PROFILE
IMAGEBUILDER_FILE_NAME="$2"
PATH_TO_IMAGE_TMP="$3"
export PATH_TO_IMAGE_TMP
PACKAGE_LIST="${4}"

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

cd /imagebuilder/"${IMAGEBUILDER_FILE_NAME}" || exit 13

make clean

PACKAGES="$(cat ./"${PACKAGE_LIST}")"
[ -z "${PACKAGES}" ] && exit 47
export PACKAGES
echo "${PACKAGES}"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
sleep 1

make image PACKAGES="${PACKAGES}" || exit 93

echo "Finished building the image..."

cp -afv ./build_dir/"${PATH_TO_IMAGE_TMP}"/*squashfs-sysupgrade.bin ../

echo "Finished, good bye..."
exit 0
