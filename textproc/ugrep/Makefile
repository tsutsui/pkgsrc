# $NetBSD: Makefile,v 1.95 2025/02/04 09:30:58 adam Exp $

DISTNAME=	ugrep-7.2.2
CATEGORIES=	textproc
MASTER_SITES=	${MASTER_SITE_GITHUB:=Genivia/}
GITHUB_TAG=	v${PKGVERSION_NOREV}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/Genivia/ugrep
COMMENT=	Fast grep with many enhancements including Unicode support
LICENSE=	modified-bsd

.include "options.mk"

USE_LANGUAGES=	c c++
USE_TOOLS+=	bash:run gmake pkg-config
GNU_CONFIGURE=	yes

REPLACE_BASH+=	bin/ug+
REPLACE_BASH+=	bin/ugrep+

.include "../../archivers/bzip2/buildlink3.mk"
.include "../../archivers/lz4/buildlink3.mk"
.include "../../archivers/xz/buildlink3.mk"
.include "../../archivers/zstd/buildlink3.mk"
.include "../../devel/pcre2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
