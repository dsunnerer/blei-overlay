# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PV="0.1.9"
SRC_URI="
	https://github.com/Lightcord/Lightcord/releases/download/v${MY_PV}/lightcord-linux-x64.zip -> ${P}.zip
	https://raw.githubusercontent.com/Lightcord/LightcordLogos/master/lightcord/lightcord.png
"
KEYWORDS="~amd64"

DESCRIPTION="A fancy, customizable Discord client"
HOMEPAGE="https://lightcord.deroku.xyz/"
LICENSE="MIT"
SLOT="0"

DEPEND="
	app-arch/unzip
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="
	opt/lightcord/lightcord
	opt/lightcord/libEGL.so
	opt/lightcord/libffmpeg.so
	opt/lightcord/libGLESv2.so
	opt/lightcord/libvk_swiftshader.so
	opt/lightcord/swiftshader/libEGL.so
	opt/lightcord/swiftshader/libGLESv2.so
"

src_install() {
	doicon "${DISTDIR}/lightcord.png"
	domenu "${FILESDIR}/Lightcord.desktop"

	dodir "/opt/lightcord/"
	cp -r "${S}/"* "${D}/opt/lightcord/" || die "Failed to install"
	fperms +x "/opt/lightcord/lightcord"
	dosym "../../opt/lightcord/lightcord" "/usr/bin/lightcord"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
