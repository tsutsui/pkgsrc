$NetBSD$

- lunafb: Implement LUNA monochrome framebuffer ROP functions and masks.

--- src/devices/dev_lunafb.c.orig
+++ src/devices/dev_lunafb.c
@@ -53,6 +53,10 @@
 
 struct lunafb_data {
 	struct vfb_data *fb;
+	uint8_t bmsel;
+	/* Only 1bpp framebuffers are supported. */
+	uint8_t rop;
+	uint32_t rop_mask;
 };
 
 
@@ -60,7 +64,7 @@
 {
  	uint32_t addr = relative_addr + BMAP_START;
 	uint64_t idata = 0, odata = 0;
-	// struct lunafb_data *d = (struct lunafb_data *) extra;
+	struct lunafb_data *d = (struct lunafb_data *) extra;
 
 	if (writeflag == MEM_WRITE)
 		idata = memory_readmax64(cpu, data, len);
@@ -72,8 +76,9 @@
 		/*  Ignore for now. (?)  */
 		break;
 
-	case BMAP_BMSEL:	/*  0xb1000000: BMSEL register  */
-		/*  Ignore for now. Used by OpenBSD's omfb_clear_framebuffer.  */
+	case BMAP_BMSEL:	/*  0xb1040000: BMSEL register  */
+		if (writeflag == MEM_WRITE)
+			d->bmsel = idata;
 		break;
 
 	default:
@@ -101,39 +106,94 @@
 }
 
 
-DEVICE_ACCESS(lunafb_bmp)
+/*
+ * ROP definitions follow NetBSD/luna68k dev/omrasopsvar.h that based on
+ * Hitachi HM53461/53462 datasheet.
+ * (There is typo in ROP_NOR comment in NetBSD omrasopsvar.h)
+ */
+static uint8_t lunafb_rop(unsigned int rop, uint8_t src, uint8_t dst)
 {
-	struct lunafb_data *d = (struct lunafb_data *) extra;
+	switch (rop) {
+	case ROP_ZERO:    return 0;
+	case ROP_AND1:    return src & dst;
+	case ROP_AND2:    return ~src & dst;
+	case ROP_AND3:    return src & ~dst;
+	case ROP_THROUGH: return src;
+	case ROP_EOR:     return src ^ dst;
+	case ROP_OR1:     return src | dst;
+	case ROP_NOR:     return ~src & ~dst;
+	case ROP_ENOR:    return ~(src ^ dst);
+	case ROP_INV1:    return ~src;
+	case ROP_OR2:     return ~src | dst;
+	case ROP_INV2:    return ~dst;
+	case ROP_OR3:     return src | ~dst;
+	case ROP_NAND:    return ~src | ~dst;
+	case ROP_ONE:     return 0xff;
+	}
+	/* ROP 3 is not ROP command (SAM configuration). */
+	return dst;
+}
+
+/*
+ * Access the common bitmap or individual plane 0 bitmap.
+ * BMSEL selects the planes written through the common bitmap.
+ */
+static int lunafb_bitmap_access(struct cpu *cpu, uint64_t relative_addr,
+    unsigned char *data, size_t len, int writeflag, struct lunafb_data *d,
+    int common)
+{
+	unsigned char result[8];
+	size_t i;
+
+	/* CPU memory accesses are at most 64 bits. Check the entire aperture. */
+	if (len == 0 || len > sizeof(result) || relative_addr >= 0x40000 ||
+	    len > 0x40000 - relative_addr)
+		return 0;
 
 	if (!use_dyntrans && relative_addr >= 8)
 		relative_addr -= 8;
 
-	if (relative_addr + len - 1 < 0x40000)
-		dev_fb_access(cpu, cpu->mem, relative_addr, data, len, writeflag, d->fb);
+	if (writeflag == MEM_READ)
+		return dev_fb_access(cpu, cpu->mem, relative_addr, data, len,
+		    writeflag, d->fb);
 
-	return 1;
+	if (common && !(d->bmsel & 1))
+		return 1;
+
+	for (i = 0; i < len; i++) {
+		uint8_t old = d->fb->framebuffer[relative_addr + i];
+		/* Framebuffer bytes are in guest order, not host word order. */
+		uint8_t mask = d->rop_mask >>
+		    (24 - ((relative_addr + i) & 3) * 8);
+		result[i] = (old & ~mask) |
+		    (lunafb_rop(d->rop, data[i], old) & mask);
+	}
+
+	/* Preserve dev_fb's dirty rectangle tracking and VFB_REVERSEBITS. */
+	return dev_fb_access(cpu, cpu->mem, relative_addr, result, len,
+	    writeflag, d->fb);
 }
 
 
-DEVICE_ACCESS(lunafb_bmap0)
+DEVICE_ACCESS(lunafb_bmp)
 {
-	struct lunafb_data *d = (struct lunafb_data *) extra;
-
-	if (!use_dyntrans && relative_addr >= 8)
-		relative_addr -= 8;
+	return lunafb_bitmap_access(cpu, relative_addr, data, len, writeflag,
+	    (struct lunafb_data *)extra, 1);
+}
 
