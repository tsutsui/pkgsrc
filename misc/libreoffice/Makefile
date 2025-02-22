# $NetBSD: Makefile,v 1.353 2025/02/05 03:50:01 ryoon Exp $

VERREL=		25.2.0
VERRC=		3
VER=		${VERREL}.${VERRC}
DISTNAME=	libreoffice-${VER}
CATEGORIES=	misc
MASTER_SITES=	http://download.documentfoundation.org/libreoffice/src/${VERREL}/
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	ryoon@NetBSD.org
HOMEPAGE=	https://www.libreoffice.org/
COMMENT=	Office productivity suite from The Document Foundation
LICENSE=	gnu-lgpl-v3

UNLIMIT_RESOURCES+=	cputime

# configure script checks the version of GCC.
GCC_REQD+=	12

USE_LANGUAGES=	c c++

USE_CXX_FEATURES+=	c++20

# Needed to get a proper (builtin) definition of alloca(3) on NetBSD.
# Mixture of C++11, C++20 and so on. Do not override standards in Makefiles.
BUILDLINK_TRANSFORM+=	opt:-std=c++17:-std=gnu++17
BUILDLINK_TRANSFORM+=	opt:-std=c++1z:-std=gnu++1z
BUILDLINK_TRANSFORM+=	opt:-std=c++2a:-std=gnu++2a
BUILDLINK_TRANSFORM+=	opt:-std=c++20:-std=gnu++20
CONFIG_SHELL=		${BASH}

SUBST_CLASSES+=			use-bash
SUBST_STAGE.use-bash=		pre-configure
SUBST_MESSAGE.use-bash=		Using bash for configure script
SUBST_FILES.use-bash+=		autogen.sh
SUBST_VARS.use-bash+=		BASH

SUBST_CLASSES+=			configure-paths
SUBST_STAGE.configure-paths=	pre-configure
SUBST_MESSAGE.configure-paths=	Fixing paths in configure.ac
SUBST_FILES.configure-paths+=	configure.ac
SUBST_SED.configure-paths+=	-e 's,-I/usr/include/dragonbox-1.1.3,-I${BUILDLINK_PREFIX.dragonbox}/include/dragonbox-1.1.3,'
SUBST_SED.configure-paths+=	-e 's,-I/usr/include/gpgme++,-I${BUILDLINK_PREFIX.gpgme}/include/gpgme++,'
#SUBST_SED.zxing+=		-e 's,ZXING_CFLAGS=-I/usr/include/ZXing,ZXING_CFLAGS=-I${BUILDLINK_PREFIX.zxing-cpp}/include/ZXing,'
SUBST_VARS.configure-paths+=	PREFIX COMPILER_RPATH_FLAG

SUBST_CLASSES+=			font-path
SUBST_STAGE.font-path=		pre-configure
SUBST_MESSAGE.font-path=	Use pkgsrc fonts for PDF import
SUBST_FILES.font-path+=		external/pdfium/pkgsrc.patch.1
SUBST_VARS.font-path+=		X11BASE

BUILD_TARGET=	build

.include "../../mk/bsd.prefs.mk"
pre-build:
	# Workaround for external openldap
	${MKDIR} ${WRKSRC}/workdir/ExternalProject
.if ${OPSYS} == "NetBSD"
	cd ${WRKSRC} && \
	${BUILD_MAKE_CMD} Executable_gengal && \
	${TOOLS_PLATFORM.paxctl} +m instdir/program/gengal.bin
.endif

PYTHON_VERSIONS_INCOMPATIBLE=	27

CHECK_SHLIBS_SUPPORTED=	no
# configure will be regenerated.
CHECK_PORTABILITY_SKIP=	configure

NOT_PAX_MPROTECT_SAFE+=	${PKGNAME_NOREV}/lib/libreoffice/program/soffice.bin

DIST_SUBDIR=	libreoffice

LO_BOOTSTRAP=	${DISTNAME}
LO_COMPONENTS=	dictionaries translations # help

DISTFILES+=	${LO_BOOTSTRAP}${EXTRACT_SUFX}
EXTRACT_ONLY=	${LO_BOOTSTRAP}${EXTRACT_SUFX}

