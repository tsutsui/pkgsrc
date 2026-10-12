$NetBSD$

- m88k: implement invalidate all instruction page for NetBSD/m88k
  shared library support
- m88k: properly invalidate code translation when the instruction page
  is invalidated

--- src/devices/dev_m8820x.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/devices/dev_m8820x.c
@@ -64,16 +64,31 @@ static void m8820x_command(struct cpu *c
 
 	switch (cmd) {
 
-	case CMMU_FLUSH_CACHE_CB_LINE:
-	case CMMU_FLUSH_CACHE_CB_PAGE:
 	case CMMU_FLUSH_CACHE_INV_LINE:
 	case CMMU_FLUSH_CACHE_INV_PAGE:
-	case CMMU_FLUSH_CACHE_INV_ALL:
 	case CMMU_FLUSH_CACHE_CBI_LINE:
 	case CMMU_FLUSH_CACHE_CBI_PAGE:
-	case CMMU_FLUSH_CACHE_CBI_SEGMENT:
+		/* SAR is physical. Dyntrans translations have page granularity.
+		 * Invalidate decoded instructions, not just virtual mappings.
+		 * D-CMMU operations do not invalidate the separate I-cache. */
+		if (d->cmmu_nr == 0)
+			cpu->invalidate_code_translation(cpu, sar, INVALIDATE_PADDR);
+		break;
+
+	case CMMU_FLUSH_CACHE_INV_ALL:
 	case CMMU_FLUSH_CACHE_CBI_ALL:
-		/*  TODO  */
+		if (d->cmmu_nr == 0)
+			m88k_invalidate_code_cache_all(cpu);
+		break;
+
+	case CMMU_FLUSH_CACHE_CB_LINE:
+	case CMMU_FLUSH_CACHE_CB_PAGE:
+		/* Data stores already update backing memory; no dirty cache
+		 * is modelled, so copyback alone has no additional effect. */
+		break;
+
+	case CMMU_FLUSH_CACHE_CBI_SEGMENT:
+		/* TODO */
 		break;
 
 	case CMMU_FLUSH_USER_ALL:
