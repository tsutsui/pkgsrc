# $NetBSD: buildlink3.mk,v 1.10 2025/02/02 13:05:16 pho Exp $

BUILDLINK_TREE+=	hs-mutable-containers

.if !defined(HS_MUTABLE_CONTAINERS_BUILDLINK3_MK)
HS_MUTABLE_CONTAINERS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-mutable-containers+=	hs-mutable-containers>=0.3.4
BUILDLINK_ABI_DEPENDS.hs-mutable-containers+=	hs-mutable-containers>=0.3.4.1nb5
BUILDLINK_PKGSRCDIR.hs-mutable-containers?=	../../devel/hs-mutable-containers

.include "../../devel/hs-mono-traversable/buildlink3.mk"
.include "../../devel/hs-primitive/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.endif	# HS_MUTABLE_CONTAINERS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-mutable-containers
