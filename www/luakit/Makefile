# $NetBSD: Makefile,v 1.36 2025/01/21 11:00:18 nia Exp $

DISTNAME=	luakit-2.3.3
PKGREVISION=	17
CATEGORIES=	www lua
MASTER_SITES=	${MASTER_SITE_GITHUB:=luakit/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://luakit.org/
COMMENT=	Fast, small, WebKit based browser extensible with Lua
LICENSE=	gnu-gpl-v3

USE_TOOLS+=	gmake pkg-config

MAKE_FLAGS+=	DEVELOPMENT_PATHS=0
MAKE_FLAGS+=	APPDIR=${PREFIX}/share/applications
MAKE_FLAGS+=	DOCDIR=${PREFIX}/share/doc/luakit
MAKE_FLAGS+=	MANPREFIX=${PREFIX}/${PKGMANDIR}
MAKE_FLAGS+=	PIXMAPDIR=${PREFIX}/share/pixmaps
MAKE_FLAGS+=	XDGPREFIX=${PKG_SYSCONFDIR}
MAKE_FLAGS+=	VERSION=${PKGVERSION}

LDFLAGS.SunOS+=	-lm -lsocket

BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,--export-dynamic

LUA_VERSIONS_ACCEPTED=	51

.include "../../lang/lua/luaversion.mk"

DEPENDS+=	${LUA_PKGPREFIX}-filesystem-[0-9]*:../../devel/lua-filesystem

OWN_DIRS+=	${PKG_SYSCONFDIR}/xdg/luakit

CONF_FILES+=	${PREFIX}/share/examples/luakit/rc.lua \
		${PKG_SYSCONFDIR}/xdg/luakit/rc.lua

CONF_FILES+=	${PREFIX}/share/examples/luakit/theme.lua \
		${PKG_SYSCONFDIR}/xdg/luakit/theme.lua

pre-install:
	${RM} -f ${WRKSRC}/lib/*.orig

.include "options.mk"
.include "../../databases/sqlite3/buildlink3.mk"
.include "../../www/webkit-gtk/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
