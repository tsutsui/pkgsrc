$NetBSD$

- m88k: implement invalidate all instruction page for NetBSD/m88k
  shared library support

--- src/include/cpu_m88k.h.orig	2021-04-22 18:04:15.000000000 +0000
+++ src/include/cpu_m88k.h
@@ -281,6 +281,7 @@ int m88k_cpu_instruction_has_delayslot(s
 int m88k_run_instr(struct cpu *cpu);
 void m88k_update_translation_table(struct cpu *cpu, uint64_t vaddr_page,
 	unsigned char *host_page, int writeflag, uint64_t paddr_page);
+void m88k_invalidate_code_cache_all(struct cpu *cpu);
 void m88k_invalidate_translation_caches(struct cpu *cpu, uint64_t, int);
 void m88k_invalidate_code_translation(struct cpu *cpu, uint64_t, int);
 int m88k_memory_rw(struct cpu *cpu, struct memory *mem, uint64_t vaddr,
