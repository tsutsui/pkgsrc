# $NetBSD: buildlink3.mk,v 1.9 2025/02/02 13:04:49 pho Exp $

BUILDLINK_TREE+=	hs-hslua-module-zip

.if !defined(HS_HSLUA_MODULE_ZIP_BUILDLINK3_MK)
HS_HSLUA_MODULE_ZIP_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-hslua-module-zip+=	hs-hslua-module-zip>=1.1.3
BUILDLINK_ABI_DEPENDS.hs-hslua-module-zip+=	hs-hslua-module-zip>=1.1.3nb1
BUILDLINK_PKGSRCDIR.hs-hslua-module-zip?=	../../archivers/hs-hslua-module-zip

.include "../../lang/hs-hslua-core/buildlink3.mk"
.include "../../lang/hs-hslua-list/buildlink3.mk"
.include "../../lang/hs-hslua-marshalling/buildlink3.mk"
.include "../../lang/hs-hslua-packaging/buildlink3.mk"
.include "../../lang/hs-hslua-typing/buildlink3.mk"
.include "../../archivers/hs-zip-archive/buildlink3.mk"
.endif	# HS_HSLUA_MODULE_ZIP_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-hslua-module-zip