.for component in ${LO_COMPONENTS}
DISTFILES+=		libreoffice-${component}-${VER}.tar.xz
EXTRACT_ONLY+=		libreoffice-${component}-${VER}.tar.xz
.endfor

MORE_DISTFILES= \
	breakpad-b324760c7f53667af128a6b77b790323da04fcb9.tar.xz \
	0168229624cfac409e766913506961a8-ucpp-1.3.2.tar.gz \
	liberation-narrow-fonts-ttf-1.07.6.tar.gz \
	liberation-fonts-ttf-2.1.5.tar.gz \
	907d6e99f241876695c19ff3db0b8923-source-code-pro-2.030R-ro-1.050R-it.tar.gz \
	edc4d741888bc0d38e32dbaa17149596-source-sans-pro-2.010R-ro-1.065R-it.tar.gz \
	source-serif-pro-3.000R.tar.gz \
	xmlsec1-1.3.6.tar.gz \
	3404ab6b1792ae5f16bbd603bd1e1d03-libformula-1.1.7.zip \
	35c94d2df8893241173de1d16b6034c0-swingExSrc.zip \
	39bb3fcea1514f1369fcfc87542390fd-sacjava-1.3.zip \
	3bdf40c0d199af31923e900d082ca2dd-libfonts-1.1.6.zip \
	a8c2c5b8f09e7ede322d5c602ff6a4b6-mythes-1.2.4.tar.gz \
	8ce2fcd72becf06c41f7201d15373ed9-librepository-1.1.6.zip \
	97b2d4dba862397f446b217e2b623e71-libloader-1.1.6.zip \
	a7983f859eafb2677d7ff386a023bc40-xsltml_2.1.2.zip \
	ace6ab49184e329db254e454a010f56d-libxml-1.1.7.zip \
	ba2930200c9f019c2d93a8c88c651a0f-flow-engine-0.9.4.zip \
	db60e4fde8dd6d6807523deb71ee34dc-liblayout-0.2.10.zip \
	d8bd5eed178db6e2b18eeed243f85aa8-flute-1.1.6.zip \
	bsh-2.1.1-src.zip \
	e7a384790b13c29113e22e596ade9687-LinLibertineG-20120116.zip \
	eeb2c7ddf0d302fba4bfc6e97eac9624-libbase-1.1.6.zip \
	33e1e61fab06a547851ed308b4ffef42-dejavu-fonts-ttf-2.37.zip \
	f94d9870737518e3b597f9265f4e9803-libserializer-1.1.6.zip \
	mariadb-connector-c-3.3.13-src.tar.gz \
	rhino-1.7.15.zip \
	368f114c078f94214a308a74c7e991bc-crosextrafonts-20130214.tar.gz \
	language-subtag-registry-2021-08-06.tar.bz2 \
	postgresql-14.15.tar.bz2 \
	graphite2-minimal-1.3.14.tgz \
	1725634df4bb3dcb1b2c91a6175f8789-GentiumBasic_1102.zip \
	EmojiOneColor-SVGinOT-1.3.tar.gz \
	alef-1.001.tar.gz \
	c74b7223abe75949b4af367942d96c7a-crosextrafonts-carlito-20130920.tar.gz \
	culmus-0.140.tar.gz \
	ttf-kacst_2.01+mry.tar.gz \
	libre-hebrew-1.0.tar.gz \
	noto-fonts-20171024.tar.gz \
	Scheherazade-2.100.zip \
	lxml-4.1.1.tgz \
	Amiri-1.000.zip \
	ReemKufi-1.7.zip \
	pdfium-6764.tar.bz2 \
	dtoa-20180411.tgz \
	skia-m130-3c64459d5df2fa9794b277f0959ed8a92552bf4c.tar.xz \
	Java-WebSocket-1.6.0.tar.gz \
	NotoSans-v2.015.zip \
	NotoSerif-v2.015.zip \
	NotoSansHebrew-v3.001.zip \
	NotoSansArabic-v2.010.zip \
	NotoKufiArabic-v2.109.zip \
	NotoNaskhArabic-v2.019.zip \
	NotoSerifHebrew-v2.004.zip \
	NotoSansArmenian-v2.008.zip \
	NotoSerifArmenian-v2.008.zip \
	NotoSansGeorgian-v2.005.zip \
	NotoSerifGeorgian-v2.003.zip \
	NotoSansLao-v2.003.zip \
	NotoSerifLao-v2.003.zip \
	NotoSansLisu-v2.102.zip

