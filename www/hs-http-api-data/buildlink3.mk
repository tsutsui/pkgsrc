# $NetBSD: buildlink3.mk,v 1.8 2025/02/02 13:06:03 pho Exp $

BUILDLINK_TREE+=	hs-http-api-data

.if !defined(HS_HTTP_API_DATA_BUILDLINK3_MK)
HS_HTTP_API_DATA_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-http-api-data+=	hs-http-api-data>=0.6.1
BUILDLINK_ABI_DEPENDS.hs-http-api-data+=	hs-http-api-data>=0.6.1nb1
BUILDLINK_PKGSRCDIR.hs-http-api-data?=		../../www/hs-http-api-data

.include "../../www/hs-cookie/buildlink3.mk"
.include "../../devel/hs-hashable/buildlink3.mk"
.include "../../www/hs-http-types/buildlink3.mk"
.include "../../devel/hs-tagged/buildlink3.mk"
.include "../../time/hs-text-iso8601/buildlink3.mk"
.include "../../time/hs-time-compat/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.include "../../devel/hs-uuid-types/buildlink3.mk"
.endif	# HS_HTTP_API_DATA_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-http-api-data
