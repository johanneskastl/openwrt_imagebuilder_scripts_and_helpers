#!/bin/sh

[ -z "${PROFILE}" ] && {
    echo "PROFILE is not defined..."
    exit 3
}

[ -z "${PACKAGE_LIST}" ] && {
    echo "PACKAGE_LIST is not defined..."
    exit 5
}

[ -z "${IMAGEBUILDER_FILE_NAME}" ] && {
    echo "IMAGEBUILDER_FILE_NAMEis not defined..."
    exit 7
}

[ -z "${IMAGEBUILDER_DIR_NAME}" ] && {
    echo "IMAGEBUILDER_DIR_NAME is not defined..."
    exit 9
}

[ -z "${PATH_TO_IMAGE_TMP}" ] && {
    echo "PATH_TO_IMAGE_TMP is not defined..."
    exit 11
}

[ -z "${DISABLED_SERVICES}" ] && {
    echo "DISABLED_SERVICES is not defined..."
    exit 13
}

echo "Ready for take-off..."

##################################################################################
##################################################################################
##################################################################################

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

echo "Installing packages in container..."
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
