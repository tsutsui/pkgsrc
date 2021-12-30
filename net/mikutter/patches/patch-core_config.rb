$NetBSD$

- add a pkgsrc specific vendor plugin directory for plugins packages

--- core/config.rb.orig	2021-12-24 16:10:48.000000000 +0000
+++ core/config.rb
@@ -35,6 +35,7 @@ module CHIConfig
   # プラグインディレクトリ
   PLUGIN_PATH = [
     File.expand_path(File.join(__dir__, '..', 'plugin')),
+    File.expand_path(File.join(__dir__, '..', 'vendor', 'plugin')),
   ]
 
   # AutoTag有効？
