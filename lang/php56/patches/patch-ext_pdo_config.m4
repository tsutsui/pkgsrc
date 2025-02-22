$NetBSD: patch-ext_pdo_config.m4,v 1.2 2025/02/08 02:57:59 taca Exp $

* make databases/php-pdo compiles and works as shared module on Mac OS
  X after the package has been modified to use modules shipped with
  PHP instead of (obsolete) PCRE versions.

--- ext/pdo/config.m4.orig	2014-11-12 13:52:21.000000000 +0000
+++ ext/pdo/config.m4
@@ -37,20 +37,6 @@ if test "$PHP_PDO" != "no"; then
 
   PHP_PDO_PEAR_CHECK
 
-  if test "$ext_shared" = "yes" ; then
-    case $host_alias in
-      *darwin*)
-          AC_MSG_ERROR([
-Due to the way that loadable modules work on OSX/Darwin, you need to
-compile the PDO package statically into the PHP core.
-
-Please follow the instructions at: http://netevil.org/node.php?nid=202
-for more detail on this issue.
-          ])
-        ext_shared=no
-        ;;
-    esac
-  fi
   PHP_NEW_EXTENSION(pdo, pdo.c pdo_dbh.c pdo_stmt.c pdo_sql_parser.c pdo_sqlstate.c, $ext_shared)
   ifdef([PHP_ADD_EXTENSION_DEP],
   [
