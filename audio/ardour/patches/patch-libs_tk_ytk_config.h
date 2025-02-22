$NetBSD: patch-libs_tk_ytk_config.h,v 1.3 2025/02/01 10:01:19 wiz Exp $

No getresuid() on NetBSD.
Only assume GNU ftw on Linux.
https://tracker.ardour.org/view.php?id=9886

--- libs/tk/ytk/config.h.orig	2024-10-17 04:04:34.000000000 +0000
+++ libs/tk/ytk/config.h
@@ -18,11 +18,11 @@
 #define HAVE_FTW_H 1
 
 /* Define to 1 if you have the `getresuid' function. */
-#if !(defined PLATFORM_WINDOWS || defined __APPLE__)
+#if !(defined PLATFORM_WINDOWS || defined __APPLE__ || defined(__NetBSD__))
 #define HAVE_GETRESUID 1
 #endif
 
-#ifndef __APPLE__
+#if !defined(__APPLE__) && !defined(__NetBSD__)
 /* Have GNU ftw */
 #define HAVE_GNU_FTW 1
 #endif
