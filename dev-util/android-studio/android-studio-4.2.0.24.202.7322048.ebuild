# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop

RESTRICT="strip"
QA_PREBUILT="
	opt/${PN}-${STUDIO_V}/bin/fsnotifier*
	opt/${PN}-${STUDIO_V}/bin/libdbm64.so
	opt/${PN}-${STUDIO_V}/bin/lldb/*
	opt/${PN}-${STUDIO_V}/lib/pty4j-native/linux/*/libpty.so
	opt/${PN}-${STUDIO_V}/plugins/android/lib/libwebp_jni*.so
	opt/${PN}-${STUDIO_V}/plugins/android/resources/installer/*
	opt/${PN}-${STUDIO_V}/plugins/android/resources/perfetto/*
	opt/${PN}-${STUDIO_V}/plugins/android/resources/simpleperf/*
	opt/${PN}-${STUDIO_V}/plugins/android/resources/transport/*
"

VER_CMP=( $(ver_rs 1- ' ') )
if [[ ${#VER_CMP[@]} -eq 6 ]]; then
	STUDIO_V=$(ver_cut 1-4)
	BUILD_V=$(ver_cut 5-6)
else
	STUDIO_V=$(ver_cut 1-3)
	BUILD_V=$(ver_cut 4-5)
fi

DESCRIPTION="Dedicated Android IDE"
HOMEPAGE="https://developer.android.com/sdk/installing/studio.html"
SRC_URI="https://dl.google.com/dl/android/studio/ide-zips/${STUDIO_V}/${PN}-ide-${BUILD_V}-linux.tar.gz"


LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux"

DEPEND="" #dev-java/commons-logging:0
	# dev-java/log4j:0"

RDEPEND="${DEPEND}
	dev-java/jetbrains-jre-bin
	dev-java/jansi-native
	dev-libs/libdbusmenu
	selinux? ( sec-policy/selinux-android )"
BDEPEND="dev-util/patchelf"

RESTRICT="strip splitdebug mirror"

src_unpack() {
	default_src_unpack

  P="${PN}-${STUDIO_V}.${BUILD_V}"
	mv android-studio "${P}"
}

src_prepare() {
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*

	rm -vrf "${S}"/jre

	#patchelf --replace-needed liblldb.so liblldb.so.9 "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend || die "Unable to patch LLDBFrontend for lldb"

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

#src_compile() {
#  patchelf --set-rpath '$ORIGIN' bin/lldb/lib/readline.so || die "Failed to fix insecure RPATH"
#}

src_install() {
	local dir="/opt/${PN}-${STUDIO_V}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,studio.sh,inspect.sh,printenv.py,restart.py,fsnotifier{,64}}

	dosym "${dir}/bin/studio.sh" "/usr/bin/${PN}"
	dosym "${dir}/bin/studio.png" "/usr/share/pixmaps/${PN}.png"
	make_desktop_entry "${PN}" "Android Studio" "${PN}" "Development;IDE;" "StartupWMClass=android-studio"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
