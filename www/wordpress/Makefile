# $NetBSD: Makefile,v 1.112 2025/02/08 04:07:19 taca Exp $

DISTNAME=		wordpress-${VERSION}
PKGNAME=		${PHP_PKG_PREFIX}-${DISTNAME}
VERSION=		6.7.1
PKGREVISION=		1
CATEGORIES=		www
MASTER_SITES=		https://wordpress.org/
EXTRACT_SUFX=		.zip

MAINTAINER=		morr@NetBSD.org
HOMEPAGE=		https://wordpress.org/
COMMENT=		Blogging tool written in php
LICENSE=		gnu-gpl-v2

USE_TOOLS+=		pax

PHP_VERSIONS_ACCEPTED=	74 81 82 83

.include "../../mk/bsd.prefs.mk"
.include "../../lang/php/phpversion.mk"
.include "options.mk"

NO_BUILD=		yes
WRKSRC=			${WRKDIR}/wordpress

WWW_USER?=		${APACHE_USER}
WWW_GROUP?=		${APACHE_GROUP}

PKG_GROUPS_VARS=	WWW_GROUP
PKG_USERS_VARS=		WWW_USER
BUILD_DEFS+=		WWW_USER WWW_GROUP APACHE_USER APACHE_GROUP
EGDIR=			${PREFIX}/share/examples/wordpress
DOCDIR=			${PREFIX}/share/doc/wordpress
WPHOME=			${PREFIX}/share/wordpress
FILES_SUBST+=		WPHOME=${WPHOME}
MESSAGE_SUBST+=		DOCDIR=${DOCDIR}

CONF_FILES+=		${EGDIR}/wordpress.conf ${PKG_SYSCONFDIR}/wordpress.conf
OWN_DIRS_PERMS+=	${WPHOME}/wp-content/uploads \
			${WWW_USER} ${WWW_GROUP} 0750

INSTALLATION_DIRS+=	${DOCDIR} ${WPHOME} ${EGDIR}

DEPENDS+=		${PHP_PKG_PREFIX}-mysqli>=${PHP_BASE_VERS}:../../databases/php-mysqli
DEPENDS+=		${PHP_PKG_PREFIX}-gd>=${PHP_BASE_VERS}:../../graphics/php-gd
DEPENDS+=		${PHP_PKG_PREFIX}-curl>=${PHP_BASE_VERS}:../../www/php-curl
DEPENDS+=		${PHP_PKG_PREFIX}-zip>=${PHP_BASE_VERS}:../../archivers/php-zip
DEPENDS+=		${PHP_PKG_PREFIX}-zlib>=${PHP_BASE_VERS}:../../archivers/php-zlib

SUBST_CLASSES+=		conf
SUBST_MESSAGE.conf=	Fixing pathnames in configuration file.
SUBST_STAGE.conf=	pre-configure
SUBST_FILES.conf=	../wordpress.conf
SUBST_VARS.conf=	WPHOME
.if !empty(PKG_OPTIONS:Map-php) && ${PKG_APACHE} == "apache24"
SUBST_SED.conf+=	-e "/Order allow,deny/d"
SUBST_SED.conf+=	-e "s,Allow from all,Require all granted,g"
.endif

post-extract:
	${CP} ${FILESDIR}/wordpress.conf ${WRKDIR}/wordpress.conf

do-install:
	${INSTALL_DATA} ${WRKSRC}/readme.html ${DESTDIR}${DOCDIR}
	${INSTALL_DATA} ${WRKSRC}/license.txt ${DESTDIR}${DOCDIR}

#	${INSTALL_DATA} ${WRKSRC}/wp-config-sample.php ${DESTDIR}${EGDIR}
	${INSTALL_DATA} ${WRKDIR}/wordpress.conf ${DESTDIR}${EGDIR}

	${RM} ${WRKSRC}/readme.html
	${RM} ${WRKSRC}/license.txt
#	${RM} ${WRKSRC}/wp-config-sample.php

	cd ${WRKSRC} && pax -rw -pmp . ${DESTDIR}${WPHOME}
	${TOUCH} ${DESTDIR}${WPHOME}/wp-content/plugins/index.html
	${FIND} ${DESTDIR}${WPHOME} \
		-type d -exec ${CHMOD} ${PKGDIRMODE} "{}" \;
	${FIND} ${DESTDIR}${WPHOME} \
		-type f -exec ${CHMOD} ${SHAREMODE} "{}" \;

.include "../../mk/bsd.pkg.mk"
