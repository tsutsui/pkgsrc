# $NetBSD: Makefile,v 1.66 2025/01/02 19:54:36 adam Exp $

DISTNAME=	libtorrent-0.15.1
CATEGORIES=	net
MASTER_SITES=	${MASTER_SITE_GITHUB:=rakshasa/}
GITHUB_TAG=	v${PKGVERSION_NOREV}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/rakshasa/libtorrent
COMMENT=	BitTorrent library written in C++ for *nix
LICENSE=	gnu-gpl-v2

USE_CXX_FEATURES=	c++14
USE_LANGUAGES=		c c++
USE_LIBTOOL=		yes
USE_TOOLS+=		autoconf automake autoreconf gmake pkg-config
GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--disable-debug
LDFLAGS+=		-lz

.include "../../mk/bsd.prefs.mk"

# configure check is fooled by trap & emulate of unaligned access on alpha
.if ${MACHINE_ARCH} == "alpha"
CONFIGURE_ARGS+=	--enable-aligned
.endif

.if ${OPSYS:M*BSD} || ${OPSYS} == "DragonFly" || ${OPSYS} == "Darwin"
CONFIGURE_ARGS+=	--with-kqueue
.endif

.include "../../mk/compiler.mk"

# See http://libtorrent.rakshasa.no/ticket/96
.if ${CC_VERSION:Mgcc-[45].*}
CXXFLAGS+=	-fpermissive -fno-strength-reduce -fno-thread-jumps \
		-fno-inline -fforce-addr
.endif

.if ${MACHINE_ARCH:M*64*} == "" && ${MACHINE_ARCH} != "alpha"
CONFIGURE_ARGS+=	--disable-instrumentation
.endif

.include "../../security/openssl/buildlink3.mk"
.if !exists(${BUILDLINK_PREFIX.openssl}/lib/pkgconfig/openssl.pc)
OPENSSL_CFLAGS=	-I${BUILDLINK_PREFIX.openssl}/include
OPENSSL_LIBS=	-L${BUILDLINK_PREFIX.openssl}/lib \
		${COMPILER_RPATH_FLAG}${BUILDLINK_PREFIX.openssl}/lib

CONFIGURE_ENV+=	OPENSSL_CFLAGS=${OPENSSL_CFLAGS:M*:Q}
CONFIGURE_ENV+=	OPENSSL_LIBS=${OPENSSL_LIBS:Q}
.endif

pre-configure:
	set -e; cd ${WRKSRC} && autoreconf -fi

.include "../../devel/zlib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
