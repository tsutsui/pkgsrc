# $NetBSD: Makefile,v 1.19 2024/11/16 12:05:03 wiz Exp $
#

DISTNAME=	Set-Array-0.30
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	11
CATEGORIES=	devel
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Set/}
EXTRACT_SUFX=	.tgz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Set-Array
COMMENT=	Arrays as objects with lots of handy methods
LICENSE=	${PERL5_LICENSE}

TOOL_DEPENDS+=	p5-Try-Tiny>=0.11:../../devel/p5-Try-Tiny
TOOL_DEPENDS+=	p5-Test-Deep>=0:../../devel/p5-Test-Deep
TOOL_DEPENDS+=	p5-Test-Pod>=0:../../devel/p5-Test-Pod
DEPENDS+=	p5-Want>=0:../../devel/p5-Want

PERL5_MODULE_TYPE=	Module::Build
PERL5_PACKLIST=		auto/Set/Array/.packlist
USE_LANGUAGES=		# none

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
