# $NetBSD: Makefile,v 1.12 2024/12/27 08:19:22 wiz Exp $

DISTNAME=	parlatype-4.0
PKGREVISION=	2
CATEGORIES=	audio
MASTER_SITES=	${MASTER_SITE_GITHUB:=gkarsay/}
GITHUB_RELEASE=	v${PKGVERSION_NOREV}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://www.parlatype.org/
COMMENT=	GNOME audio player for transcription
LICENSE=	gnu-gpl-v3 AND cc-by-sa-v4.0

USE_PKGLOCALEDIR=	yes
USE_TOOLS+=		itstool gawk msgfmt pkg-config

FORCE_C_STD=		c99

MESON_ARGS+=	-Dlocaledir=${PKGLOCALEDIR}/locale

BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,--version-script
BUILDLINK_TRANSFORM.SunOS+=	rm:-Wl,${WRKSRC}/libparlatype/src/libparlatype.map

PKGCONFIG_OVERRIDE_STAGE=	pre-install
PKGCONFIG_OVERRIDE+=		output/meson-private/parlatype.pc

REPLACE_SH+=	libparlatype/tests/data/generate_config_data

ICON_THEMES=	yes

.include "../../devel/meson/build.mk"
.include "../../devel/gobject-introspection/buildlink3.mk"
.include "../../devel/gettext-tools/msgfmt-desktop.mk"
.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../multimedia/gstreamer1/buildlink3.mk"
.include "../../multimedia/gst-plugins1-base/buildlink3.mk"
.include "../../textproc/iso-codes/buildlink3.mk"
BUILDLINK_API_DEPENDS.glib2+=	glib2>=2.58
.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/glib2/schemas.mk"
.include "../../x11/gtk4/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
