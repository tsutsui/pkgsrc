# $NetBSD: Makefile,v 1.27 2024/11/16 12:04:45 wiz Exp $
#

DISTNAME=	MooseX-SemiAffordanceAccessor-0.10
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	10
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=MooseX/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/MooseX-SemiAffordanceAccessor
COMMENT=	Perl 5 module to name your accessors foo() and set_foo()
LICENSE=	artistic-2.0

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/MooseX/SemiAffordanceAccessor/.packlist

#TOOL_DEPENDS+=	{perl>=5.10.1,p5-Test-Simple>=0.88}:../../devel/p5-Test-Simple
DEPENDS+=		p5-Moose>=0.94:../../devel/p5-Moose
# for make test
TOOL_DEPENDS+=		p5-Package-DeprecationManager-[0-9]*:../../devel/p5-Package-DeprecationManager

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
