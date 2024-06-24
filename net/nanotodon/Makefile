# $NetBSD: Makefile,v 1.21 2024/05/29 16:33:59 adam Exp $

DISTNAME=	nanotodon-${GITHUB_TAG:S/-rc/rc/}
CATEGORIES=	net
MASTER_SITES=	${MASTER_SITE_GITHUB:=taka-tuos/}
GITHUB_TAG=	0.4.0-rc3

MAINTAINER=	tsutsui@NetBSD.org
HOMEPAGE=	https://github.com/taka-tuos/nanotodon
COMMENT=	CUI/C99 mastodon client
LICENSE=	mit

USE_LANGUAGES=		c
USE_CC_FEATURES=	c99

INSTALLATION_DIRS+=	bin share/doc/nanotodon

BUILD_TARGET=		default

.include "options.mk"

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/nanotodon ${DESTDIR}${PREFIX}/bin
	${INSTALL_DATA} ${WRKSRC}/README.md \
	    ${DESTDIR}${PREFIX}/share/doc/nanotodon

.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
