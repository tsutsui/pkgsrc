# $NetBSD: buildlink3.mk,v 1.9 2025/02/02 13:05:12 pho Exp $

BUILDLINK_TREE+=	hs-lens-family-core

.if !defined(HS_LENS_FAMILY_CORE_BUILDLINK3_MK)
HS_LENS_FAMILY_CORE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-lens-family-core+=	hs-lens-family-core>=2.1.3
BUILDLINK_ABI_DEPENDS.hs-lens-family-core+=	hs-lens-family-core>=2.1.3nb2
BUILDLINK_PKGSRCDIR.hs-lens-family-core?=	../../devel/hs-lens-family-core
.endif	# HS_LENS_FAMILY_CORE_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-lens-family-core
