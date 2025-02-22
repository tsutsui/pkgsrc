# $NetBSD: buildlink3.mk,v 1.4 2025/02/02 13:05:41 pho Exp $

BUILDLINK_TREE+=	hs-network-control

.if !defined(HS_NETWORK_CONTROL_BUILDLINK3_MK)
HS_NETWORK_CONTROL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-network-control+=	hs-network-control>=0.1.4
BUILDLINK_ABI_DEPENDS.hs-network-control+=	hs-network-control>=0.1.4nb1
BUILDLINK_PKGSRCDIR.hs-network-control?=	../../net/hs-network-control

.include "../../devel/hs-psqueues/buildlink3.mk"
.include "../../time/hs-unix-time/buildlink3.mk"
.endif	# HS_NETWORK_CONTROL_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-network-control
