# $NetBSD: Makefile,v 1.20 2024/10/09 13:18:15 wiz Exp $

DISTNAME=	build-1.2.2.post1
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
CATEGORIES=	devel python
MASTER_SITES=	${MASTER_SITE_PYPI:=b/build/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/pypa/build
COMMENT=	Simple, correct PEP517 package builder
LICENSE=	mit

DEPENDS+=	${PYPKGPREFIX}-packaging>=19.1:../../devel/py-packaging
DEPENDS+=	${PYPKGPREFIX}-pyproject_hooks-[0-9]*:../../devel/py-pyproject_hooks
TEST_DEPENDS+=	${PYPKGPREFIX}-filelock>=3:../../devel/py-filelock
TEST_DEPENDS+=	${PYPKGPREFIX}-wheel>=0.36.0:../../devel/py-wheel
TEST_DEPENDS+=	${PYPKGPREFIX}-test>=6.2.4:../../devel/py-test
TEST_DEPENDS+=	${PYPKGPREFIX}-test-cov>=2.12:../../devel/py-test-cov
TEST_DEPENDS+=	${PYPKGPREFIX}-test-mock>=2:../../devel/py-test-mock
TEST_DEPENDS+=	${PYPKGPREFIX}-test-rerunfailures>=9.1:../../devel/py-test-rerunfailures
TEST_DEPENDS+=	${PYPKGPREFIX}-test-xdist>=1.34:../../devel/py-test-xdist

USE_LANGUAGES=	# none

.include "../../lang/python/pyversion.mk"
.if ${PYTHON_VERSION} < 311
DEPENDS+=	${PYPKGPREFIX}-tomli>=1.1.0:../../textproc/py-tomli
.endif

post-install:
	cd ${DESTDIR}${PREFIX}/bin && \
	${MV} pyproject-build pyproject-build-${PYVERSSUFFIX} || ${TRUE}

# as of 1.2.2.post1
# 14 failed, 125 passed, 55 skipped, 1 xfailed, 1 error, 10 rerun

# needs 'make install'
do-test:
	cd ${WRKSRC} && ${SETENV} ${TEST_ENV} pytest-${PYVERSSUFFIX}

.include "../../lang/python/bootstrap.mk"
.include "../../mk/bsd.pkg.mk"
