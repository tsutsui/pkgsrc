# $NetBSD: Makefile,v 1.37 2024/07/13 08:44:20 adam Exp $

DISTNAME=	libva-2.22.0
CATEGORIES=	multimedia
MASTER_SITES=	${MASTER_SITE_GITHUB:=intel/}
GITHUB_RELEASE=	${PKGVERSION_NOREV}
EXTRACT_SUFX=	.tar.bz2

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/intel/libva
COMMENT=	Video Acceleration API
LICENSE=	mit

GNU_CONFIGURE=	yes
USE_LIBTOOL=	yes
USE_TOOLS+=	gmake pkg-config

USE_CC_FEATURES=	c99

# error: 'for' loop initial declarations are only allowed in C99 mode
FORCE_C_STD=		gnu99

.include "../../mk/bsd.prefs.mk"

#
# vaapi drivers (e.g. intel-vaapi-driver) can be installed under
# ${PREFIX}/lib/dri and linked against native X.org. Instruct libva's
# DRIVER_SEARCH_PATH to look at them too for native X.org.
#
.if ${X11_TYPE} == "native"
DRIVER_SEARCH_PATH=	${X11BASE}/lib/dri:${PREFIX}/lib/dri
.else
DRIVER_SEARCH_PATH=	${X11BASE}/lib/dri
.endif

CONFIGURE_ARGS+=	--enable-shared
CONFIGURE_ARGS+=	--with-drivers-path=${DRIVER_SEARCH_PATH:Q}
# Might be useful to have this but I'll leave it to
# someone else to enable. -tnn
CONFIGURE_ARGS+=	--disable-wayland
# To avoid a PLIST mismatch with base Xorg
CONFIGURE_ARGS+=	--disable-glx

LIBS+=			${BUILDLINK_LDADD.dl}

PKGCONFIG_OVERRIDE+=	pkgconfig/libva-drm.pc.in
PKGCONFIG_OVERRIDE+=	pkgconfig/libva-glx.pc.in
PKGCONFIG_OVERRIDE+=	pkgconfig/libva-wayland.pc.in
PKGCONFIG_OVERRIDE+=	pkgconfig/libva-x11.pc.in
PKGCONFIG_OVERRIDE+=	pkgconfig/libva.pc.in

BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,-version-script
BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,./libva.syms

.include "../../x11/libXfixes/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libdrm/buildlink3.mk"
.include "../../mk/dlopen.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
