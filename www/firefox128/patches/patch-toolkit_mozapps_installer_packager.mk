$NetBSD: patch-toolkit_mozapps_installer_packager.mk,v 1.1 2024/08/18 15:02:22 leot Exp $

* Symbolic link to lib/firefox/firefox causes 'Couldn't load XPCOM.' error.

--- toolkit/mozapps/installer/packager.mk.orig	2020-01-29 07:05:13.000000000 +0000
+++ toolkit/mozapps/installer/packager.mk
@@ -145,7 +145,7 @@ endif
 	  (cd $(DESTDIR)$(installdir) && tar -xf -)
 	$(NSINSTALL) -D $(DESTDIR)$(bindir)
 	$(RM) -f $(DESTDIR)$(bindir)/$(MOZ_APP_NAME)
-	ln -s $(installdir)/$(MOZ_APP_NAME) $(DESTDIR)$(bindir)
+	#ln -s $(installdir)/$(MOZ_APP_NAME) $(DESTDIR)$(bindir)
 
 upload:
 	$(PYTHON3) -u $(MOZILLA_DIR)/build/upload.py --base-path $(DIST) $(UPLOAD_FILES)
