# $NetBSD: buildlink3.mk,v 1.11 2025/02/02 13:05:37 pho Exp $

BUILDLINK_TREE+=	hs-invariant

.if !defined(HS_INVARIANT_BUILDLINK3_MK)
HS_INVARIANT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-invariant+=	hs-invariant>=0.6.4
BUILDLINK_ABI_DEPENDS.hs-invariant+=	hs-invariant>=0.6.4nb1
BUILDLINK_PKGSRCDIR.hs-invariant?=	../../math/hs-invariant

.include "../../math/hs-bifunctors/buildlink3.mk"
.include "../../math/hs-comonad/buildlink3.mk"
.include "../../math/hs-contravariant/buildlink3.mk"
.include "../../math/hs-profunctors/buildlink3.mk"
.include "../../devel/hs-StateVar/buildlink3.mk"
.include "../../devel/hs-tagged/buildlink3.mk"
.include "../../devel/hs-th-abstraction/buildlink3.mk"
.include "../../devel/hs-transformers-compat/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.endif	# HS_INVARIANT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-invariant
