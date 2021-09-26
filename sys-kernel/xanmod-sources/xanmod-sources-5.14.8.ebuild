# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2-src-prepare-overlay
detect_version

DESCRIPTION="Full XanMod sources with cacule option and including the Gentoo patchset "
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
XANMOD_VERSION="1"
XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${XANMOD_URI}/5.14.6-xanmod${XANMOD_VERSION}-cacule/patch-5.14.6-xanmod${XANMOD_VERSION}-cacule.xz
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
		UNIPATCH_LIST="${DISTDIR}/patch-5.14.6-xanmod${XANMOD_VERSION}-cacule.xz
						${FILESDIR}/maple-tree-v2.patch"

	kernel-2-src-prepare-overlay_src_unpack

	## UKSM patch
	cd "${S}"
	patch -n -p1 -i "${FILESDIR}/uksm.patch" || die "UKSM patch failed to apply ..."
	# dirty fix
	sed -i 's/radix-tree\.o/radix-tree\.o sradix-tree.o/' "${S}/lib/Makefile"
	sed -i 's/SUBLEVEL = 6/SUBLEVEL = 8/' "${S}/Makefile"
}

src_prepare() {

	kernel-2-src-prepare-overlay_src_prepare

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
