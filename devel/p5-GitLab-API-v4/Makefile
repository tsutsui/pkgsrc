# $NetBSD: Makefile,v 1.13 2024/11/16 12:04:21 wiz Exp $

DISTNAME=	GitLab-API-v4-0.26
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	2
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/B/BL/BLUEFEET/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/GitLab-API-v4
COMMENT=	Complete GitLab API v4 client
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Const-Fast-[0-9]*:../../devel/p5-Const-Fast
DEPENDS+=	p5-IO-Prompter-[0-9]*:../../devel/p5-IO-Prompter
DEPENDS+=	p5-Log-Any-Adapter-Screen>=0.13:../../devel/p5-Log-Any-Adapter-Screen
DEPENDS+=	p5-Log-Any-Adapter-TAP-[0-9]*:../../devel/p5-Log-Any-Adapter-TAP
DEPENDS+=	p5-Path-Tiny>=0.079:../../filesystems/p5-Path-Tiny
DEPENDS+=	p5-YAML-[0-9]*:../../textproc/p5-YAML
DEPENDS+=	p5-HTTP-Tiny-Multipart>=0.08:../../www/p5-HTTP-Tiny-Multipart
DEPENDS+=	p5-Role-REST-Client>=0.22:../../www/p5-Role-REST-Client

REPLACE_PERL+=	script/gitlab-api-v4

PERL5_PACKLIST=		auto/GitLab/API/v4/.packlist
PERL5_MODULE_TYPE=	Module::Build::Tiny

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