-	if (relative_addr + len - 1 < 0x40000)
-		dev_fb_access(cpu, cpu->mem, relative_addr, data, len, writeflag, d->fb);
 
-	return 1;
+DEVICE_ACCESS(lunafb_bmap0)
+{
+	return lunafb_bitmap_access(cpu, relative_addr, data, len, writeflag,
+	    (struct lunafb_data *)extra, 0);
 }
 
 
 DEVICE_ACCESS(lunafb_b)
 {
  	uint32_t addr = relative_addr + BMAP_BMAP1;
-	uint64_t idata = 0, odata = 0;
-	// struct lunafb_data *d = (struct lunafb_data *) extra;
+	uint64_t idata = 0;
+	struct lunafb_data *d = (struct lunafb_data *) extra;
 
 	if (writeflag == MEM_WRITE)
 		idata = memory_readmax64(cpu, data, len);
@@ -143,53 +203,46 @@
 		return 1;
 	}
 
-	switch (addr) {
-
-	case BMAP_BMAP1:	/*  0xb1100000: Bitmap plane 1  */
-		/*  Return a dummy value. OpenBSD writes and reads to
-		    detect presence of bitplanes.  */
-		odata = 0;
-		break;
-
-	case BMAP_FN + 4 * ROP_THROUGH:	/*  0xb12c0014: "common bitmap function"  */
-		/*  Function 5 is "ROP copy", according to OpenBSD sources.  */
-		/*  See hitachi_hm53462_rop.h  */
-		if (writeflag == MEM_READ) {
-			debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
-		    	    "TODO: lunafb READ from BMAP_FN ROP register");
-			cpu->running = 0;
-			return 0;
-		}
-		if (idata != 0xffffffff) {
-			debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
-		    	    "TODO: lunafb write which does not set ALL bits");
-			cpu->running = 0;
-			return 0;
+	/*
+	 * Writing a function address sets the function and mask of the
+	 * selected planes, without changing VRAM.  BMSEL applies only to
+	 * common settings.  Bank 0 is common; bank n+1 is for plane n.
+	 * Function registers are write-only.  ROP 3 is a serial-mode command
+	 * according to nono's RasterOp(), and is not supported here.
+	 */
+	if (addr >= BMAP_FN && addr < BMAP_END) {
+		uint32_t offset = (addr - BMAP_FN) & 0x3ffff;
+		unsigned int bank = (addr - BMAP_FN) / 0x40000;
+		if (writeflag == MEM_WRITE && len == 4 && offset < 64 &&
+		    (offset & 3) == 0 && offset != 3 * 4) {
+			if ((bank == 0 && (d->bmsel & 1)) || bank == 1) {
+				d->rop = offset / 4;
+				d->rop_mask = idata;
+			}
+			/* In 1bpp mode, settings for other planes have no effect. */
+			return 1;
 		}
-		break;
-
-	default:
-		if (writeflag == MEM_WRITE)
-			debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
-		    	    "unimplemented %i-bit WRITE to address 0x%x: 0x%x",
-		    	    len * 8,
-			    (int) addr,
-			    (int) idata);
-		else
-			debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
-		    	    "unimplemented %i-bit READ from address 0x%x",
-		    	    len * 8,
-			    (int) addr);
-
-		// Stop the emulation immediately.
-		cpu->running = 0;
-		return 0;
 	}
 
-	if (writeflag == MEM_READ)
-		memory_writemax64(cpu, data, len, odata);
+	if (addr == BMAP_BMAP1) {
+		/* OpenBSD probes plane 1 to detect the framebuffer depth. */
+		if (writeflag == MEM_READ)
+			memory_writemax64(cpu, data, len, 0);
+		return 1;
+	}
 
-	return 1;
+	if (writeflag == MEM_WRITE)
+		debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
+		    "unimplemented %i-bit WRITE to address 0x%x: 0x%x",
+		    len * 8, (int) addr, (int) idata);
+	else
+		debugmsg_cpu(cpu, SUBSYS_DEVICE, "lunafb_b", VERBOSITY_ERROR,
+		    "unimplemented %i-bit READ from address 0x%x",
+		    len * 8, (int) addr);
+
+	// Stop the emulation immediately.
+	cpu->running = 0;
+	return 0;
 }
 
 
@@ -199,6 +252,9 @@
 
 	CHECK_ALLOCATION(d = (struct lunafb_data *) malloc(sizeof(struct lunafb_data)));
 	memset(d, 0, sizeof(struct lunafb_data));
+	/* Preserve direct-write behaviour until the guest programs a ROP. */
+	d->rop = ROP_THROUGH;
+	d->rop_mask = 0xffffffff;
 
 	/*
 	 *  OpenBSD/luna88k uses both BMAP_BMP _and_ BMAP_BMAP0. During
