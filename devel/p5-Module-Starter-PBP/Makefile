# $NetBSD: Makefile,v 1.21 2024/11/16 12:04:38 wiz Exp $

DISTNAME=	Module-Starter-PBP-v0.0.3
PKGNAME=	p5-Module-Starter-PBP-0.0.3
PKGREVISION=	17
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Module/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Module-Starter-PBP
COMMENT=	Perl 5 module plugin for Module::Starter module

DEPENDS+=	p5-Module-Starter-[0-9]*:../../devel/p5-Module-Starter

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/Module/Starter/PBP/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
