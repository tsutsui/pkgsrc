# $NetBSD: Makefile,v 1.144 2025/02/05 19:00:26 osa Exp $

DISTNAME=	nginx-1.27.4
PKGNAME=	${DISTNAME:S/-/-devel-/1}
PKGREVISION=	0
CATEGORIES=	www
MASTER_SITES=	https://nginx.org/download/
DISTFILES=	${DEFAULT_DISTFILES}

MAINTAINER=	osa@NetBSD.org
HOMEPAGE=	https://nginx.org/
COMMENT=	Lightweight HTTP server and mail proxy server
LICENSE=	2-clause-bsd

PATCH_SITES=		https://github.com/freenginx/nginx/commit/
PATCHFILES=		1ac658f44afc9240f13e9d6c1c9d5a7816299e8e.patch
PATCH_DIST_ARGS=	-d ${WRKSRC} -p1

CONFLICTS=	nginx-[0-9]*

.include "../../mk/bsd.prefs.mk"

NGINX_USER?=		nginx
NGINX_GROUP?=		nginx
NGINX_DATADIR?=		${VARBASE}/db/nginx
NGINX_LOGDIR?=		${VARBASE}/log/nginx
NGINX_PIDDIR?=		${VARBASE}/run

BUILD_DEFS+=		NGINX_DATADIR NGINX_LOGDIR NGINX_PIDDIR VARBASE

PKG_USERS_VARS+=	NGINX_USER
PKG_GROUPS_VARS+=	NGINX_GROUP
PKG_GROUPS=		${NGINX_GROUP}
PKG_USERS=		${NGINX_USER}:${NGINX_GROUP}

PKG_GECOS.${NGINX_USER}=	NGINX server user
PKG_HOME.${NGINX_USER}=		${NGINX_DATADIR}
PKG_SHELL.${NGINX_USER}=	${NOLOGIN}

USE_PKGLOCALEDIR=	yes
HAS_CONFIGURE=		yes
CONFIGURE_ARGS+=	--user=${NGINX_USER}
CONFIGURE_ARGS+=	--group=${NGINX_GROUP}
CONFIGURE_ARGS+=	--with-ld-opt=-L${PREFIX}/lib\ ${COMPILER_RPATH_FLAG}${PREFIX}/lib
CONFIGURE_ARGS+=	--prefix=${PREFIX}
CONFIGURE_ARGS+=	--sbin-path=${PREFIX}/sbin
CONFIGURE_ARGS+=	--conf-path=${PKG_SYSCONFDIR}/nginx.conf
CONFIGURE_ARGS+=	--pid-path=${NGINX_PIDDIR}/nginx.pid
CONFIGURE_ARGS+=	--lock-path=${NGINX_DATADIR}/nginx.lock
CONFIGURE_ARGS+=	--error-log-path=${NGINX_LOGDIR}/error.log
CONFIGURE_ARGS+=	--http-log-path=${NGINX_LOGDIR}/access.log
CONFIGURE_ARGS+=	--http-client-body-temp-path=${NGINX_DATADIR}/client_body_temp
CONFIGURE_ARGS+=	--http-proxy-temp-path=${NGINX_DATADIR}/proxy_temp
CONFIGURE_ARGS+=	--http-fastcgi-temp-path=${NGINX_DATADIR}/fstcgi_temp
CONFIGURE_ARGS+=	--http-scgi-temp-path=${NGINX_DATADIR}/scgi_temp
CONFIGURE_ARGS+=	--with-pcre

SUBST_CLASSES+=		fix-pcre2
SUBST_STAGE.fix-pcre2=	pre-configure
SUBST_FILES.fix-pcre2=	auto/lib/pcre/conf
SUBST_SED.fix-pcre2=	-e 's,/usr/pkg,${BUILDLINK_PREFIX.pcre2},g'
SUBST_NOOP_OK.fix-pcre2=yes

PKG_SYSCONFSUBDIR=	nginx

.include "options.mk"

EGDIR=			${PREFIX}/share/examples/nginx
EGFILES+=		fastcgi.conf fastcgi_params koi-utf koi-win \
			mime.types nginx.conf win-utf

.for file in ${EGFILES}
CONF_FILES+=	${EGDIR}/conf/${file} ${PKG_SYSCONFDIR}/${file}
.  if !empty(PKG_OPTIONS:Mnaxsi)
CONF_FILES+=	${EGDIR}/conf/naxsi_core.rules ${PKG_SYSCONFDIR}/naxsi_core.rules
.  endif
.endfor

