TEMPLATE        = app
TARGET          = tst_textedit_v1
DESTDIR         = $$PWD

greaterThan(QT_MAJOR_VERSION, 4): {
  QT     += widgets printsupport testlib
  CONFIG += qt warn_on testlib
}
else: {
  CONFIG += qt warn_on qtestlib
}

HEADERS         = ../textedit_v1/textedit.h \
                  testcoverageobject.h \
                  tst_textedit.h

SOURCES         = ../textedit_v1/textedit.cpp \
                  testcoverageobject.cpp \
                  tst_textedit.cpp

win32: MAINDIR=$$replace(PWD,"/","\\")
win32: MAINDIR=\"$$MAINDIR\"
!win32:MAINDIR=$$PWD

CodeCoverage {
 COVERAGE_OPTIONS =  --cs-count --cs-full-instrumentation
 COVERAGE_OPTIONS += --cs-include-file-abs-wildcard=*textedit_v1*
 COVERAGE_OPTIONS += --cs-include-file-abs-wildcard=*textedit_v2*
 COVERAGE_OPTIONS += --cs-exclude-file-abs-wildcard=*qrc_*

 QMAKE_CFLAGS   += $$COVERAGE_OPTIONS
 QMAKE_CXXFLAGS += $$COVERAGE_OPTIONS
 QMAKE_LFLAGS   += $$COVERAGE_OPTIONS

 QMAKE_CC=cs$$QMAKE_CC
 QMAKE_CXX=cs$$QMAKE_CXX
 QMAKE_LINK=cs$$QMAKE_LINK
 QMAKE_LINK_SHLIB=cs$$QMAKE_LINK_SHLIB
 QMAKE_AR=cs$$QMAKE_AR
 QMAKE_LIB=cs$$QMAKE_LIB

 # Import code coverage report
 unix {
   QMAKE_POST_LINK  = rm $$MAINDIR/tst_textedit_v1.csexe ;
   QMAKE_POST_LINK += $$MAINDIR/./tst_textedit_v1 ;
   QMAKE_POST_LINK += cmcsexeimport -m $$MAINDIR/tst_textedit_v1.csmes -e $$MAINDIR/tst_textedit_v1.csexe -t UnitTest
 }
 win32 {
   QMAKE_POST_LINK  = echo Executing unit tests &
   QMAKE_POST_LINK += $$MAINDIR\\tst_textedit_v1.exe &
   QMAKE_POST_LINK += echo Importing coverage report &
   QMAKE_POST_LINK += cmcsexeimport -m $$MAINDIR\\tst_textedit_v1.exe.csmes -e $$MAINDIR\\tst_textedit_v1.exe.csexe -t UnitTest &
   QMAKE_POST_LINK += del /F $$MAINDIR\\tst_textedit_v1.exe.csexe
 }

 # Merge coverage database into TextEdit database
 unix {
   QMAKE_POST_LINK += ;
   QMAKE_POST_LINK += cmmerge -o $$MAINDIR/../textedit_v1/textedit.tmp -i $$MAINDIR/../textedit_v1/textedit.csmes $$MAINDIR/./tst_textedit_v1.csmes &&
   QMAKE_POST_LINK += rm $$MAINDIR/../textedit_v1/textedit.csmes &&
   QMAKE_POST_LINK += mv $$MAINDIR/../textedit_v1/textedit.tmp $$MAINDIR/../textedit_v1/textedit.csmes
 }
 win32 {
   QMAKE_POST_LINK += &
   QMAKE_POST_LINK += echo Merging unit test result into the main application &
   QMAKE_POST_LINK += cmmerge -o $$MAINDIR\\..\\textedit_v1\\textedit_unit.exe.csmes -i $$MAINDIR\\..\\textedit_v1\\textedit.exe.csmes $$MAINDIR\\tst_textedit_v1.exe.csmes &
   QMAKE_POST_LINK += COPY /Y $$MAINDIR\\..\\textedit_v1\\textedit_unit.exe.csmes $$MAINDIR\\..\\textedit_v1\\textedit.exe.csmes &
   QMAKE_POST_LINK += DEL /F $$MAINDIR\\..\\textedit_v1\\textedit_unit.exe.csmes
 }
}

RESOURCES += ../textedit_v1/textedit.qrc
build_all:!build_pass {
    CONFIG -= build_all
    CONFIG += release
}

# install
target.path = $$[QT_INSTALL_DEMOS]/textedit
sources.files = $$SOURCES $$HEADERS $$RESOURCES *.pro *.html *.doc images
sources.path = $$[QT_INSTALL_DEMOS]/textedit
INSTALLS += target sources

symbian: include($$QT_SOURCE_TREE/demos/symbianpkgrules.pri)
