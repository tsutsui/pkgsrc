$NetBSD$

--- io-webp.c.orig	2023-03-30 00:29:21.000000000 +0000
+++ io-webp.c
@@ -188,7 +188,11 @@ stop_load (gpointer data, GError **error
       if (status == VP8_STATUS_OK)
         {
           if (context->prepare_func)
-            context->prepare_func (pb, NULL, context->user_data);
+            {
+              context->prepare_func (pb, NULL, context->user_data);
+              if (context->update_func)
+                context->update_func (pb, 0, 0, context->width, context->height, context->user_data);
+            }
 
           g_clear_object (&pb);
 
