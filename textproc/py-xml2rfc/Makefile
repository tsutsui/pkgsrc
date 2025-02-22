# $NetBSD: Makefile,v 1.25 2025/02/07 07:16:25 adam Exp $

DISTNAME=	xml2rfc-3.27.0
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
CATEGORIES=	textproc python
MASTER_SITES=	${MASTER_SITE_PYPI:=x/xml2rfc/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/ietf-tools/xml2rfc
COMMENT=	IETF RFC 7749 XML-to-RFC conversion tool
LICENSE=	modified-bsd

DEPENDS+=	${PYPKGPREFIX}-configargparse>=1.2.3:../../devel/py-configargparse
DEPENDS+=	${PYPKGPREFIX}-country>=22.3.5:../../geography/py-country
DEPENDS+=	${PYPKGPREFIX}-google-i18n-address>=3.0.0:../../devel/py-google-i18n-address
DEPENDS+=	${PYPKGPREFIX}-intervaltree>=3.1.0:../../devel/py-intervaltree
DEPENDS+=	${PYPKGPREFIX}-jinja2>=3.1.2:../../textproc/py-jinja2
DEPENDS+=	${PYPKGPREFIX}-lxml>=5.3.0:../../textproc/py-lxml
DEPENDS+=	${PYPKGPREFIX}-platformdirs>=3.6.0:../../misc/py-platformdirs
DEPENDS+=	${PYPKGPREFIX}-requests>=2.5.0:../../devel/py-requests
DEPENDS+=	${PYPKGPREFIX}-setuptools>=24.2.0:../../devel/py-setuptools
DEPENDS+=	${PYPKGPREFIX}-wcwidth>=0.2.5:../../devel/py-wcwidth
DEPENDS+=	${PYPKGPREFIX}-yaml>=5.3.1:../../textproc/py-yaml
TEST_DEPENDS+=	${PYPKGPREFIX}-decorator-[0-9]*:../../devel/py-decorator
TEST_DEPENDS+=	${PYPKGPREFIX}-dict2xml-[0-9]*:../../devel/py-dict2xml
TEST_DEPENDS+=	${PYPKGPREFIX}-pdf>=3.2.1:../../textproc/py-pdf
TEST_DEPENDS+=	${PYPKGPREFIX}-weasyprint>=60.1:../../print/py-weasyprint

USE_LANGUAGES=	# none

post-install:
	cd ${DESTDIR}${PREFIX}/bin && \
	${MV} xml2rfc xml2rfc-${PYVERSSUFFIX} || ${TRUE}

do-test:
	${RUN} cd ${WRKSRC} && ${PYTHONBIN} -m unittest

.include "../../lang/python/wheel.mk"
.include "../../mk/bsd.pkg.mk"
