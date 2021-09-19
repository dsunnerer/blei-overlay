# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_jdk_build="1649.1"
MY_PV="${PV//\./_}"

DESCRIPTION="JetBrains JDK"
HOMEPAGE="https://github.com/JetBrains/JetBrainsRuntime"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dcevm fd +jcef nomod"
REQUIRED_USE="amd64 ( ^^ ( dcevm fd jcef nomod ) )"

SRC_URI="
  amd64? (
      dcevm? ( https://cache-redirector.jetbrains.com/intellij-jbr/jbr_dcevm-${MY_PV}-linux-x64-b${_jdk_build}.tar.gz )
      fd? ( https://cache-redirector.jetbrains.com/intellij-jbr/jbr_fd-${MY_PV}-linux-x64-b${_jdk_build}.tar.gz )
      jcef? ( https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${MY_PV}-linux-x64-b${_jdk_build}.tar.gz )
      nomod? ( https://cache-redirector.jetbrains.com/intellij-jbr/jbr_nomod-${MY_PV}-linux-x64-b${_jdk_build}.tar.gz )
  )
"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/jbr"

src_install() {
	dodir "/usr/lib/jvm/${PN}"
	cp -pRP * "${ED}/usr/lib/jvm/${PN}"

	insinto "/etc/profile.d"
	newins "${FILESDIR}/jbrsdk-r1.sh" jbrsdk.sh
}
