# $NetBSD: Makefile,v 1.81 2024/11/14 22:20:08 wiz Exp $

DISTNAME=	gphoto2-2.5.28
PKGREVISION=	3
CATEGORIES=	graphics
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=gphoto/}
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://gphoto.sourceforge.net/
COMMENT=	Digital camera access command line client
LICENSE=	gnu-gpl-v2

CONFLICTS=		gphoto-[0-9]*

USE_LIBTOOL=		yes
USE_PKGLOCALEDIR=	yes
USE_TOOLS+=		pkg-config
GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--with-cdk-prefix=${BUILDLINK_PREFIX.cdk}
CONFIGURE_ARGS+=	--with-jpeg-prefix=${JPEGBASE}
TEST_TARGET=		check

CFLAGS.Darwin+=	-D_DARWIN_C_SOURCE

.include "../../devel/cdk/buildlink3.mk"
.include "../../devel/libgphoto2/buildlink3.mk"
.include "../../devel/ncurses/buildlink3.mk"
.include "../../devel/popt/buildlink3.mk"
# uses rl_completion_matches() (NetBSD 3.* don't have) and rl_copy_text()
.include "../../devel/readline/buildlink3.mk"
.include "../../mk/jpeg.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
