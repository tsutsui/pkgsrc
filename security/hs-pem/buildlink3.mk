# $NetBSD: buildlink3.mk,v 1.11 2025/02/02 13:05:44 pho Exp $

BUILDLINK_TREE+=	hs-pem

.if !defined(HS_PEM_BUILDLINK3_MK)
HS_PEM_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-pem+=	hs-pem>=0.2.4
BUILDLINK_ABI_DEPENDS.hs-pem+=	hs-pem>=0.2.4nb10
BUILDLINK_PKGSRCDIR.hs-pem?=	../../security/hs-pem

.include "../../devel/hs-basement/buildlink3.mk"
.include "../../devel/hs-memory/buildlink3.mk"
.endif	# HS_PEM_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-pem
