$NetBSD: patch-uitoolkit_quartz_ui__imagelib.c,v 1.1 2024/09/22 21:40:33 tsutsui Exp $

- pull upstream transparent fixes:
  https://github.com/arakiken/mlterm/commit/51232032
  > * ui_imagelib.h, */ui_imagelib.c: Add 'transparent' to arguments of
  >   ui_imagelib_load_file().
  > * c_sixel.c: load_sixel_from_{data|file}() check whether P2 is 1 or not
  >   and return it by 'transparent' argument.

--- uitoolkit/quartz/ui_imagelib.c.orig	2023-04-01 13:54:40.000000000 +0000
+++ uitoolkit/quartz/ui_imagelib.c
@@ -138,8 +138,8 @@ static int check_has_alpha(u_char *image
 }
 
 static int load_file(char *path, /* must be UTF-8 */
-                     u_int *width, u_int *height, ui_picture_modifier_t *pic_mod, Pixmap *pixmap,
-                     PixmapMask *mask) {
+                     u_int *width, u_int *height, ui_picture_modifier_t *pic_mod,
+                     Pixmap *pixmap, PixmapMask *mask, int *transparent) {
   char *suffix;
   u_char *image;
   CGImageAlphaInfo info;
@@ -147,7 +147,7 @@ static int load_file(char *path, /* must
   suffix = path + strlen(path) - 4;
 #ifdef BUILTIN_SIXEL
   if (strcasecmp(suffix, ".six") == 0 && *width == 0 && *height == 0 &&
-      (image = load_sixel_from_file(path, width, height))) {
+      (image = load_sixel_from_file(path, width, height, transparent))) {
     adjust_pixmap(image, *width, *height, pic_mod);
 
     info = check_has_alpha(image, *width, *height) ? kCGImageAlphaPremultipliedLast
@@ -179,6 +179,10 @@ static int load_file(char *path, /* must
       return 0;
     }
 
+    if (transparent) {
+      *transparent = 0;
+    }
+
     info = CGImageGetAlphaInfo(*pixmap);
 
     if (!ui_picture_modifier_is_normal(pic_mod)) {
@@ -206,7 +210,8 @@ static int load_file(char *path, /* must
 
   if (info == kCGImageAlphaPremultipliedLast || info == kCGImageAlphaPremultipliedFirst ||
       info == kCGImageAlphaLast || info == kCGImageAlphaFirst) {
-    *mask = 1L; /* dummy */
+    /* dummy (If cur_pic->mask is non-zero, need_clear = 1 in draw_picture() in ui_draw_str.c) */
+    *mask = 1L;
   }
 
   return 1;
@@ -237,7 +242,7 @@ Pixmap ui_imagelib_load_file_for_backgro
   u_int width = 0;
   u_int height = 0;
 
-  if (!load_file(path, &width, &height, pic_mod, &pixmap, NULL)) {
+  if (!load_file(path, &width, &height, pic_mod, &pixmap, NULL, NULL)) {
     return None;
   }
 
@@ -254,8 +259,9 @@ Pixmap ui_imagelib_get_transparent_backg
   return None;
 }
 
-int ui_imagelib_load_file(ui_display_t *disp, char *path, u_int32_t **cardinal, Pixmap *pixmap,
-                          PixmapMask *mask, u_int *width, u_int *height, int keep_aspect) {
+int ui_imagelib_load_file(ui_display_t *disp, char *path, int keep_aspect, u_int32_t **cardinal,
+                          Pixmap *pixmap, PixmapMask *mask, u_int *width, u_int *height,
+                          int *transparent) {
   u_int pix_width = 0;
   u_int pix_height = 0;
 
@@ -263,7 +269,7 @@ int ui_imagelib_load_file(ui_display_t *
     return 0;
   }
 
-  if (!load_file(path, &pix_width, &pix_height, NULL, pixmap, mask)) {
+  if (!load_file(path, &pix_width, &pix_height, NULL, pixmap, mask, transparent)) {
     return 0;
   }
 
