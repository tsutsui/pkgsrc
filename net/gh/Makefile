# $NetBSD: Makefile,v 1.87 2024/11/25 19:18:07 bsiegert Exp $

# Please also update GH_REL_DATE when upgrading to a new release.

DISTNAME=	gh-2.62.0
CATEGORIES=	net
MASTER_SITES=	${MASTER_SITE_GITHUB:=cli/}
GITHUB_PROJECT=	cli
GITHUB_TAG=	v${PKGVERSION_NOREV}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://cli.github.com/
COMMENT=	GitHub CLI
LICENSE=	mit

DEPENDS+=		git-base-[0-9]*:../../devel/git-base

# Because we are not calling scripts/build as the Makefile for gh would
# do, we do not get these flags set. These flags make the output from
# "gh --version" meaningful.
GH_REL_DATE=		2024-11-14
GO_BUILD_PATTERN+=	-ldflags ' \
			-X github.com/cli/cli/v2/internal/build.Date=${GH_REL_DATE} \
			-X github.com/cli/cli/v2/internal/build.Version=${PKGVERSION_NOREV}'
GO_BUILD_PATTERN+=	./cmd/gh

.include "go-modules.mk"

.include "../../lang/go/go-module.mk"
.include "../../mk/bsd.pkg.mk"
