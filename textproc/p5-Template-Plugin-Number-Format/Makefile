# $NetBSD: Makefile,v 1.23 2024/11/16 12:06:55 wiz Exp $
#

DISTNAME=	Template-Plugin-Number-Format-1.06
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	10
CATEGORIES=	textproc
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Template/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Number-Format
COMMENT=	Plugin/filter interface to Number::Format
LICENSE=	gnu-gpl-v3

DEPENDS+=	p5-Template-Toolkit>=2.07:../../www/p5-Template-Toolkit
DEPENDS+=	p5-Number-Format-[0-9]*:../../textproc/p5-Number-Format

PERL5_PACKLIST=		auto/Template/Plugin/Number/Format/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
