# $NetBSD: buildlink3.mk,v 1.11 2025/02/02 13:04:58 pho Exp $

BUILDLINK_TREE+=	hs-base-unicode-symbols

.if !defined(HS_BASE_UNICODE_SYMBOLS_BUILDLINK3_MK)
HS_BASE_UNICODE_SYMBOLS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-base-unicode-symbols+=	hs-base-unicode-symbols>=0.2.4
BUILDLINK_ABI_DEPENDS.hs-base-unicode-symbols+=	hs-base-unicode-symbols>=0.2.4.2nb9
BUILDLINK_PKGSRCDIR.hs-base-unicode-symbols?=	../../devel/hs-base-unicode-symbols
.endif	# HS_BASE_UNICODE_SYMBOLS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-base-unicode-symbols
