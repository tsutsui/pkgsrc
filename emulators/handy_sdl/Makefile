# $NetBSD: Makefile,v 1.10 2025/01/06 21:49:07 ktnb Exp $
#

DISTNAME=	handy_sdl-0.5-src
PKGNAME=	${DISTNAME:S/-src//}
PKGREVISION=	3
CATEGORIES=	emulators
MASTER_SITES=	https://shalafi.home.xs4all.nl/
EXTRACT_SUFX=	.tar.bz2

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://sdlemu.ngemu.com/handysdl.php
COMMENT=	Atari Lynx emulator

MAKE_JOBS_SAFE=		no

MAKE_FILE=	Makefile-0.95
USE_TOOLS+=	gmake

INSTALLATION_DIRS=	bin share/doc/handy_sdl

MAKE_FLAGS+=	LDFLAGS=${LDFLAGS:Q}

post-extract:
	${FIND} ${WRKSRC}/src -type d -exec ${CHMOD} a+X {} \;

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/handy_sdl ${DESTDIR}${PREFIX}/bin
	${INSTALL_DATA} ${WRKSRC}/README ${DESTDIR}${PREFIX}/share/doc/handy_sdl

.include "../../devel/SDL/buildlink3.mk"
.include "../../graphics/MesaLib/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
