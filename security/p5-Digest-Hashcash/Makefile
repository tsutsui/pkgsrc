# $NetBSD: Makefile,v 1.34 2024/11/16 12:06:32 wiz Exp $

DISTNAME=	Digest-Hashcash-1.1
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	8
CATEGORIES=	security perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Digest/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Digest-Hashcash
COMMENT=	Perl5 extension module for hashcash hashes
LICENSE=	gnu-gpl-v2

DEPENDS+=	p5-Canary-Stability-[0-9]*:../../devel/p5-Canary-Stability

PERL5_PACKLIST=		auto/Digest/Hashcash/.packlist

# Hashcash.xs: In function 'XS_Digest__Hashcash__gentoken':
# Hashcash.xs:441:28: error: array subscript has type 'char' [-Werror=char-subscripts]
#                *s = nextenc [*s];
# Maybe fix this later.
BUILDLINK_TRANSFORM+=	rm:-Werror=char-subscripts

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