.for md in ${MORE_DISTFILES}
DISTFILES+=		${md}
SITES.${md}=		https://dev-www.libreoffice.org/src/
.endfor

MORE_DISTFILES2+=	f543e6e2d7275557a839a164941c0a86e5f2c3f2a0042bfc434c88c6dde9e140-opens___.ttf \
			odfvalidator-0.9.0-RC2-SNAPSHOT-jar-with-dependencies-2726ab578664434a545f8379a01a9faffac0ae73.jar \
			8249374c274932a21846fa7629c2aa9b-officeotron-0.7.4-master.jar
.for md in ${MORE_DISTFILES2}
SITES.${md}=		https://dev-www.libreoffice.org/extern/
.endfor

.include "../../graphics/librsvg/available.mk"
.if ${LIBRSVG_TYPE} == "c" || make(distinfo) || make(mdi)
MORE_DISTFILES2+=		harfbuzz-3.3.1.tar.xz
SITES.harfbuzz-3.3.1.tar.xz=	https://github.com/harfbuzz/harfbuzz/releases/download/3.3.1/
.endif

.for md2 in ${MORE_DISTFILES2}
DISTFILES+=		${md2}
.endfor

.include "options.mk"

# tar: Invalid header, starting valid header search.
EXTRACT_USING=		bsdtar

WRKSRC=		${WRKDIR}/${LO_BOOTSTRAP}

TOOL_DEPENDS+=		p5-Archive-Zip-[0-9]*:../../archivers/p5-Archive-Zip
DEPENDS+=		xdg-utils-[0-9]*:../../misc/xdg-utils
DEPENDS+=		gnupg2-[0-9]*:../../security/gnupg2

LDFLAGS+=		-lboost_system

USE_LIBTOOL=		yes
# Use GNU find from findutils.
TOOLS_PLATFORM.find=	# empty
# GUN tar is really needed. Some Makefiles depends on GNUTAR.
USE_TOOLS+=		automake bash bison gmake gsed gtar
USE_TOOLS+=		msgfmt perl pkg-config unzip zip
PTHREAD_OPTS+=		require

HAS_CONFIGURE=		yes

CXXFLAGS.NetBSD+=	-DNO_CPLUSPLUS_ALLOCA

# Do not use /tmp, outside of WRKSRC.
CONFIGURE_ENV+=		TMPDIR=${WRKSRC}/tmp
CONFIGURE_ENV+=		ANT_LIB=${PREFIX}/lib/java/ant
CONFIGURE_ENV+=		ac_cv_path_GPG=${PREFIX}/bin/gpg2

MAKE_JOBS_SAFE=		no # --with-parallelism conficts with -jN
.if !empty(MAKE_JOBS.${PKGPATH})
CONFIGURE_ARGS+=	--with-parallelism=${MAKE_JOBS.${PKGPATH}}
.elif !empty(MAKE_JOBS)
CONFIGURE_ARGS+=	--with-parallelism=${MAKE_JOBS}
.else
CONFIGURE_ARGS+=	--with-parallelism=1
.endif


