# $NetBSD: Makefile,v 1.16 2024/11/16 12:05:18 wiz Exp $

DISTNAME=		Test-InDistDir-1.112071
PKGNAME=		p5-${DISTNAME}
PKGREVISION=		13
CATEGORIES=		devel perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Test/}

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://metacpan.org/release/Test-InDistDir
COMMENT=		Test environment setup for development with IDE
LICENSE=		${PERL5_LICENSE}

PERL5_PACKLIST=		auto/Test/InDistDir/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
