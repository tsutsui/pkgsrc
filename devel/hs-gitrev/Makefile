# $NetBSD: Makefile,v 1.8 2025/02/02 13:05:08 pho Exp $

DISTNAME=	gitrev-1.3.1
PKGREVISION=	6
CATEGORIES=	devel

MAINTAINER=	pkgsrc-users@NetBSD.org
COMMENT=	Compile git revision info into Haskell projects
LICENSE=	modified-bsd

DEPENDS+=	git-base-[0-9]*:../../devel/git-base

.include "../../devel/hs-base-compat/buildlink3.mk"
.include "../../mk/haskell.mk"
.include "../../mk/bsd.pkg.mk"
