# $NetBSD: Makefile,v 1.24 2024/11/16 12:07:32 wiz Exp $

DISTNAME=	Catalyst-Engine-PSGI-0.14
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	7
CATEGORIES=	www perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Catalyst/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Catalyst-Engine-PSGI
COMMENT=	Perl 5 PSGI engine for Catalyst
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Catalyst-Action-RenderView-[0-9]*:../../www/p5-Catalyst-Action-RenderView
DEPENDS+=	p5-Catalyst-Runtime>=5.80007:../../www/p5-Catalyst-Runtime
DEPENDS+=	p5-Package-DeprecationManager-[0-9]*:../../devel/p5-Package-DeprecationManager

TOOL_DEPENDS+=	p5-Test-TCP-[0-9]*:../../net/p5-Test-TCP
TOOL_DEPENDS+=	p5-Test-Requires-[0-9]*:../../devel/p5-Test-Requires
TOOL_DEPENDS+=	p5-Plack-[0-9]*:../../www/p5-Plack

USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/Catalyst/Engine/PSGI/.packlist
PERL5_MODULE_TYPE=	Module::Build::Tiny

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
