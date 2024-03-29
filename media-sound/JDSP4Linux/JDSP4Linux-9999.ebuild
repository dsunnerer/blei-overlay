EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/Audio4Linux/JDSP4Linux.git"
KEYWORDS="~amd64"

DESCRIPTION="DSP for Pipewire and Pulseaudio"
HOMEPAGE="https://github.com/Audio4Linux/JDSP4Linux"
LICENSE="GPL-3"
SLOT="0"

IUSE="+pulseaudio pipewire"

REQUIRED_USE="pulseaudio? ( !pipewire )
    pipewire? ( !pulseaudio )
"

DEPEND="
	dev-qt/qtcore
	dev-qt/qtsvg
	dev-libs/glib
	dev-cpp/glibmm
	pulseaudio? (
	    media-sound/pulseaudio
	    media-libs/gst-plugins-base
	    media-libs/gstreamer
	 )
	pipewire? (
	    media-video/pipewire
	)
"

RDEPEND="${DEPEND}"

src_prepare() {
    eapply_user
}

src_compile() {
    BUILDDIR="${S}"/build
    mkdir "${BUILDDIR}" && cd "${BUILDDIR}" || die "BUILDDIR does not exist"

    if use pulseaudio; then
      qmake "../JDSP4Linux.pro" "CONFIG += USE_PULSEAUDIO"
    else
      qmake "../JDSP4Linux.pro"
    fi
    emake
}

src_install() {
    dolib.a "${BUILDDIR}"/libjamesdsp/liblibjamesdsp.a
    dobin "${BUILDDIR}"/src/jamesdsp
}
