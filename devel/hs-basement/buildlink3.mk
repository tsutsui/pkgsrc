# $NetBSD: buildlink3.mk,v 1.13 2025/02/02 13:04:58 pho Exp $

BUILDLINK_TREE+=	hs-basement

.if !defined(HS_BASEMENT_BUILDLINK3_MK)
HS_BASEMENT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-basement+=	hs-basement>=0.0.16
BUILDLINK_ABI_DEPENDS.hs-basement+=	hs-basement>=0.0.16nb3
BUILDLINK_PKGSRCDIR.hs-basement?=	../../devel/hs-basement
.endif	# HS_BASEMENT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-basement
