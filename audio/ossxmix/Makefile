# $NetBSD: Makefile,v 1.14 2024/12/27 08:19:22 wiz Exp $

PKGREVISION= 11
.include "../../audio/ossinfo/Makefile.common"

PKGNAME=	ossxmix-${OSS_CMD_VER}
CATEGORIES=	audio

MAINTAINER=	nia@NetBSD.org
COMMENT=	Audio mixer GUI from OSSv4

USE_TOOLS+=	pkg-config

INSTALLATION_DIRS+=	share/applications

install-desktop-file: .PHONY
	${INSTALL_DATA} ${FILESDIR}/ossxmix.desktop \
		${DESTDIR}${PREFIX}/share/applications

do-install: install-desktop-file

.include "../../sysutils/desktop-file-utils/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
