# $NetBSD: buildlink3.mk,v 1.7 2025/02/02 13:05:34 pho Exp $

BUILDLINK_TREE+=	hs-language-javascript

.if !defined(HS_LANGUAGE_JAVASCRIPT_BUILDLINK3_MK)
HS_LANGUAGE_JAVASCRIPT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-language-javascript+=	hs-language-javascript>=0.7.1
BUILDLINK_ABI_DEPENDS.hs-language-javascript+=	hs-language-javascript>=0.7.1.0nb6
BUILDLINK_PKGSRCDIR.hs-language-javascript?=	../../lang/hs-language-javascript

.include "../../devel/hs-blaze-builder/buildlink3.mk"
.include "../../devel/hs-utf8-string/buildlink3.mk"
.endif	# HS_LANGUAGE_JAVASCRIPT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-language-javascript
