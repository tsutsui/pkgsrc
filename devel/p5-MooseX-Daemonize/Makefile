# $NetBSD: Makefile,v 1.23 2024/11/16 12:04:42 wiz Exp $
#

DISTNAME=	MooseX-Daemonize-0.22
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	5
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=MooseX/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/MooseX-Daemonize
COMMENT=	Role for daemonizing your Moose based applicationoose
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Moose>=0.33:../../devel/p5-Moose
DEPENDS+=	p5-MooseX-Getopt>=0.07:../../devel/p5-MooseX-Getopt
DEPENDS+=	p5-MooseX-Types-Path-Class-[0-9]*:../../devel/p5-MooseX-Types-Path-Class
DEPENDS+=	p5-Sub-Exporter-ForMethods>=0:../../devel/p5-Sub-Exporter-ForMethods

USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/MooseX/Daemonize/.packlist
PERL5_MODULE_TYPE=	Module::Install::Bundled

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