CONFIGURE_ARGS+=	--prefix=${PREFIX}/${PKGNAME_NOREV}
CONFIGURE_ARGS+=	--disable-ccache
CONFIGURE_ARGS+=	--disable-epm
CONFIGURE_ARGS+=	--disable-fetch-external
CONFIGURE_ARGS+=	--disable-firebird-sdbc
CONFIGURE_ARGS+=	--disable-odk
CONFIGURE_ARGS+=	--disable-sdremote-bluetooth
# Enabling GIO causes error. losessioninstall.component not found.
CONFIGURE_ARGS+=	--disable-gio
# Use PDFium instead of poppler for PDF import since 6.3.2.2nb1
CONFIGURE_ARGS+=	--enable-pdfium --disable-poppler
#CONFIGURE_ARGS+=	--disable-pdfium --disable-poppler --disable-pdfimport
CONFIGURE_ARGS+=	--enable-gstreamer-1-0
CONFIGURE_ARGS+=	--enable-python=system
CONFIGURE_ARGS+=	--enable-ext-wiki-publisher
CONFIGURE_ARGS+=	--enable-ext-nlpsolver
CONFIGURE_ARGS+=	--with-system-gpgmepp
#CONFIGURE_ARGS+=	--without-system-jpeg
CONFIGURE_ARGS+=	--with-system-jpeg
CONFIGURE_ARGS+=	--without-system-postgresql
CONFIGURE_ARGS+=	--without-system-mariadb
CONFIGURE_ARGS+=	--without-system-rhino
CONFIGURE_ARGS+=	--without-system-xmlsec # Needs NSS support
CONFIGURE_ARGS+=	--with-system-zxing
CONFIGURE_ENV+=		CPLUS_INCLUDE_PATH=${BUILDLINK_PREFIX.zxing-cpp}/include
CONFIGURE_ARGS+=	--with-system-libcmis
CONFIGURE_ARGS+=	--with-compat-oowrappers
CONFIGURE_ARGS+=	--with-external-tar=${WRKSRC}/src
CONFIGURE_ARGS+=	--with-fonts
CONFIGURE_ARGS+=	--with-lang="ALL"
CONFIGURE_ARGS+=	--with-myspell-dicts
CONFIGURE_ARGS+=	--with-boost-libdir=${BUILDLINK_PREFIX.boost-libs}/lib
CONFIGURE_ARGS+=	--with-system-libs
CONFIGURE_ARGS+=	--with-system-dicts
CONFIGURE_ARGS+=	--with-vendor="pkgsrc"
CONFIGURE_ARGS+=	--with-tls="nss"
CONFIGURE_ARGS+=	--with-system-nss
CONFIGURE_ARGS+=	--without-doxygen
CONFIGURE_ARGS+=	--without-junit
CONFIGURE_ARGS+=	--without-krb5
CONFIGURE_ARGS+=	--without-gssapi
CONFIGURE_ARGS+=	--with-system-cppunit
# internal sane should be used because only header files are used.
CONFIGURE_ARGS+=	--without-system-sane
.if ${LIBRSVG_TYPE} == "rust"
CONFIGURE_ARGS+=	--with-system-harfbuzz
CONFIGURE_ARGS+=	--with-system-graphite
.else
# Use internal harfbuzz because fonts/harfbuzz has no graphite2 support.
CONFIGURE_ARGS+=	--without-system-harfbuzz
CONFIGURE_ARGS+=	--without-system-graphite
.endif
# sbin might not be in PATH
CONFIGURE_ARGS+=	ac_cv_path_SYSTEM_GENCCODE=${BUILDLINK_PREFIX.icu}/sbin/genccode
CONFIGURE_ARGS+=	ac_cv_path_SYSTEM_GENCMN=${BUILDLINK_PREFIX.icu}/sbin/gencmn
CONFIGURE_ARGS+=	--with-system-libtommath
CONFIGURE_ARGS+=	--with-system-openjpeg
#CONFIGURE_ARGS+=	--with-help
CONFIGURE_ARGS+=	--without-system-java-websocket

LO_PROGRAMS=		libreoffice lobase localc lodraw loffice
LO_PROGRAMS+=		lofromtemplate loimpress lomath loweb lowriter
# Base depends on java, we don't install the icon
#LO_DESKTOP_FILES=	calc.desktop draw.desktop impress.desktop math.desktop \
#			startcenter.desktop writer.desktop

CONFIGURE_SCRIPT=	${WRKSRC}/autogen.sh

MAKE_ENV+=		ROOT_USER=${ROOT_USER}
MAKE_ENV+=		ROOT_GROUP=${ROOT_GROUP}
MAKE_ENV+=		SHELL=${BASH:Q}
BUILD_MAKE_FLAGS+=	VERBOSE=true

