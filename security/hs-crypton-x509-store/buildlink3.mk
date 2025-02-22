# $NetBSD: buildlink3.mk,v 1.4 2025/02/02 13:05:43 pho Exp $

BUILDLINK_TREE+=	hs-crypton-x509-store

.if !defined(HS_CRYPTON_X509_STORE_BUILDLINK3_MK)
HS_CRYPTON_X509_STORE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-crypton-x509-store+=	hs-crypton-x509-store>=1.6.9
BUILDLINK_ABI_DEPENDS.hs-crypton-x509-store+=	hs-crypton-x509-store>=1.6.9nb3
BUILDLINK_PKGSRCDIR.hs-crypton-x509-store?=	../../security/hs-crypton-x509-store

.include "../../devel/hs-asn1-encoding/buildlink3.mk"
.include "../../devel/hs-asn1-types/buildlink3.mk"
.include "../../security/hs-crypton/buildlink3.mk"
.include "../../security/hs-crypton-x509/buildlink3.mk"
.include "../../security/hs-pem/buildlink3.mk"
.endif	# HS_CRYPTON_X509_STORE_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-crypton-x509-store
