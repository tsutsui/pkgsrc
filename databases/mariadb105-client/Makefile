# $NetBSD: Makefile,v 1.27 2024/12/11 07:55:52 nia Exp $

PKGNAME=	${DISTNAME:S/-/-client-/}
COMMENT=	MariaDB 10.5, a free MySQL compatible database (client)

CONFLICTS=	mysql-client-[0-9]*

.include "Makefile.common"

CMAKE_CONFIGURE_ARGS+=	-DWITHOUT_SERVER=ON
CMAKE_CONFIGURE_ARGS+=	-DWITH_WSREP=OFF

INSTALL_DIRS+=	client include libmariadb man scripts

.include "options.mk"
.include "../../mk/bsd.pkg.mk"
