# $NetBSD: Makefile,v 1.50 2024/12/27 08:19:40 wiz Exp $
#

DISTNAME=	scite339
PKGNAME=	scite-3.3.9
PKGREVISION=	23
CATEGORIES=	editors
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=scintilla/}
EXTRACT_SUFX=	.tgz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://scintilla.sourceforge.net/
COMMENT=	Source code editor
#LICENSE=	# TODO: (see mk/license.mk)

WRKSRC=			${WRKDIR}/scite
USE_LANGUAGES=		c c++
BUILD_DIRS+=		gtk
USE_TOOLS+=		gmake pkg-config
MAKE_FILE=		makefile
INSTALLATION_DIRS=	share/applications share/pixmaps

BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,--as-needed
BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,--version-script=lua.vers

post-extract:
	${RM} -r ${WRKDIR}/scintilla
	${RM} ${WRKSRC}/gtk/deps.mak
	${TOUCH} ${WRKSRC}/gtk/deps.mak

.include "../../devel/glib2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
BUILDLINK_API_DEPENDS.scintilla+= scintilla>=3.2.4
.include "../../devel/scintilla/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../mk/bsd.pkg.mk"
