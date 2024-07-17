AC_INIT([curl-impersonate], [0.7.1], [kong@yifei.me])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST

AC_PROG_CC
AC_PROG_CXX

AC_CHECK_TOOL([STRIP], [strip])

AC_ARG_VAR([API], [Android API version])
AC_ARG_VAR([NDK], [Android NDK path])
AC_ARG_VAR([TARGET], [Android build target])

AC_ARG_ENABLE([static],
    [AS_HELP_STRING([--enable-static],
        [Build curl-impersonate statically with libcurl-impersonate])],
    [AC_SUBST([static_build], ["$enableval"])],
    [AC_SUBST([static_build], ["no"])])

# Check for Android environment
AC_ARG_WITH([android],
    [AS_HELP_STRING([--with-android], [Build for Android])],
    [build_for_android=$withval],
    [build_for_android=no])

AS_IF(
    # If building for android
    [test x"$build_for_android" = xyes],
    [EXTRA_CMAKE_FLAGS="-DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-${API} -DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake"],
    [EXTRA_CMAKE_FLAGS=""]
)

AC_SUBST(EXTRA_CMAKE_FLAGS)

# Let the user optionally specify the path to zlib.
# This is useful when cross compiling.
# The Makefile will pass on the path to curl's own configure script.
AC_ARG_WITH([zlib],
    [AS_HELP_STRING([--with-zlib=PATH],
        [Search for zlib in PATH. Useful when cross compiling])],
    [with_zlib="$withval"],
    [with_zlib="check"])

AS_IF(
    # User provided --without-zlib, which we don't support
    [test x"$with_zlib" = xno],
    [AC_MSG_ERROR(building without zlib is not supported)],
    # User didn't provide --with-zlib at all, or provided --with-zlib without
    # a path. Check if zlib can be linked against using the default linker flags.
    [test x"$with_zlib" = xcheck -o x"$with_zlib" = xyes],
        [AC_CHECK_LIB([z], [inflateEnd],
            [AC_SUBST([with_zlib], [""])],
            [AC_MSG_ERROR(failed to find zlib)])],
    # User provided --with-zlib with a path.
    [AC_SUBST([with_zlib], ["$with_zlib"])])

# Let the user optionally specify the path to zstd, the same for zlib
AC_ARG_WITH([zstd],
    [AS_HELP_STRING([--with-zstd=PATH],
        [Search for zstd in PATH. Useful when cross compiling])],
    [with_zstd="$withval"],
    [with_zstd="check"])

AS_IF(
    # User provided --without-zstd, which we don't support
    [test x"$with_zstd" = xno],
    [AC_MSG_ERROR(building without zstd is not supported)],
    # User didn't provide --with-zstd at all, or provided --with-zstd without
    # a path. Check if zstd can be linked against using the default linker flags.
    [test x"$with_zstd" = xcheck -o x"$with_zstd" = xyes],
        [AC_CHECK_LIB([zstd], [ZSTD_decompress],
            [AC_SUBST([with_zstd], [""])],
            [AC_MSG_ERROR(failed to find zstd)])],
    # User provided --with-zstd with a path.
    [AC_SUBST([with_zstd], ["$with_zstd"])])

# Path to CA certificates.
# These options will be passed as-is to curl's configure script.
# Useful when cross compiling, since curl's configure script doesn't know
# where to look for these files in that case.
AC_ARG_WITH([ca-bundle],
    [AS_HELP_STRING([--with-ca-bundle=FILE],
        [Path to be passed to curl's --with-ca-bundle configure option. \
         Useful when cross compiling. \
         Relevant only for the Chrome build.])],
    [AC_SUBST([with_ca_bundle], ["$withval"])],
    [AC_SUBST([with_ca_bundle], [""])])
AC_ARG_WITH([ca-path],
    [AS_HELP_STRING([--with-ca-path=DIRECTORY],
        [Path to be passed to curl's --with-ca-path configure option. \
         Useful when cross compiling. \
         Relevant only for the chrome build.])],
    [AC_SUBST([with_ca_path], ["$withval"])],
    [AC_SUBST([with_ca_path], [""])])

# BoringSSL requires cmake 3.5+, which is sometimes available under
# "cmake3" instead of "cmake"
AC_CHECK_PROGS([cmake], [cmake3 cmake])

AC_CHECK_PROGS([ninja], [ninja ninja-build])

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
