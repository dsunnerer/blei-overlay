# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="A desktop chat client for Slack and Discord"
HOMEPAGE="https://cancel.fm/ripcord/"
MY_FILE="Ripcord-${PV}-x86_64.AppImage"
SRC_URI="https://cancel.fm/dl/${MY_FILE}"

LICENSE="ripcord"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="system-libs"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/glib
	dev-libs/libbsd
	dev-libs/libpcre
	media-libs/libglvnd
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	system-libs? (
		dev-libs/double-conversion
		dev-libs/icu
		dev-libs/libpcre2
		dev-libs/libsodium
		dev-libs/openssl
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwebsockets:5
		dev-qt/qtwidgets:5
		media-gfx/graphite2
		media-libs/flac
		media-libs/freetype
		media-libs/harfbuzz
		media-libs/libogg
		media-libs/libpng
		media-libs/libsndfile
		media-libs/libvorbis
		media-libs/opus
		media-sound/pulseaudio
		net-libs/libasyncns
		sys-apps/dbus
		sys-apps/tcp-wrappers
		sys-apps/util-linux
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXext
		x11-libs/libXScrnSaver
		x11-libs/libXtst
	)"
BDEPEND=""

RESTRICT="strip"

src_unpack() {
	cd "${WORKDIR}"
	cp "${DISTDIR}/${MY_FILE}" "${WORKDIR}"
	chmod +x "${MY_FILE}"
	./"${MY_FILE}" --appimage-extract
	mv squashfs-root "${P}"
	chmod -R +644 "${P}"
	find "${P}" -type d -exec chmod +111 {} \;
}

src_prepare() {
	sed -i 's/Exec=Ripcord/Exec=ripcord/' Ripcord.desktop

	if use system-libs; then
		patchelf --replace-needed libsodium.so.18 libsodium.so.23 Ripcord
	else
		patchelf --set-rpath /opt/ripcord/lib Ripcord
	fi

	default
}

src_install() {
	dodir /opt/ripcord/

	cp -r \
		Ripcord \
		doc \
		translations \
		twemoji.ripdb \
		"${ED}"/opt/ripcord/

	if ! use system-libs; then
		cp -r \
			lib \
			plugins \
			qt.conf \
			"${ED}"/opt/ripcord/
	fi

	doicon Ripcord_Icon.png
	newmenu Ripcord.desktop ripcord.desktop
	dosym ../../opt/ripcord/Ripcord /usr/bin/ripcord
}
