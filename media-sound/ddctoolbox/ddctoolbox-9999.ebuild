EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/ThePBone/DDCToolbox.git"
KEYWORDS="~amd64"

DESCRIPTION="Create and edit ViPER DDC files"
HOMEPAGE="https://github.com/Audio4Linux"
LICENSE="GPL-3"
SLOT="0"

IUSE=""

DEPEND="
	dev-qt/qtcore:5=
"

RDEPEND="${DEPEND}"

src_prepare() {
    eapply_user
}

src_compile() {
    BUILDDIR="${S}"/build
    mkdir "${BUILDDIR}" && cd "${BUILDDIR}" || die "BUILDDIR does not exist"
    qmake "../DDCToolbox.pro"
    emake
}

src_install() {
    dobin "${BUILDDIR}"/src/DDCToolbox
}