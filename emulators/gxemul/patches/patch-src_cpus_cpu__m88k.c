$NetBSD$

- m88k: handle bcnd a,rXX,NNNN instruction

--- src/cpus/cpu_m88k.c.orig	2021-04-22 18:04:18.000000000 +0000
+++ src/cpus/cpu_m88k.c
@@ -1269,6 +1269,7 @@ int m88k_cpu_disassemble_instr(struct cp
 			case 0x5: debug("not_maxneg_nor_zero"); break;
 			case 0x7: debug("not_maxneg"); break;
 			case 0x8: debug("maxneg"); break;
+			case 0xa: debug("maxneg_or_zero"); break;
 			case 0xc: debug("lt0"); break;
 			case 0xd: debug("ne0"); break;
 			case 0xe: debug("le0"); break;
