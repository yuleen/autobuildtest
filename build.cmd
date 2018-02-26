qmake AutoBuildTest.pro -o Makefile
mingw32-make -f Makefile clean
mingw32-make -f Makefile release
mingw32-make -f Makefile install