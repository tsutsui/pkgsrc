# $NetBSD: buildlink3.mk,v 1.7 2025/02/02 13:05:57 pho Exp $

BUILDLINK_TREE+=	hs-skylighting-format-context

.if !defined(HS_SKYLIGHTING_FORMAT_CONTEXT_BUILDLINK3_MK)
HS_SKYLIGHTING_FORMAT_CONTEXT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-skylighting-format-context+=	hs-skylighting-format-context>=0.1.0
BUILDLINK_ABI_DEPENDS.hs-skylighting-format-context+=	hs-skylighting-format-context>=0.1.0.2nb3
BUILDLINK_PKGSRCDIR.hs-skylighting-format-context?=	../../textproc/hs-skylighting-format-context

.include "../../textproc/hs-skylighting-core/buildlink3.mk"
.endif	# HS_SKYLIGHTING_FORMAT_CONTEXT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-skylighting-format-context
