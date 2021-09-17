EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/kuba160/ddb_gui_qt5.git"
KEYWORDS="~amd64"

DESCRIPTION="QT5 gui for deadbeef"
HOMEPAGE="https://github.com/kuba160/ddb_gui_qt5"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

DEPEND="
	>=media-sound/deadbeef-1.8.0
	dev-qt/qtcore:5=
"

RDEPEND="${DEPEND}"

src_prepare() {
    eapply_user
}

src_compile() {
    qmake "ddb_gui_qt5.pro"
    emake
}

src_install() {
	insinto /usr/lib64/deadbeef/
	doins ddb_gui_qt5.so
}
