# $NetBSD: buildlink3.mk,v 1.10 2025/02/02 13:05:51 pho Exp $

BUILDLINK_TREE+=	hs-cheapskate

.if !defined(HS_CHEAPSKATE_BUILDLINK3_MK)
HS_CHEAPSKATE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-cheapskate+=	hs-cheapskate>=0.1.1
BUILDLINK_ABI_DEPENDS.hs-cheapskate+=	hs-cheapskate>=0.1.1.2nb9
BUILDLINK_PKGSRCDIR.hs-cheapskate?=	../../textproc/hs-cheapskate

.include "../../textproc/hs-blaze-html/buildlink3.mk"
.include "../../devel/hs-data-default/buildlink3.mk"
.include "../../devel/hs-syb/buildlink3.mk"
.include "../../devel/hs-uniplate/buildlink3.mk"
.include "../../www/hs-xss-sanitize/buildlink3.mk"
.endif	# HS_CHEAPSKATE_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-cheapskate
