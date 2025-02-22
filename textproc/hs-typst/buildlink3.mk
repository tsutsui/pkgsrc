# $NetBSD: buildlink3.mk,v 1.6 2025/02/02 13:05:59 pho Exp $

BUILDLINK_TREE+=	hs-typst

.if !defined(HS_TYPST_BUILDLINK3_MK)
HS_TYPST_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-typst+=	hs-typst>=0.6.1
BUILDLINK_ABI_DEPENDS.hs-typst+=	hs-typst>=0.6.1nb1
BUILDLINK_PKGSRCDIR.hs-typst?=		../../textproc/hs-typst

.include "../../textproc/hs-typst-symbols/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.include "../../devel/hs-ordered-containers/buildlink3.mk"
.include "../../textproc/hs-cassava/buildlink3.mk"
.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../textproc/hs-regex-tdfa/buildlink3.mk"
.include "../../math/hs-scientific/buildlink3.mk"
.include "../../textproc/hs-toml-parser/buildlink3.mk"
.include "../../textproc/hs-xml-conduit/buildlink3.mk"
.include "../../textproc/hs-yaml/buildlink3.mk"
.endif	# HS_TYPST_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-typst
