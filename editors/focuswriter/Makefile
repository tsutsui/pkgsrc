# $NetBSD: Makefile,v 1.41 2024/11/14 22:19:39 wiz Exp $

DISTNAME=	focuswriter-1.8.9
PKGREVISION=	3
CATEGORIES=	editors
MASTER_SITES=	${MASTER_SITE_GITHUB:=gottcode/}
GITHUB_TAG=	v${PKGVERSION_NOREV}

MAINTAINER=	pin@NetBSD.org
HOMEPAGE=	https://gottcode.org/focuswriter/
COMMENT=	Simple, distraction-free writing environment
LICENSE=	gnu-gpl-v3

USE_PKGLOCALEDIR=	yes
USE_LANGUAGES=		c c++
USE_TOOLS+=		pkg-config

CMAKE_CONFIGURE_ARGS+=	-DCMAKE_INSTALL_PREFIX=${PREFIX}
CMAKE_CONFIGURE_ARGS+=	-DCMAKE_INSTALL_MANDIR=${PKGMANDIR}
CMAKE_CONFIGURE_ARGS+=	-DCMAKE_INSTALL_DATADIR=${PREFIX}/share

TOOL_DEPENDS+=	qt6-qttools-[0-9]*:../../devel/qt6-qttools

.include "../../x11/qt6-qtbase/buildlink3.mk"
.include "../../multimedia/qt6-qtmultimedia/buildlink3.mk"
.include "../../textproc/hunspell/buildlink3.mk"
.include "../../converters/libiconv/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../devel/cmake/build.mk"
.include "../../mk/bsd.pkg.mk"
