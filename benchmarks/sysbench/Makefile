# $NetBSD: Makefile,v 1.27 2024/11/14 22:18:46 wiz Exp $

DISTNAME=	sysbench-0.4.12
PKGREVISION=	18
CATEGORIES=	benchmarks
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=sysbench/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://launchpad.net/sysbench/
COMMENT=	Modular, cross-platform and multi-threaded benchmark tool

USE_LIBTOOL=		yes
GNU_CONFIGURE=		yes
PTHREAD_AUTO_VARS=	yes
MAKE_FLAGS+=		bin_SCRIPTS= # don't install problematic scripts

CFLAGS.NetBSD+=		-D_NETBSD_SOURCE # hack for ulong along with patch-aa

.include "../../mk/compiler.mk"
.if !empty(MACHINE_PLATFORM:MSunOS-5.1[0-9]-*) && \
    !empty(CC_VERSION:Mgcc-4.[6-9].*)
BUILDLINK_TRANSFORM+=	rm:-D_XOPEN_SOURCE=500
.endif

.include "options.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
