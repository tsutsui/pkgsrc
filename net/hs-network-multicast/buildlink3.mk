# $NetBSD: buildlink3.mk,v 1.4 2025/02/02 13:05:41 pho Exp $

BUILDLINK_TREE+=	hs-network-multicast

.if !defined(HS_NETWORK_MULTICAST_BUILDLINK3_MK)
HS_NETWORK_MULTICAST_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-network-multicast+=	hs-network-multicast>=0.3.2
BUILDLINK_ABI_DEPENDS.hs-network-multicast+=	hs-network-multicast>=0.3.2nb3
BUILDLINK_PKGSRCDIR.hs-network-multicast?=	../../net/hs-network-multicast

.include "../../net/hs-network/buildlink3.mk"
.include "../../net/hs-network-bsd/buildlink3.mk"
.endif	# HS_NETWORK_MULTICAST_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-network-multicast
