# $NetBSD: buildlink3.mk,v 1.4 2024/11/14 22:20:48 wiz Exp $

BUILDLINK_TREE+=	kf6-attica

.if !defined(KF6_ATTICA_BUILDLINK3_MK)
KF6_ATTICA_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kf6-attica+=	kf6-attica>=6.2.0
BUILDLINK_ABI_DEPENDS.kf6-attica?=	kf6-attica>=6.2.0nb4
BUILDLINK_PKGSRCDIR.kf6-attica?=	../../misc/kf6-attica

.include "../../x11/qt6-qtbase/buildlink3.mk"
.endif	# KF6_ATTICA_BUILDLINK3_MK

BUILDLINK_TREE+=	-kf6-attica
