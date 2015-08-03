
# check for one particular file of the sources 
AC_INIT([ocaml-portaudio],[0.2.1],[savonet-users@lists.sourceforge.net])

VERSION=$PACKAGE_VERSION
AC_MSG_RESULT([configuring $PACKAGE_STRING])

AC_BASE_CHECKS()

if test "x$CAML_THREADS" = "xyes"; then
  CFLAGS="$CFLAGS -DCAML_THREADS"
fi

REQUIRES="threads"

PKG_PROG_PKG_CONFIG()
PKG_CONFIG_CHECK_MODULE([portaudio-2.0])

# substitutions to perform
AC_SUBST(VERSION)
AC_SUBST(REQUIRES)

# Finally create the Makefile and samples
AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_CONFIG_FILES([src/META])
AC_CONFIG_FILES([src/Makefile])
AC_OUTPUT
