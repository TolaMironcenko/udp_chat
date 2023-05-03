# Maintainer: Tola Mironcenko <mironcenkotola@gmail.com>
pkgname=udpchat
pkgver=1.0.1
pkgrel=1
epoch=
pkgdesc=""
arch=('x86_64')
url=""
license=('GPL')
groups=()
depends=()
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
noextract=()
md5sums=()
validpgpkeys=()

build() {
	cd $HOME/Documents/cpp/udp_chat
	make
}

package() {
	cd $HOME/Documents/cpp/udp_chat
	make INSTALL_DIR="$pkgdir/usr/local/bin/" install
}
