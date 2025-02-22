$NetBSD: patch-Source_WebCore_platform_graphics_surfaces_GraphicsSurfaceToken.h,v 1.3 2025/01/24 11:54:37 wiz Exp $

* Treat *BSD like Linux

--- Source/WebCore/platform/graphics/surfaces/GraphicsSurfaceToken.h.orig	2013-11-27 01:01:44.000000000 +0000
+++ Source/WebCore/platform/graphics/surfaces/GraphicsSurfaceToken.h
@@ -35,7 +35,7 @@ struct GraphicsSurfaceToken {
 
 #if OS(DARWIN)
     typedef mach_port_t BufferHandle;
-#elif OS(LINUX)
+#elif OS(LINUX) || OS(FREEBSD) || OS(NETBSD) || OS(OPENBSD)
     typedef uint32_t BufferHandle;
 #elif OS(WINDOWS)
     typedef HANDLE BufferHandle;
