# $NetBSD: Makefile,v 1.35 2024/11/16 12:03:48 wiz Exp $

DISTNAME=	Class-Container-0.13
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	7
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Class/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Class-Container
COMMENT=	Glues object frameworks together transparently
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Params-Validate>=0.23:../../devel/p5-Params-Validate
#DEPENDS+=	{perl>=5.10,p5-Scalar-List-Utils-[0-9]*}:../../devel/p5-Scalar-List-Utils

USE_LANGUAGES=		# none
PERL5_MODULE_TYPE=	Module::Build
PERL5_PACKLIST=		auto/Class/Container/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
