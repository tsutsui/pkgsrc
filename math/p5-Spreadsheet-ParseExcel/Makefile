# $NetBSD: Makefile,v 1.43 2024/11/16 12:06:01 wiz Exp $

DISTNAME=	Spreadsheet-ParseExcel-0.66
PKGNAME=	p5-${DISTNAME}00
PKGREVISION=	1
CATEGORIES=	math perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Spreadsheet/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/Spreadsheet-ParseExcel
COMMENT=	Perl module to get information from an Excel file
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Crypt-RC4-[0-9]*:../../security/p5-Crypt-RC4
DEPENDS+=	p5-Digest-Perl-MD5-[0-9]*:../../security/p5-Digest-Perl-MD5
DEPENDS+=	p5-OLE-Storage_Lite>=0.19:../../devel/p5-OLE-Storage_Lite
DEPENDS+=	p5-IO-stringy>=0:../../devel/p5-IO-stringy

USE_LANGUAGES=	# empty
PERL5_PACKLIST=	auto/Spreadsheet/ParseExcel/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
