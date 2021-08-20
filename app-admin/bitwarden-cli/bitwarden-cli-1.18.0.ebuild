# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The command line vault"
HOMEPAGE="https://bitwarden.com"
SRC_URI="https://github.com/bitwarden/cli/releases/download/v${PV}/bw-linux-${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

DEPEND="app-arch/unzip"
RDEPEND=""

# stripping breaks the webpack binary
RESTRICT=strip

src_unpack() {
	default
	mkdir "${S}"
	mv bw "${S}/"
}

src_compile() {
	chmod u+x bw

	use zsh-completion && ./bw completion --shell zsh > _bw
}

src_install() {
	dobin bw

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins _bw
	fi
}
