# $NetBSD: Makefile,v 1.105 2024/08/06 03:56:10 tnn Exp $

PKGNAME=	pkgdiff-1.12
CATEGORIES=	pkgtools devel

MAINTAINER=	wiz@NetBSD.org
HOMEPAGE=	https://cdn.NetBSD.org/pub/pkgsrc/current/pkgsrc/doc/pkgsrc.html
COMMENT=	Tools to create, maintain, and send back patches for pkgsrc
LICENSE=	2-clause-bsd AND original-bsd

NO_CONFIGURE=	yes

WRKSRC=		${WRKDIR}
USE_LANGUAGES=	# empty
USE_TOOLS+=	diff:run perl:run

MAKE_ENV+=	PKGSRCDIR=${_PKGSRCDIR:Q}

.include "../../mk/bsd.prefs.mk"

BUILD_DEFS+=	MANINSTALL

.if	\
	${OPSYS} == "SunOS" ||	\
	${OPSYS} == "OSF1" ||	\
	${OPSYS} == "Darwin" && empty(OSX_VERSION:M[0-9].*) && empty(OSX_VERSION:M1[0-2].*)
DEPENDS+=	diffutils-[0-9]*:../../devel/diffutils
PKGDIFF_DIFF?=	${PREFIX}/bin/gdiff
.else
PKGDIFF_DIFF?=	${DIFF}
.endif

INSTALLATION_DIRS=	bin
.if !empty(MANINSTALL:Mcatinstall)
INSTALLATION_DIRS+=	${PKGMANDIR}/cat1
.endif
.if !empty(MANINSTALL:Mmaninstall)
INSTALLATION_DIRS+=	${PKGMANDIR}/man1
.endif

PKGDIFF_MAKE?=	${MAKE}

do-build:
.for f in mkpatches patchdiff
	${SED}	-e 's|@PREFIX@|${PREFIX}|g'		\
		-e 's|@PERL5@|${PERL5}|g'		\
		-e 's|@MAKE@|${PKGDIFF_MAKE}|g'		\
		< ${FILESDIR}/${f}.pl			\
		> ${WRKSRC}/${f}
.endfor
	${SED} -e 's|@DIFF@|${PKGDIFF_DIFF}|g'		\
		-e 's|@SH@|${SH}|g'			\
		-e 's|@EGREP@|${EGREP}|g'		\
		< ${FILESDIR}/pkgdiff			\
		> ${WRKSRC}/pkgdiff
	${CP} ${FILESDIR}/pkgvi ${WRKSRC}
	${CP} ${FILESDIR}/feedback-patches ${WRKSRC}
.if !empty(MANINSTALL:Mcatinstall)
.  for f in mkpatches patchdiff pkgdiff pkgvi feedback-patches
	${CP} ${FILESDIR}/${f}.0 ${WRKSRC}/${f}.0
.  endfor
.endif

do-install:
.for f in mkpatches patchdiff pkgdiff pkgvi feedback-patches
	${INSTALL_SCRIPT} ${WRKSRC}/${f} ${DESTDIR}${PREFIX}/bin
.  if !empty(MANINSTALL:Mcatinstall)
.    if defined(CATMAN_SECTION_SUFFIX) && ${CATMAN_SECTION_SUFFIX:U:tl} == yes
	${INSTALL_MAN} ${WRKSRC}/${f}.0 ${DESTDIR}${PREFIX}/${PKGMANDIR}/cat1/${f}.1
.    else
	${INSTALL_MAN} ${WRKSRC}/${f}.0 ${DESTDIR}${PREFIX}/${PKGMANDIR}/cat1
.    endif
.  endif
.  if !empty(MANINSTALL:Mmaninstall)
	${INSTALL_MAN} ${FILESDIR}/${f}.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1
.  endif
.endfor

.include "../../mk/bsd.pkg.mk"
