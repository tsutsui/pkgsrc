# $NetBSD: buildlink3.mk,v 1.11 2025/02/02 13:05:54 pho Exp $

BUILDLINK_TREE+=	hs-hxt-regex-xmlschema

.if !defined(HS_HXT_REGEX_XMLSCHEMA_BUILDLINK3_MK)
HS_HXT_REGEX_XMLSCHEMA_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-hxt-regex-xmlschema+=	hs-hxt-regex-xmlschema>=9.2.0
BUILDLINK_ABI_DEPENDS.hs-hxt-regex-xmlschema+=	hs-hxt-regex-xmlschema>=9.2.0.7nb9
BUILDLINK_PKGSRCDIR.hs-hxt-regex-xmlschema?=	../../textproc/hs-hxt-regex-xmlschema

.include "../../textproc/hs-hxt-charproperties/buildlink3.mk"
.endif	# HS_HXT_REGEX_XMLSCHEMA_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-hxt-regex-xmlschema
