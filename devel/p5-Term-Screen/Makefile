# $NetBSD: Makefile,v 1.25 2024/11/16 12:05:12 wiz Exp $

DISTNAME=	Term-Screen-1.06
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	8
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Term/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Term-Screen
COMMENT=	Term::Cap based screen positioning module

PERL5_PACKLIST=		auto/Term/Screen/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
