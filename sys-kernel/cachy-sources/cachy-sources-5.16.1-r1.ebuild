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
						#${FILESDIR}/cachy-patches/5.16/next/0006-lazy-mm.patch
						#${FILESDIR}/cachy-patches/5.16/0001-page-table-check.patch
						#${FILESDIR}/cachy-patches/5.16/next/0005-blake-next.patch
						#${FILESDIR}/cachy-patches/5.16/0001-tcp.patch
						#${FILESDIR}/cachy-patches/5.16/misc/0002-LL-elevator-set-default-scheduler-to-bfq-for-blk-mq.patch
						#${FILESDIR}/cachy-patches/5.16/0001-net-patches.patch
						#${FILESDIR}/cachy-patches/5.16/0001-blk-patches.patch
						#${FILESDIR}/cachy-patches/5.16/misc/0007-v5.16-winesync.patch
						#${FILESDIR}/cachy-patches/5.16/0001-futex.patch
						#${FILESDIR}/cachy-patches/5.16/0001-block-patches.patch
						#${FILESDIR}/cachy-patches/5.16/next/0001-mm-next.patch

						#${FILESDIR}/cachy-patches/5.16/0001-fixes-miscellaneous.patch
						#${FILESDIR}/cachy-patches/5.16/next/0001-bitmap-next.patch

						#implement fix
						#${FILESDIR}/cachy-patches/5.16/next/0004-rcu-next.patch
						#${FILESDIR}/cachy-patches/5.16/0001-fixes-misc.patch
		CACHY_PATCHES="${FILESDIR}/cachy-patches/5.16/misc/unused/0001-amd64-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-f2fs-xfs-ext4-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-zen-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-zstd-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-cpu.patch
						${FILESDIR}/cachy-patches/5.16/next/0002-mm-next.patch
						${FILESDIR}/cachy-patches/5.16/0001-sched-perf-fix.patch
						${FILESDIR}/cachy-patches/5.16/0001-lru-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-bbr2-patches.patch
						${FILESDIR}/cachy-patches/5.16/0001-lrng.patch
						${FILESDIR}/cachy-patches/5.16/0001-amdpstate.patch
						${FILESDIR}/cachy-patches/5.16/0001-misc.patch
						${FILESDIR}/cachy-patches/5.16/0001-btrfs.patch
						${FILESDIR}/cachy-patches/5.16/sched/0001-tt.patch
						${FILESDIR}/cachy-patches/5.16/next/0001-block-next.patch
						${FILESDIR}/cachy-patches/5.16/0001-clearlinux.patch
						${FILESDIR}/cachy-patches/5.16/misc/0001-blake2.patch
						${FILESDIR}/cachy-patches/5.16/0001-futex-winesync.patch
						${FILESDIR}/cachy-patches-integration/5.16/maple/0001-mapple-tree.patch
						${FILESDIR}/cachy-patches-integration/5.16/maple/maple-mmap.c.patch
						${FILESDIR}/cachy-patches-integration/5.16/maple/maple-task_mmu.patch
						${FILESDIR}/cachy-patches-integration/5.16/maple/maple-vaddr.c.patch"
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
