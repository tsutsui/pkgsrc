# $NetBSD: Makefile,v 1.5 2024/11/11 07:29:19 wiz Exp $

DISTNAME=	django-localflavor-4.0
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
CATEGORIES=	www python
MASTER_SITES=	${MASTER_SITE_PYPI:=d/django-localflavor/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://django-localflavor.readthedocs.io/en/latest/
COMMENT=	L18N support for Django
LICENSE=	modified-bsd

TOOL_DEPENDS+=	${PYPKGPREFIX}-setuptools-[0-9]*:../../devel/py-setuptools
DEPENDS+=	${PYPKGPREFIX}-django>=3.2:../../www/py-django3
DEPENDS+=	${PYPKGPREFIX}-stdnum>=1.6:../../misc/py-stdnum

USE_LANGUAGES=	# none

PYTHON_VERSIONS_INCOMPATIBLE=	27

.include "../../lang/python/wheel.mk"
.include "../../mk/bsd.pkg.mk"
