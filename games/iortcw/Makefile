# $NetBSD: Makefile,v 1.34 2024/11/14 22:19:50 wiz Exp $

DISTNAME=	iortcw-1.51c
PKGREVISION=	31
CATEGORIES=	games
MASTER_SITES=	${MASTER_SITE_GITHUB:=iortcw/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/iortcw/iortcw
COMMENT=	Game engine for Return to Castle Wolfenstein
LICENSE=	gnu-gpl-v3

USE_TOOLS+=	gmake pkg-config
USE_LANGUAGES=	c c++

BUILD_DIRS=	SP MP
BUILD_TARGET=	release
INSTALL_DIRS=	SP MP
INSTALL_TARGET=	copyfiles

MAKE_FLAGS+=	V=1
MAKE_FLAGS+=	BUILD_SERVER=1
MAKE_FLAGS+=	BUILD_CLIENT=1
MAKE_FLAGS+=	BUILD_GAME_SO=1
MAKE_FLAGS+=	BUILD_GAME_QVM=0
MAKE_FLAGS+=	USE_RENDERER_DLOPEN=0
MAKE_FLAGS+=	CROSS_COMPILING=0
MAKE_FLAGS+=	CC=${CC:Q}
MAKE_FLAGS+=	CXX=${CXX:Q}
MAKE_FLAGS+=	TOOLS_CC=${CC:Q}
MAKE_FLAGS+=	BUILD_BASEGAME=1
MAKE_FLAGS+=	USE_CURL=1
MAKE_FLAGS+=	USE_CURL_DLOPEN=0
MAKE_FLAGS+=	USE_CODEC_VORBIS=1
MAKE_FLAGS+=	USE_CODEC_OPUS=1
MAKE_FLAGS+=	USE_FREETYPE=1
MAKE_FLAGS+=	USE_INTERNAL_LIBS=0
MAKE_FLAGS+=	USE_LOCAL_HEADERS=0
MAKE_FLAGS+=	OPTIMIZEVM=""
MAKE_FLAGS+=	OPTIMIZE=""
MAKE_FLAGS+=	COPYDIR="${DESTDIR}${PREFIX}/share/iortcw"

.include "../../mk/bsd.prefs.mk"

MAKE_FLAGS+=	COMPILE_ARCH=${MACHINE_ARCH}

.if ${MACHINE_ARCH} == "i386"
IORTCW_ARCH=	x86
.elif ${MACHINE_ARCH} == "x86_64"
IORTCW_ARCH=	x86_64
.elif ${MACHINE_ARCH:Mpowerpc64*}
IORTCW_ARCH=	ppc64
.elif ${MACHINE_ARCH} == "sparc64"
IORTCW_ARCH=	sparc
.else
IORTCW_ARCH=	${MACHINE_ARCH}
.endif

.if ${SHLIB_TYPE} == "dylib"
PLIST_SUBST+=	SO_EXT="dylib"
.else
PLIST_SUBST+=	SO_EXT="so"
.endif

# shm_open()
LDFLAGS.NetBSD+=	-lrt

PLIST_SUBST+=	IORTCW_ARCH=${IORTCW_ARCH}

INSTALLATION_DIRS+=	bin
INSTALLATION_DIRS+=	share/applications
INSTALLATION_DIRS+=	share/icons/hicolor/scalable/apps

CHECK_PORTABILITY_SKIP+=	SP/make-macosx_xcode3.sh
CHECK_PORTABILITY_SKIP+=	SP/make-macosx_xcode4.sh
CHECK_PORTABILITY_SKIP+=	SP/make-macosx_xcode5.sh
CHECK_PORTABILITY_SKIP+=	MP/make-macosx_xcode3.sh
CHECK_PORTABILITY_SKIP+=	MP/make-macosx_xcode4.sh
CHECK_PORTABILITY_SKIP+=	MP/make-macosx_xcode5.sh

NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfded.${IORTCW_ARCH}
NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfmp.${IORTCW_ARCH}
NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfmp_rend2.${IORTCW_ARCH}
NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfsp.${IORTCW_ARCH}
NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfsp_rend2.${IORTCW_ARCH}
NOT_PAX_MPROTECT_SAFE+=	share/iortcw/iowolfspded.${IORTCW_ARCH}

post-build:
.for bin in iowolfded iowolfmp iowolfsp
	${SED}  -e 's,@PREFIX@,${PREFIX},g' \
		-e 's,@WOLFBIN@,${PREFIX}/share/iortcw/${bin}.${IORTCW_ARCH},g' \
		${FILESDIR}/iortcw.sh.in > ${WRKDIR}/${bin}
.endfor

post-install:
	${INSTALL_SCRIPT} ${WRKDIR}/iowolfded ${DESTDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKDIR}/iowolfmp ${DESTDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKDIR}/iowolfsp ${DESTDIR}${PREFIX}/bin
	${INSTALL_DATA} ${FILESDIR}/iowolfmp.desktop \
	    ${DESTDIR}${PREFIX}/share/applications
	${INSTALL_DATA} ${FILESDIR}/iowolfsp.desktop \
	    ${DESTDIR}${PREFIX}/share/applications
	${INSTALL_DATA} ${WRKSRC}/MP/misc/iortcw.svg \
	    ${DESTDIR}${PREFIX}/share/icons/hicolor/scalable/apps/wolfmp.svg
	${INSTALL_DATA} ${WRKSRC}/SP/misc/iortcw.svg \
	    ${DESTDIR}${PREFIX}/share/icons/hicolor/scalable/apps/wolfsp.svg

.include "options.mk"
.include "../../audio/opusfile/buildlink3.mk"
.include "../../audio/libvorbis/buildlink3.mk"
.include "../../devel/SDL2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../mk/jpeg.buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
