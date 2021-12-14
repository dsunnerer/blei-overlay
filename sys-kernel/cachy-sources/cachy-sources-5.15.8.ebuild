# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
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
						#${FILESDIR}/cachy-patches/0001-block-backport.patch
						#${FILESDIR}/cachy-patches/0001-bfq.patch
						#${FILESDIR}/cachy-patches/0001-btrfs-patches.patch
						#${FILESDIR}/cachy-patches/0001-btrfs-fixes.patch
						#${FILESDIR}/cachy-patches/0001-cpufreq-patches.patch
						#${FILESDIR}/cachy-patches/0001-f2fs-backport.patch
						#${FILESDIR}/cachy-patches/0001-mm-lru.patch
						#${FILESDIR}/cachy-patches/0001-prjc.patch
						#${FILESDIR}/cachy-patches/0001-sbitmap-patches.patch
						#${FILESDIR}/cachy-patches/0001-sched-fix.patch
						#${FILESDIR}/cachy-patches/0001-sitemap.patch
						#${FILESDIR}/cachy-patches/0001-zstd-upstream-patches.patch
						#${FILESDIR}/cachy-patches/0001-sched.patch
						#${FILESDIR}/cachy-patches/bcachefs-patches/0001-bcachefs-5.15-introduce-bcachefs-patchset.patch
						#${FILESDIR}/cachy-patches/0001-le9.patch
						#${FILESDIR}/cachy-patches/0001-misc-patch.patch
						#${FILESDIR}/cachy-patches/0001-PGO.patch"
						#${FILESDIR}/cachy-patches/0001-MGLRU-v5.patch
						#${FILESDIR}/cachy-patches-integration/0001-damon.patch
						#${FILESDIR}/cachy-patches/0001-ksm-patches.patch
						#${FILESDIR}/cachy-patches-integration/0001-fix-tcp.patch
						#${FILESDIR}/cachy-patches/0001-tcp.patch
						#${FILESDIR}/cachy-patches/0001-speculative-patches.patch
						#${FILESDIR}/maple-tree-v2.patch
						#${FILESDIR}/cachy-patches/TT/0001-tt-r3.patch
		CACHY_PATCHES="${FILESDIR}/cachy-patches/AMD/0001-amd64-patches.patch
						${FILESDIR}/cachy-patches/AMD/0001-amd-c3.patch
						${FILESDIR}/cachy-patches-integration/0001-speculative.patch
						${FILESDIR}/cachy-patches/0001-bbr2.patch
						${FILESDIR}/cachy-patches/0001-block-patches.patch
						${FILESDIR}/cachy-patches/0001-block-sbitmap.patch
						${FILESDIR}/cachy-patches-integration/0001-btrfs-next.patch
						${FILESDIR}/cachy-patches/0001-ck-hrtimer.patch
						${FILESDIR}/cachy-patches/0001-clang.patch
						${FILESDIR}/cachy-patches/0001-cpu-patches.patch
						${FILESDIR}/cachy-patches/AMD/0001-amd-perf-v3.patch
						${FILESDIR}/cachy-patches-integration/0001-AMD-fix-pstate-perf.patch
						${FILESDIR}/cachy-patches/0001-futex.patch
						${FILESDIR}/cachy-patches/0001-lqx-patches.patch
						${FILESDIR}/cachy-patches/0001-lrng-patches.patch
						${FILESDIR}/cachy-patches-integration/0001-string.patch
						${FILESDIR}/cachy-patches/0001-xanmod-patches.patch
						${FILESDIR}/cachy-patches/0001-xfs-backport.patch
						${FILESDIR}/cachy-patches/0001-zen-patches.patch
						${FILESDIR}/cachy-patches/0001-zstd-patches-v2.patch
						${FILESDIR}/cachy-patches/TT/0001-tt-r3-cpu-fixes.patch
						${FILESDIR}/cachy-patches/TT/0001-tt-high-hz.patch
						${FILESDIR}/cachy-patches/arch-patches-v2/0001-arch-patches.patch
						${FILESDIR}/cachy-patches-integration/0001-misc.patch
						${FILESDIR}/cachy-patches/0001-pf-patches.patch
						${FILESDIR}/cachy-patches-integration/0001-fix-string.patch
						${FILESDIR}/cachy-patches/0001-fixes-miscellaneous.patch
						${FILESDIR}/maple-tree-v2.patch
						${FILESDIR}/cachy-patches/0004-tcp-optimizations.patch
						${FILESDIR}/cachy-patches-integration/0001-fix-tcp.patch
						${FILESDIR}/cachy-patches/AMD/amd-sched.patch"
	kernel-2-src-prepare-overlay_src_unpack

	for patch in ${CACHY_PATCHES[@]}; do
		einfo "Applying $patch"
		patch -f -p1 -i "$(echo "$patch" | sed 's/^\s*//' | sed 's/\s*$//')" || die "Applying patch failed: $patch"
	done

}

src_prepare() {
	kernel-2-src-prepare-overlay_src_prepare
	sed -i 's/SUBLEVEL\s*=\s*0/SUBLEVEL = 8/' "${S}"/Makefile
}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
