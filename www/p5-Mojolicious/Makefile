# $NetBSD: Makefile,v 1.155 2024/11/16 12:07:54 wiz Exp $
#
# When updating this package, please upload the distfile
# since they disappear immediately when new releases happen,
# which is quite often.

DISTNAME=	Mojolicious-9.38
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	www perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Mojolicious/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://mojolicio.us/
COMMENT=	Perl web framework: The Web In A Box!
LICENSE=	artistic-2.0

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/Mojolicious/.packlist

REPLACE_PERL+=	script/*

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
