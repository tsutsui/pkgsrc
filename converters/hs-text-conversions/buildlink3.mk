# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:04:53 pho Exp $

BUILDLINK_TREE+=	hs-text-conversions

.if !defined(HS_TEXT_CONVERSIONS_BUILDLINK3_MK)
HS_TEXT_CONVERSIONS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-text-conversions+=	hs-text-conversions>=0.3.1
BUILDLINK_ABI_DEPENDS.hs-text-conversions+=	hs-text-conversions>=0.3.1.1nb5
BUILDLINK_PKGSRCDIR.hs-text-conversions?=	../../converters/hs-text-conversions

.include "../../converters/hs-base16-bytestring/buildlink3.mk"
.include "../../converters/hs-base64-bytestring/buildlink3.mk"
.endif	# HS_TEXT_CONVERSIONS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-text-conversions
