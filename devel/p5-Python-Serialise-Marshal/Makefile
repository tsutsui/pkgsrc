# $NetBSD: Makefile,v 1.18 2024/11/16 12:04:59 wiz Exp $

DISTNAME=	Python-Serialise-Marshal-0.02
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	13
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Python/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Python-Serialise-Marshal
COMMENT=	Module for reading and writing marshalled Python files
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-File-Binary>=1.0:../../devel/p5-File-Binary
#DEPENDS+=	{perl>=5,p5-Math-Complex-[0-9]*}:../../math/p5-Math-Complex
#DEPENDS+=	{perl>=5.6.2,p5-Test-Simple-[0-9]*}:../../devel/p5-Test-Simple

PERL5_MODULE_TYPE=	Module::Build
PERL5_PACKLIST=		auto/Python/Serialise/Marshal/.packlist
USE_LANGUAGES=		# none

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
