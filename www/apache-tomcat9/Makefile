# $NetBSD: Makefile,v 1.13 2024/07/18 11:48:07 ryoon Exp $
#

DISTNAME=	apache-tomcat-${TOMCAT_VER}
CATEGORIES=	www
MASTER_SITES=	${MASTER_SITE_APACHE:=tomcat/tomcat-9/v${TOMCAT_VER}/bin/}

MAINTAINER=	ryoon@NetBSD.org
HOMEPAGE=	https://tomcat.apache.org/
COMMENT=	Implementation of Java Servlet and JavaServer Pages technologies
LICENSE=	apache-2.0

CONFLICTS+=	apache-tomcat55-[0-9]*
CONFLICTS+=	apache-tomcat6-[0-9]*
CONFLICTS+=	apache-tomcat7-[0-9]*
CONFLICTS+=	apache-tomcat8-[0-9]*
CONFLICTS+=	apache-tomcat85-[0-9]*

NO_BUILD=	yes
USE_LANGUAGES=	# none
USE_JAVA=	run
USE_JAVA2=	8
USE_TOOLS+=	pax

.include "../../mk/bsd.prefs.mk"

TOMCAT_VER=		9.0.91
TOMCAT_HOME=		${PREFIX}/share/tomcat
EGDIR=			${PREFIX}/share/examples/tomcat
DOCDIR=			${PREFIX}/share/doc/tomcat
RCD_SCRIPTS=		tomcat
SMF_NAME=		tomcat
TOMCAT_USER?=		tomcat
TOMCAT_GROUP?=		tomcat
PKG_GROUPS=		${TOMCAT_GROUP}
PKG_USERS=		${TOMCAT_USER}:${TOMCAT_GROUP}
PKG_GROUPS_VARS+=	TOMCAT_GROUP
PKG_USERS_VARS+=	TOMCAT_USER
PKG_HOME.tomcat=	${TOMCAT_HOME}
PKG_SHELL.tomcat=	${SH}
PKG_SYSCONFDIR.tomcat=	${TOMCAT_HOME}/conf
OWN_DIRS_PERMS+=	${PKG_SYSCONFDIR.tomcat} ${TOMCAT_USER} ${TOMCAT_GROUP} 0755
FILES_SUBST+=		JAVA_HOME=${PKG_JAVA_HOME} TOMCAT_HOME=${TOMCAT_HOME} \
			TOMCAT_USER=${TOMCAT_USER} TOMCAT_GROUP=${TOMCAT_GROUP}

PRIVATE_EGFILES=	server.xml tomcat-users.xml
PUBLIC_EGFILES=		catalina.policy catalina.properties \
			context.xml logging.properties web.xml
DOCFILES=		LICENSE NOTICE RELEASE-NOTES RUNNING.txt
WORK_DIRS=		work temp logs

.for f in ${PRIVATE_EGFILES}
CONF_FILES_PERMS+=	${EGDIR}/${f} ${PKG_SYSCONFDIR.tomcat}/${f} \
			${TOMCAT_USER} ${TOMCAT_GROUP} 0640
.endfor

.for f in ${PUBLIC_EGFILES}
CONF_FILES_PERMS+=	${EGDIR}/${f} ${PKG_SYSCONFDIR.tomcat}/${f} \
			${TOMCAT_USER} ${TOMCAT_GROUP} 0644
.endfor

.for d in ${WORK_DIRS}
OWN_DIRS_PERMS+=	${TOMCAT_HOME}/${d} ${TOMCAT_USER} ${TOMCAT_GROUP} 0755
.endfor

INSTALLATION_DIRS+=	${TOMCAT_HOME} ${EGDIR} ${DOCDIR}

do-install:
.for d in ${WORK_DIRS}
	${RM} -rf ${WRKSRC}/${d}
.endfor

.for f in ${DOCFILES}
	${INSTALL_DATA} ${WRKSRC}/${f} ${DESTDIR}${DOCDIR}/${f}
	${RM} -f ${WRKSRC}/${f}
.endfor

.for f in ${PRIVATE_EGFILES}
	${INSTALL_DATA} ${WRKSRC}/conf/${f} ${DESTDIR}${EGDIR}/${f}
	${RM} -f ${WRKSRC}/conf/${f}
.endfor

.for f in ${PUBLIC_EGFILES}
	${INSTALL_DATA} ${WRKSRC}/conf/${f} ${DESTDIR}${EGDIR}/${f}
	${RM} -f ${WRKSRC}/conf/${f}
.endfor

	${FIND} ${WRKSRC} -name \*.exe -type f -print | ${XARGS} ${RM} -f
	${FIND} ${WRKSRC} -name \*.bat -type f -print | ${XARGS} ${RM} -f

	cd ${WRKSRC} && ${PAX} -rw -pm . ${DESTDIR}${TOMCAT_HOME}

	${FIND} ${DESTDIR}${TOMCAT_HOME} -type d -print | \
		${XARGS} ${CHMOD} ${PKGDIRMODE}
	${FIND} ${DESTDIR}${TOMCAT_HOME} -type f -print | \
		${XARGS} ${CHMOD} ${SHAREMODE}
	${FIND} ${DESTDIR}${TOMCAT_HOME} -type f -name \*.sh -print | \
		${XARGS} ${CHMOD} ${BINMODE}

.include "../../mk/java-vm.mk"
.include "../../mk/bsd.pkg.mk"
