# $NetBSD: Makefile,v 1.4 2024/11/16 12:06:28 wiz Exp $
#

DISTNAME=		Crypt-Juniper-0.02
PKGNAME=		p5-${DISTNAME}
PKGREVISION=		3
CATEGORIES=		security perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Crypt/}

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://metacpan.org/release/Crypt-Juniper
COMMENT=		Perl5 module to decode type-9 Juniper scrambling
LICENSE=		${PERL5_LICENSE}

#DEPENDS+=		p5-Tie-EncryptedHash-[0-9]*:../../security/p5-Tie-EncryptedHash

USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/Crypt/Juniper/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
