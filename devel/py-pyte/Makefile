# $NetBSD: Makefile,v 1.8 2024/11/11 07:28:21 wiz Exp $

DISTNAME=	pyte-0.8.2
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	devel python
MASTER_SITES=	${MASTER_SITE_PYPI:=p/pyte/}

MAINTAINER=	gson@NetBSD.org
HOMEPAGE=	https://github.com/selectel/pyte
COMMENT=	VTXXX-compatible terminal emulator library
LICENSE=	gnu-lgpl-v3

TOOL_DEPENDS+=	${PYPKGPREFIX}-setuptools-[0-9]*:../../devel/py-setuptools
DEPENDS+=	${PYPKGPREFIX}-wcwidth>=0.1.7:../../devel/py-wcwidth
TEST_DEPENDS+=	${PYPKGPREFIX}-test-[0-9]*:../../devel/py-test

USE_LANGUAGES=	# none

PYTHON_VERSIONS_INCOMPATIBLE=	27

# as of 0.8.2
# 114 passed, 1 xfailed, 9 warnings

.include "../../lang/python/wheel.mk"
.include "../../mk/bsd.pkg.mk"
