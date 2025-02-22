# $NetBSD: buildlink3.mk,v 1.4 2025/02/02 13:05:55 pho Exp $

BUILDLINK_TREE+=	hs-prettyprinter-compat-ansi-wl-pprint

.if !defined(HS_PRETTYPRINTER_COMPAT_ANSI_WL_PPRINT_BUILDLINK3_MK)
HS_PRETTYPRINTER_COMPAT_ANSI_WL_PPRINT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-prettyprinter-compat-ansi-wl-pprint+=	hs-prettyprinter-compat-ansi-wl-pprint>=1.0.2
BUILDLINK_ABI_DEPENDS.hs-prettyprinter-compat-ansi-wl-pprint+=	hs-prettyprinter-compat-ansi-wl-pprint>=1.0.2nb3
BUILDLINK_PKGSRCDIR.hs-prettyprinter-compat-ansi-wl-pprint?=	../../textproc/hs-prettyprinter-compat-ansi-wl-pprint

.include "../../textproc/hs-prettyprinter/buildlink3.mk"
.include "../../textproc/hs-prettyprinter-ansi-terminal/buildlink3.mk"
.endif	# HS_PRETTYPRINTER_COMPAT_ANSI_WL_PPRINT_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-prettyprinter-compat-ansi-wl-pprint
