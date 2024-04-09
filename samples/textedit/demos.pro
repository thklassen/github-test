SUBDIRS = textedit_v1 textedit_v2 textedit_v1_tests
TEMPLATE = subdirs
CONFIG += ordered

QMAKE_EXTRA_TARGETS +=  cscope ctags tag 
tag.depends=cscope ctags

#ctags.target=tags
ctags.commands = ctags $$PWD/*/*.{c,cpp,h} -R $$(QTDIR)/include

#cscope.target=cscope.out
cscope.commands = cscope -b $$PWD/*/*.{c,cpp,h}

