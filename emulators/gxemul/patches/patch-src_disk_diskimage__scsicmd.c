$NetBSD$

- diskimage: don't respond requests against non-zero LUNs

--- src/disk/diskimage_scsicmd.c.orig	2021-04-22 18:04:21.000000000 +0000
+++ src/disk/diskimage_scsicmd.c
@@ -286,20 +286,21 @@ if (xferp->cmd_len > 7 && xferp->cmd[5] 
 		if (xferp->cmd_len != 6)
 			debug(" (weird len=%i)", xferp->cmd_len);
 
-		/*  TODO: bits 765 of buf[1] contains the LUN  */
-		if (xferp->cmd[1] != 0x00)
+		if ((xferp->cmd[1] & 0x1f) != 0)
 			debugmsg(SUBSYS_DISK, "scsi", VERBOSITY_WARNING,
 			    "WARNING: TEST_UNIT_READY with cmd[1]=0x%02x"
 			    " not yet implemented", (int)xferp->cmd[1]);
 
 		diskimage__return_default_status_and_message(xferp);
+		if ((xferp->cmd[1] & 0xe0) != 0)
+			xferp->status[0] = 0x02;  /*  CHECK CONDITION  */
 		break;
 
 	case SCSICMD_INQUIRY:
 		debug("INQUIRY");
 		if (xferp->cmd_len != 6)
 			debug(" (weird len=%i)", xferp->cmd_len);
-		if (xferp->cmd[1] != 0x00) {
+		if ((xferp->cmd[1] & 0x1f) != 0) {
 			debugmsg(SUBSYS_DISK, "scsi", VERBOSITY_WARNING,
 			    "WARNING: INQUIRY with cmd[1]=0x%02x not yet "
 			    "implemented", (int)xferp->cmd[1]);
@@ -316,6 +317,17 @@ if (xferp->cmd_len > 7 && xferp->cmd[5] 
 		/*  Return data:  */
 		scsi_transfer_allocbuf(&xferp->data_in_len, &xferp->data_in,
 		    retlen, 1);
+
+		/*
+		 * Disk images currently provide only LUN 0 for each target.
+		 * For an unsupported LUN, INQUIRY returns PQ=3, PDT=0x1f.
+		 */
+		if ((xferp->cmd[1] & 0xe0) != 0) {
+			xferp->data_in[0] = 0x7f;
+			diskimage__return_default_status_and_message(xferp);
+			break;
+		}
+
 		xferp->data_in[0] = 0x00;  /*  0x00 = Direct-access disk  */
 		xferp->data_in[1] = 0x00;  /*  0x00 = non-removable  */
 		xferp->data_in[2] = 0x02;  /*  SCSI-2  */
@@ -771,8 +783,7 @@ xferp->data_in[4] = 0x2c - 4;	/*  Additi
 
 		retlen = xferp->cmd[4];
 
-		/*  TODO: bits 765 of buf[1] contains the LUN  */
-		if (xferp->cmd[1] != 0x00)
+		if ((xferp->cmd[1] & 0x1f) != 0)
 			fatal("WARNING: REQUEST_SENSE with cmd[1]=0x%02x not"
 			    " yet implemented\n", (int)xferp->cmd[1]);
 
@@ -786,6 +797,16 @@ xferp->data_in[4] = 0x2c - 4;	/*  Additi
 		scsi_transfer_allocbuf(&xferp->data_in_len, &xferp->data_in,
 		    retlen, 1);
 
+		if ((xferp->cmd[1] & 0xe0) != 0) {
+			xferp->data_in[0] = 0x70;	/*  Current errors  */
+			xferp->data_in[2] = 0x05;	/*  ILLEGAL REQUEST  */
+			xferp->data_in[7] = retlen - 8;
+			xferp->data_in[12] = 0x25;	/*  LOGICAL UNIT NOT SUPPORTED  */
+			xferp->data_in[13] = 0x00;
+			diskimage__return_default_status_and_message(xferp);
+			break;
+		}
+
 		xferp->data_in[0] = 0x80 + 0x70;/*  0x80 = valid,
 						    0x70 = "current errors"  */
 		xferp->data_in[2] = 0x00;	/*  SENSE KEY!  */
