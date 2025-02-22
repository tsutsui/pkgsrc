$NetBSD: patch-lib_ext2fs_bitops.h,v 1.3 2025/01/21 18:13:57 triaxx Exp $

Force GNU inline semantic.

--- lib/ext2fs/bitops.h.orig	2014-07-03 23:33:48.000000000 +0900
+++ lib/ext2fs/bitops.h	2014-12-10 21:10:47.000000000 +0900
@@ -232,7 +232,7 @@ extern errcode_t ext2fs_find_first_set_g
 #define _INLINE_ inline
 #else /* not C99 */
 #ifdef __GNUC__
-#define _INLINE_ extern __inline__
+#define _INLINE_ extern __attribute__((__gnu_inline__)) __inline__
 #else				/* For Watcom C */
 #define _INLINE_ extern inline
 #endif /* __GNUC__ */
