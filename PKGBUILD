# Maintainer: VHSgunzo <vhsgunzo.github.io>
# Maintainer: Levente Polyak <anthraxx[at]archlinux[dot]org>
# Maintainer: Giancarlo Razzolini <grazzolini@archlinux.org>
# Contributor: Gaetan Bisson <bisson@archlinux.org>
# Contributor: Aaron Griffin <aaron@archlinux.org>
# Contributor: judd <jvinet@zeroflux.org>

pkgname=runimage-openssh
pkgver=9.6p1
pkgrel=1
pkgdesc="SSH protocol implementation for remote login, command execution and file transfer for RunImage container"
arch=('x86_64')
url='https://www.openssh.com/portable.html'
license=(
  'BSD-2-Clause'
  'BSD-3-Clause'
  'ISC'
  'MIT'
)
depends=(
  'glibc'
  'ldns'
  'libedit'
  'libxcrypt' 'libcrypt.so'
  'openssl'
  'zlib'
)
makedepends=('libfido2' 'linux-headers')
optdepends=(
  'libfido2: FIDO/U2F support'
  'sh: for ssh-copy-id and findssl.sh'
  'x11-ssh-askpass: input passphrase in X'
  'xorg-xauth: X11 forwarding'
)
backup=(
  'etc/ssh/ssh_config'
  'etc/ssh/sshd_config'
)
source=(
  "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${pkgver}.tar.gz"{,.asc}
  "runimage.patch"
  'sshdgenkeys.service'
  'sshd.service'
  'sshd.conf'
)
conflicts=('openssh')
provides=("openssh=$pkgver")
md5sums=('5e90def5af3ffb27e149ca6fff12bef3'
         'SKIP'
         '026393a656283b5d16b2641f7feaf77d'
         '53868d434cb2db6e46b46abc1f3ff397'
         '26483c2a13e970c55e0ee690dbdd6975'
         '0dc7eaae0fcaf48a5a0f11c618e503c9')
validpgpkeys=('7168B983815A5EEF59A4ADFD2A3F414E736060BA')  # Damien Miller <djm@mindrot.org>

prepare() {
  patch -Np1 -d "openssh-$pkgver" -i ../runimage.patch
}

build() {
  local configure_options=(
    --prefix=/usr
    --sbindir=/usr/bin
    --libexecdir=/usr/lib/ssh
    --sysconfdir=/etc/ssh
    --disable-strip
    --with-ldns
    --with-libedit
    --with-security-key-builtin
    --with-ssl-engine
    --with-privsep-user=nobody
    --with-xauth=/usr/bin/xauth
    --with-pid-dir=/run
    --with-default-path='/usr/local/sbin:/usr/local/bin:/usr/bin:/var/RunDir/static'
    --without-zlib-version-check
  )

  cd "openssh-${pkgver}"

  ./configure "${configure_options[@]}"
  make
}

check() {
  cd "openssh-${pkgver}"

  # NOTE: make t-exec does not work in our build environment
  make file-tests interop-tests unit
}

package() {
  cd "openssh-${pkgver}"

  make DESTDIR="${pkgdir}" install

  ln -sf ssh.1.gz "${pkgdir}"/usr/share/man/man1/slogin.1.gz
  install -Dm644 LICENCE -t "${pkgdir}/usr/share/licenses/openssh/"

  install -Dm644 ../sshdgenkeys.service -t "${pkgdir}"/usr/lib/systemd/system/
  install -Dm644 ../sshd.service -t "${pkgdir}"/usr/lib/systemd/system/
  install -Dm644 ../sshd.conf -t "${pkgdir}"/usr/lib/tmpfiles.d/

  install -Dm755 contrib/findssl.sh -t "${pkgdir}"/usr/bin/
  install -Dm755 contrib/ssh-copy-id -t "${pkgdir}"/usr/bin/
  install -Dm644 contrib/ssh-copy-id.1 -t "${pkgdir}"/usr/share/man/man1/
}
