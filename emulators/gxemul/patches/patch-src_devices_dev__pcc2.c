$NetBSD$

- pcctwo: fix timer intertupt and workaround unimplemented registers

--- src/devices/dev_pcc2.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/devices/dev_pcc2.c
@@ -138,12 +138,6 @@ static void pcc_timer_tick(struct timer 
 			}
 		}
 
-		/*  Overflow?  */
-		if ((int32_t) old_count1 >= 0 && (int32_t) count1 < 0) {
-			int oc = 1 + (d->pcctwo_reg[PCCTWO_T1CTL] >> 4);
-			d->pcctwo_reg[PCCTWO_T1CTL] &= ~PCC2_TCTL_OVF;
-			d->pcctwo_reg[PCCTWO_T1CTL] |= (oc << 4);
-		}
 	}
 
 	/*  ... and the same for timer 2:  */
@@ -163,11 +157,18 @@ static void pcc_timer_tick(struct timer 
 			}
 		}
 
-		if ((int32_t) old_count2 >= 0 && (int32_t) count2 < 0) {
-			int oc = 1 + (d->pcctwo_reg[PCCTWO_T2CTL] >> 4);
-			d->pcctwo_reg[PCCTWO_T2CTL] &= ~PCC2_TCTL_OVF;
-			d->pcctwo_reg[PCCTWO_T2CTL] |= (oc << 4);
-		}
+	}
+
+	/*  Each timer interrupt increments the 4-bit overflow counter.  */
+	if (interrupt1) {
+		int oc = (d->pcctwo_reg[PCCTWO_T1CTL] >> 4) + interrupt1;
+		d->pcctwo_reg[PCCTWO_T1CTL] &= ~PCC2_TCTL_OVF;
+		d->pcctwo_reg[PCCTWO_T1CTL] |= (oc & 0xf) << 4;
+	}
+	if (interrupt2) {
+		int oc = (d->pcctwo_reg[PCCTWO_T2CTL] >> 4) + interrupt2;
+		d->pcctwo_reg[PCCTWO_T2CTL] &= ~PCC2_TCTL_OVF;
+		d->pcctwo_reg[PCCTWO_T2CTL] |= (oc & 0xf) << 4;
 	}
 
 	/*  Should we cause interrupts?  */
@@ -511,6 +512,42 @@ DEVICE_ACCESS(pcc2)
 		reassert_interrupts(d);
 		break;
 
+	case PCCTWO_PRTICR:
+	case PCCTWO_PTRFICR:
+	case PCCTWO_PTRSICR:
+	case PCCTWO_PTRPICR:
+	case PCCTWO_PRTBICR:
+	case PCCTWO_PRTSTATUS:
+	case PCCTWO_PRTCTL:
+		if (len != 1) {
+			fatal("TODO: pcc2: non-byte printer register access\n");
+			exit(1);
+		}
+		if (writeflag == MEM_WRITE)
+			d->pcctwo_reg[relative_addr] = idata;
+		break;
+
+	case PCCTWO_IEERR:
+	case PCCTWO_IEICR:
+	case PCCTWO_IEBERR:
+		if (len != 1) {
+			fatal("TODO: pcc2: non-byte ethernet register access\n");
+			exit(1);
+		}
+		if (writeflag == MEM_WRITE)
+			d->pcctwo_reg[relative_addr] = idata;
+		break;
+
+	case PCCTWO_SCSIERR:
+		if (len != 1) {
+			fatal("TODO: pcc2: non-byte reads and writes of "
+			    "PCCTWO_SCSIERR\n");
+			exit(1);
+		}
+		if (writeflag == MEM_WRITE && (idata & 1))
+			d->pcctwo_reg[relative_addr] = 0;
+		break;
+
 	case PCCTWO_SCSIICR:
 		if (len != 1) {
 			fatal("TODO: pcc2: non-byte reads and writes of "
