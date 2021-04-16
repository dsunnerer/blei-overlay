# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop

DESCRIPTION="C/C++ IDE"
HOMEPAGE="https://www.jetbrains.com/clion/"
SRC_URI="https://download.jetbrains.com/cpp/CLion-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-java/jetbrains-jre-bin
	dev-java/jansi-native
	dev-libs/libdbusmenu
	dev-util/lldb"
BDEPEND="dev-util/patchelf"

_IDE=clion

RESTRICT="strip splitdebug mirror"

S="${WORKDIR}/${_IDE}-${PV}"

src_prepare() {
	rm -r "${S}/jbr"
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

src_install() {
	local dir="/opt/${P}"
	dodir "${dir}"
	cp -a "${S}"/* "${ED}/${dir}/"

	dosym "${dir}/bin/${_IDE}.sh" "/usr/bin/${PN}"
	dosym "${dir}/bin/${_IDE}.svg" "/usr/share/pixmaps/${PN}.svg"
	make_desktop_entry "${PN}" "CLion" "${PN}" "Development;IDE;" "StartupWMClass=jetbrains-clion"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
