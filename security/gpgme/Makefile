# $NetBSD: Makefile,v 1.121 2024/12/09 11:39:38 adam Exp $

DISTNAME=	gpgme-1.24.1
CATEGORIES=	security
MASTER_SITES=	https://www.gnupg.org/ftp/gcrypt/gpgme/
EXTRACT_SUFX=	.tar.bz2

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://www.gnupg.org/related_software/gpgme/
COMMENT=	GnuPG Made Easy
LICENSE=	gnu-gpl-v2

USE_CC_FEATURES=	c99
USE_CXX_FEATURES=	c++11
USE_LANGUAGES+=		c c++
USE_LIBTOOL=		yes
USE_TOOLS+=		gmake
GNU_CONFIGURE=		yes
PTHREAD_OPTS+=		require
INFO_FILES=		yes
CONFIGURE_ARGS+=	--enable-languages="cl cpp"

SUBST_CLASSES+=		pthread
SUBST_FILES.pthread=	src/gpgme-config.in
SUBST_SED.pthread+=	-e 's,@PTHREAD_LIBS@,${PTHREAD_LDFLAGS} ${PTHREAD_LIBS},g'
SUBST_VARS.pthread=	PTHREAD_CFLAGS
SUBST_STAGE.pthread=	pre-configure

CPPFLAGS.Darwin=	-D_POSIX_C_SOURCE=200809L
LIBS.SunOS+=		-lnsl -lsocket

BUILDLINK_TRANSFORM+=	rm:-Wsuggest-override

TEST_TARGET=		all
TEST_DIRS=		tests

PKGCONFIG_OVERRIDE+=	src/gpgme.pc
PKGCONFIG_OVERRIDE+=	src/gpgme-glib.pc
PKGCONFIG_OVERRIDE+=	lang/cpp/src/gpgmepp.pc

PKGCONFIG_OVERRIDE_STAGE=	post-configure

.include "options.mk"

.include "../../security/libassuan2/buildlink3.mk"
BUILDLINK_API_DEPENDS.libgpg-error+=	libgpg-error>=1.28
.include "../../security/libgpg-error/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
