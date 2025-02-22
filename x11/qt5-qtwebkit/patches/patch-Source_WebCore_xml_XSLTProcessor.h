$NetBSD: patch-Source_WebCore_xml_XSLTProcessor.h,v 1.3 2025/01/24 11:54:38 wiz Exp $

Fix build with libxml2 2.12.

--- Source/WebCore/xml/XSLTProcessor.h.orig	2020-03-04 17:16:37.000000000 +0000
+++ Source/WebCore/xml/XSLTProcessor.h
@@ -64,7 +64,7 @@ public:
 
     void reset();
 
-    static void parseErrorFunc(void* userData, xmlError*);
+    static void parseErrorFunc(void* userData, const xmlError*);
     static void genericErrorFunc(void* userData, const char* msg, ...);
     
     // Only for libXSLT callbacks
