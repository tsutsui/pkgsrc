$NetBSD$

- osiop: handle selection timeout properly

--- src/devices/dev_osiop.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/devices/dev_osiop.c
@@ -591,14 +591,10 @@ int osiop_execute_scripts_instr(struct c
 			} else {
 				d->selected_id = -1;
 
-#if 1
-				/*  TODO: The scsi ID does not exist.
-				    Should we simply timeout:  */
+				/*  Selection of a non-existing target times out.  */
+				d->reg[OSIOP_SSTAT0] |= OSIOP_SSTAT0_STO;
 				d->scripts_running = 0;
-#else
-				/*  or branch to the reselect address?  */
-				*(uint32_t*) &d->reg[OSIOP_DSP] = target_addr;
-#endif
+				osiop_reassert_interrupts(d);
 			}
 
 			break;
