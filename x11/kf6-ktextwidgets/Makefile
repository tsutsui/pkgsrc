# $NetBSD: Makefile,v 1.6 2024/12/05 09:43:28 markd Exp $

DISTNAME=	ktextwidgets-${KF6VER}
CATEGORIES=	x11

HOMEPAGE=	https://community.kde.org/Frameworks
COMMENT=	Advanced text editing widgets
LICENSE=	gnu-lgpl-v2 AND gnu-lgpl-v2.1

.include "../../meta-pkgs/kde/kf6.mk"

USE_TOOLS+=	msgmerge

.include "../../lang/python/tool.mk"
.include "../../audio/qt6-qtspeech/buildlink3.mk"
.include "../../devel/kf6-kconfig/buildlink3.mk"
.include "../../devel/qt6-qttools/buildlink3.mk"
.include "../../graphics/kf6-kiconthemes/buildlink3.mk"
# qt6-qtmultimedia possibly should be in qt6-qtspeech/buildlink3.mk
.include "../../multimedia/qt6-qtmultimedia/buildlink3.mk"
.include "../../textproc/kf6-kcompletion/buildlink3.mk"
.include "../../textproc/kf6-sonnet/buildlink3.mk"
.include "../../x11/kf6-kconfigwidgets/buildlink3.mk"
.include "../../x11/qt6-qtbase/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
