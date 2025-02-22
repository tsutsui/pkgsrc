# $NetBSD: Makefile,v 1.70 2024/12/10 16:07:24 schmonz Exp $
#

DISTNAME=		ucspi-ssl-0.13.03
PKGNAME=		${DISTNAME:S/-0./-0.999./}
PKGREVISION=		2
CATEGORIES=		net
MASTER_SITES=		https://www.fehcom.de/ipnet/ucspi-ssl/
EXTRACT_SUFX=		.tgz

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://www.fehcom.de/ipnet/ucspi-ssl.html
COMMENT=		Command-line tools for SSL client-server applications
LICENSE=		public-domain

WRKSRC=			${WRKDIR}/host/superscript.com/net/${DISTNAME}
DJB_SLASHPACKAGE=	YES

SSL_SCRIPTS=		https@ sslcat sslconnect
SSL_PROGRAMS=		sslclient sslserver
SSL_LIBS=		ucspissl.a
SSL_HEADERS=		ucspissl.h
SSL_MAN1PAGES=		${SSL_SCRIPTS:S/$/.1/g} ${SSL_PROGRAMS:S/$/.1/g}
SSL_MAN1PAGES+=		sslhandle.1
SSL_MAN2PAGES=		ucspi-tls.2

PKG_USERS_VARS+=	UCSPI_SSL_USER
PKG_GROUPS_VARS+=	UCSPI_SSL_GROUP
PKG_GROUPS+=		${UCSPI_SSL_GROUP}
PKG_USERS+=		${UCSPI_SSL_USER}:${UCSPI_SSL_GROUP}

BUILD_DEFS+=		PKG_SYSCONFBASE
PKG_SYSCONFSUBDIR=	${PKGBASE}

EGDIR=			${PREFIX}/share/examples/${PKGBASE}
MAKE_DIRS+=		${PKG_SYSCONFDIR}
CONF_FILES+=		${EGDIR}/dh2048.pem ${PKG_SYSCONFDIR}/dh2048.pem

DJB_CONFIG_DIR=		${WRKSRC}
DJB_CONFIG_CMDS=							\
	${ECHO} > conf-ssl;						\
	${ECHO} ${SSLDIR}/certs > conf-cadir;				\
	${ECHO} ${PKG_SYSCONFDIR}/dh2048.pem > conf-dhfile;		\
	${ECHO} ${DEFAULT_CIPHERS} > conf-ciphers;			\
	${ECHO} it-base > src/it=d;

# from `conf-ciphers` for TLS 1.3:
DEFAULT_CIPHERS=	TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384

INSTALLATION_DIRS=	bin include lib ${PKGMANDIR}/man1 ${PKGMANDIR}/man2 share/doc/${PKGBASE} ${EGDIR}

.include "options.mk"

do-test:
	cd ${WRKSRC}; \
		./package/rts

do-install: do-install-sslperl
.for i in ${SSL_SCRIPTS}
	  ${INSTALL_SCRIPT} ${WRKSRC}/command/${i} ${DESTDIR}${PREFIX}/bin
.endfor

.for i in ${SSL_PROGRAMS}
	  ${INSTALL_PROGRAM} ${WRKSRC}/command/${i} ${DESTDIR}${PREFIX}/bin
.endfor

.for i in ${SSL_LIBS}
	  ${INSTALL_DATA} ${WRKSRC}/compile/${i} ${DESTDIR}${PREFIX}/lib
.endfor

.for i in ${SSL_HEADERS}
	  ${INSTALL_DATA} ${WRKSRC}/compile/${i} ${DESTDIR}${PREFIX}/include
.endfor

.for i in ${SSL_MAN1PAGES}
	  ${INSTALL_MAN} ${WRKSRC}/man/${i} ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1
.endfor

.for i in ${SSL_MAN2PAGES}
	  ${INSTALL_MAN} ${WRKSRC}/man/${i} ${DESTDIR}${PREFIX}/${PKGMANDIR}/man2
.endfor

.for i in dh2048.pem
	  ${INSTALL_DATA} ${WRKSRC}/etc/${i} ${DESTDIR}${EGDIR}
.endfor

.for i in CHAIN-SSL CHANGELOG TLSVERSION_CIPHERSUITES TLS_1_3 TODO UCSPI-SSL.md
	  ${INSTALL_DATA} ${WRKSRC}/doc/${i} \
	    ${DESTDIR}${PREFIX}/share/doc/${PKGBASE}
.endfor

.include "../../net/fehqlibs/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../mk/dlopen.buildlink3.mk"
.include "../../mk/djbware.mk"
.include "../../mk/bsd.pkg.mk"
