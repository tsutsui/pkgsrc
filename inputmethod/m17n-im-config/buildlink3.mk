# $NetBSD: buildlink3.mk,v 1.63 2024/12/27 08:20:10 wiz Exp $

BUILDLINK_TREE+=	m17n-im-config

.if !defined(M17N_IM_CONFIG_BUILDLINK3_MK)
M17N_IM_CONFIG_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.m17n-im-config+=	m17n-im-config>=0.9.0
BUILDLINK_ABI_DEPENDS.m17n-im-config+=	m17n-im-config>=0.9.0nb62
BUILDLINK_PKGSRCDIR.m17n-im-config?=	../../inputmethod/m17n-im-config

.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../devel/m17n-lib/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif # M17N_IM_CONFIG_BUILDLINK3_MK

BUILDLINK_TREE+=	-m17n-im-config
