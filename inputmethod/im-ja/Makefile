# $NetBSD: Makefile,v 1.96 2024/12/27 08:20:10 wiz Exp $
#

DISTNAME=	im-ja-1.5
PKGREVISION=	91
CATEGORIES=	inputmethod japanese
MASTER_SITES=	http://im-ja.sourceforge.net/

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://im-ja.sourceforge.net/
COMMENT=	Japanese input module for GTK2 and XIM server
#LICENSE=	gnu-gpl-v2 AND gnu-lgpl-v2 # AND bsd?

GNU_CONFIGURE=	yes
USE_LIBTOOL=	yes
USE_TOOLS+=	intltool msgfmt pkg-config gmake

GCONF_SCHEMAS+=	im-ja.schemas

GTK2_IMMODULES=	yes

CONFIGURE_ARGS+=	--sysconfdir=${PKG_SYSCONFDIR}
CONFIGURE_ARGS+=	--disable-gnome

.include "options.mk"
.include "../../devel/GConf/schemas.mk"
.include "../../devel/libglade/buildlink3.mk"
.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../x11/gtk2/modules.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../mk/bsd.pkg.mk"