.if ${MACHINE_ARCH} == "i386"
# XXX: avoid unexpected substitution in the include path (work.i386 -> work.1)
#      when ${OBJMACHINE} is set (PR/56440)
CFLAGS+=		-Ui386
.endif

.include "../../mk/dlopen.buildlink3.mk"
BUILDLINK_TRANSFORM+=	opt:-ldl:${BUILDLINK_LDADD.dl:Q}

INSTALLATION_DIRS=	bin share/applications

CHECK_WRKREF_SKIP+=	${PKGNAME_NOREV}/lib/libreoffice/program/libsofficeapp.so

.PHONY: debugrun
# For debugging
debugrun:
	cd ${WRKSRC} && gmake debugrun

post-extract:
	${MKDIR} -p ${WRKSRC}/src
.for md in ${MORE_DISTFILES} ${MORE_DISTFILES2}
	${LN} -s ${DISTDIR}/${DIST_SUBDIR}/${md} ${WRKSRC}/src/${md}
.endfor
	mkdir ${WRKSRC}/tmp

pre-configure: provide-python3

.PHONY: provide-python3
provide-python3:
	# install phase uses python3 command
	[ -h "${BUILDLINK_DIR}/bin/python3" ] || ${LN} -s ${PYTHONBIN} "${BUILDLINK_DIR}/bin/python3"

do-install:
	cd ${WRKSRC} && make DESTDIR="${DESTDIR}" PREFIXDIR="${PREFIX}" distro-pack-install
# make install cleans ${DESTDIR}${PREFIX}/*, so bin etc. are removed.
.for d in ${INSTALLATION_DIRS}
	cd ${DESTDIR}${PREFIX} && \
		${MKDIR} ${d}
.endfor

BUILD_DEFS+=	PYTHONBIN

post-install:
.for f in ${LO_PROGRAMS}
	cd ${DESTDIR}${PREFIX}/bin && ${LN} -s ../${PKGNAME_NOREV}/bin/${f}
.endfor

