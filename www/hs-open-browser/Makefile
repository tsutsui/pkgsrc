# $NetBSD: Makefile,v 1.9 2025/02/02 13:06:05 pho Exp $

DISTNAME=	open-browser-0.2.1.0
PKGREVISION=	6
CATEGORIES=	www

MAINTAINER=	pkgsrc-users@NetBSD.org
COMMENT=	Open a web browser from Haskell
LICENSE=	modified-bsd

HASKELL_DISABLE_EXECUTABLES+=	\
	example

.include "../../mk/bsd.fast.prefs.mk"
.if ${OPSYS} != "Darwin"
DEPENDS+=	xdg-utils-[0-9]*:../../misc/xdg-utils
.endif

.include "../../mk/haskell.mk"
.include "../../mk/bsd.pkg.mk"
