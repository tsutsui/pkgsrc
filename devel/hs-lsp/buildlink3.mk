# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:05:13 pho Exp $

BUILDLINK_TREE+=	hs-lsp

.if !defined(HS_LSP_BUILDLINK3_MK)
HS_LSP_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-lsp+=	hs-lsp>=2.7.0
BUILDLINK_ABI_DEPENDS.hs-lsp+=	hs-lsp>=2.7.0.1nb1
BUILDLINK_PKGSRCDIR.hs-lsp?=	../../devel/hs-lsp

.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../devel/hs-async/buildlink3.mk"
.include "../../textproc/hs-attoparsec/buildlink3.mk"
.include "../../sysutils/hs-co-log-core/buildlink3.mk"
.include "../../devel/hs-data-default/buildlink3.mk"
.include "../../misc/hs-extra/buildlink3.mk"
.include "../../devel/hs-hashable/buildlink3.mk"
.include "../../devel/hs-lens/buildlink3.mk"
.include "../../converters/hs-lens-aeson/buildlink3.mk"
.include "../../devel/hs-lsp-types/buildlink3.mk"
.include "../../textproc/hs-prettyprinter/buildlink3.mk"
.include "../../devel/hs-sorted-list/buildlink3.mk"
.include "../../textproc/hs-text-rope/buildlink3.mk"
.include "../../devel/hs-unliftio/buildlink3.mk"
.include "../../devel/hs-unliftio-core/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.endif	# HS_LSP_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-lsp
