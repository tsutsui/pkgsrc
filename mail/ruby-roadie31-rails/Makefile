# $NetBSD: Makefile,v 1.1 2024/11/06 16:04:29 taca Exp $

DISTNAME=	roadie-rails-3.1.0
PKGNAME=	${RUBY_PKGPREFIX}-${DISTNAME:S/-rails/31-rails${RUBY_RAILS}/}
CATEGORIES=	mail

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/Mange/roadie-rails
COMMENT=	Hooks Roadie into your Rails application version 3.1.x
LICENSE=	mit

DEPENDS+=	${RUBY_RAILTIES_DEPENDS}
DEPENDS+=	${RUBY_PKGPREFIX}-roadie>=5.0<6:../../mail/ruby-roadie

USE_LANGUAGES=	# none

RUBY_RAILS_ACCEPTED=	61

.include "../../lang/ruby/gem.mk"
.include "../../mk/bsd.pkg.mk"
