# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:04:54 pho Exp $

BUILDLINK_TREE+=	floskell

.if !defined(FLOSKELL_BUILDLINK3_MK)
FLOSKELL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.floskell+=	floskell>=0.11.1
BUILDLINK_ABI_DEPENDS.floskell+=	floskell>=0.11.1nb2
BUILDLINK_PKGSRCDIR.floskell?=		../../devel/floskell

.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../textproc/hs-attoparsec/buildlink3.mk"
.include "../../textproc/hs-attoparsec-aeson/buildlink3.mk"
.include "../../devel/hs-data-default/buildlink3.mk"
.include "../../devel/hs-haskell-src-exts/buildlink3.mk"
.include "../../devel/hs-monad-dijkstra/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.endif	# FLOSKELL_BUILDLINK3_MK

BUILDLINK_TREE+=	-floskell
