# $NetBSD: Makefile,v 1.19 2024/10/10 20:00:19 nia Exp $
#

DISTNAME=		udpcast-20060619
PKGREVISION=		10
CATEGORIES=		net
MASTER_SITES=		http://www.udpcast.linux.lu/download/

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://www.udpcast.linux.lu/
COMMENT=		Send data simultaneously to many destinations on a LAN

MAKE_JOBS_SAFE=		no

USE_TOOLS+=		gmake perl pod2man

# msg_controllen and friends
CFLAGS.SunOS+=		-D_POSIX_C_SOURCE=200809L -D__EXTENSIONS__

INSTALLATION_DIRS=	sbin ${PKGMANDIR}/man1

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/udp-receiver ${DESTDIR}${PREFIX}/sbin
	${INSTALL_PROGRAM} ${WRKSRC}/udp-sender ${DESTDIR}${PREFIX}/sbin
	${INSTALL_MAN} ${WRKSRC}/udp-receiver.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1
	${INSTALL_MAN} ${WRKSRC}/udp-sender.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1

.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
