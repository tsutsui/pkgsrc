# $NetBSD: Makefile,v 1.21 2024/11/16 12:06:17 wiz Exp $
#

DISTNAME=	Net-Server-SS-PreFork-0.05
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	16
CATEGORIES=	net perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Net/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Net-Server-SS-PreFork
COMMENT=	Hot-deployable variant of Perl 5 module Net::Server::PreFork
LICENSE=	${PERL5_LICENSE}

PERL5_MODULE_TYPE=	Module::Install::Bundled

USE_LANGUAGES=		# empty
MAKE_ENV+=		PERL_USE_UNSAFE_INC=1
PERL5_PACKLIST=		auto/Net/Server/SS/PreFork/.packlist

TOOL_DEPENDS+=	p5-HTTP-Server-Simple-[0-9]*:../../www/p5-HTTP-Server-Simple
TOOL_DEPENDS+=	p5-libwww-[0-9]*:../../www/p5-libwww
TOOL_DEPENDS+=	p5-Test-TCP>=0.06:../../net/p5-Test-TCP
DEPENDS+=	p5-Net-Server-[0-9]*:../../net/p5-Net-Server
DEPENDS+=	p5-Server-Starter>=0.02:../../sysutils/p5-Server-Starter

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
