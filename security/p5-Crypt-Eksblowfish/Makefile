# $NetBSD: Makefile,v 1.26 2024/11/16 12:06:28 wiz Exp $
#

DISTNAME=		Crypt-Eksblowfish-0.009
PKGNAME=		p5-${DISTNAME}
PKGREVISION=		13
CATEGORIES=		security perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Crypt/}

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://metacpan.org/release/Crypt-Eksblowfish
COMMENT=		Perl5 Eksblowfish block cipher
LICENSE=		${PERL5_LICENSE}

DEPENDS+=		p5-Class-Mix>=0.001:../../devel/p5-Class-Mix
#DEPENDS+=		{perl>=5.10.1,p5-parent-[0-9]*}:../../devel/p5-parent
#DEPENDS+=		{perl>=5.8.2,p5-MIME-Base64>=2.21}:../../converters/p5-MIME-Base64
#TOOL_DEPENDS+=	{perl>=5.10.0,p5-ExtUtils-CBuilder>=0.15}:../../devel/p5-ExtUtils-CBuilder

USE_LANGUAGES=		c
PERL5_MODULE_TYPE=	Module::Build
PERL5_PACKLIST=		auto/Crypt/Eksblowfish/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
