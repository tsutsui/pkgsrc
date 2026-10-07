$NetBSD$

- clmpcc: misc workaround for NetBSD/mvme88k

--- src/devices/dev_clmpcc.c.orig	2021-04-22 18:04:20.000000000 +0000
+++ src/devices/dev_clmpcc.c
@@ -125,7 +125,13 @@ DEVICE_ACCESS(clmpcc)
 		    (int) idata);  */
 		break;
 
+	case CLMPCC_REG_GFRCR:	/*  Global Firmware Revision Code Register  */
+		break;
+
 	case CLMPCC_REG_CCR:	/*  Channel Command Register:  */
+		if (writeflag == MEM_WRITE &&
+		    (idata & CLMPCC_CCR_T0_RESET_ALL) != 0)
+			d->reg[CLMPCC_REG_GFRCR] = 0x0d;
 		odata = 0;
 		break;
 
@@ -148,21 +154,27 @@ DEVICE_ACCESS(clmpcc)
 
 	case CLMPCC_REG_STCR:	/*  Special Transmit Command Register  */
 		if (writeflag == MEM_WRITE) {
-			if (idata == 0x0b) {
-				if (d->reg[CLMPCC_REG_CAR] == 0)
-					console_putchar(d->console_handle,
-					    d->reg[CLMPCC_REG_SCHR3]);
-				else
-					fatal("[ clmpcc: TODO: transmit "
-					    "to channel, CAR!=0 ]\n");
-
-				/*  Command done:  */
-				d->reg[CLMPCC_REG_STCR] = 0x00;
-			} else {
+			int schr;
+
+			switch (idata) {
+			case 0x09: schr = CLMPCC_REG_SCHR1; break;
+			case 0x0a: schr = CLMPCC_REG_SCHR2; break;
+			case 0x0b: schr = CLMPCC_REG_SCHR3; break;
+			case 0x0c: schr = CLMPCC_REG_SCHR4; break;
+			default:
 				fatal("clmpcc: unimplemented STCR byte "
 				    "0x%02x\n", (int) idata);
 				exit(1);
 			}
+
+			if (d->reg[CLMPCC_REG_CAR] == 0)
+				console_putchar(d->console_handle, d->reg[schr]);
+			else
+				fatal("[ clmpcc: TODO: transmit "
+				    "to channel, CAR!=0 ]\n");
+
+			/*  Command done:  */
+			d->reg[CLMPCC_REG_STCR] = 0x00;
 		}
 		break;
 
@@ -188,6 +200,7 @@ DEVICE_ACCESS(clmpcc)
 		reassert_interrupts(d);
 		break;
 
+	case CLMPCC_REG_RISR:	/*  Receive Interrupt Status Reg (high)  */
 	case CLMPCC_REG_RISRl:	/*  Receive Interrupt Status Reg (low)  */
 		odata = 0x00;
 		break;
@@ -196,6 +209,11 @@ DEVICE_ACCESS(clmpcc)
 		odata = 0x40;	/*  see openbsd's cl_txintr  */
 		break;
 
+	case CLMPCC_REG_TISR:	/*  Transmit Interrupt Status Register  */
+		odata = d->reg[CLMPCC_REG_IER] &
+		    (CLMPCC_TISR_TX_EMPTY | CLMPCC_TISR_TX_FIFO);
+		break;
+
 	case CLMPCC_REG_RIR:	/*  Rx Interrupt Register  */
 		odata = 0x00;
 		if (console_charavail(d->console_handle))
@@ -233,11 +251,7 @@ DEVICE_ACCESS(clmpcc)
 
 	case CLMPCC_REG_TDR:
 		if (writeflag == MEM_WRITE) {
-			if (d->reg[CLMPCC_REG_CAR] == 0)
-				console_putchar(d->console_handle, idata);
-			else
-				fatal("[ clmpcc: TODO: transmit "
-				    "to channel, CAR!=0 ]\n");
+			console_putchar(d->console_handle, idata);
 		} else {
 			odata = console_readchar(d->console_handle);
 		}
@@ -266,6 +280,7 @@ DEVINIT(clmpcc)
 
 	CHECK_ALLOCATION(d = (struct clmpcc_data *) malloc(sizeof(struct clmpcc_data)));
 	memset(d, 0, sizeof(struct clmpcc_data));
+	d->reg[CLMPCC_REG_GFRCR] = 0x0d;
 
 	d->console_handle =
 	    console_start_slave(devinit->machine, devinit->name2 != NULL?
