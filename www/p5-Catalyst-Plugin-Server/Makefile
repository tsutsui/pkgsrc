# $NetBSD: Makefile,v 1.23 2024/11/16 12:07:34 wiz Exp $

DISTNAME=	Catalyst-Plugin-Server-0.28
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	13
CATEGORIES=	www perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Catalyst/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Catalyst-Plugin-Server
COMMENT=	Base Server plugin for RPC-able protocols
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Catalyst-Runtime>=5.66:../../www/p5-Catalyst-Runtime
DEPENDS+=	p5-RPC-XML>=0.67:../../net/p5-RPC-XML
DEPENDS+=	p5-MRO-Compat-[0-9]*:../../devel/p5-MRO-Compat
DEPENDS+=	p5-Clone-Fast-[0-9]*:../../devel/p5-Clone-Fast

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/Catalyst/Plugin/Server/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
