# $NetBSD: Makefile,v 1.17 2025/02/07 21:38:44 adam Exp $

DISTNAME=	libsoup-3.6.4
PKGNAME=	${DISTNAME:S/soup/soup3/}
CATEGORIES=	net gnome
MASTER_SITES=	${MASTER_SITE_GNOME:=sources/libsoup/${PKGVERSION_NOREV:R}/}
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://wiki.gnome.org/Projects/libsoup
COMMENT=	HTTP library implementation in C (major version 3)
LICENSE=	gnu-lgpl-v2

DEPENDS+=	glib-networking-[0-9]*:../../net/glib-networking
# not found by meson
#TOOL_DEPENDS+=	${PYPKGPREFIX}-gi-docgen-[0-9]*:../../devel/py-gi-docgen

USE_CC_FEATURES=	c99
USE_LANGUAGES=		c
USE_TOOLS+=		msgfmt pkg-config

PKGCONFIG_OVERRIDE+=		output/meson-private/libsoup-3.0.pc
PKGCONFIG_OVERRIDE_STAGE=	pre-install

# disable vala detection
MESON_ARGS+=	-Dvapi=disabled
# disable sysprof, not shipped in subprojects and gets git cloned otherwise
MESON_ARGS+=	-Dsysprof=disabled

TEST_ENV+=	LD_LIBRARY_PATH=${WRKSRC}/output/libsoup
TEST_ENV+=	LD_LIBRARY_PATH=${WRKSRC}/output/tests
# for Darwin
TEST_ENV+=	DYLD_LIBRARY_PATH=${WRKSRC}/output/libsoup
TEST_ENV+=	DYLD_LIBRARY_PATH=${WRKSRC}/output/tests

PYTHON_FOR_BUILD_ONLY=		tool

.include "options.mk"

# prevent sprurious git cloning of gi-docgen in configure stage
post-extract:
	rm -f ${WRKSRC}/subprojects/*.wrap

.include "../../archivers/brotli/buildlink3.mk"
.include "../../databases/sqlite3/buildlink3.mk"
BUILDLINK_API_DEPENDS.glib2+=	glib2>=2.69.1
.include "../../devel/glib2/buildlink3.mk"
BUILDLINK_API_DEPENDS.gobject-introspection+=	gobject-introspection>=0.9.5
BUILDLINK_DEPMETHOD.gobject-introspection=	build
.include "../../devel/gobject-introspection/buildlink3.mk"
.include "../../devel/meson/build.mk"
.include "../../lang/python/tool.mk"
.include "../../security/gnutls/buildlink3.mk"
.include "../../www/libpsl/buildlink3.mk"
.include "../../www/nghttp2/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
