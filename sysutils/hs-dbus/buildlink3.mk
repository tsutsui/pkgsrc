# $NetBSD: buildlink3.mk,v 1.6 2025/02/02 13:05:46 pho Exp $

BUILDLINK_TREE+=	hs-dbus

.if !defined(HS_DBUS_BUILDLINK3_MK)
HS_DBUS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-dbus+=	hs-dbus>=1.3.11
BUILDLINK_ABI_DEPENDS.hs-dbus+=	hs-dbus>=1.3.11nb1
BUILDLINK_PKGSRCDIR.hs-dbus?=	../../sysutils/hs-dbus

.include "../../devel/hs-cereal/buildlink3.mk"
.include "../../devel/hs-conduit/buildlink3.mk"
.include "../../devel/hs-lens/buildlink3.mk"
.include "../../net/hs-network/buildlink3.mk"
.include "../../devel/hs-random/buildlink3.mk"
.include "../../devel/hs-split/buildlink3.mk"
.include "../../devel/hs-th-lift/buildlink3.mk"
.include "../../devel/hs-vector/buildlink3.mk"
.include "../../textproc/hs-xml-conduit/buildlink3.mk"
.include "../../textproc/hs-xml-types/buildlink3.mk"
.endif	# HS_DBUS_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-dbus
