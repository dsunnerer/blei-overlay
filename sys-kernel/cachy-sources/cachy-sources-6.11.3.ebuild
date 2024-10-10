# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="4"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"

inherit kernel-2 unpacker
detect_version
detect_arch

DESCRIPTION="Linux kernel with CachyOS patches"
HOMEPAGE="https://github.com/CachyOS/kernel-patches"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

KEYWORDS="~amd64 ~arm64 ~x86"

src_unpack() {
	kernel-2_src_unpack

	CACHY_PATCHES="${FILESDIR}/cachy-patches/6.11/all/0001-cachyos-base-all.patch
			${FILESDIR}/cachy-patches/6.11/sched/0001-bore-cachy.patch"


	for patch in ${CACHY_PATCHES[@]}; do
		einfo "Applying $patch"
		patch -f -p1 -i "$(echo "$patch" | sed 's/^\s*//' | sed 's/\s*$//')" || die "Applying patch failed: $patch"
	done
}

pkg_setup() {
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the zen developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_install() {
	kernel-2_src_install
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
