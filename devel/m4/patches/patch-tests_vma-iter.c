$NetBSD$

- fix build errors on netbsd-5 and prior

--- tests/vma-iter.c.orig	2026-02-03 19:04:18.000000000 +0000
+++ tests/vma-iter.c
@@ -72,6 +72,7 @@
 #if defined __NetBSD__ || defined __OpenBSD__ /* NetBSD, OpenBSD */
 # include <sys/types.h>
 # include <sys/mman.h> /* mmap, munmap */
+# include <sys/param.h> /* prerequisite of <sys/sysctl.h> */
 # include <sys/sysctl.h> /* sysctl, struct kinfo_vmentry */
 #endif
 
