# $NetBSD: Makefile,v 1.38 2024/11/15 12:34:40 pin Exp $

DISTNAME=	qtermwidget-2.1.0
CATEGORIES=	x11
MASTER_SITES=	${MASTER_SITE_GITHUB:=lxqt/}
GITHUB_RELEASE=	${PKGVERSION_NOREV}
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/lxqt/qtermwidget/
COMMENT=	Terminal emulator widget for Qt5
LICENSE=	gnu-lgpl-v2.1 AND modified-bsd

USE_TOOLS+=	pkg-config perl
USE_LANGUAGES=	c c++

LDFLAGS.NetBSD+=	-lutil

SUBST_CLASSES+=		prefix
SUBST_MESSAGE.prefix=	Fixing paths.
SUBST_STAGE.prefix=	pre-configure
SUBST_FILES.prefix=	lib/qtermwidget.cpp
SUBST_SED.prefix=	-e 's,/usr/share,${PREFIX}/share,g'

TOOL_DEPENDS+=	lxqt-build-tools>=2.1.0:../../devel/lxqt-build-tools
TOOL_DEPENDS+=	qt6-qttools-[0-9]*:../../devel/qt6-qttools

.include "../../x11/qt6-qtbase/buildlink3.mk"
.include "../../devel/cmake/build.mk"
.include "../../mk/bsd.pkg.mk"
