# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.4.0

EAPI=8

CRATES="
	addr2line-0.16.0
	adler-1.0.2
	aho-corasick-0.7.18
	annotate-snippets-0.5.0
	ansi_term-0.11.0
	assert_cmd-1.0.7
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.61
	base64-0.9.3
	base64-0.12.3
	base64-0.13.0
	bitflags-1.2.1
	bstr-0.2.16
	bumpalo-3.7.0
	bytecount-0.3.2
	byteorder-1.4.3
	bytes-0.4.12
	bytes-0.5.6
	bytes-1.0.1
	cargo-husky-1.5.0
	cast-0.2.7
	cc-1.0.69
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	chrono-tz-0.5.3
	clap-2.33.3
	clap-verbosity-flag-0.2.0
	console-0.14.1
	criterion-0.3.5
	criterion-plot-0.4.4
	crossbeam-channel-0.3.9
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.0
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.6.6
	crossbeam-utils-0.8.5
	csv-1.1.6
	csv-core-0.1.10
	difference-2.0.0
	difflib-0.4.0
	doc-comment-0.3.3
	dtparse-1.2.0
	either-1.6.1
	encode_unicode-0.3.6
	encoding_rs-0.8.28
	env_logger-0.5.13
	exitfailure-0.5.1
	failure-0.1.8
	failure_derive-0.1.8
	float-cmp-0.8.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	fs_extra-1.2.0
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	futures-channel-0.3.16
	futures-core-0.3.16
	futures-io-0.3.16
	futures-macro-0.3.16
	futures-sink-0.3.16
	futures-task-0.3.16
	futures-util-0.3.16
	getopts-0.2.21
	getrandom-0.2.3
	gimli-0.25.0
	glob-0.2.11
	glob-0.3.0
	globset-0.4.8
	globwalk-0.3.1
	h2-0.2.7
	half-1.7.1
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	http-0.2.4
	http-body-0.3.1
	httparse-1.4.1
	httpdate-0.3.2
	human-panic-1.0.3
	humantime-1.3.0
	hyper-0.13.10
	hyper-old-types-0.11.0
	hyper-rustls-0.21.0
	idna-0.2.3
	ignore-0.4.18
	im-13.0.0
	include_dir-0.2.1
	include_dir_impl-0.2.1
	indexmap-1.7.0
	indicatif-0.13.0
	iovec-0.1.4
	ipnet-2.3.1
	itertools-0.8.2
	itertools-0.10.1
	itoa-0.4.7
	jemalloc-sys-0.3.2
	jemallocator-0.3.2
	js-sys-0.3.51
	kernel32-sys-0.2.2
	language-tags-0.2.2
	lazy_static-1.4.0
	libc-0.2.98
	log-0.4.14
	logfmt-0.0.2
	maplit-1.0.2
	matches-0.1.8
	memchr-2.4.0
	memoffset-0.6.4
	mime-0.3.16
	mime_guess-2.0.3
	miniz_oxide-0.4.4
	mio-0.6.23
	miow-0.2.2
	net2-0.2.37
	nom-4.2.3
	nom_locate-0.3.1
	normalize-line-endings-0.3.0
	num-0.2.1
	num-bigint-0.2.6
	num-complex-0.2.4
	num-derive-0.2.5
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.2.4
	num-traits-0.2.14
	num_cpus-1.13.0
	number_prefix-0.3.0
	object-0.26.0
	once_cell-1.8.0
	oorandom-11.1.3
	ordered-float-2.7.0
	os_type-2.3.0
	parse-zoneinfo-0.3.0
	percent-encoding-1.0.1
	percent-encoding-2.1.0
	pin-project-1.0.8
	pin-project-internal-1.0.8
	pin-project-lite-0.1.12
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	plotters-0.3.1
	plotters-backend-0.3.2
	plotters-svg-0.3.1
	ppv-lite86-0.2.10
	predicates-1.0.8
	predicates-2.0.1
	predicates-core-1.0.2
	predicates-tree-1.0.2
	proc-macro-hack-0.4.3
	proc-macro-hack-0.5.19
	proc-macro-hack-impl-0.4.3
	proc-macro-nested-0.1.7
	proc-macro2-0.4.30
	proc-macro2-1.0.28
	pulldown-cmark-0.2.0
	quantiles-0.7.1
	quick-error-1.2.3
	quick-xml-0.17.2
	quicli-0.4.0
	quote-0.6.13
	quote-1.0.9
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.9
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	reqwest-0.10.10
	ring-0.16.20
	rust_decimal-0.10.2
	rustc-demangle-0.1.20
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustls-0.18.1
	ryu-1.0.5
	safemem-0.3.3
	same-file-1.0.6
	scopeguard-1.1.0
	sct-0.6.1
	self_update-0.19.0
	semver-0.9.0
	semver-1.0.3
	semver-parser-0.7.0
	serde-1.0.126
	serde_cbor-0.11.1
	serde_derive-1.0.126
	serde_json-1.0.64
	serde_urlencoded-0.7.0
	sized-chunks-0.3.1
	slab-0.4.3
	socket2-0.3.19
	spin-0.5.2
	strfmt-0.1.6
	strsim-0.8.0
	structopt-0.2.18
	structopt-derive-0.2.18
	syn-0.14.9
	syn-0.15.44
	syn-1.0.74
	synstructure-0.12.5
	tempfile-3.2.0
	termcolor-1.1.2
	terminal_size-0.1.17
	test-generator-0.3.0
	textwrap-0.11.0
	thread_local-1.1.3
	time-0.1.43
	tinytemplate-1.2.1
	tinyvec-1.3.1
	tinyvec_macros-0.1.0
	tokio-0.2.25
	tokio-rustls-0.14.1
	tokio-util-0.3.1
	toml-0.4.10
	toml-0.5.8
	tower-service-0.3.1
	tracing-0.1.26
	tracing-core-0.1.18
	tracing-futures-0.2.5
	treeline-0.1.0
	try-lock-0.2.3
	typenum-1.13.0
	unicase-2.6.0
	unicode-bidi-0.3.5
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.8
	unicode-xid-0.1.0
	unicode-xid-0.2.2
	untrusted-0.7.1
	url-2.2.2
	uuid-0.8.2
	vec_map-0.8.2
	version_check-0.1.5
	version_check-0.9.3
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.74
	wasm-bindgen-backend-0.2.74
	wasm-bindgen-futures-0.4.24
	wasm-bindgen-macro-0.2.74
	wasm-bindgen-macro-support-0.2.74
	wasm-bindgen-shared-0.2.74
	web-sys-0.3.51
	webpki-0.21.4
	webpki-roots-0.20.0
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.7.0
	ws2_32-sys-0.2.1
"

inherit cargo

DESCRIPTION="CLI App to slice and dice logfiles"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/rcoh/angle-grinder"
SRC_URI="https://github.com/rcoh/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"
# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
  cargo_src_unpack
}

src_configure() {
  cargo_gen_config
}

src_compile() {
  cargo_src_compile
}

pkg_install() {
 dobin "${S}/agrinder"
}