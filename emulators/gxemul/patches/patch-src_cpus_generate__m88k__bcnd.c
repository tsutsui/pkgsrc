$NetBSD$

- m88k: handle bcnd a,rXX,NNNN instruction

--- src/cpus/generate_m88k_bcnd.c.orig	2021-04-22 18:04:18.000000000 +0000
+++ src/cpus/generate_m88k_bcnd.c
@@ -46,6 +46,7 @@ void print_function_name(int samepage, i
 	case 0x5: printf("not_maxneg_nor_zero"); break;
 	case 0x7: printf("not_maxneg"); break;
 	case 0x8: printf("maxneg"); break;
+	case 0xa: printf("maxneg_or_zero"); break;
 	case 0xc: printf("lt0"); break;
 	case 0xd: printf("ne0"); break;
 	case 0xe: printf("le0"); break;
@@ -62,6 +63,7 @@ void print_operator(int m5)
 	case 0x5: printf("!= 0x80000000UL"); break;
 	case 0x7: printf("!= 0x80000000UL"); break;
 	case 0x8: printf("== 0x80000000UL"); break;
+	case 0xa: printf("== 0x80000000UL"); break;
 	case 0xc: printf("< 0"); break;
 	case 0xd: printf("!= 0"); break;
 	case 0xe: printf("<= 0"); break;
@@ -81,11 +83,13 @@ void bcnd(int samepage, int n_bit, int m
 	/*  Easiest case is without the n_bit:  */
 	if (!n_bit) {
 		printf("\tif ((%sint32_t)reg(ic->arg[0]) ",
-		    (m5 == 5 || m5 == 7 || m5 == 8)? "u" : "");
+		    (m5 == 5 || m5 == 7 || m5 == 8 || m5 == 0xa)? "u" : "");
 		print_operator(m5);
 
 		if (m5 == 5)
 			printf(" && (int32_t)reg(ic->arg[0]) != 0");
+		else if (m5 == 0xa)
+			printf(" || (int32_t)reg(ic->arg[0]) == 0");
 
 		printf(") {\n");
 
@@ -101,10 +105,12 @@ void bcnd(int samepage, int n_bit, int m
 	} else {
 		/*  n_bit, i.e. delay slot:  */
 		printf("\tint cond = (%sint32_t)reg(ic->arg[0]) ",
-		    (m5 == 5 || m5 == 7 || m5 == 8)? "u" : "");
+		    (m5 == 5 || m5 == 7 || m5 == 8 || m5 == 0xa)? "u" : "");
 		print_operator(m5);
 		if (m5 == 5)
 			printf(" && (int32_t)reg(ic->arg[0]) != 0");
+		else if (m5 == 0xa)
+			printf(" || (int32_t)reg(ic->arg[0]) == 0");
 		printf(";\n");
 
 		printf("\tSYNCH_PC;\n");
@@ -149,7 +155,7 @@ int main(int argc, char *argv[])
 	for (samepage=0; samepage<=1; samepage++)
 		for (n_bit=0; n_bit<=1; n_bit++)
 			for (m5=0; m5<=31; m5++) {
-				if (m5 == 1 || m5 == 2 || m5 == 3 || m5 == 5 || m5 == 7 || m5 == 8 ||
+				if (m5 == 1 || m5 == 2 || m5 == 3 || m5 == 5 || m5 == 7 || m5 == 8 || m5 == 0xa ||
 				    m5 == 0xc || m5 == 0xd || m5 == 0xe)
 					bcnd(samepage, n_bit, m5);
 			}
@@ -163,7 +169,7 @@ int main(int argc, char *argv[])
 				if (m5 || n_bit || samepage)
 					printf(",\n");
 
-				if (m5 == 1 || m5 == 2 || m5 == 3 || m5 == 5 || m5 == 7 || m5 == 8 ||
+				if (m5 == 1 || m5 == 2 || m5 == 3 || m5 == 5 || m5 == 7 || m5 == 8 || m5 == 0xa ||
 				    m5 == 0xc || m5 == 0xd || m5 == 0xe) {
 					if (samepage && n_bit)
 						printf("NULL");
