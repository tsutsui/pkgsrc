# $NetBSD: buildlink3.mk,v 1.13 2025/02/02 13:06:04 pho Exp $

BUILDLINK_TREE+=	hs-http2

.if !defined(HS_HTTP2_BUILDLINK3_MK)
HS_HTTP2_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-http2+=	hs-http2>=5.3.9
BUILDLINK_ABI_DEPENDS.hs-http2+=	hs-http2>=5.3.9nb1
BUILDLINK_PKGSRCDIR.hs-http2?=		../../www/hs-http2

.include "../../devel/hs-async/buildlink3.mk"
.include "../../textproc/hs-case-insensitive/buildlink3.mk"
.include "../../www/hs-http-semantics/buildlink3.mk"
.include "../../www/hs-http-types/buildlink3.mk"
.include "../../net/hs-iproute/buildlink3.mk"
.include "../../net/hs-network/buildlink3.mk"
.include "../../net/hs-network-byte-order/buildlink3.mk"
.include "../../net/hs-network-control/buildlink3.mk"
.include "../../devel/hs-psqueues/buildlink3.mk"
.include "../../time/hs-time-manager/buildlink3.mk"
.include "../../time/hs-unix-time/buildlink3.mk"
.include "../../devel/hs-utf8-string/buildlink3.mk"
.endif	# HS_HTTP2_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-http2
