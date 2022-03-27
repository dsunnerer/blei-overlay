# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop

DESCRIPTION="JS/TS IDE"
HOMEPAGE="https://www.jetbrains.com/webstorm/"
SRC_URI="https://download.jetbrains.com/webstorm/WebStorm-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-java/jetbrains-jre-bin
	dev-java/jansi-native
	dev-libs/libdbusmenu"
BDEPEND="dev-util/patchelf"

_PV="213.7172.31"
_CAP_IDE=WebStorm
_IDE=webstorm

RESTRICT="strip splitdebug mirror"

S="${WORKDIR}/${_CAP_IDE}-${_PV}"

src_prepare() {
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*
	rm -vrf "${S}"/jbr

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

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,${_IDE}.sh,inspect.sh,printenv.py,restart.py,fsnotifier}

	dosym "${dir}/bin/${_IDE}.sh" "/usr/bin/${PN}"
	dosym "${dir}/bin/${_IDE}.png" "/usr/share/pixmaps/${PN}.png"
	make_desktop_entry "${PN}" "${_CAP_IDE}" "${PN}" "Development;IDE;" "StartupWMClass=jetbrains-${IDE}"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
