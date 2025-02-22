# $NetBSD: Makefile,v 1.44 2025/01/07 19:35:09 riastradh Exp $

.include "dist.mk"

PKGNAME=	python39-${PY_DISTVERSION}
CATEGORIES=	lang python

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://www.python.org/
COMMENT=	Interpreted, interactive, object-oriented programming language
LICENSE=	python-software-foundation

CONFLICTS+=	python-[0-9]*
CONFLICTS+=	py39-cElementTree-[0-9]*
CONFLICTS+=	py39-curses-[0-9]*
CONFLICTS+=	py39-cursespanel-[0-9]*
CONFLICTS+=	py39-expat-[0-9]*
CONFLICTS+=	py39-readline-[0-9]*
CONFLICTS+=	py39-sqlite3-[0-9]*
SUPERSEDES+=	py39-cElementTree-[0-9]*
SUPERSEDES+=	py39-curses-[0-9]*
SUPERSEDES+=	py39-cursespanel-[0-9]*
SUPERSEDES+=	py39-expat-[0-9]*
SUPERSEDES+=	py39-readline-[0-9]*
SUPERSEDES+=	py39-sqlite3-[0-9]*

PLIST_AWK=		-f ${PKGSRCDIR}/lang/python/plist-python.awk
PLIST_AWK_ENV+=		PYVERS=39
PRINT_PLIST_AWK+=	/^[^@]/ && /[^\/]+\.pyc$$/ {
PRINT_PLIST_AWK+=	sub(/__pycache__\//, "")
PRINT_PLIST_AWK+=	sub(/\.cpython-39/, "")}
PRINT_PLIST_AWK+=	/^[^@]/ && /[^\/]+\.opt-1.pyc$$/ {
PRINT_PLIST_AWK+=	sub(/.opt-[12].pyc$$/, ".pyo")}

USE_LANGUAGES=		c c++
USE_TOOLS+=		pkg-config
GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--enable-shared
CONFIGURE_ARGS+=	--with-openssl=${BUILDLINK_PREFIX.openssl}
CONFIGURE_ARGS+=	--with-system-expat
CONFIGURE_ARGS+=	--with-system-ffi
CONFIGURE_ARGS+=	--without-ensurepip
CONFIGURE_ENV+=		OPT=${CFLAGS:M*:Q}
CONFIGURE_ENV+=		ac_cv_path_mkdir=${TOOLS_PATH.mkdir}
PKGCONFIG_OVERRIDE+=	Misc/python.pc.in Misc/python-embed.pc.in

# NetBSD-8 curses has enough support for py-curses
USE_CURSES=		getsyx wide
# But we build as ncurses still to get the full feature set easily
FAKE_NCURSES=		yes

PTHREAD_OPTS+=	require
.include "../../mk/pthread.buildlink3.mk"

.include "../../mk/bsd.prefs.mk"

.if ${USE_CROSS_COMPILE:tl} == "yes"
TOOL_DEPENDS+=		${PKGNAME}:../../${PKGPATH}
CONFIGURE_ARGS+=	\
	PYTHON_FOR_BUILD=${TOOLBASE:Q}/bin/python${PY_VER_SUFFIX}
CONFIGURE_ARGS+=	MACHDEP=${PY_PLATNAME}
CONFIGURE_ARGS+=	ac_sys_system=${OPSYS}
.  if ${OPSYS} == "OSF1"
CONFIGURE_ARGS+=	ac_cv_buggy_getaddrinfo=true
.  else
CONFIGURE_ARGS+=	ac_cv_buggy_getaddrinfo=false
.  endif
CONFIGURE_ARGS.NetBSD+=	ac_cv_file__dev_ptmx=yes
CONFIGURE_ARGS.NetBSD+=	ac_cv_file__dev_ptc=no
ALL_ENV+=		_PYTHON_PROJECT_BASE=${WRKSRC}
ALL_ENV+=		\
	_PYTHON_HOST_PLATFORM=${LOWER_OPSYS}-${MACHINE_GNU_ARCH}
ALL_ENV+=		\
	_PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_${PY_PLATNAME}
.endif

# http://bugs.python.org/issue13241
.if ${MACHINE_PLATFORM:MDarwin-1[12].*}
PKGSRC_COMPILER=	clang
PKG_CC=			clang
PKG_CXX=		clang++
.endif

# Used in socketmodule.c to determine if a sethostname declaration is required
CFLAGS.SunOS+=		-DPKGSRC_OPSYS_VERSION=${OPSYS_VERSION}
LIBS.SunOS+=		-lrt	# fdatasync()
LIBS.SunOS+=		-luuid
.if ${OPSYS} == "SunOS" && ${OPSYS_VERSION} < 051100
SUBST_CLASSES+=		setup
SUBST_MESSAGE.setup=	Replacing crypt with crypt_i
SUBST_STAGE.setup=	pre-configure
SUBST_FILES.setup=	setup.py
SUBST_SED.setup=	-e "s,'crypt','crypt_i',"
.endif

PY_VER_SUFFIX=		3.9

.if ${OPSYS} == "Darwin"
USE_TOOLS+=	gmake
.endif

.include "platname.mk"
PLIST_SUBST+=	PY_PLATNAME=${PY_PLATNAME:Q}

# For Xcode 5 and up, we need to search the SDK path for headers, otherwise
# certain modules will not be built.
.if ${OPSYS} == "Darwin" && exists(${OSX_SDK_PATH:Q}/usr/include)
CFLAGS+=	-I${OSX_SDK_PATH:Q}/usr/include
.endif

PLIST_VARS+=	nis
.for incdir in ${_OPSYS_INCLUDE_DIRS}
.  if (exists(${incdir}/rpc/rpc.h) || exists(${incdir}/tirpc/rpc/rpc.h))
HAVE_RPC_H=	yes
.  endif
.  if (exists(${incdir}/rpcsvc/yp_prot.h) || exists(${incdir}/nsl/rpcsvc/yp_prot.h))
HAVE_YP_PROT_H=	yes
.  endif
.endfor
.if (${HAVE_RPC_H:Uno} == yes && ${HAVE_YP_PROT_H:Uno} == yes)
PLIST.nis=	yes
.endif

PLIST_SUBST+=	PY_VER_SUFFIX=${PY_VER_SUFFIX:Q}

PRINT_PLIST_AWK+=	{ gsub(/${PY_PLATNAME}/, "$${PY_PLATNAME}") }
PRINT_PLIST_AWK+=	{ gsub(/python${PY_VER_SUFFIX}/, \
				"python$${PY_VER_SUFFIX}") }

TEST_TARGET=	test
INSTALL_TARGET=	altinstall

REPLACE_INTERPRETER+=	python
REPLACE.python.old=	.*python[^ ]*
REPLACE.python.new=	${PREFIX}/bin/python${PY_VER_SUFFIX}
REPLACE_FILES.python+=	Lib/base64.py
REPLACE_FILES.python+=	Lib/cProfile.py
REPLACE_FILES.python+=	Lib/cgi.py
REPLACE_FILES.python+=	Lib/encodings/rot_13.py
REPLACE_FILES.python+=	Lib/idlelib/pyshell.py
REPLACE_FILES.python+=	Lib/keyword.py
REPLACE_FILES.python+=	Lib/lib2to3/pgen2/token.py
REPLACE_FILES.python+=	Lib/lib2to3/tests/data/different_encoding.py
REPLACE_FILES.python+=	Lib/lib2to3/tests/data/false_encoding.py
REPLACE_FILES.python+=	Lib/lib2to3/tests/pytree_idempotency.py
REPLACE_FILES.python+=	Lib/pdb.py
REPLACE_FILES.python+=	Lib/platform.py
REPLACE_FILES.python+=	Lib/profile.py
REPLACE_FILES.python+=	Lib/pydoc.py
REPLACE_FILES.python+=	Lib/quopri.py
REPLACE_FILES.python+=	Lib/smtpd.py
REPLACE_FILES.python+=	Lib/smtplib.py
REPLACE_FILES.python+=	Lib/symbol.py
REPLACE_FILES.python+=	Lib/tabnanny.py
REPLACE_FILES.python+=	Lib/tarfile.py
REPLACE_FILES.python+=	Lib/test/bisect_cmd.py
REPLACE_FILES.python+=	Lib/test/crashers/recursive_call.py
REPLACE_FILES.python+=	Lib/test/curses_tests.py
REPLACE_FILES.python+=	Lib/test/re_tests.py
REPLACE_FILES.python+=	Lib/test/regrtest.py
REPLACE_FILES.python+=	Lib/timeit.py
REPLACE_FILES.python+=	Lib/trace.py
REPLACE_FILES.python+=	Lib/turtledemo/__main__.py
REPLACE_FILES.python+=	Lib/turtledemo/bytedesign.py
REPLACE_FILES.python+=	Lib/turtledemo/clock.py
REPLACE_FILES.python+=	Lib/turtledemo/forest.py
REPLACE_FILES.python+=	Lib/turtledemo/fractalcurves.py
REPLACE_FILES.python+=	Lib/turtledemo/lindenmayer.py
REPLACE_FILES.python+=	Lib/turtledemo/minimal_hanoi.py
REPLACE_FILES.python+=	Lib/turtledemo/paint.py
REPLACE_FILES.python+=	Lib/turtledemo/peace.py
REPLACE_FILES.python+=	Lib/turtledemo/penrose.py
REPLACE_FILES.python+=	Lib/turtledemo/planet_and_moon.py
REPLACE_FILES.python+=	Lib/turtledemo/sorting_animate.py
REPLACE_FILES.python+=	Lib/turtledemo/tree.py
REPLACE_FILES.python+=	Lib/turtledemo/yinyang.py
REPLACE_FILES.python+=	Lib/uu.py
REPLACE_FILES.python+=	Lib/webbrowser.py

REPLACE_SH+=		Misc/python-config.sh.in

# XXX: It might be needed to add manually more paths like ${PREFIX}/qt5/lib
# Test: python -c 'from ctypes.util import find_library; print(find_library("ffi"));'
SUBST_CLASSES+=		findlib
SUBST_MESSAGE.findlib=	Fixing find_library().
SUBST_STAGE.findlib=	pre-configure
SUBST_FILES.findlib=	Lib/ctypes/macholib/dyld.py
SUBST_FILES.findlib+=	Lib/ctypes/util.py
SUBST_FILES.findlib+=	Lib/distutils/unixccompiler.py
SUBST_SED.findlib=	-e 's,/usr/local,${PREFIX},'
SUBST_SED.findlib+=	-e "s!\('-Wl,-t'\)!'${COMPILER_RPATH_FLAG}${PREFIX}/lib', '-L${PREFIX}/lib', \1!"
SUBST_NOOP_OK.findlib=	yes

SUBST_CLASSES+=		pkgversion
SUBST_STAGE.pkgversion=	pre-configure
SUBST_FILES.pkgversion=	Lib/lib2to3/pgen2/driver.py
SUBST_VARS.pkgversion=	PKGVERSION_NOREV

.include "options.mk"

CHECK_INTERPRETER_SKIP=		lib/python${PY_VER_SUFFIX}/venv/scripts/posix/pydoc
CHECK_INTERPRETER_SKIP+=	lib/python${PY_VER_SUFFIX}/test/ziptestdata/exe_with_z64
CHECK_INTERPRETER_SKIP+=	lib/python${PY_VER_SUFFIX}/test/ziptestdata/exe_with_zip
CHECK_INTERPRETER_SKIP+=	lib/python${PY_VER_SUFFIX}/test/ziptestdata/header.sh

# contain CONFIGURE_ARGS and CONFIGURE_ENV
CHECK_WRKREF_SKIP+=	lib/python${PY_VER_SUFFIX}/_sysconfigdata*
CHECK_WRKREF_SKIP+=	lib/python${PY_VER_SUFFIX}/__pycache__/_sysconfigdata*
CHECK_WRKREF_SKIP+=	lib/python${PY_VER_SUFFIX}/config-${PY_VER_SUFFIX}/Makefile

# Avoid error: Cannot generate ./Include/opcode.h, python not found !
post-configure:
	touch ${WRKSRC}/Include/opcode.h

.if ${OPSYS} == "HPUX"
post-install: hpux-postinstall
.PHONY: hpux-postinstall
hpux-postinstall:
	${LN} -fs ${DESTDIR}${PREFIX}/lib/libpython3.9.sl \
		${DESTDIR}${PREFIX}/lib/libpython3.9.sl.1.0
.endif

INSTALLATION_DIRS+=	lib/python${PY_VER_SUFFIX}/site-packages

pre-install: setuptools-preinstall
.PHONY: setuptools-preinstall
setuptools-preinstall:
	${INSTALL_DATA} ${.CURDIR}/../../devel/py-setuptools/files/_distutils_system_mod \
		${DESTDIR}${PREFIX}/lib/python${PY_VER_SUFFIX}/site-packages/_distutils_system_mod.py

.include "../../archivers/bzip2/buildlink3.mk"
.include "../../archivers/xz/buildlink3.mk"
.include "../../databases/sqlite3/buildlink3.mk"
.include "../../devel/gettext-lib/buildlink3.mk"
.if ${USE_BUILTIN.gettext:U:tl} == no
CONFIGURE_ENV+=		ac_cv_lib_intl_textdomain=yes
.endif
.include "../../devel/libffi/buildlink3.mk"
.include "../../devel/libuuid/buildlink3.mk"
.include "../../devel/readline/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../mk/bdb.buildlink3.mk"
.include "../../mk/curses.buildlink3.mk"
.include "../../mk/dlopen.buildlink3.mk"
.include "../../mk/oss.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
