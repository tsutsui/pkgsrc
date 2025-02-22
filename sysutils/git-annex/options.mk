# $NetBSD: options.mk,v 1.3 2025/02/02 04:31:03 pho Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.git-annex
PKG_SUPPORTED_OPTIONS=	${PKG_SUGGESTED_OPTIONS} debug
PKG_SUGGESTED_OPTIONS=	dbus git-annex-servant git-annex-assistant

.include "../../mk/bsd.prefs.mk"
.include "../../mk/bsd.options.mk"

###
### Enable seravnt, enabling using annex+http urls and git-annex p2phttp
###
.if ${PKG_OPTIONS:Mgit-annex-servant}
CONFIGURE_ARGS+=	-f +Servant
.  include "../../www/hs-servant/buildlink3.mk"
.  include "../../www/hs-servant-server/buildlink3.mk"
.  include "../../www/hs-servant-client/buildlink3.mk"
.  include "../../www/hs-servant-client-core/buildlink3.mk"
.  include "../../www/hs-warp/buildlink3.mk"
.  include "../../www/hs-warp-tls/buildlink3.mk"
.else
CONFIGURE_ARGS+=	-f -Servant
.endif

###
### Enable git-annex assistant, webapp, and watch command
###
.if ${PKG_OPTIONS:Mgit-annex-assistant}
CONFIGURE_ARGS+=	-f +assistant
.  include "../../sysutils/hs-mountpoints/buildlink3.mk"
.  include "../../www/hs-yesod/buildlink3.mk"
.  include "../../www/hs-yesod-static/buildlink3.mk"
.  include "../../www/hs-yesod-form/buildlink3.mk"
.  include "../../www/hs-yesod-core/buildlink3.mk"
.  include "../../www/hs-path-pieces/buildlink3.mk"
.  include "../../www/hs-warp/buildlink3.mk"
.  include "../../www/hs-warp-tls/buildlink3.mk"
.  include "../../www/hs-wai/buildlink3.mk"
.  include "../../www/hs-wai-extra/buildlink3.mk"
.  include "../../devel/hs-blaze-builder/buildlink3.mk"
.  include "../../www/hs-clientsession/buildlink3.mk"
.  include "../../textproc/hs-shakespeare/buildlink3.mk"
.  if ${OPSYS} == "Linux"
.    include "../../devel/hs-hinotify/buildlink3.mk"
.  elif ${OPSYS} == "Darwin"
.    include "../../devel/hs-hfsevents/buildlink3.mk"
.  endif
.else
CONFIGURE_ARGS+=	-f -assistant
.endif

###
### Enable D-Bus and desktop notification support
###
.if ${PKG_OPTIONS:Mdbus}
CONFIGURE_ARGS+=	-f +Dbus
.  include "../../sysutils/hs-dbus/buildlink3.mk"
.  include "../../sysutils/hs-fdo-notify/buildlink3.mk"
.else
CONFIGURE_ARGS+=	-f -Dbus
.endif

###
### Enable debugging
###
.if ${PKG_OPTIONS:Mdebug}
CONFIGURE_ARGS+=	-f +DebugLocks
.else
CONFIGURE_ARGS+=	-f -DebugLocks
.endif
