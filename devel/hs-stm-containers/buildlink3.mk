# $NetBSD: buildlink3.mk,v 1.10 2025/02/02 13:05:24 pho Exp $

BUILDLINK_TREE+=	hs-stm-containers

.if !defined(HS_STM_CONTAINERS_BUILDLINK3_MK)
HS_STM_CONTAINERS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-stm-containers+=	hs-stm-containers>=1.2.1
BUILDLINK_ABI_DEPENDS.hs-stm-containers+=	hs-stm-containers>=1.2.1nb1
BUILDLINK_PKGSRCDIR.hs-stm-containers?=		../../devel/hs-stm-containers

.include "../../devel/hs-deferred-folds/buildlink3.mk"
.include "../../devel/hs-focus/buildlink3.mk"
.include "../../devel/hs-hashable/buildlink3.mk"
.include "../../devel/hs-list-t/buildlink3.mk"
.include "../../devel/hs-stm-hamt/buildlink3.mk"
.endif	# HS_STM_CONTAINERS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-stm-containers
