# $NetBSD: buildlink3.mk,v 1.3 2025/02/02 13:05:32 pho Exp $

BUILDLINK_TREE+=	stylish-haskell

.if !defined(STYLISH_HASKELL_BUILDLINK3_MK)
STYLISH_HASKELL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.stylish-haskell+=	stylish-haskell>=0.14.6
BUILDLINK_ABI_DEPENDS.stylish-haskell+=	stylish-haskell>=0.14.6.0nb2
BUILDLINK_PKGSRCDIR.stylish-haskell?=	../../devel/stylish-haskell

# lib:stylish-haskell
.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../devel/hs-file-embed/buildlink3.mk"
.include "../../devel/hs-ghc-lib-parser-ex/buildlink3.mk"
.include "../../textproc/hs-HsYAML/buildlink3.mk"
.include "../../textproc/hs-HsYAML-aeson/buildlink3.mk"
.include "../../textproc/hs-regex-tdfa/buildlink3.mk"
.include "../../devel/hs-syb/buildlink3.mk"
.include "../../devel/hs-ghc-lib-parser/buildlink3.mk"

.endif	# STYLISH_HASKELL_BUILDLINK3_MK

BUILDLINK_TREE+=	-stylish-haskell
