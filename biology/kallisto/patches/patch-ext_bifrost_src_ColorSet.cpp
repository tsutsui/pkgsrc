$NetBSD: patch-ext_bifrost_src_ColorSet.cpp,v 1.3 2024/09/20 00:03:15 bacon Exp $

# vfscanf() not found on NetBSD 9

--- ext/bifrost/src/ColorSet.cpp.orig	2023-11-03 12:48:11.435933052 +0000
+++ ext/bifrost/src/ColorSet.cpp
@@ -1,3 +1,4 @@
+#include <cstdio>
 #include "ColorSet.hpp"
 
 UnitigColors::UnitigColors() : setBits(localBitVector) {}
