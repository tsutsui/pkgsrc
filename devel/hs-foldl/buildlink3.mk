# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:05:06 pho Exp $

BUILDLINK_TREE+=	hs-foldl

.if !defined(HS_FOLDL_BUILDLINK3_MK)
HS_FOLDL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-foldl+=	hs-foldl>=1.4.18
BUILDLINK_ABI_DEPENDS.hs-foldl+=	hs-foldl>=1.4.18nb1
BUILDLINK_PKGSRCDIR.hs-foldl?=		../../devel/hs-foldl

.include "../../devel/hs-random/buildlink3.mk"
.include "../../devel/hs-primitive/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.include "../../devel/hs-hashable/buildlink3.mk"
.include "../../math/hs-contravariant/buildlink3.mk"
.include "../../math/hs-profunctors/buildlink3.mk"
.include "../../math/hs-semigroupoids/buildlink3.mk"
.include "../../math/hs-comonad/buildlink3.mk"
.endif	# HS_FOLDL_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-foldl
