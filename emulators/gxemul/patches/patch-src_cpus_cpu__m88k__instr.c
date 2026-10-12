$NetBSD$

- m88k: allow load target to r0 and just discard result

--- src/cpus/cpu_m88k_instr.c.orig	2021-04-22 18:04:18.000000000 +0000
+++ src/cpus/cpu_m88k_instr.c
@@ -2246,9 +2246,6 @@ X(to_be_translated)
 			    + (signedness? M88K_LOADSTORE_SIGNEDNESS:0)
 			    + (cpu->byte_order == EMUL_BIG_ENDIAN?
 			       M88K_LOADSTORE_ENDIANNESS : 0) ];
-
-			if (!store && d == 0)
-				ic->arg[0] = (size_t) &cpu->cd.m88k.zero_scratch;
 		}
 		break;
 
@@ -2743,9 +2740,6 @@ X(to_be_translated)
 				    + (user? M88K_LOADSTORE_USR : 0)
 				    + M88K_LOADSTORE_REGISTEROFFSET ];
 
-				if (d == M88K_ZERO_REG && op == 0)
-					ic->arg[0] = (size_t)&cpu->cd.m88k.zero_scratch;
-
 				if (opsize == 3 && d == 31) {
 					fatal("m88k load/store of register "
 					    "pair r31/r0: TODO\n");
