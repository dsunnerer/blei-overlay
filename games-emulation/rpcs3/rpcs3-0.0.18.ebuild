# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="PS3 emulator and debugger."
HOMEPAGE="https://rpcs3.net/"
MY_SHA="v0.0.18"
ASMJIT_SHA="d0d14ac774977d0060a351f66e35cb57ba0bf59c"
CEREAL_SHA="59ce20e132dae9e4b9e4064e3e46baa8fa9b8a8a"
HIDAPI_SHA="01f601a1509bf9c67819fbf521df39644bab52d5"
LLVM_SHA="5836324d6443a62ed09b84c125029e98324978c3"
YAML_CPP_SHA="0b67821f307e8c6bf0eba9b6d3250e3cf1441450"
WOLFSSL_SHA="60adf22ce1e74cbfc5a65f9b0c07d294e8b9d04d"
SPAN_SHA="5d8d366eca918d0ed3d2d196cbeae6abfd874736"
SRC_URI="https://github.com/RPCS3/rpcs3/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/RPCS3/llvm-mirror/archive/${LLVM_SHA}.tar.gz -> ${PN}-llvm-${LLVM_SHA:0:7}.tar.gz
	https://github.com/asmjit/asmjit/archive/${ASMJIT_SHA}.tar.gz -> ${PN}-asmjit-${ASMJIT_SHA:0:7}.tar.gz
	https://github.com/wolfSSL/wolfssl/archive/${WOLFSSL_SHA}.tar.gz -> ${PN}-wolfssl-${WOLFSSL_SHA:0:7}.tar.gz
	https://github.com/RPCS3/hidapi/archive/${HIDAPI_SHA}.tar.gz -> ${PN}-hidapi-${HIDAPI_SHA:0:7}.tar.gz
	https://github.com/RPCS3/yaml-cpp/archive/${YAML_CPP_SHA}.tar.gz -> ${PN}-yaml-cpp-${YAML_CPP_SHA:0:7}.tar.gz
	https://github.com/RPCS3/cereal/archive/${CEREAL_SHA}.tar.gz -> ${PN}-cereal-${CEREAL_SHA:0:7}.tar.gz
	https://github.com/tcbrindle/span/archive/${SPAN_SHA}.tar.gz -> ${PN}-span-${SPAN_SHA:0:7}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa faudio joystick +llvm pulseaudio vulkan wayland"
REQUIRED_USE="wayland? ( vulkan )"

DEPEND="dev-libs/pugixml
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtdbus
	dev-qt/qtgui
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-util/glslang
	media-libs/libpng:*
	media-libs/openal
	media-video/ffmpeg
	sys-libs/zlib
	virtual/jpeg:=
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	faudio? ( app-emulation/faudio )
	joystick? ( dev-libs/libevdev )
	pulseaudio? ( media-sound/pulseaudio )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )"
RDEPEND="${DEPEND} sys-devel/gdb"
BDEPEND=">=sys-devel/gcc-9"

S="${WORKDIR}/${PN}-${MY_SHA:1}"
PATCHES=(
	"${FILESDIR}/${PN}-0001-allow-more-system-libs.patch"
	"${FILESDIR}/${PN}-0003-add-missing-include-fix-branch-names.patch"
	"${FILESDIR}/${PN}-0004-add-use_wayland.patch"
	"${FILESDIR}/${PN}-0005-faudio.patch"
)

src_prepare() {
	rmdir "${S}/llvm" || die
	mv "${WORKDIR}/llvm-mirror-${LLVM_SHA}" "${S}/llvm" || die
	rmdir "${S}/3rdparty/"{cereal,wolfssl,hidapi,yaml-cpp,span} || die
	mv "${WORKDIR}/wolfssl-${WOLFSSL_SHA}" "${S}/3rdparty/wolfssl" || die
	mv "${WORKDIR}/hidapi-${HIDAPI_SHA}" "${S}/3rdparty/hidapi" || die
	mv "${WORKDIR}/yaml-cpp-${YAML_CPP_SHA}" "${S}/3rdparty/yaml-cpp" || die
	mv "${WORKDIR}/cereal-${CEREAL_SHA}" "${S}/3rdparty/cereal" || die
	mv "${WORKDIR}/span-${SPAN_SHA}" "${S}/3rdparty/span" || die
	rmdir "${S}/asmjit" || die
	mv "${WORKDIR}/asmjit-${ASMJIT_SHA}" "${S}/asmjit" || die
	echo "#define RPCS3_GIT_VERSION \"0000-${MY_SHA}\"" > rpcs3/git-version.h
	echo '#define RPCS3_GIT_BRANCH "master"' >> rpcs3/git-version.h
	echo '#define RPCS3_GIT_VERSION_NO_UPDATE 1' >> rpcs3/git-version.h
	sed -r \
		-e 's/MATCHES "\^\(DEBUG\|RELEASE\|RELWITHDEBINFO\|MINSIZEREL\)\$/MATCHES "^(DEBUG|RELEASE|RELWITHDEBINFO|MINSIZEREL|GENTOO)/' \
		-i "${S}/llvm/CMakeLists.txt" || die
	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DBUILD_EXTERNAL=OFF
		-DBUILD_LLVM_SUBMODULE=ON
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DUSE_ALSA=$(usex alsa)
		-DUSE_DISCORD_RPC=OFF
		-DUSE_SYSTEM_FAUDIO=$(usex faudio)
		-DUSE_LIBEVDEV=$(usex joystick)
		-DUSE_NATIVE_INSTRUCTIONS=OFF
		-DUSE_PULSE=$(usex pulseaudio)
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_GLSLANG=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_SPIRV_HEADERS=ON
		-DUSE_SYSTEM_XXHASH=ON
		-DUSE_SYSTEM_ZLIB=ON
		-DUSE_SYS_LIBUSB=ON
		-DUSE_VULKAN=$(usex vulkan)
		-DUSE_WAYLAND=$(usex wayland)
		-DWITH_LLVM=$(usex llvm)
	)
	cmake_src_configure
}
