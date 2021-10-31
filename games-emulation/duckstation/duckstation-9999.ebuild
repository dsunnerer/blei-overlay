# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake desktop git-r3

DESCRIPTION="Fast Sony PlayStation (PSX) emulator"
HOMEPAGE="https://github.com/stenzek/duckstation"
EGIT_REPO_URI="https://github.com/stenzek/duckstation.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
IUSE="discord egl evdev fbdev +gamepad gbm +nogui qt5 retroachievements wayland X"

# Either or both frontends must be built
REQUIRED_USE="
	?? ( fbdev gbm )
	gbm? ( egl )
	wayland? ( egl )
"

BDEPEND="
	virtual/pkgconfig
	wayland? ( kde-frameworks/extra-cmake-modules )
"
DEPEND="
	evdev? ( dev-libs/libevdev )
	gamepad? ( media-libs/libsdl2 )
	gbm? ( x11-libs/libdrm )
	qt5? (
			dev-qt/qtcore
			dev-qt/qtgui
			dev-qt/qtnetwork
	)
	retroachievements? ( net-misc/curl[curl_ssl_gnutls] )
	X? (
			x11-libs/libX11
			x11-libs/libXrandr
	)
"
RDEPEND="${DEPEND}"

# Set working directory to checkout directory
S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_NOGUI_FRONTEND=$(usex nogui)
		-DBUILD_QT_FRONTEND=$(usex qt5)
		-DENABLE_CHEEVOS=$(usex retroachievements)
		–DENABLE_DISCORD_PRESENCE=$(usex discord)
		-DUSE_DRMKMS=$(usex gbm)
		-DUSE_EGL=$(usex egl)
		-DUSE_EVDEV=$(usex evdev)
		-DUSE_FBDEV=$(usex fbdev)
		-DUSE_SDL2=$(usex gamepad)
		-DUSE_WAYLAND=$(usex wayland)
		-DUSE_X11=$(usex X)

		-DBUILD_SHARED_LIBS=OFF
	)

	cmake_src_configure
}

src_install() {
	dodoc README.md

	# Binary and resources files must be in same directory – installing in /opt
	insinto /opt/${PN}
	doins -r "${BUILD_DIR}"/bin/{database,inputprofiles,resources,shaders,translations}

	ICOPATH="usr/share/icons/hicolor"
	if use nogui; then
		#newicon -s 16 appimage/icon-16px.png duckstation-nogui
		#newicon -s 32 appimage/icon-32px.png duckstation-nogui
		#newicon -s 48 appimage/icon-48px.png duckstation-nogui
		#newicon -s 64 appimage/icon-64px.png duckstation-nogui
		domenu "${FILESDIR}"/duckstation-nogui.desktop
		doins "${BUILD_DIR}"/bin/duckstation-nogui
		fperms +x /opt/${PN}/duckstation-nogui
	fi

	if use qt5; then
		#newicon -s 16 appimage/icon-16px.png duckstation-qt
		#newicon -s 32 appimage/icon-32px.png duckstation-qt
		#newicon -s 48 appimage/icon-48px.png duckstation-qt
		#newicon -s 64 appimage/icon-64px.png duckstation-qt
		domenu "${FILESDIR}"/duckstation-qt.desktop
		doins "${BUILD_DIR}"/bin/duckstation-qt
		fperms +x /opt/${PN}/duckstation-qt
	fi
}
