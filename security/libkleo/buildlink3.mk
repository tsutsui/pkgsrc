# $NetBSD: buildlink3.mk,v 1.10 2024/11/14 22:21:31 wiz Exp $

BUILDLINK_TREE+=	libkleo

.if !defined(LIBKLEO_BUILDLINK3_MK)
LIBKLEO_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libkleo+=	libkleo>=20.04.1
BUILDLINK_ABI_DEPENDS.libkleo?=	libkleo>=23.08.4nb6
BUILDLINK_PKGSRCDIR.libkleo?=	../../security/libkleo

.include "../../devel/kitemmodels/buildlink3.mk"
.include "../../security/qgpgme/buildlink3.mk"
.include "../../textproc/kpimtextedit/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# LIBKLEO_BUILDLINK3_MK

BUILDLINK_TREE+=	-libkleo
