# $NetBSD: buildlink3.mk,v 1.6 2025/02/02 13:05:40 pho Exp $

BUILDLINK_TREE+=	hs-aws

.if !defined(HS_AWS_BUILDLINK3_MK)
HS_AWS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-aws+=	hs-aws>=0.24.4
BUILDLINK_ABI_DEPENDS.hs-aws+=	hs-aws>=0.24.4nb1
BUILDLINK_PKGSRCDIR.hs-aws?=	../../net/hs-aws

.include "../../converters/hs-aeson/buildlink3.mk"
.include "../../textproc/hs-attoparsec/buildlink3.mk"
.include "../../textproc/hs-attoparsec-aeson/buildlink3.mk"
.include "../../converters/hs-base16-bytestring/buildlink3.mk"
.include "../../converters/hs-base64-bytestring/buildlink3.mk"
.include "../../devel/hs-blaze-builder/buildlink3.mk"
.include "../../devel/hs-byteable/buildlink3.mk"
.include "../../textproc/hs-case-insensitive/buildlink3.mk"
.include "../../devel/hs-cereal/buildlink3.mk"
.include "../../devel/hs-conduit/buildlink3.mk"
.include "../../devel/hs-conduit-extra/buildlink3.mk"
.include "../../security/hs-crypton/buildlink3.mk"
.include "../../devel/hs-data-default/buildlink3.mk"
.include "../../www/hs-http-client-tls/buildlink3.mk"
.include "../../www/hs-http-conduit/buildlink3.mk"
.include "../../www/hs-http-types/buildlink3.mk"
.include "../../devel/hs-lifted-base/buildlink3.mk"
.include "../../devel/hs-memory/buildlink3.mk"
.include "../../devel/hs-monad-control/buildlink3.mk"
.include "../../devel/hs-resourcet/buildlink3.mk"
.include "../../devel/hs-safe/buildlink3.mk"
.include "../../math/hs-scientific/buildlink3.mk"
.include "../../devel/hs-tagged/buildlink3.mk"
.include "../../devel/hs-unordered-containers/buildlink3.mk"
.include "../../devel/hs-utf8-string/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.include "../../textproc/hs-xml-conduit/buildlink3.mk"
.include "../../net/hs-network/buildlink3.mk"
.include "../../net/hs-network-bsd/buildlink3.mk"
.endif	# HS_AWS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-aws
