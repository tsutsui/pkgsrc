# $NetBSD: Makefile,v 1.14 2024/11/11 07:29:09 wiz Exp $

DISTNAME=	sphinxcontrib_bibtex-2.6.3
PKGNAME=	${PYPKGPREFIX}-${DISTNAME:S/_/-/}
CATEGORIES=	textproc python
MASTER_SITES=	${MASTER_SITE_PYPI:=s/sphinxcontrib-bibtex/}

MAINTAINER=	jaapb@NetBSD.org
HOMEPAGE=	https://github.com/mcmtroffaes/sphinxcontrib-bibtex
COMMENT=	Sphinx extension for BibTeX style citations
LICENSE=	2-clause-bsd

TOOL_DEPENDS+=	${PYPKGPREFIX}-setuptools-[0-9]*:../../devel/py-setuptools
DEPENDS+=	${PYPKGPREFIX}-docutils>=0.20:../../textproc/py-docutils
DEPENDS+=	${PYPKGPREFIX}-sphinx>=3.5:../../textproc/py-sphinx
DEPENDS+=	${PYPKGPREFIX}-pybtex>=0.24:../../textproc/py-pybtex
DEPENDS+=	${PYPKGPREFIX}-pybtex-docutils>=1.0.0:../../textproc/py-pybtex-docutils

USE_LANGUAGES=	# none

PYTHON_VERSIONS_INCOMPATIBLE=	39 # py-sphinx

.include "../../lang/python/pyversion.mk"
.if ${PYTHON_VERSION} >= 312
DEPENDS+=	${PYPKGPREFIX}-setuptools-[0-9]*:../../devel/py-setuptools
.endif

.include "../../lang/python/wheel.mk"
.include "../../mk/bsd.pkg.mk"
