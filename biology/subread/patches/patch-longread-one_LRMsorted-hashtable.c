$NetBSD: patch-longread-one_LRMsorted-hashtable.c,v 1.1 2025/01/20 17:29:59 bacon Exp $

# Use standard compiler macros

--- longread-one/LRMsorted-hashtable.c.orig	2018-11-08 14:47:43 UTC
+++ longread-one/LRMsorted-hashtable.c
@@ -22,11 +22,9 @@
 #include <string.h>
 #include "LRMsorted-hashtable.h"
 
-#ifndef MACOS
-#ifndef FREEBSD
+#if !defined(__APPLE__) && !defined(__FreeBSD__)
 #include <malloc.h>
 #endif
-#endif
 
 #include<math.h>
 #include "LRMfile-io.h"
