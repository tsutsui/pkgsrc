$NetBSD$

- m88k: allow load target to r0 and just discard result

--- src/cpus/cpu_m88k_instr_loadstore.c.orig	2021-04-22 18:04:18.000000000 +0000
+++ src/cpus/cpu_m88k_instr_loadstore.c
@@ -27,7 +27,8 @@
  *
  *  M88K load/store instructions; the following args are used:
  *  
- *  arg[0] = pointer to the register to load to or store from (d)
+ *  arg[0] = pointer to the architectural register to load to or store from (d)
+ *           Loads to r0 discard the first result, but still access memory.
  *  arg[1] = pointer to the base register (s1)
  *  arg[2] = pointer to the offset register (s2), or an uint32_t offset
  *
@@ -93,7 +94,7 @@ void LS_GENERIC_N(struct cpu *cpu, struc
 #else
 	{
 		int dreg = (((uint32_t *)ic->arg[0]) - &cpu->cd.m88k.r[0]);
-		if (dreg < 1 || dreg > 31) {
+		if (dreg < 0 || dreg > 31) {
 			debugmsg_cpu(cpu, SUBSYS_CPU, "m88k load/store",
 			    VERBOSITY_ERROR,
 			    "HUH? dreg = %i in cpu_m88k_instr_loadstore.c."
@@ -196,10 +197,12 @@ void LS_GENERIC_N(struct cpu *cpu, struc
 	x = memory_readmax64(cpu, data, LS_SIZE);
 #ifdef LS_8
 	if (cpu->byte_order == EMUL_BIG_ENDIAN) {
-		reg(ic->arg[0]) = x >> 32;
+		if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+			reg(ic->arg[0]) = x >> 32;
 		reg(ic->arg[0] + 4) = x;
 	} else {
-		reg(ic->arg[0]) = x;
+		if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+			reg(ic->arg[0]) = x;
 		reg(ic->arg[0] + 4) = x >> 32;
 	}
 #else
@@ -214,7 +217,8 @@ void LS_GENERIC_N(struct cpu *cpu, struc
 	x = (int32_t)x;
 #endif
 #endif
-	reg(ic->arg[0]) = x;
+	if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+		reg(ic->arg[0]) = x;
 #endif
 
 #else	/*  LS_STORE:  */
@@ -296,7 +300,8 @@ void LS_N(struct cpu *cpu, struct m88k_i
 	/*  Load:  */
 
 #ifdef LS_1
-	reg(ic->arg[0]) =
+	if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+		reg(ic->arg[0]) =
 #ifdef LS_SIGNED
 	    (int8_t)
 #endif
@@ -304,7 +309,8 @@ void LS_N(struct cpu *cpu, struct m88k_i
 #endif	/*  LS_1  */
 
 #ifdef LS_2
-	reg(ic->arg[0]) =
+	if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+		reg(ic->arg[0]) =
 #ifdef LS_SIGNED
 	    (int16_t)
 #endif
@@ -324,7 +330,8 @@ void LS_N(struct cpu *cpu, struct m88k_i
 #endif	/*  LS_2  */
 
 #ifdef LS_4
-	reg(ic->arg[0]) =
+	if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+		reg(ic->arg[0]) =
 #ifdef LS_SIGNED
 	    (int32_t)
 #else
@@ -348,7 +355,8 @@ void LS_N(struct cpu *cpu, struct m88k_i
 #ifdef LS_8
 
 	/*  Load first word in pair:  */
-	reg(ic->arg[0]) =
+	if ((uint32_t *)ic->arg[0] != &cpu->cd.m88k.r[M88K_ZERO_REG])
+		reg(ic->arg[0]) =
 #ifdef LS_BE
 #ifdef HOST_BIG_ENDIAN
 	    ( *(uint32_t *)(p + addr) );
