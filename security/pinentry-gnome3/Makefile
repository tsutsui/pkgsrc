# $NetBSD: Makefile,v 1.19 2024/12/27 08:20:35 wiz Exp $

PKGNAME=	${DISTNAME:S/pinentry-/pinentry-gnome3-/}
PKGREVISION=	4
COMMENT=	Applications for entering PINs or Passphrases, GNOME 3 enabled

.include "../../security/pinentry/Makefile.common"

USE_TOOLS+=		pkg-config
CONFIGURE_ARGS+=	--disable-libsecret
CONFIGURE_ARGS+=	--disable-pinentry-curses
CONFIGURE_ARGS+=	--disable-pinentry-emacs
CONFIGURE_ARGS+=	--disable-pinentry-efl
CONFIGURE_ARGS+=	--disable-pinentry-fltk
CONFIGURE_ARGS+=	--disable-pinentry-gtk2
CONFIGURE_ARGS+=	--disable-pinentry-qt
CONFIGURE_ARGS+=	--disable-pinentry-qt5
CONFIGURE_ARGS+=	--enable-pinentry-gnome3

INSTALL_DIRS=		gnome3

.include "../../security/gcr/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
