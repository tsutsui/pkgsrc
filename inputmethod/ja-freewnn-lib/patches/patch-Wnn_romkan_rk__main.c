$NetBSD$

- Appease -Wchar-subscripts warnings/errors

--- Wnn/romkan/rk_main.c.orig	2026-06-23 18:35:34.977127060 +0000
+++ Wnn/romkan/rk_main.c
@@ -88,7 +88,7 @@ char eofflg;                    /* romka
                                    処理中はeofflgは2。 */
 
 letter evalbuf[2][2][OUTSIZ];
-char ebf_sw = 0;
+int ebf_sw = 0;
 letter saishu_out[OUTSIZ];
 letter delchr, delchr2 = EOLTTR, nisedl;        /* DELのキャラクタは二個まで持てる */
 
