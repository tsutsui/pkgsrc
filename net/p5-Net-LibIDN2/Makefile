# $NetBSD: Makefile,v 1.5 2024/11/16 12:06:15 wiz Exp $

DISTNAME=	Net-LibIDN2-1.02
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	net perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Net/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Net-LibIDN2
COMMENT=	Perl bindings for GNU libidn2
LICENSE=	artistic

PERL5_MODULE_TYPE=	Module::Build
PERL5_PACKLIST=		auto/Net/LibIDN2/.packlist

# otherwise libidn2.so.0 doesn't get found
MAKE_ENV+=	"LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${BUILDLINK_DIR}/lib"

.include "../../devel/libidn2/buildlink3.mk"
.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
