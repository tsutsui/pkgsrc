# $NetBSD: buildlink3.mk,v 1.11 2025/02/02 13:05:28 pho Exp $

BUILDLINK_TREE+=	hs-turtle

.if !defined(HS_TURTLE_BUILDLINK3_MK)
HS_TURTLE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-turtle+=	hs-turtle>=1.6.2
BUILDLINK_ABI_DEPENDS.hs-turtle+=	hs-turtle>=1.6.2nb3
BUILDLINK_PKGSRCDIR.hs-turtle?=		../../devel/hs-turtle

.include "../../textproc/hs-ansi-wl-pprint/buildlink3.mk"
.include "../../devel/hs-async/buildlink3.mk"
.include "../../time/hs-clock/buildlink3.mk"
.include "../../devel/hs-foldl/buildlink3.mk"
.include "../../sysutils/hs-hostname/buildlink3.mk"
.include "../../devel/hs-managed/buildlink3.mk"
.include "../../devel/hs-optional-args/buildlink3.mk"
.include "../../devel/hs-optparse-applicative/buildlink3.mk"
.include "../../devel/hs-streaming-commons/buildlink3.mk"
.include "../../sysutils/hs-temporary/buildlink3.mk"
.include "../../devel/hs-unix-compat/buildlink3.mk"
.endif	# HS_TURTLE_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-turtle
