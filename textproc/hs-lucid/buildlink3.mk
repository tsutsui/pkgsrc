# $NetBSD: buildlink3.mk,v 1.14 2025/02/02 13:05:54 pho Exp $

BUILDLINK_TREE+=	hs-lucid

.if !defined(HS_LUCID_BUILDLINK3_MK)
HS_LUCID_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-lucid+=	hs-lucid>=2.11.20230408
BUILDLINK_ABI_DEPENDS.hs-lucid+=	hs-lucid>=2.11.20230408nb3
BUILDLINK_PKGSRCDIR.hs-lucid?=		../../textproc/hs-lucid

.include "../../devel/hs-blaze-builder/buildlink3.mk"
.include "../../devel/hs-hashable/buildlink3.mk"
.include "../../devel/hs-mmorph/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.endif	# HS_LUCID_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-lucid
