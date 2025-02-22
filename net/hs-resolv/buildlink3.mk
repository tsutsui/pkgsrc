# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:05:41 pho Exp $

BUILDLINK_TREE+=	hs-resolv

.if !defined(HS_RESOLV_BUILDLINK3_MK)
HS_RESOLV_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-resolv+=	hs-resolv>=0.2.0
BUILDLINK_ABI_DEPENDS.hs-resolv+=	hs-resolv>=0.2.0.2nb3
BUILDLINK_PKGSRCDIR.hs-resolv?=		../../net/hs-resolv

.include "../../converters/hs-base16-bytestring/buildlink3.mk"
.endif	# HS_RESOLV_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-resolv
