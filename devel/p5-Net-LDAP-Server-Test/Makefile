# $NetBSD: Makefile,v 1.23 2024/11/16 12:04:48 wiz Exp $

DISTNAME=	Net-LDAP-Server-Test-0.22
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	7
CATEGORIES=	devel net perl5
#MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/K/KA/KARMAN/}
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Net/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Net-LDAP-Server-Test
COMMENT=	Perl 5 module to test Net::LDAP code
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Net-LDAP-Server-[0-9]*:../../net/p5-Net-LDAP-Server
DEPENDS+=	p5-Net-LDAP-SID-[0-9]*:../../devel/p5-Net-LDAP-SID
DEPENDS+=	p5-perl-ldap-[0-9]*:../../databases/p5-perl-ldap
DEPENDS+=	p5-Data-Dump-[0-9]*:../../devel/p5-Data-Dump

USE_LANGUAGES=		# empty

PERL5_PACKLIST=	auto/Net/LDAP/Server/Test/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
