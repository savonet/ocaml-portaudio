
# check for one particular file of the sources 
AC_INIT(ocaml-portaudio, 0.1.3, savonet-users@lists.sourceforge.net)

VERSION=$PACKAGE_VERSION
AC_MSG_RESULT([configuring $PACKAGE_STRING])

# Add prefix to compilation variables
# if passed
if test "x$prefix" != "xNONE"; then
	CFLAGS="$CFLAGS -I$prefix/include"
	LDFLAGS="$LDFLAGS -L$prefix/lib"
	CPPFLAGS="$CPPFLAGS -I$prefix/include"
fi

AC_CHECK_OCAML_COMPILERS()

AC_PROG_CC()
AC_CHECK_TOOL([AR],[ar],no)
AC_SUBST(AR)
PKG_PROG_PKG_CONFIG()
# PKG_CHECK_MODULES loses when you need --libs-only-[lL]
if ! $PKG_CONFIG --exists portaudio-2.0; then
        AC_MSG_ERROR([libportaudio not found])
fi
portaudio_CFLAGS=`$PKG_CONFIG --cflags portaudio-2.0`
AC_SUBST([portaudio_CFLAGS])
portaudio_LIBS=`$PKG_CONFIG --libs-only-l portaudio-2.0`
AC_SUBST([portaudio_LIBS])
portaudio_LDFLAGS=`$PKG_CONFIG --libs-only-L portaudio-2.0`
AC_SUBST([portaudio_LDFLAGS])


# substitutions to perform
AC_SUBST(VERSION)

# Finally create the Makefile and samples
AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_CONFIG_FILES([src/META])
AC_CONFIG_FILES([src/Makefile])
AC_OUTPUT