RCD_SCRIPTS=		nginx

INSTALLATION_DIRS+=	${PKGMANDIR}/man8 sbin share/examples/nginx/conf \
			share/examples/nginx/html
MAKE_DIRS+=		${NGINX_PIDDIR}
OWN_DIRS=		${NGINX_LOGDIR}
OWN_DIRS_PERMS+=	${NGINX_DATADIR} ${NGINX_USER} ${NGINX_GROUP} 0700

BUILD_TARGET=		build

SUBST_CLASSES+=		paths
SUBST_STAGE.paths=	pre-configure
SUBST_FILES.paths=	conf/nginx.conf
SUBST_SED.paths=	-e 's,%%PKG_SYSCONFDIR%%,${PKG_SYSCONFDIR},g'
SUBST_SED.paths+=	-e 's,%%NGINX_LOGDIR%%,${NGINX_LOGDIR},g'
SUBST_SED.paths+=	-e 's,%%NGINX_PIDDIR%%,${NGINX_PIDDIR},g'
SUBST_SED.paths+=	-e 's,%%NGINX_USER%%,${NGINX_USER},g'
SUBST_SED.paths+=	-e 's,%%NGINX_GROUP%%,${NGINX_GROUP},g'

MESSAGE_SUBST+=		NGINX_LOGDIR=${NGINX_LOGDIR}
MESSAGE_SUBST+=		NGINX_PIDDIR=${NGINX_PIDDIR}
MESSAGE_SUBST+=		NGINX_USER=${NGINX_USER}
MESSAGE_SUBST+=		NGINX_GROUP=${NGINX_GROUP}

.if ${OPSYS} == "Darwin"
SOEXT=		bundle
.else
SOEXT=		so
.endif
PLIST_SUBST+=	SOEXT=${SOEXT}

post-patch:
.if !empty(PKG_OPTIONS:Mgssapi)
	${SED} -i.bak '4d;5d;6d' ${WRKDIR}/${GSSAPI_DISTNAME}/config
.endif
.if !empty(PKG_OPTIONS:Mnaxsi)
	${SED} -i.bak '308,309s/MSIZE/NAXSI_MSIZE/g' \
		${WRKSRC}/..${NAXSI_SUBDIR}/libinjection/src/libinjection_sqli.c
.endif

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/objs/nginx ${DESTDIR}${PREFIX}/sbin/nginx
.for file in ${EGFILES}
	${INSTALL_DATA} ${WRKSRC}/conf/${file} ${DESTDIR}${EGDIR}/conf/${file}
.endfor
	${INSTALL_DATA} ${WRKSRC}/html/50x.html ${DESTDIR}${EGDIR}/html/50x.html
	${INSTALL_DATA} ${WRKSRC}/html/index.html ${DESTDIR}${EGDIR}/html/index.html
	${INSTALL_MAN} ${WRKSRC}/objs/nginx.8 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man8
.if !empty(PKG_OPTIONS:Mnaxsi)
	${INSTALL_DATA} ${WRKDIR}/naxsi_rules/naxsi_core.rules ${DESTDIR}${EGDIR}/conf
.endif
.if !empty(PKG_OPTIONS:Mperl)
	${INSTALL_LIB_DIR} ${DESTDIR}${PERL5_INSTALLVENDORARCH}/auto/nginx
	${INSTALL_LIB} ${WRKSRC}/objs/src/http/modules/perl/blib/arch/auto/nginx/nginx.${SOEXT} \
		${DESTDIR}${PERL5_INSTALLVENDORARCH}/auto/nginx
	${INSTALL_DATA} ${WRKSRC}/objs/src/http/modules/perl/blib/lib/nginx.pm \
		${DESTDIR}${PERL5_INSTALLVENDORARCH}
.endif
.if !empty(PKG_OPTIONS:Mdso)
	${INSTALL_LIB_DIR} ${DESTDIR}${PREFIX}/libexec/nginx
	(cd ${WRKSRC}/objs/ && ${FIND} . -name '*.so' -maxdepth 1 -type f \
		-exec ${INSTALL_PROGRAM} {} ${DESTDIR}${PREFIX}/libexec/nginx \;)
.endif

.include "../../devel/pcre2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