.include "../../archivers/bzip2/buildlink3.mk"
.include "../../converters/libabw/buildlink3.mk"
.include "../../converters/libcdr/buildlink3.mk"
.include "../../converters/libe-book/buildlink3.mk"
.include "../../converters/libepubgen/buildlink3.mk"
BUILDLINK_API_DEPENDS.libetonyek+=	libetonyek>=0.1.2
.include "../../converters/libetonyek/buildlink3.mk"
.include "../../converters/libfreehand/buildlink3.mk"
.include "../../converters/librevenge/buildlink3.mk"
.include "../../converters/libmspub/buildlink3.mk"
.include "../../converters/libpagemaker/buildlink3.mk"
.include "../../converters/libqxp/buildlink3.mk"
.include "../../converters/libstaroffice/buildlink3.mk"
.include "../../converters/libvisio/buildlink3.mk"
.include "../../converters/libwpd/buildlink3.mk"
.include "../../converters/libwpg/buildlink3.mk"
.include "../../converters/libwps/buildlink3.mk"
.include "../../converters/libmwaw/buildlink3.mk"
.include "../../converters/libzmf/buildlink3.mk"
.include "../../converters/orcus/buildlink3.mk"
.include "../../databases/db4/buildlink3.mk"
#.include "../../mk/mysql.buildlink3.mk"
.include "../../databases/shared-mime-info/buildlink3.mk"
.include "../../databases/unixodbc/buildlink3.mk"
.include "../../devel/abseil/buildlink3.mk"
.include "../../devel/apr-util/buildlink3.mk"
.include "../../devel/boost-headers/buildlink3.mk"
.include "../../devel/boost-libs/buildlink3.mk"
.include "../../devel/cppunit/buildlink3.mk"
.include "../../devel/frozen/buildlink3.mk"
.include "../../devel/gperf/buildlink3.mk"
#.include "../../devel/jemalloc/buildlink3.mk"
.include "../../devel/libexecinfo/buildlink3.mk"
.include "../../devel/liblangtag/buildlink3.mk"
.include "../../devel/mdds/buildlink3.mk"
.include "../../devel/nss/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../fonts/fontconfig/buildlink3.mk"
# harfbuzz with graphite2 support is required.
.if ${LIBRSVG_TYPE} == "rust"
#BUILDLINK_API_DEPENDS.harfbuzz+=	harfbuzz>=1.4.2
.include "../../fonts/harfbuzz/buildlink3.mk"
.include "../../fonts/harfbuzz-icu/buildlink3.mk"
.include "../../graphics/graphite2/buildlink3.mk"
.endif
.include "../../mk/jpeg.buildlink3.mk"
.include "../../graphics/box2d/buildlink3.mk"
.include "../../graphics/cairo/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.include "../../graphics/gdk-pixbuf2-xlib/buildlink3.mk"
.include "../../graphics/glew/buildlink3.mk"
.include "../../graphics/glu/buildlink3.mk"
.include "../../graphics/glm/buildlink3.mk"
.include "../../graphics/lcms2/buildlink3.mk"
.include "../../graphics/libepoxy/buildlink3.mk"
.include "../../graphics/librsvg/buildlink3.mk"
.include "../../graphics/libwebp/buildlink3.mk"
.include "../../graphics/openjpeg/buildlink3.mk"
.include "../../graphics/png/buildlink3.mk"
.include "../../graphics/zxing-cpp/buildlink3.mk"
#.include "../../graphics/sane-backends/buildlink3.mk"
#.include "../../graphics/vigra/buildlink3.mk"
.include "../../lang/python/batteries-included.mk"
.include "../../lang/python/application.mk"
# workaround for dtoa.h conflict with python and dtoa:
# Do not pass -I${PREFIX}/include/python?.? to CPPFLAGS/CFLAGS/CXXFLAGS always.
BUILDLINK_INCDIRS.${PYPKGPREFIX:S/py/python/}=	# empty
.include "../../lang/python/tool.mk"
.include "../../math/coinmp/buildlink3.mk"
.include "../../math/dragonbox/buildlink3.mk"
.include "../../math/libfixmath/buildlink3.mk"
BUILDLINK_API_DEPENDS.libnumbertext+=	libnumbertext>=1.0.6
.include "../../math/libnumbertext/buildlink3.mk"
.include "../../math/lp_solve/buildlink3.mk"
.include "../../math/ltm/buildlink3.mk"
.include "../../multimedia/gstreamer1/buildlink3.mk"
.include "../../multimedia/gst-plugins1-base/buildlink3.mk"
.include "../../net/libcmis/buildlink3.mk"
.include "../../net/mDNSResponder/buildlink3.mk"
# Use PDFium instead of poppler for PDF import since 6.3.2.2nb1
#.include "../../print/poppler-cpp/buildlink3.mk"
#.include "../../print/poppler-includes/buildlink3.mk"
.include "../../security/argon2/buildlink3.mk"
.include "../../security/gpgme/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../security/zxcvbn-c/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../textproc/hunspell/buildlink3.mk"
.include "../../textproc/hyphen/buildlink3.mk"
.include "../../textproc/icu/buildlink3.mk"
.include "../../textproc/libclucene/buildlink3.mk"
BUILDLINK_API_DEPENDS.libodfgen+=       libodfgen>=0.1.4
.include "../../textproc/libodfgen/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../textproc/libxslt/buildlink3.mk"
.include "../../textproc/redland/buildlink3.mk"
.include "../../textproc/libexttextcat/buildlink3.mk"
.include "../../textproc/mythes/buildlink3.mk"
.include "../../textproc/raptor2/buildlink3.mk"
.include "../../textproc/rasqal/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../www/neon/buildlink3.mk"
.include "../../www/serf/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXcursor/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libXfixes/buildlink3.mk"
.include "../../x11/libXi/buildlink3.mk"
.include "../../x11/libXinerama/buildlink3.mk"
.include "../../x11/libXrandr/buildlink3.mk"
.include "../../x11/libXrender/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"
.include "../../x11/pixman/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../graphics/gnome-icon-theme/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../mk/atomic64.mk"
.include "../../mk/bsd.pkg.mk"
