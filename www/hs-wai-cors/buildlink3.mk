# $NetBSD: buildlink3.mk,v 1.6 2025/02/02 13:06:06 pho Exp $

BUILDLINK_TREE+=	hs-wai-cors

.if !defined(HS_WAI_CORS_BUILDLINK3_MK)
HS_WAI_CORS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-wai-cors+=	hs-wai-cors>=0.2.7
BUILDLINK_ABI_DEPENDS.hs-wai-cors+=	hs-wai-cors>=0.2.7nb5
BUILDLINK_PKGSRCDIR.hs-wai-cors?=	../../www/hs-wai-cors

.include "../../textproc/hs-attoparsec/buildlink3.mk"
.include "../../devel/hs-base-unicode-symbols/buildlink3.mk"
.include "../../textproc/hs-case-insensitive/buildlink3.mk"
.include "../../www/hs-http-types/buildlink3.mk"
.include "../../www/hs-wai/buildlink3.mk"
.endif	# HS_WAI_CORS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-wai-cors
