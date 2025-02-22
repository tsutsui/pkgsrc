$NetBSD: patch-Source_WebCore_css_makegrammar.pl,v 1.3 2025/01/24 11:54:37 wiz Exp $

let Bison generate the header directly 

Starting with Bison 3.7, the generated C++ file #include's the header 
by default, instead of duplicating it. So we should not delete it. 

Remove the code to add #ifdef guards to the header, since Bison adds 
them itself since version 2.6.3. 

Author: Dmitry Shachnev <mitya57@debian.org> 

--- Source/WebCore/css/makegrammar.pl.orig	2020-03-04 17:16:37.000000000 +0000
+++ Source/WebCore/css/makegrammar.pl
@@ -73,25 +73,6 @@ if ($suffix eq ".y.in") {
 }
 
 my $fileBase = File::Spec->join($outputDir, $filename);
-my @bisonCommand = ($bison, "-d", "-p", $symbolsPrefix, $grammarFilePath, "-o", "$fileBase.cpp");
+my @bisonCommand = ($bison, "--defines=$fileBase.h", "-p", $symbolsPrefix, $grammarFilePath, "-o", "$fileBase.cpp");
 push @bisonCommand, "--no-lines" if $^O eq "MSWin32"; # Work around bug in bison >= 3.0 on Windows where it puts backslashes into #line directives.
 system(@bisonCommand) == 0 or die;
-
-open HEADER, ">$fileBase.h" or die;
-print HEADER << "EOF";
-#ifndef CSSGRAMMAR_H
-#define CSSGRAMMAR_H
-EOF
-
-open HPP, "<$fileBase.cpp.h" or open HPP, "<$fileBase.hpp" or die;
-while (<HPP>) {
-    print HEADER;
-}
-close HPP;
-
-print HEADER "#endif\n";
-close HEADER;
-
-unlink("$fileBase.cpp.h");
-unlink("$fileBase.hpp");
-
