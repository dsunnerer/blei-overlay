# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg-utils

MY_PN="Joplin"
DESCRIPTION="Open Source note taking app a la Evernote"
HOMEPAGE="https://joplin.org"
SRC_URI="https://github.com/laurent22/joplin/releases/download/v${PV}/Joplin-${PV}.AppImage -> ${P}.7z"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
dev-libs/libappindicator
gnome-base/gconf
x11-libs/libnotify
dev-libs/libindicator
x11-libs/libXScrnSaver
x11-libs/libXtst
"

S="${WORKDIR}"

QA_PREBUILT="
"

src_unpack() {
  unpacker_src_unpack
  mkdir "${S}/Joplin"
  mv "${S}"/* "${S}/Joplin"
  mv "${S}"/Joplin/usr "${S}"
}

src_install() {
	insinto /opt
	doins -r "${S}/${MY_PN}"
	fperms 755 /opt/Joplin
	fperms 4755 /opt/Joplin/chrome-sandbox

	fperms 755 /opt/Joplin/@joplinapp-desktop
	dosym /opt/Joplin/@joplinapp-desktop /usr/bin/joplinapp-desktop

	insinto /usr/share/applications
	doins /opt/Joplin/@joplinapp-desktop.desktop

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
