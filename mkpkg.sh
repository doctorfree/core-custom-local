#!/bin/bash
PKG="core-custom-local"
PKG_NAME="core-custom-local"
PKG_VER="1.0.1"
TOP="usr"
DESTDIR="${TOP}/local"
SRC=${HOME}/src
SUDO=sudo

# Subdirectory in which to create the distribution files
OUT_DIR="dist/${PKG_NAME}_${PKG_VER}"

[ -d "${SRC}/${PKG_NAME}" ] || {
  [ -d "/builds/doctorfree/${PKG_NAME}" ] || {
    echo "$SRC/$PKG_NAME does not exist or is not a directory. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  SUDO=
}

cd "${SRC}/${PKG_NAME}"
${SUDO} rm -rf dist
mkdir dist

[ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}
mkdir ${OUT_DIR}/DEBIAN

echo "Package: ${PKG}
Version: ${PKG_VER}
Section: misc
Priority: optional
Architecture: armhf
Depends:
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Build-Depends: debhelper (>= 11)
Standards-Version: 4.1.3
Homepage: https://gitlab.com/doctorfree/core-custom-local
Description: Custom package to hold /usr/local as a recognized installation folder
 The Debian packaging system does not recognize /usr/local as a standard installation path" > ${OUT_DIR}/DEBIAN/control

chmod 644 ${OUT_DIR}/DEBIAN/control

for dir in "${TOP}" "${DESTDIR}" "${TOP}/share" "${TOP}/share/doc" \
           "${TOP}/share/doc/${PKG}" "${DESTDIR}/bin" "${DESTDIR}/etc" \
           "${DESTDIR}/games" "${DESTDIR}/include" "${DESTDIR}/lib" \
           "${DESTDIR}/sbin" "${DESTDIR}/share" "${DESTDIR}/src"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

${SUDO} cp Install ${OUT_DIR}/${TOP}/share/doc/${PKG}/Install
${SUDO} cp Uninstall ${OUT_DIR}/${TOP}/share/doc/${PKG}/Uninstall
${SUDO} cp AUTHORS ${OUT_DIR}/${TOP}/share/doc/${PKG}/AUTHORS
${SUDO} cp LICENSE ${OUT_DIR}/${TOP}/share/doc/${PKG}/copyright
${SUDO} cp CHANGELOG.md ${OUT_DIR}/${TOP}/share/doc/${PKG}/changelog
${SUDO} cp README.md ${OUT_DIR}/${TOP}/share/doc/${PKG}/README
${SUDO} gzip -9 ${OUT_DIR}/${TOP}/share/doc/${PKG}/changelog

cd dist
${SUDO} dpkg-deb --build ${PKG_NAME}_${PKG_VER}
