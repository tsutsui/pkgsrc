# $NetBSD: buildlink3.mk,v 1.7 2025/02/02 13:04:54 pho Exp $

BUILDLINK_TREE+=	hasktags

.if !defined(HASKTAGS_BUILDLINK3_MK)
HASKTAGS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hasktags+=	hasktags>=0.73.0
BUILDLINK_ABI_DEPENDS.hasktags+=	hasktags>=0.73.0nb3
BUILDLINK_PKGSRCDIR.hasktags?=		../../devel/hasktags

.include "../../converters/hs-json/buildlink3.mk"
.include "../../devel/hs-microlens-platform/buildlink3.mk"
.include "../../devel/hs-utf8-string/buildlink3.mk"
.endif	# HASKTAGS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hasktags
