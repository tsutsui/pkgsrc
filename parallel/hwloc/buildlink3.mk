# $NetBSD: buildlink3.mk,v 1.15 2024/11/14 22:21:21 wiz Exp $

BUILDLINK_TREE+=	hwloc

.if !defined(HWLOC_BUILDLINK3_MK)
HWLOC_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hwloc+=	hwloc>=1.4
BUILDLINK_ABI_DEPENDS.hwloc?=	hwloc>=1.11.13nb12
BUILDLINK_PKGSRCDIR.hwloc?=	../../parallel/hwloc

.include "../../mk/bsd.fast.prefs.mk"
.if ${OPSYS} != "Darwin"
# libpciaccess is marked as broken on Darwin
.include "../../sysutils/libpciaccess/buildlink3.mk"
.endif
.include "../../textproc/libxml2/buildlink3.mk"
.endif	# HWLOC_BUILDLINK3_MK

BUILDLINK_TREE+=	-hwloc
