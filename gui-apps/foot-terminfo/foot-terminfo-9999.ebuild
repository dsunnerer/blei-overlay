# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz  -> foot-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/foot"
else
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/dnkl/foot.git"
fi

DESCRIPTION="Terminfo for foot, a great Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="<sys-libs/ncurses-6.4"
BDEPEND="sys-libs/ncurses"

src_prepare() {
	default
	sed -i 's/@default_terminfo@/foot/g' "${S}/foot.info" || die "Failed to pre-process terminfo"
}

src_compile() {
	tic -x -o "${S}" -e foot,foot-direct "${S}/foot.info" || die "Failed to compile terminfo"
}

src_install() {
	dodir /usr/share/terminfo/f/
	cp "${S}/f/foot" "${D}/usr/share/terminfo/f/foot" || die
	cp "${S}/f/foot-direct" "${D}/usr/share/terminfo/f/foot-direct" || die
}
