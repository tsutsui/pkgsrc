# $NetBSD: Makefile,v 1.42 2024/11/16 12:07:14 wiz Exp $

DISTNAME=	ack-v3.7.0
PKGNAME=	p5-${DISTNAME:S/-v/-/}
PKGREVISION=	2
CATEGORIES=	textproc perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/P/PE/PETDANCE/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/ack
COMMENT=	Grep-like text finder
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-File-Next>=1.18:../../devel/p5-File-Next
#DEPENDS+=	p5-Term-ANSIColor-[0-9]*:../../devel/p5-Term-ANSIColor

USE_TOOLS+=		perl
USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/ack/.packlist
REPLACE_PERL+=		ack

# Avoid ack regenerating itself and frustrating REPLACE_PERL setting
post-configure:
	    ${TOUCH} ${WRKSRC}/ack

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
