# $NetBSD: Makefile,v 1.76 2024/12/27 08:19:19 wiz Exp $

DISTNAME=	mp3info-0.8.5a
PKGNAME=	g${DISTNAME}
PKGREVISION=	44
CATEGORIES=	audio
MASTER_SITES=	ftp://ftp.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/
MASTER_SITES+=	${MASTER_SITE_SUNSITE:=apps/sound/mp3-utils/mp3info/}
EXTRACT_SUFX=	.tgz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://www.ibiblio.org/mp3info/
COMMENT=	Utility to read and modify the ID3 tags of MP3 files
LICENSE=	gnu-gpl-v2

CONFLICTS=	mp3info-[0-9]*

USE_TOOLS+=	pkg-config

INSTALLATION_DIRS=	bin ${PKGMANDIR}/man1

.include "../../mk/curses.buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"

.include "../../mk/bsd.pkg.mk"
