# $NetBSD: Makefile,v 1.29 2024/11/16 12:05:18 wiz Exp $

DISTNAME=		Test-Kwalitee-1.28
PKGNAME=		p5-${DISTNAME}
PKGREVISION=		6
CATEGORIES=		devel perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Test/}

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://metacpan.org/release/Test-Kwalitee
COMMENT=		Perl5 module to test the Kwalitee of a distribution
LICENSE=		${PERL5_LICENSE}

DEPENDS+=		p5-Module-CPANTS-Analyse>=0.82:../../devel/p5-Module-CPANTS-Analyse
DEPENDS+=		p5-Test-Warnings>=0:../../devel/p5-Test-Warnings
DEPENDS+=		p5-CPAN-Meta-Check>=0:../../devel/p5-CPAN-Meta-Check
DEPENDS+=		p5-namespace-clean-[0-9]*:../../devel/p5-namespace-clean

# for make test
TOOL_DEPENDS+=		p5-Test-Deep-[0-9]*:../../devel/p5-Test-Deep
TOOL_DEPENDS+=		p5-Archive-Zip-[0-9]*:../../archivers/p5-Archive-Zip
TOOL_DEPENDS+=		p5-File-Find-Object-[0-9]*:../../devel/p5-File-Find-Object
TOOL_DEPENDS+=		p5-Class-XSAccessor-[0-9]*:../../devel/p5-Class-XSAccessor
TOOL_DEPENDS+=		p5-JSON-MaybeXS-[0-9]*:../../converters/p5-JSON-MaybeXS

USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/Test/Kwalitee/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
