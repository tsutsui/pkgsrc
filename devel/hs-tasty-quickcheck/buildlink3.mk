# $NetBSD: buildlink3.mk,v 1.5 2025/02/02 13:05:26 pho Exp $

BUILDLINK_TREE+=	hs-tasty-quickcheck

.if !defined(HS_TASTY_QUICKCHECK_BUILDLINK3_MK)
HS_TASTY_QUICKCHECK_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-tasty-quickcheck+=	hs-tasty-quickcheck>=0.11.1
BUILDLINK_ABI_DEPENDS.hs-tasty-quickcheck+=	hs-tasty-quickcheck>=0.11.1nb1
BUILDLINK_PKGSRCDIR.hs-tasty-quickcheck?=	../../devel/hs-tasty-quickcheck

.include "../../devel/hs-optparse-applicative/buildlink3.mk"
.include "../../devel/hs-QuickCheck/buildlink3.mk"
.include "../../devel/hs-random/buildlink3.mk"
.include "../../devel/hs-tagged/buildlink3.mk"
.include "../../devel/hs-tasty/buildlink3.mk"
.endif	# HS_TASTY_QUICKCHECK_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-tasty-quickcheck
