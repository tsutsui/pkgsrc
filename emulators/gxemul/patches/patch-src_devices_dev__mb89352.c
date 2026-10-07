$NetBSD$

- spc: handle SCMD_SET_ACK command for NetBSD spc(4)
- spc: don't ack for SCMD_SELECT against non-existent target

--- src/devices/dev_mb89352.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/devices/dev_mb89352.c
@@ -190,9 +190,11 @@ int mb89352_dreg_read(struct cpu* cpu, s
 
 	d->reg[SSTS] &= ~SSTS_XFR;
 
-	if (d->phase == PH_DATAIN)
+	if (d->phase == PH_DATAIN) {
 		d->phase = PH_STAT;
-	else if (d->phase == PH_STAT)
+		if (d->xferp->status != NULL && d->xferp->status_len > 0)
+			d->reg[TEMP] = d->xferp->status[0];
+	} else if (d->phase == PH_STAT)
 		d->phase = PH_MSGIN;
 	else if (d->phase == PH_MSGIN)
 		d->phase = PH_BUS_FREE;
@@ -262,6 +264,8 @@ void mb89352_dreg_write(struct cpu* cpu,
 
 		// TODO: How about failure results?
 		d->phase = PH_STAT;
+		if (d->xferp->status != NULL && d->xferp->status_len > 0)
+			d->reg[TEMP] = d->xferp->status[0];
 		break;
 
 	case PH_CMD:
@@ -272,8 +276,11 @@ void mb89352_dreg_write(struct cpu* cpu,
 			d->phase = PH_DATAOUT;
 		else if (d->xferp->data_in != NULL)
 			d->phase = PH_DATAIN;
-		else
+		else {
 			d->phase = PH_STAT;
+			if (d->xferp->status != NULL && d->xferp->status_len > 0)
+				d->reg[TEMP] = d->xferp->status[0];
+		}
 		break;
 
 	default:
@@ -382,14 +389,27 @@ DEVICE_ACCESS(mb89352)
 					    	    "SCMD_SELECT with no target?");
 
 					d->target = target;
+
+					if (d->xferp != NULL) {
+						scsi_transfer_free(d->xferp);
+						d->xferp = NULL;
+					}
+
+					if (target >= 8 || !diskimage_exist(cpu->machine,
+					    target, DISKIMAGE_SCSI)) {
+						d->reg[INTS] |= INTS_TIMEOUT;
+						d->reg[PSNS] &= ~(PSNS_REQ | PSNS_BSY);
+						d->reg[SSTS] &= ~(SSTS_TARGET | SSTS_INITIATOR |
+						    SSTS_XFR | SSTS_BUSY);
+						d->phase = PH_BUS_FREE;
+						break;
+					}
+
 					d->reg[INTS] |= INTS_CMD_DONE;
 					d->reg[PSNS] &= ~7;
 					d->phase = PH_CMD;
 					d->reg[PSNS] |= PSNS_REQ;
 
-					if (d->xferp != NULL)
-						scsi_transfer_free(d->xferp);
-
 					d->xferp = scsi_transfer_alloc();
 					d->transfer_bufpos = 0;
 
@@ -440,9 +460,26 @@ DEVICE_ACCESS(mb89352)
 				}
 				break;
 
+			case SCMD_SET_ACK:
+				/* Initiator acknowledges the current target byte. */
+				d->reg[PSNS] |= PSNS_ACK;
+				d->reg[PSNS] &= ~PSNS_REQ;
+				break;
+
 			case SCMD_RST_ACK:
 				d->reg[SSTS] &= ~(SSTS_INITIATOR | SSTS_TARGET);
-				d->reg[PSNS] &= ~PSNS_REQ;
+				d->reg[PSNS] &= ~PSNS_ACK;
+
+				/*
+				 * NetBSD spc(4) reads the STATUS byte through TEMP and
+				 * handshakes it manually.  Once ACK is released, move
+				 * on to MESSAGE IN and present the next REQ.
+				 */
+				if (d->phase == PH_STAT) {
+					d->phase = PH_MSGIN;
+					d->reg[PSNS] |= PSNS_REQ;
+				} else
+					d->reg[PSNS] &= ~PSNS_REQ;
 				break;
 
 			default:
