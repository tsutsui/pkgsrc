# $NetBSD: Makefile,v 1.51 2025/02/06 14:28:27 adam Exp $

DISTNAME=	talloc-2.4.3
CATEGORIES=	devel
MASTER_SITES=	https://www.samba.org/ftp/talloc/

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://talloc.samba.org/talloc/doc/html/index.html
COMMENT=	Hierarchical pool based memory allocator with destructors
LICENSE=	gnu-gpl-v3 AND gnu-lgpl-v3

TOOL_DEPENDS+=	libxslt-[0-9]*:../../textproc/libxslt
TOOL_DEPENDS+=	docbook-xsl-[0-9]*:../../textproc/docbook-xsl

# include/talloc.h
CONFLICTS+=	samba<=4.6.8nb3

USE_TOOLS+=		pkg-config
HAS_CONFIGURE=		yes
CONFIGURE_ARGS+=	--mandir=${PREFIX}/${PKGMANDIR}
CONFIGURE_ARGS+=	--abi-check-disable
CONFIGURE_ARGS+=	--disable-symbol-versions
.if defined(MAKE_JOBS) && !empty(MAKE_JOBS) && !(defined(MAKE_JOBS_SAFE) && ${MAKE_JOBS_SAFE:U:tl} == no)
CONFIGURE_ARGS+=	--jobs=${MAKE_JOBS}
.else
CONFIGURE_ARGS+=	--jobs=1
.endif
PKGCONFIG_OVERRIDE+=	talloc.pc.in
PKGCONFIG_OVERRIDE+=	pytalloc-util.pc.in
TEST_TARGET=		test

PY_PATCHPLIST=		yes
REPLACE_PYTHON+=	buildtools/bin/waf
MAKE_FLAGS+=		WAF_BINARY=${PYTHONBIN}\ ${WRKSRC}/buildtools/bin/waf

SUBST_CLASSES+=		docbook
SUBST_MESSAGE.docbook=	Fixing docbook URLs.
SUBST_FILES.docbook+=	buildtools/wafsamba/samba_conftests.py
SUBST_FILES.docbook+=	buildtools/wafsamba/wafsamba.py
SUBST_STAGE.docbook=	pre-configure
SUBST_SED.docbook+=	-e 's,http://docbook.sourceforge.net/release/xsl/current,${PREFIX}/share/xsl/docbook,g'

.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../lang/python/application.mk"
.include "../../lang/python/extension.mk"
.include "../../mk/dlopen.buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
