# $NetBSD: buildlink3.mk,v 1.8 2025/02/02 13:05:23 pho Exp $

BUILDLINK_TREE+=	hs-sorted-list

.if !defined(HS_SORTED_LIST_BUILDLINK3_MK)
HS_SORTED_LIST_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-sorted-list+=	hs-sorted-list>=0.2.2
BUILDLINK_ABI_DEPENDS.hs-sorted-list+=	hs-sorted-list>=0.2.2.0nb3
BUILDLINK_PKGSRCDIR.hs-sorted-list?=	../../devel/hs-sorted-list
.endif	# HS_SORTED_LIST_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-sorted-list
