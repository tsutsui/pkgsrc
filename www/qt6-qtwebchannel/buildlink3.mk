# $NetBSD: buildlink3.mk,v 1.13 2024/12/26 22:20:19 adam Exp $

BUILDLINK_TREE+=	qt6-qtwebchannel

.if !defined(QT6_QTWEBCHANNEL_BUILDLINK3_MK)
QT6_QTWEBCHANNEL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.qt6-qtwebchannel+=	qt6-qtwebchannel>=6.4.1
BUILDLINK_ABI_DEPENDS.qt6-qtwebchannel+=	qt6-qtwebchannel>=6.8.1
BUILDLINK_PKGSRCDIR.qt6-qtwebchannel?=		../../www/qt6-qtwebchannel

.include "../../lang/qt6-qtdeclarative/buildlink3.mk"
.include "../../x11/qt6-qtbase/buildlink3.mk"
.endif	# QT6_QTWEBCHANNEL_BUILDLINK3_MK

BUILDLINK_TREE+=	-qt6-qtwebchannel
