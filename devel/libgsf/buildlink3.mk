# $NetBSD: buildlink3.mk,v 1.43 2024/11/14 22:19:31 wiz Exp $

BUILDLINK_TREE+=	libgsf

.if !defined(LIBGSF_BUILDLINK3_MK)
LIBGSF_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libgsf+=	libgsf>=1.13.3
BUILDLINK_ABI_DEPENDS.libgsf+=	libgsf>=1.14.53nb3
BUILDLINK_PKGSRCDIR.libgsf?=	../../devel/libgsf

.include "../../archivers/bzip2/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/gdk-pixbuf2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif # LIBGSF_BUILDLINK3_MK

BUILDLINK_TREE+=	-libgsf
