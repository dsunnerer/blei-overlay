# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
ETYPE="sources"

inherit eapi7-ver

K_USEPV="yes"
UNIPATCH_STRICTORDER="yes"
K_SECURITY_UNSUPPORTED="1"
GIT_COMMIT="5.13-9"

CKV="$(ver_cut 1-2)"
ETYPE="sources"

inherit kernel-2
#detect_version
K_NOSETEXTRAVERSION="don't_set_it"

DESCRIPTION="The Liquorix Kernel Sources v5.x"
HOMEPAGE="http://liquorix.net/"
LIQUORIX_VERSION="${GIT_COMMIT/_p[0-9]*}"
LIQUORIX_FILE="${P}.tar.gz"
LIQUORIX_URI="https://github.com/damentz/liquorix-package/archive/${LIQUORIX_VERSION}.tar.gz -> ${LIQUORIX_FILE}"
SRC_URI="${KERNEL_URI} ${LIQUORIX_URI}";

KEYWORDS="-* ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

KV_FULL="${PVR/_p/-pf}"
S="${WORKDIR}"/linux-"${KV_FULL}"

pkg_setup(){
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the Liquorix developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_unpack() {
	unpack "${LIQUORIX_FILE}"
	kernel-2_src_unpack
}

src_prepare(){
	# Taken from
	# https://github.com/damentz/liquorix-package/blob/5.6/linux-liquorix/debian/patches/series
	local lqx_patches="${WORKDIR}/liquorix-package-${GIT_COMMIT}/linux-liquorix/debian/patches"
	eapply "${lqx_patches}/zen/v${PV/_p/-lqx}.patch"

	# Probably don't need these.
	eapply "${lqx_patches}/debian/version.patch"
	eapply "${lqx_patches}/debian/uname-version-timestamp.patch"
	eapply "${lqx_patches}/debian/kernelvariables.patch"

	# Adds config options for OpenRC/Systemd
	eapply "${FILESDIR}"/4567_distro-Gentoo-Kconfig.patch

	# Maple Tree v2 patches
	eapply "${FILESDIR}/maple-tree-v2.patch"

	eapply_user
}

K_EXTRAEINFO="For more info on liquorix-sources and details on how to report problems, see: \
${HOMEPAGE}."
