# $NetBSD: buildlink3.mk,v 1.4 2024/11/14 22:21:59 wiz Exp $

BUILDLINK_TREE+=	kf6-kholidays

.if !defined(KF6_KHOLIDAYS_BUILDLINK3_MK)
KF6_KHOLIDAYS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kf6-kholidays+=	kf6-kholidays>=6.2.0
BUILDLINK_ABI_DEPENDS.kf6-kholidays?=	kf6-kholidays>=6.2.0nb4
BUILDLINK_PKGSRCDIR.kf6-kholidays?=	../../time/kf6-kholidays

.include "../../lang/qt6-qtdeclarative/buildlink3.mk"
.include "../../x11/qt6-qtbase/buildlink3.mk"
.endif	# KF6_KHOLIDAYS_BUILDLINK3_MK

BUILDLINK_TREE+=	-kf6-kholidays
