# $NetBSD: Makefile,v 1.14 2024/08/22 17:06:00 gdt Exp $
#

DISTNAME=		xylem.1.8.7
PKGNAME=		xylem-1.8.7
CATEGORIES=		biology
MASTER_SITES=		ftp://ftp.cc.umanitoba.ca/psgendb/
EXTRACT_SUFX=		.tar.Z

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		https://home.cc.umanitoba.ca/~psgendb/XYLEM.html
COMMENT=		Tools for manipulation of genetic databases

MAKE_JOBS_SAFE=		no

WRKSRC=			${WRKDIR}/xylem
BUILD_DIRS=		src.c # yes, it's a directory
INSTALLATION_DIRS=	bin

do-configure:
	${CP} ${WRKSRC}/src.c/p2c.h.standard ${WRKSRC}/src.c/p2c.h

# Rename some binaries to avoid confusion with base system or conflicts
post-build:
	${RM} -f ${WRKSRC}/test/testxylem.csh.orig
	${MV} ${WRKSRC}/src.c/identify ${WRKSRC}/src.c/xyl-identify
	${MV} ${WRKSRC}/src.c/shuffle ${WRKSRC}/src.c/xyl-shuffle

do-install:
.for program in dbstat getloc getob xyl-identify prot2nuc reform ribosome \
	splitdb xyl-shuffle flat2phyl phyl2flat
	${INSTALL_PROGRAM} ${WRKSRC}/src.c/${program} ${DESTDIR}${PREFIX}/bin
.endfor
	${INSTALL_DATA_DIR} ${DESTDIR}${PREFIX}/share/doc/xylem
	${INSTALL_DATA} ${WRKSRC}/doc/* ${DESTDIR}${PREFIX}/share/doc/xylem/
	${INSTALL_DATA_DIR} ${DESTDIR}${PREFIX}/share/examples/xylem
	${INSTALL_DATA} ${WRKSRC}/test/sample.* \
		${DESTDIR}${PREFIX}/share/examples/xylem
	${INSTALL_SCRIPT} ${WRKSRC}/test/testxylem.csh \
		${DESTDIR}${PREFIX}/share/examples/xylem

.include "../../mk/bsd.pkg.mk"
