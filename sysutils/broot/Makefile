# $NetBSD: Makefile,v 1.111 2025/01/13 20:27:14 pin Exp $

DISTNAME=	broot-1.44.6
CATEGORIES=	sysutils
MASTER_SITES=	${MASTER_SITE_GITHUB:=Canop/}
GITHUB_TAG=	v${PKGVERSION_NOREV}

MAINTAINER=	pin@NetBSD.org
HOMEPAGE=	https://dystroy.org/broot/
COMMENT=	New way to see and navigate directory trees
LICENSE=	mit

.include "cargo-depends.mk"

RUST_REQ=			1.79.0
USE_TOOLS+=			pkg-config
PYTHON_FOR_BUILD_ONLY=		tool

INSTALLATION_DIRS=	${PKGMANDIR}/man1

RUSTFLAGS+=	-C link-arg=${COMPILER_RPATH_FLAG}${BUILDLINK_PREFIX.libxcb}/lib
RUSTFLAGS+=	-C link-arg=-L${BUILDLINK_PREFIX.libxcb}/lib

post-install:
	${INSTALL_MAN} ${WRKSRC}/man/page \
		${DESTDIR}${PREFIX}/${PKGMANDIR}/man1/broot.1

.include "../../lang/rust/cargo.mk"
.include "../../lang/python/batteries-included.mk"
.include "../../lang/python/tool.mk"
.include "../../x11/libxcb/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
