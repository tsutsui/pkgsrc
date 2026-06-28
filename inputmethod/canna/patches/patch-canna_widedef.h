$NetBSD: patch-canna_widedef.h,v 1.2 2017/07/22 17:53:16 maya Exp $

- DragonFly wchar_t support.
- machine/ansi.h is not necessary

--- canna/widedef.h.orig	2026-05-09 14:08:44.000000000 +0000
+++ canna/widedef.h
@@ -30,12 +30,10 @@
 # include <osreldate.h>
 #endif
 
-#if (defined(__FreeBSD__) && __FreeBSD_version < 500000) \
-    || defined(__NetBSD__) || defined(__OpenBSD__)
-# include <machine/ansi.h>
-#endif
-
-#if (defined(__FreeBSD__) && __FreeBSD_version < 500000) \
+#if defined(__DragonFly__)
+# include <wchar.h>
+# define _WCHAR_T
+#elif (defined(__FreeBSD__) && __FreeBSD_version < 500000) \
     || defined(__NetBSD__) || defined(__OpenBSD__)
 # ifdef _BSD_WCHAR_T_
 #  undef _BSD_WCHAR_T_
