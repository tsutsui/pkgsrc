# $NetBSD: buildlink3.mk,v 1.5 2025/02/02 13:05:39 pho Exp $

BUILDLINK_TREE+=	hs-statistics

.if !defined(HS_STATISTICS_BUILDLINK3_MK)
HS_STATISTICS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-statistics+=	hs-statistics>=0.16.3
BUILDLINK_ABI_DEPENDS.hs-statistics+=	hs-statistics>=0.16.3.0nb1
BUILDLINK_PKGSRCDIR.hs-statistics?=	../../math/hs-statistics

.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../devel/hs-async/buildlink3.mk"
.include "../../devel/hs-data-default-class/buildlink3.mk"
.include "../../math/hs-dense-linear-algebra/buildlink3.mk"
.include "../../math/hs-math-functions/buildlink3.mk"
.include "../../math/hs-mwc-random/buildlink3.mk"
.include "../../devel/hs-parallel/buildlink3.mk"
.include "../../devel/hs-primitive/buildlink3.mk"
.include "../../devel/hs-random/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.include "../../devel/hs-vector-algorithms/buildlink3.mk"
.include "../../devel/hs-vector-binary-instances/buildlink3.mk"
.include "../../devel/hs-vector-th-unbox/buildlink3.mk"
.endif	# HS_STATISTICS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-statistics
