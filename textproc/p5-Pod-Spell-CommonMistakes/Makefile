# $NetBSD: Makefile,v 1.22 2024/11/16 12:06:51 wiz Exp $

DISTNAME=	Pod-Spell-CommonMistakes-1.002
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	10
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Pod/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Pod-Spell-CommonMistakes
COMMENT=	Catches common typos in POD
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-IO-stringy>=2.110:../../devel/p5-IO-stringy
DEPENDS+=	p5-Pod-Spell>=1.01:../../textproc/p5-Pod-Spell

PERL5_PACKLIST=		auto/Pod/Spell/CommonMistakes/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
