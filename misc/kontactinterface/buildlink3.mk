# $NetBSD: buildlink3.mk,v 1.10 2024/11/14 22:20:50 wiz Exp $

BUILDLINK_TREE+=	kontactinterface

.if !defined(KONTACTINTERFACE_BUILDLINK3_MK)
KONTACTINTERFACE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kontactinterface+=	kontactinterface>=20.04.1
BUILDLINK_ABI_DEPENDS.kontactinterface?=		kontactinterface>=23.08.4nb6
BUILDLINK_PKGSRCDIR.kontactinterface?=		../../misc/kontactinterface

.include "../../devel/kparts/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KONTACTINTERFACE_BUILDLINK3_MK

BUILDLINK_TREE+=	-kontactinterface
