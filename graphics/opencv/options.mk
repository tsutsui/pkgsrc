# $NetBSD: options.mk,v 1.16 2025/02/07 23:35:30 adam Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.opencv
PKG_SUPPORTED_OPTIONS=	ffmpeg jasper

.include "../../mk/bsd.prefs.mk"

.if ${OPSYS} != "Darwin"
PKG_SUPPORTED_OPTIONS+=	gtk
PKG_SUGGESTED_OPTIONS+=	gtk
.endif

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mffmpeg)
CMAKE_CONFIGURE_ARGS+=	-DWITH_FFMPEG=ON
CMAKE_CONFIGURE_ARGS+=	-DFFMPEG_INCLUDE_DIR=${PREFIX}/include/ffmpeg6
CMAKE_CONFIGURE_ARGS+=	-DFFMPEG_LIB_DIR=${PREFIX}/lib/ffmpeg6
.include "../../multimedia/ffmpeg6/buildlink3.mk"
.else
CMAKE_CONFIGURE_ARGS+=	-DWITH_FFMPEG=OFF
.endif

.if !empty(PKG_OPTIONS:Mjasper)
CMAKE_CONFIGURE_ARGS+=	-DWITH_JASPER=ON
# jasper uses SIZE_MAX and friends in its headers.
CXXFLAGS+=	-D__STDC_LIMIT_MACROS
.include "../../graphics/jasper/buildlink3.mk"
.else
CMAKE_CONFIGURE_ARGS+=	-DWITH_JASPER=OFF
.endif

.if !empty(PKG_OPTIONS:Mgtk)
CMAKE_CONFIGURE_ARGS+=	-DWITH_GTK=ON
.include "../../x11/gtk3/buildlink3.mk"
.else
CMAKE_CONFIGURE_ARGS+=	-DWITH_GTK=OFF
.endif

# FIXME: should be option.mk'ed instead
CMAKE_CONFIGURE_ARGS+=	-DBUILD_DOCS=OFF
