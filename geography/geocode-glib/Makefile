# $NetBSD: Makefile,v 1.16 2024/11/14 22:20:01 wiz Exp $

DISTNAME=	geocode-glib-3.26.2
MASTER_SITES=	${MASTER_SITE_GNOME:=sources/${PKGBASE}/${PKGVERSION_NOREV:R}/}
PKGREVISION=	13
CATEGORIES=	geography gnome
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://developer.gnome.org/geocode-glib/
COMMENT=	GNOME convenience library for geocoding
LICENSE=	gnu-lgpl-v2

TOOL_DEPENDS+=	gtk-doc-[0-9]*:../../textproc/gtk-doc

USE_TOOLS+=	pkg-config xgettext

PYTHON_FOR_BUILD_ONLY=	tool

PKGCONFIG_OVERRIDE_STAGE=	pre-install
PKGCONFIG_OVERRIDE+=		output/meson-private/geocode-glib-1.0.pc

.include "../../devel/meson/build.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/gobject-introspection/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"
.include "../../textproc/json-glib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
