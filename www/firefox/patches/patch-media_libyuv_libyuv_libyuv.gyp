$NetBSD$

- Pull upstrem fix for non-Windows i386 builds:
 https://bugzilla.mozilla.org/show_bug.cgi?id=2084560
 https://github.com/mozilla-firefox/firefox/commit/1b95f6d65ffa

--- media/libyuv/libyuv/libyuv.gyp.orig	2026-11-05 05:15:08.259055372 +0000
+++ media/libyuv/libyuv/libyuv.gyp
@@ -148,6 +148,16 @@
       'sources': [
         '<@(libyuv_sources)',
       ],
+      # Undo filename_rules.gypi's exclusion of *_win.cc on non-Windows. The
+      # files are guarded by #if, and rotate_win.cc is used for 32-bit x86 on
+      # any OS.
+      'target_conditions': [
+        ['OS != "win"', {
+          'sources/': [
+            ['include', '_win\\.cc$'],
+          ],
+        }],
+      ],
     },
     {
       'target_name': 'libyuv_neon',
