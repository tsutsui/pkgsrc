# $NetBSD: buildlink3.mk,v 1.8 2025/02/02 13:06:06 pho Exp $

BUILDLINK_TREE+=	hs-servant-server

.if !defined(HS_SERVANT_SERVER_BUILDLINK3_MK)
HS_SERVANT_SERVER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-servant-server+=	hs-servant-server>=0.20.2
BUILDLINK_ABI_DEPENDS.hs-servant-server+=	hs-servant-server>=0.20.2nb1
BUILDLINK_PKGSRCDIR.hs-servant-server?=		../../www/hs-servant-server

.include "../../devel/hs-constraints/buildlink3.mk"
.include "../../www/hs-http-api-data/buildlink3.mk"
.include "../../www/hs-servant/buildlink3.mk"
.include "../../converters/hs-base64-bytestring/buildlink3.mk"
.include "../../www/hs-http-media/buildlink3.mk"
.include "../../www/hs-http-types/buildlink3.mk"
.include "../../devel/hs-monad-control/buildlink3.mk"
.include "../../net/hs-network/buildlink3.mk"
.include "../../devel/hs-resourcet/buildlink3.mk"
.include "../../devel/hs-sop-core/buildlink3.mk"
.include "../../devel/hs-tagged/buildlink3.mk"
.include "../../devel/hs-transformers-base/buildlink3.mk"
.include "../../www/hs-wai/buildlink3.mk"
.include "../../www/hs-wai-app-static/buildlink3.mk"
.include "../../devel/hs-word8/buildlink3.mk"
.endif	# HS_SERVANT_SERVER_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-servant-server
