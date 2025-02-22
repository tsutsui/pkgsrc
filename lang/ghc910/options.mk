# $NetBSD: options.mk,v 1.1 2025/01/29 13:21:52 pho Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.ghc
PKG_SUPPORTED_OPTIONS=	doc
PKG_SUGGESTED_OPTIONS=	doc

.include "../../mk/bsd.prefs.mk"

# GHC has a native implementation of codegen (NCG) for some platforms. On
# those platforms LLVM is optional. It's a requirement anywhere else. See
# compiler/GHC/Driver/Backend.hs
#
# The LLVM backend tends to produce slightly faster code than what NCG
# produces, but it is much slower than NCG. It is therefore not the default
# backend on platforms where NCG is available. On platforms where NCG is
# available, LLVM should be disabled by default because it's a huge
# dependency that takes hours to compile.
#
# Note that bootkits also require LLVM/Clang on platforms lacking NCG. This
# can cause a transitional problem when a new compiler arrives with NCG for
# a platform which used to lack one. In this case we have to either (1)
# build a new bootkit for the platform with LLVM backend disabled, or (2)
# reuse the old bootkit by putting llvm/clang in TOOL_DEPENDS (regardless
# of user choice) and arrange parameters so that they are used only by the
# stage-0 compiler. We don't have an infrastructure for (2), as it's not
# worth the additional complexity, so (1) is the only option atm.

GHC_NCG_SUPPORTED=	aarch64 i386 x86_64 powerpc powerpc64 sparc
.if !empty(GHC_NCG_SUPPORTED:M${MACHINE_ARCH})
PKG_SUPPORTED_OPTIONS+=	llvm
GHC_LLVM_REQUIRED=	no
.else
GHC_LLVM_REQUIRED=	yes
.endif

.if !empty(PKG_SUPPORTED_OPTIONS)
.  include "../../mk/bsd.options.mk"
.endif

###
### LLVM codegen
###
.if !empty(PKG_OPTIONS:Mllvm) || ${GHC_LLVM_REQUIRED} == "yes"
DEPENDS+=		llvm-[0-9]*:../../lang/llvm
CONFIGURE_ARGS.common+=	LLC=${PREFIX:Q}/bin/llc
CONFIGURE_ARGS.common+=	OPT=${PREFIX:Q}/bin/opt

# When we use the LLVM backend, we *have* to use Clang's integrated
# assembler because llc emits assembly source files incompatible with
# Binutils < 2.36 (see https://reviews.llvm.org/D97448). It also requires
# Clang on Darwin (see runClang in compiler/GHC/SysTools/Tasks.hs).
DEPENDS+=		clang-[0-9]*:../../lang/clang
CONFIGURE_ARGS.common+=	CLANG=${PREFIX:Q}/bin/clang
CONFIGURE_ARGS.common+=	CC=${PREFIX:Q}/bin/clang

# Maybe GHC doesn't like this but it's the only option available to us.
LLVM_VERSION_CMD=	${PKG_INFO} -E llvm | ${SED} -E 's/^llvm-([0-9]*)\..*/\1/'
LLVM_MAX_VERSION_CMD=	${EXPR} ${LLVM_VERSION_CMD:sh} + 1
SUBST_CLASSES+=		llvm
SUBST_STAGE.llvm=	post-extract
SUBST_MESSAGE.llvm=	Modifying configure.ac to accept whichever version of LLVM installed via pkgsrc
SUBST_FILES.llvm=	configure.ac
SUBST_SED.llvm=		-e 's/LlvmMaxVersion=[0-9]*/LlvmMaxVersion=${LLVM_MAX_VERSION_CMD:sh}/'

.else
CONFIGURE_ARGS.common+=	LLC=${FALSE:Q}
CONFIGURE_ARGS.common+=	OPT=${FALSE:Q}
CONFIGURE_ARGS.common+=	CLANG=${FALSE:Q}
CONFIGURE_ARGS.common+=	CC=${CC:Q}
.endif

###
### HTML users' guide and man pages, built with Sphinx.
###
### In fact we are very reluctant to rely on Sphinx, but no Sphinx means no
### man pages. You don't like it when you type "man ghc" and it says "no
### entry for ghc" do you? But don't hesitate to turn it off if you find
### GHC stop building because of this.
###
PLIST_VARS+=		doc
.if !empty(PKG_OPTIONS:Mdoc)
TOOL_DEPENDS+=		${PYPKGPREFIX}-sphinx-[0-9]*:../../textproc/py-sphinx
CONFIGURE_ARGS+=	SPHINXBUILD=${PREFIX:Q}/bin/sphinx-build-${PYVERSSUFFIX}
PLIST.doc=		yes
.else
HADRIAN_ARGS+=		--docs=no-sphinx
.endif
# But don't even think of PDF either way. It's absolutely unacceptable for
# GHC to stop building just because of fragility in Sphinx-TeX interaction.
HADRIAN_ARGS+=		--docs=no-sphinx-pdfs
