# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:05:49 pho Exp $

BUILDLINK_TREE+=	hs-ansi-wl-pprint

.if !defined(HS_ANSI_WL_PPRINT_BUILDLINK3_MK)
HS_ANSI_WL_PPRINT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-ansi-wl-pprint+=	hs-ansi-wl-pprint>=1.0.2
BUILDLINK_ABI_DEPENDS.hs-ansi-wl-pprint+=	hs-ansi-wl-pprint>=1.0.2nb3
BUILDLINK_PKGSRCDIR.hs-ansi-wl-pprint?=		../../textproc/hs-ansi-wl-pprint

.include "../../textproc/hs-prettyprinter-compat-ansi-wl-pprint/buildlink3.mk"
.endif	# HS_ANSI_WL_PPRINT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-ansi-wl-pprint
