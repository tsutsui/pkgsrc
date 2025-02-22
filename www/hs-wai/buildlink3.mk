# $NetBSD: buildlink3.mk,v 1.10 2025/02/02 13:06:06 pho Exp $

BUILDLINK_TREE+=	hs-wai

.if !defined(HS_WAI_BUILDLINK3_MK)
HS_WAI_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-wai+=	hs-wai>=3.2.4
BUILDLINK_ABI_DEPENDS.hs-wai+=	hs-wai>=3.2.4nb2
BUILDLINK_PKGSRCDIR.hs-wai?=	../../www/hs-wai

.include "../../www/hs-http-types/buildlink3.mk"
.include "../../net/hs-network/buildlink3.mk"
.include "../../devel/hs-vault/buildlink3.mk"
.endif	# HS_WAI_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-wai
