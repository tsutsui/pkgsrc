# $NetBSD: Makefile,v 1.19 2025/02/02 13:05:45 pho Exp $

DISTNAME=	ShellCheck-0.10.0
PKGNAME=	${DISTNAME:tl}
PKGREVISION=	2
CATEGORIES=	shells devel

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://www.shellcheck.net/
COMMENT=	Shell script analysis tool
LICENSE=	gnu-gpl-v3

HASKELL_UNRESTRICT_DEPENDENCIES+=	\
	Diff		\
	QuickCheck	\
	aeson		\
	filepath	\
	mtl		\
	transformers

.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../devel/hs-fgl/buildlink3.mk"
.include "../../devel/hs-QuickCheck/buildlink3.mk"
.include "../../textproc/hs-Diff/buildlink3.mk"
.include "../../textproc/hs-regex-tdfa/buildlink3.mk"
.include "../../mk/haskell.mk"
.include "../../mk/bsd.pkg.mk"
