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
IUSE="jetbrains-jre selinux system-sdk-update-manager"

DEPEND="" #dev-java/commons-logging:0
	# dev-java/log4j:0"

RDEPEND="${DEPEND}
	dev-java/jansi-native
	dev-libs/libdbusmenu
	system-sdk-update-manager? ( dev-util/android-sdk-update-manager )
	selinux? ( sec-policy/selinux-android )
	jetbrains-jre? ( dev-java/jetbrains-jre-bin )
	|| ( >=virtual/jdk-1.7 )"
BDEPEND="" # dev-util/patchelf"

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

	# This is really a bundled jdk not a jre
	# If jetbrains-jre is not set bundled jre is replaced with system vm/jdk
	if use jetbrains-jre; then
		mv -f "${S}/jre" "${S}/custom-jdk" || die "Could not move bundled jdk"
	else
		rm -rf "${S}/jre" || die "Could not remove bundled jdk"
	fi

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
	local dir="/opt/${PN}-${STUDIO_V}"

	insinto "${dir}"
	doins -r *

	# This is really a bundled jdk not a jre
	# If jetbrains-jre is not set bundled jre is replaced with system vm/jdk
	if use jetbrains-jre; then
		dosym "../../usr/lib/jvm/jetbrains-jre-bin" "${dir}/jre"
	else
		dosym "../../etc/java-config-2/current-system-vm" "${dir}/jre"
	fi

	fperms 755 "${dir}"/bin/{format.sh,studio.sh,inspect.sh,printenv.py,restart.py,fsnotifier{,64}}

	dosym "${dir}/bin/studio.sh" "/usr/bin/${PN}"
	dosym "${dir}/bin/studio.png" "/usr/share/pixmaps/${PN}.png"
	make_desktop_entry "${PN}" "Android Studio" "${PN}" "Development;IDE;" "StartupWMClass=android-studio"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
