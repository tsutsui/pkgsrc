$NetBSD$

- mvme88k: workaround iee(4) failure on NetBSD/mvme88k

--- src/machines/machine_mvme88k.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/machines/machine_mvme88k.c
@@ -103,7 +103,7 @@ MACHINE_SETUP(mvme88k)
 		    (size_t) device_add(machine, tmpstr);
 
 		/*  ie0 ethernet: TODO  */
-		device_add(machine, "unreadable addr=0xfff46000 len=0x1000");
+		device_add(machine, "zero addr=0xfff46000 len=0x1000");
 
 		/*  53C710 SCSI at 0xfff47000:  */
 		snprintf(tmpstr, sizeof(tmpstr), "osiop irq=%s.cpu[%i].pcc2.%i "
