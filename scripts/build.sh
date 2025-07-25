#!/bin/bash
set -eux

# Args: VERSION, ARCH, DEST
VERSION="$1"       # ex: 0.9.7-rc0
ARCH="$2"          # amd64, amd64-rocm, arm64
DEST="$3"          # ex: dist/

BASENAME="ollama-linux-${ARCH}"
TGZ_URL="https://github.com/ollama/ollama/releases/download/v${VERSION}/${BASENAME}.tgz"

rm -rf build
mkdir -p build/debian/usr/bin
mkdir -p build/debian/lib/systemd/system
mkdir -p "$DEST"

curl -sL "$TGZ_URL" -o "build/${BASENAME}.tgz"

tar -xzf "build/${BASENAME}.tgz" -C build/debian/usr

chmod +x build/debian/usr/bin/ollama

cp -r debian/DEBIAN build/debian/
cp debian/lib/systemd/system/ollama.service build/debian/lib/systemd/system/
chmod +x build/debian/DEBIAN/postinst
chmod +x build/debian/DEBIAN/postrm

CONTROL="build/debian/DEBIAN/control"
sed -i "s/^Version: .*/Version: ${VERSION}/" "$CONTROL"

if [[ "$ARCH" == "amd64-rocm" ]]; then
  sed -i "s/^Architecture: .*/Architecture: amd64/" "$CONTROL"
  sed -i "s/^Package: .*/Package: ollama-rocm/" "$CONTROL"
  OUT="ollama-rocm_${VERSION}_amd64.deb"
elif [[ "$ARCH" == "amd64" ]]; then
  sed -i "s/^Architecture: .*/Architecture: amd64/" "$CONTROL"
  sed -i "s/^Package: .*/Package: ollama/" "$CONTROL"
  OUT="ollama_${VERSION}_amd64.deb"
else
  sed -i "s/^Architecture: .*/Architecture: arm64/" "$CONTROL"
  sed -i "s/^Package: .*/Package: ollama/" "$CONTROL"
  OUT="ollama_${VERSION}_arm64.deb"
fi

dpkg-deb --build --root-owner-group build/debian "$DEST/$OUT"
