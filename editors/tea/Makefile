# $NetBSD: Makefile,v 1.96 2024/11/14 22:19:40 wiz Exp $

DISTNAME=	tea-48.0.1
PKGREVISION=	44
CATEGORIES=	editors
MASTER_SITES=	${MASTER_SITE_GITHUB:=psemiletov/}
GITHUB_PROJECT=	tea-qt

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://semiletov.org/tea/
COMMENT=	Powerful, easy-to-use text editor
LICENSE=	gnu-gpl-v3

WRKSRC=		${WRKDIR}/${GITHUB_PROJECT}-${GITHUB_TAG}
USE_CMAKE=	yes
USE_TOOLS+=	pkg-config
USE_LANGUAGES=	c c++

# XXX should not be needed but we have weird paths with spaces
# which break bmake
USE_TOOLS+=	gmake

.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/djvulibre-lib/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../print/poppler-qt5/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../textproc/aspell/buildlink3.mk"
.include "../../textproc/hunspell/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.include "../../x11/qt5-qtdeclarative/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
