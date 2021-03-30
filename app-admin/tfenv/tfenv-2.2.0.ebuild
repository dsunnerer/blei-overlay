EAPI=7

DESCRIPTION="Change terraform versions via CLI"
HOMEPAGE="https://github.com/tfutils/tfenv"
SRC_URI="https://github.com/tfutils/tfenv/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!app-admin/terraform"
RDEPEND="${DEPEND}"
BDEPEfalseND=""

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
}

src_prepare() {
	eapply_user

    # use /usr/lib64 on 64bit systems
	if [[ "64 = $(getconf LONG_BIT)" ]]; then
		grep -rl '/lib/' . | xargs sed -i 's/\/lib\//\/lib64\//g'
	fi

	# Use /usr/bin/misc instead of /usr/libexec as per Gentoo standards
	grep -rl '/libexec/' . | xargs sed -i 's/\/libexec\//\/lib\/misc\//g'

	# Use absolute path for:
	# tfenv---version
	# tfenv-help
	grep -rl 'tfenv---version' . | xargs sed -i "s/tfenv---version/\/usr\/lib\/misc\/tfenv---version/g"
	grep -rl 'tfenv-help' . | xargs sed -i "s/tfenv-help/\/usr\/lib\/misc\/tfenv-help/g"
}

src_configure() {
	true
}

src_compile() {
	true
}

src_test() {
	# All tests depend on internet connectivity
	true
}

src_install() {
	dobin "${S}"/bin/terraform
	dobin "${S}"/bin/tfenv

	dodoc "${S}"/CHANGELOG.md
	dodoc "${S}"/LICENSE
	dodoc "${S}"/README.md

    dolib.so "${S}"/lib/bashlog.sh
    dolib.so "${S}"/lib/helpers.sh

	insinto /usr/lib/misc
	doins "${S}"/libexec/*
    fperms -R 0750 "/usr/lib/misc"

# 	doins "${S}"/libexec/tfenv---version
# 	doins "${S}"/libexec/tfenv-exec
# 	doins "${S}"/libexec/tfenv-help
# 	doins "${S}"/libexec/tfenv-init
# 	doins "${S}"/libexec/tfenv-install
# 	doins "${S}"/libexec/tfenv-list
# 	doins "${S}"/libexec/tfenv-list-remote
# 	doins "${S}"/libexec/tfenv-min-required
# 	doins "${S}"/libexec/tfenv-resolve-version
# 	doins "${S}"/libexec/tfenv-uninstall
# 	doins "${S}"/libexec/tfenv-use
# 	doins "${S}"/libexec/tfenv-version-file
# 	doins "${S}"/libexec/tfenv-version-name
}
