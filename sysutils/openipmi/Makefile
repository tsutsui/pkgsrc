# $NetBSD: Makefile,v 1.8 2024/11/16 12:06:37 wiz Exp $

DISTNAME=	OpenIPMI-2.0.32
PKGNAME=	${DISTNAME:S/OpenIPMI/openipmi/}
PKGREVISION=	4
CATEGORIES=	sysutils
MASTER_SITES=	https://sourceforge.net/projects/openipmi/files/OpenIPMI%202.0%20Library/

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://openipmi.sourceforge.net/
COMMENT=	User-level library that provides a higher-level abstraction of IPMI
LICENSE=	gnu-lgpl-v2

GNU_CONFIGURE=	yes
USE_LIBTOOL=	yes
USE_TOOLS+=	gmake gsed perl pkg-config

PKGCONFIG_OVERRIDE+=	*.pc.in

EGDIR=			${PREFIX}/share/examples/openipmi
EGFILES=		lan.conf ipmisim1.emu

INSTALLATION_DIRS=	share/examples/openipmi

.include "../../mk/bsd.prefs.mk"

.if ${OPSYS} == "NetBSD" || ${OPSYS} == "FreeBSD"
LDFLAGS+=		-lexecinfo
BUILDLINK_TRANSFORM+=	rm:-ldl
.endif

post-install:
.for file in ${EGFILES}
	${MV} ${DESTDIR}${PREFIX}/etc/ipmi/${file} ${DESTDIR}${EGDIR}/${file}
.endfor

.include "options.mk"

.include "../../devel/popt/buildlink3.mk"
.include "../../mk/curses.buildlink3.mk"
.include "../../mk/readline.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
