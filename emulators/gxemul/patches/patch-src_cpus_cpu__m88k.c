$NetBSD$

- m88k: handle bcnd a,rXX,NNNN instruction
- m88k: allow load target to r0 and just discard result
- m88k: implement invalidate all instruction page for NetBSD/m88k
  shared library support

--- src/cpus/cpu_m88k.c.orig	2021-04-22 18:04:18.000000000 +0000
+++ src/cpus/cpu_m88k.c
@@ -54,6 +54,27 @@
 #include "thirdparty/m88k_dmt.h"
 #include "thirdparty/mvmeprom.h"
 
+/* Invalidate all physical instruction pages without discarding the table.
+ * INVALIDATE_ALL in dyntrans only drops virtual-to-physical shortcuts; it
+ * leaves the decoded physical instruction pages available for reuse. */
+void m88k_invalidate_code_cache_all(struct cpu *cpu)
+{
+	uint32_t *table = (uint32_t *)cpu->translation_cache;
+	size_t i;
+
+	for (i = 0; i < N_BASE_TABLE_ENTRIES; i++) {
+		uint32_t ofs = table[i];
+		while (ofs != 0) {
+			struct m88k_tc_physpage *page =
+			    (struct m88k_tc_physpage *)(cpu->translation_cache + ofs);
+			uint32_t next = page->next_ofs;
+			cpu->invalidate_code_translation(cpu, page->physaddr,
+			    INVALIDATE_PADDR);
+			ofs = next;
+		}
+	}
+}
+
 #define DYNTRANS_32
 #define DYNTRANS_DELAYSLOT
 #include "tmp_m88k_head.c"
@@ -442,19 +463,9 @@ void m88k_ldcr(struct cpu *cpu, uint32_t
 		/*
 		 *  Catch some possible internal errors in the emulator:
 		 *
-		 *  For valid memory Load transactions, the Destination Register
-		 *  should not be zero.
-		 *
+		 *  Loads may target r0; their results are discarded.
 		 *  The Byte Order bit should be the same as the CPU's.
 		 */
-		if (retval & DMT_VALID && !(retval & DMT_WRITE)) {
-			if (DMT_DREGBITS(retval) == M88K_ZERO_REG) {
-				debugmsg_cpu(cpu, SUBSYS_CPU, "m88k", VERBOSITY_ERROR,
-				    "ldcr: DMT DREG = zero? Internal error.");
-				cpu->running = false;
-				return;
-			}
-		}
 		if (!!(cpu->cd.m88k.cr[M88K_CR_PSR] & M88K_PSR_BO)
 		    != !!(retval & DMT_BO) && retval & DMT_VALID) {
 			debugmsg_cpu(cpu, SUBSYS_CPU, "m88k", VERBOSITY_ERROR,
@@ -1269,6 +1280,7 @@ int m88k_cpu_disassemble_instr(struct cp
 			case 0x5: debug("not_maxneg_nor_zero"); break;
 			case 0x7: debug("not_maxneg"); break;
 			case 0x8: debug("maxneg"); break;
+			case 0xa: debug("maxneg_or_zero"); break;
 			case 0xc: debug("lt0"); break;
 			case 0xd: debug("ne0"); break;
 			case 0xe: debug("le0"); break;
