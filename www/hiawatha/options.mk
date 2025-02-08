# $NetBSD: options.mk,v 1.4 2025/02/08 04:11:32 taca Exp $

PKG_OPTIONS_VAR=		PKG_OPTIONS.hiawatha
PKG_SUPPORTED_OPTIONS=		cache letsencrypt monitor rproxy tomahawk
PKG_SUPPORTED_OPTIONS+=		urltoolkit xslt

PKG_OPTIONS_OPTIONAL_GROUPS=	tls
PKG_OPTIONS_GROUP.tls=		mbedtls mbedtls-private

PKG_SUGGESTED_OPTIONS=		cache rproxy urltoolkit mbedtls-private xslt

PLIST_VARS+=			letsencrypt urltoolkit xslt

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mcache)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_CACHE=on
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_CACHE=off
.endif

.if !empty(PKG_OPTIONS:Mletsencrypt)
PKG_OPTIONS_REQUIRED_GROUPS=	tls
PLIST.letsencrypt=		yes
REPLACE_PHP+=			extra/letsencrypt/lefh.in

DEPENDS+=	php-[0-9]*:${PHPPKGSRCDIR}
.include "../../lang/php/phpversion.mk"
.endif

.if !empty(PKG_OPTIONS:Mmonitor)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_MONITOR=on
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_MONITOR=off
.endif

.if !empty(PKG_OPTIONS:Mrproxy)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_RPROXY=on
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_RPROXY=off
.endif

.if !empty(PKG_OPTIONS:Mtomahawk)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_TOMAHAWK=on
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_TOMAHAWK=off
.endif

# TLS support options

.if !empty(PKG_OPTIONS:Mmbedtls)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_TLS=on
CMAKE_CONFIGURE_ARGS+=	-DUSE_SYSTEM_MBEDTLS=on
CONF_FILES+=	${EGDIR}/letsencrypt.conf ${PKG_SYSCONFDIR}/letsencrypt.conf
.include "../../security/mbedtls3/buildlink3.mk"
.endif
.if !empty(PKG_OPTIONS:Mmbedtls-private)
# Should the enclosed mbedtls be replaced by an update?
HIAWATHA_REPLACE_MBEDTLS=	yes
.if !empty(HIAWATHA_REPLACE_MBEDTLS:Myes)
MTVER=		3.6.2
DISTFILES+=	mbedtls-${MTVER}.tar.bz2
SITES.mbedtls-${MTVER}.tar.bz2= \
		${MASTER_SITE_GITHUB:=Mbed-TLS/mbedtls/releases/download/mbedtls-${MTVER}/}
.endif
CMAKE_CONFIGURE_ARGS+=		-DENABLE_TLS=on
CMAKE_CONFIGURE_ARGS+=		-DUSE_SYSTEM_MBEDTLS=off
CMAKE_CONFIGURE_ARGS+=		-DUSE_SHARED_MBEDTLS_LIBRARY=OFF
CMAKE_CONFIGURE_ARGS+=		-DUSE_STATIC_MBEDTLS_LIBRARY=ON
.endif
.if empty(PKG_OPTIONS:Mmbedtls) && empty(PKG_OPTIONS:Mmbedtls-private)
CMAKE_CONFIGURE_ARGS+=	-DENABLE_TLS=off
.endif

.if !empty(PKG_OPTIONS:Murltoolkit)
PLIST.urltoolkit=	yes
CONF_FILES+=		${EGDIR}/toolkit.conf ${PKG_SYSCONFDIR}/toolkit.conf

CMAKE_CONFIGURE_ARGS+=	-DENABLE_TOOLKIT=on
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_TOOLKIT=off
.endif

.if !empty(PKG_OPTIONS:Mxslt)
PLIST.xslt=	yes
CONF_FILES+=	${EGDIR}/error.xslt ${PKG_SYSCONFDIR}/error.xslt
CONF_FILES+=	${EGDIR}/index.xslt ${PKG_SYSCONFDIR}/index.xslt

CMAKE_CONFIGURE_ARGS+=	-DENABLE_XSLT=ON
.include "../../textproc/libxslt/buildlink3.mk"
.else
CMAKE_CONFIGURE_ARGS+=	-DENABLE_XSLT=OFF
.endif
