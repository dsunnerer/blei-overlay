# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
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
		CACHY_PATCHES="${FILESDIR}/cachy-patches/5.16/0001-boot.patch
						${FILESDIR}/cachy-patches/5.16/0001-cachy.patch
						${FILESDIR}/cachy-patches/5.16/0001-amdpstate.patch
						${FILESDIR}/cachy-patches/5.16/0001-blk-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-fs-patches.patch
						${FILESDIR}/cachy-patches/5.16//0001-misc-new.patch
						${FILESDIR}/cachy-patches/5.16/0001-bitmap.patch
						${FILESDIR}/cachy-patches/5.16/0001-amd64-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-zstd-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-cpu.patch
						${FILESDIR}/cachy-patches/5.16/0001-sched-perf-fix.patch
						${FILESDIR}/cachy-patches/5.16/0001-bbr2-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-lrng.patch
						${FILESDIR}/cachy-patches/5.16/sched/0001-tt.patch
						${FILESDIR}/cachy-patches/5.16/0001-numa-pan.patch
						${FILESDIR}/cachy-patches/5.16/0001-numa-balanc.patch
						${FILESDIR}/maple-tree-v2-5.16.4.patch"

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
