# $NetBSD: buildlink3.mk,v 1.7 2025/02/02 13:05:41 pho Exp $

BUILDLINK_TREE+=	hs-network-bsd

.if !defined(HS_NETWORK_BSD_BUILDLINK3_MK)
HS_NETWORK_BSD_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-network-bsd+=	hs-network-bsd>=2.8.1
BUILDLINK_ABI_DEPENDS.hs-network-bsd+=	hs-network-bsd>=2.8.1.0nb6
BUILDLINK_PKGSRCDIR.hs-network-bsd?=	../../net/hs-network-bsd

.include "../../net/hs-network/buildlink3.mk"
.endif	# HS_NETWORK_BSD_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-network-bsd
