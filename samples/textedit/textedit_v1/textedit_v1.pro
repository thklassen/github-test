TEMPLATE        = app
TARGET          = textedit
DESTDIR         = $$PWD

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

CONFIG          += qt warn_on

HEADERS         = textedit.h
SOURCES         = textedit.cpp \
                  main.cpp

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
}

RESOURCES += textedit.qrc
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
