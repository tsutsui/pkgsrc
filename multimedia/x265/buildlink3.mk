# $NetBSD: buildlink3.mk,v 1.5 2024/11/24 06:59:05 adam Exp $

BUILDLINK_TREE+=	x265

.if !defined(X265_BUILDLINK3_MK)
X265_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.x265+=	x265>=1.1
BUILDLINK_ABI_DEPENDS.x265+=	x265>=4.1
BUILDLINK_PKGSRCDIR.x265?=	../../multimedia/x265
.endif	# X265_BUILDLINK3_MK

BUILDLINK_TREE+=	-x265
