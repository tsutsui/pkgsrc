# $NetBSD: buildlink3.mk,v 1.12 2025/02/02 13:05:55 pho Exp $

BUILDLINK_TREE+=	hs-prettyprinter-ansi-terminal

.if !defined(HS_PRETTYPRINTER_ANSI_TERMINAL_BUILDLINK3_MK)
HS_PRETTYPRINTER_ANSI_TERMINAL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-prettyprinter-ansi-terminal+=	hs-prettyprinter-ansi-terminal>=1.1.3
BUILDLINK_ABI_DEPENDS.hs-prettyprinter-ansi-terminal+=	hs-prettyprinter-ansi-terminal>=1.1.3nb8
BUILDLINK_PKGSRCDIR.hs-prettyprinter-ansi-terminal?=	../../textproc/hs-prettyprinter-ansi-terminal

.include "../../devel/hs-ansi-terminal/buildlink3.mk"
.include "../../textproc/hs-prettyprinter/buildlink3.mk"
.endif	# HS_PRETTYPRINTER_ANSI_TERMINAL_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-prettyprinter-ansi-terminal
