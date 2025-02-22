# $NetBSD: buildlink3.mk,v 1.4 2025/02/02 13:05:32 pho Exp $

BUILDLINK_TREE+=	stan

.if !defined(STAN_BUILDLINK3_MK)
STAN_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.stan+=	stan>=0.2.0
BUILDLINK_ABI_DEPENDS.stan+=	stan>=0.2.0.0nb1
BUILDLINK_PKGSRCDIR.stan?=	../../devel/stan

# lib:stan
.include "../../converters/hs-base64/buildlink3.mk"
.include "../../textproc/hs-blaze-html/buildlink3.mk"
.include "../../textproc/hs-clay/buildlink3.mk"
.include "../../devel/hs-colourista/buildlink3.mk"
.include "../../security/hs-cryptohash-sha1/buildlink3.mk"
.include "../../sysutils/hs-dir-traverse/buildlink3.mk"
.include "../../devel/hs-extensions/buildlink3.mk"
.include "../../devel/hs-gitrev/buildlink3.mk"
.include "../../converters/hs-microaeson/buildlink3.mk"
.include "../../devel/hs-optparse-applicative/buildlink3.mk"
.include "../../devel/hs-pretty-simple/buildlink3.mk"
.include "../../devel/hs-relude/buildlink3.mk"
.include "../../devel/hs-slist/buildlink3.mk"
.include "../../textproc/hs-tomland/buildlink3.mk"
.include "../../devel/hs-trial/buildlink3.mk"
.include "../../devel/hs-trial-optparse-applicative/buildlink3.mk"
.include "../../textproc/hs-trial-tomland/buildlink3.mk"

# lib:target
.include "../../math/hs-scientific/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"

.endif	# STAN_BUILDLINK3_MK

BUILDLINK_TREE+=	-stan
