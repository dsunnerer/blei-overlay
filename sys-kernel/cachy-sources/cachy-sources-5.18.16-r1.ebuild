# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="19"
UNIPATCH_STRICTORDER="1"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2-src-prepare-overlay
detect_version

DESCRIPTION="Kernel with a nice sounding set of cachyos patches and maple-tree v2 on top"
HOMEPAGE="https://github.com/ptr1337/kernel-patches"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
			#${FILESDIR}/cachy-patches/5.18/trunk/0001-ksm.patch
		CACHY_PATCHES="${FILESDIR}/cachy-patches/5.18/0002-cachy.patch
						${FILESDIR}/cachy-patches/5.18/sched/0001-tt-cachy-5.18.patch
						${FILESDIR}/cachy-patches/5.18/0004-fixes.patch
						${FILESDIR}/cachy-patches/5.18/0007-lru-le9-spf.patch
						${FILESDIR}/cachy-patches/5.18/0006-lrng.patch
						${FILESDIR}/cachy-patches/5.18/0009-misc.patch
						${FILESDIR}/cachy-patches/5.18/0010-futex-winesync.patch
						${FILESDIR}/cachy-patches/5.18/0011-rcu.patch
						${FILESDIR}/cachy-patches/5.18/0013-fs-patches.patch
						${FILESDIR}/cachy-patches/5.18/0014-perf.patch
						${FILESDIR}/9001-clang-pgo-kees.patch
						${FILESDIR}/maple-jun21.patch"

	kernel-2-src-prepare-overlay_src_unpack

	for patch in ${CACHY_PATCHES[@]}; do
		einfo "Applying $patch"
		patch -f -p1 -i "$(echo "$patch" | sed 's/^\s*//' | sed 's/\s*$//')" || die "Applying patch failed: $patch"
	done

}

src_prepare() {
	kernel-2-src-prepare-overlay_src_prepare
	sed -i "s|SUBLEVEL\s*=\s*0|SUBLEVEL = $(echo $PV | cut -d '.' -f 3)|" "${S}"/Makefile
}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
