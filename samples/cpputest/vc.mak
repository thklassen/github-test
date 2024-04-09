# Path of CppUTest framework
# Please not that the framekwork is not part of the sample
CPPUTEST_INSTALL=cpputest-3.5

COCO_SETTINGS=--cs-exclude-file-abs-wildcard=*/unittest.cpp --cs-exclude-file-abs-wildcard=*/$(CPPUTEST_INSTALL)/* 
EXECUTABLE=cpputest_sample.exe
CSMES_EXECUTABLE=$(EXECUTABLE).csmes
CSEXE_EXECUTABLE=$(EXECUTABLE).csexe
HTML_REPORT=$(EXECUTABLE).html
OBJECTS=unittest.obj cococpputestplugin.obj code.obj

LFLAGS=-lCppUTest -lCppUTestExt
COMPILER=cscl.exe
LINKER=cslink.exe
COMPILER_FLAGS=/EHsc /I $(CPPUTEST_INSTALL)/include /nologo /Zi /MT $(COCO_SETTINGS)
LINKER_FLAGS=/NOLOGO /DEBUG  $(CPPUTEST_INSTALL)/lib/cpputest.lib $(COCO_SETTINGS)

all: $(HTML_REPORT)

clean:
	-del /Q $(EXECUTABLE) *.obj *.csmes *.csexe $(HTML_REPORT) 

# HTML report generation
$(HTML_REPORT): $(CSEXE_EXECUTABLE) 
	@echo Import the execution report (.csexe file) into the .csmes file
	cmcsexeimport -e $(CSEXE_EXECUTABLE) -m $(CSMES_EXECUTABLE) -t "CppUTests/Unknown" 
	@echo HTML report generation
	cmreport --title="$(EXECUTABLE)" -m $(CSMES_EXECUTABLE) --select=".*" --bargraph --toc --global=all --method=all --source=all --execution=all --html=$(HTML_REPORT)

# Execute the unit tests, the execution generates the .csexe file
$(CSEXE_EXECUTABLE): $(EXECUTABLE)
	-del /Q $(CSEXE_EXECUTABLE)
	-$(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINKER)  /OUT:$@  $(OBJECTS) $(LINKER_FLAGS)

.cpp.obj:
	$(COMPILER) /c $(COMPILER_FLAGS) $? /Fo$@
