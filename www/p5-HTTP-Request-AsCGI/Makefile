# $NetBSD: Makefile,v 1.21 2024/11/16 12:07:46 wiz Exp $

DISTNAME=	HTTP-Request-AsCGI-1.2
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	15
CATEGORIES=	www perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=HTTP/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/HTTP-Request-AsCGI
COMMENT=	Setup a CGI enviroment from a HTTP::Request
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Class-Accessor>=0:../../devel/p5-Class-Accessor
DEPENDS+=	p5-libwww>=5.805:../../www/p5-libwww
DEPENDS+=	p5-URI-[0-9]*:../../www/p5-URI

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/HTTP/Request/AsCGI/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
