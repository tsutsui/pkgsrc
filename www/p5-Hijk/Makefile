# $NetBSD: Makefile,v 1.21 2024/11/16 12:07:48 wiz Exp $

DISTNAME=	Hijk-0.28
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	6
CATEGORIES=	www
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/G/GU/GUGOD/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/pod/Hijk
COMMENT=	Hijk - Fast & minimal low-level HTTP client
LICENSE=	mit

# for make test
TOOL_DEPENDS+=	p5-Test-Exception-[0-9]*:../../devel/p5-Test-Exception
TOOL_DEPENDS+=	p5-URI-[0-9]*:../../www/p5-URI
#TOOL_DEPENDS+=	p5-Time-HiRes-[0-9]*:../../time/p5-Time-HiRes
TOOL_DEPENDS+=	p5-Net-Server>=0:../../net/p5-Net-Server
TOOL_DEPENDS+=	p5-Plack>=0:../../www/p5-Plack

PERL5_PACKLIST=	auto/Hijk/.packlist
USE_LANGUAGES=	# none

PERL5_MODULE_TYPE=	Module::Build::Tiny

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
