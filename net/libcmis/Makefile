# $NetBSD: Makefile,v 1.52 2024/12/29 15:09:57 adam Exp $

DISTNAME=	libcmis-0.6.2
PKGREVISION=	1
CATEGORIES=	net devel
MASTER_SITES=	${MASTER_SITE_GITHUB:=tdf/}
GITHUB_PROJECT=	libcmis
GITHUB_RELEASE=	v${PKGVERSION_NOREV}

MAINTAINER=	jaapb@NetBSD.org
HOMEPAGE=	https://github.com/tdf/libcmis
COMMENT=	Client library for the CMIS interface
LICENSE=	gnu-gpl-v2 OR gnu-lgpl-v2 OR mpl-1.1

GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--with-man=no --disable-werror
USE_LANGUAGES+=		c c++
USE_TOOLS+=		gmake pkg-config
USE_LIBTOOL=		yes

.include "../../devel/boost-headers/buildlink3.mk"
.include "../../devel/boost-libs/buildlink3.mk"
.include "../../devel/cppunit/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
