# $NetBSD: buildlink3.mk,v 1.5 2025/02/02 13:05:46 pho Exp $

BUILDLINK_TREE+=	hs-disk-free-space

.if !defined(HS_DISK_FREE_SPACE_BUILDLINK3_MK)
HS_DISK_FREE_SPACE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-disk-free-space+=	hs-disk-free-space>=0.1.0
BUILDLINK_ABI_DEPENDS.hs-disk-free-space+=	hs-disk-free-space>=0.1.0.1nb4
BUILDLINK_PKGSRCDIR.hs-disk-free-space?=	../../sysutils/hs-disk-free-space
.endif	# HS_DISK_FREE_SPACE_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-disk-free-space
