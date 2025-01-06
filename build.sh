#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$0" 2>/dev/null)" 2>/dev/null)"
echo "= Change perms"
chmod 777 -R "$PWD"
echo "= Update"
pacman -Syu --noconfirm
echo "= create archlinux package"
export MAKEFLAGS="-j$(nproc)"
pacman -S --needed --noconfirm base-devel ldns libedit libxcrypt openssl zlib libfido2 linux-headers && \
sudo -u alpm makepkg -fsCc --noconfirm --skippgpcheck
echo "= cleanup"
rm -rf .gnupg .ssh
