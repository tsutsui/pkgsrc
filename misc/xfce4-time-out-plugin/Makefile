# $NetBSD: Makefile,v 1.36 2024/12/27 08:20:22 wiz Exp $

PKGREVISION= 8
.include "../../meta-pkgs/xfce4/Makefile.common"

VERSION=	1.1.3
DISTNAME=	xfce4-time-out-plugin-${VERSION}
CATEGORIES=	misc
MASTER_SITES=	https://archive.xfce.org/src/panel-plugins/xfce4-time-out-plugin/${VERSION:R}/

HOMEPAGE=	https://goodies.xfce.org/projects/panel-plugins/xfce4-time-out-plugin
COMMENT=	Xfce periodical breaks plugin

.include "../../x11/xfce4-panel/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
