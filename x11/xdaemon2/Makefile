# $NetBSD: Makefile,v 1.21 2025/01/27 11:11:40 wiz Exp $

DISTNAME=	xdaemon-2.1
PKGREVISION=	1
CATEGORIES=	games x11
MASTER_SITES=	${MASTER_SITE_LOCAL}
DISTFILES=	${IMAGES:=.png} Daemon.README

MAINTAINER=	hubertf@NetBSD.org
HOMEPAGE=	https://www.NetBSD.org/
COMMENT=	BSD Daemon sticking on your desktop (like xteddy)

DEPENDS+=	xteddy>=2:../../x11/xteddy

CONFLICTS+=	xdaemon-1.*

NO_CONFIGURE=	yes
NO_BUILD=	yes
DIST_SUBDIR=	xdaemon

IMAGES=		xdaemon xdaemon2 xnetbsd-flag xnetbsd-flag2

INSTALLATION_DIRS=	bin share/doc share/xteddy

do-extract:
	@${MKDIR} ${WRKSRC}
	@${ECHO} Bringing daemonic powers to you!

do-install:
.for img in ${IMAGES}
	${INSTALL_DATA} ${DISTDIR}/${DIST_SUBDIR}/${img}.png ${DESTDIR}${PREFIX}/share/xteddy/${img}.png
	${RM} -f ${DESTDIR}${PREFIX}/bin/${img}
	${LN} -s xteddy ${DESTDIR}${PREFIX}/bin/${img}
.endfor
	${INSTALL_DATA} ${DISTDIR}/${DIST_SUBDIR}/Daemon.README ${DESTDIR}${PREFIX}/share/doc/xdaemon.README

.include "../../mk/bsd.pkg.mk"
