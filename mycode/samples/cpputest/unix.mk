COCO_SETTINGS=--cs-exclude-file-abs-wildcard=*/unittest.cpp 
EXECUTABLE:=cpputest_sample.exe
CSMES_EXECUTABLE:=$(EXECUTABLE).csmes
CSEXE_EXECUTABLE:=$(EXECUTABLE).csexe
HTML_REPORT:=$(EXECUTABLE).html
OBJECTS:=unittest.o cococpputestplugin.o code.o
LFLAGS:=-lCppUTest -lCppUTestExt $(COCO_SETTINGS)
CXXFLAGS:=-O2 $(COCO_SETTINGS)
CXX:=cs$(CXX)

all: $(HTML_REPORT)

clean:
	-rm -rv $(EXECUTABLE) *.o *.csmes *.csexe $(HTML_REPORT) *_html

# HTML report generation
$(HTML_REPORT): $(CSEXE_EXECUTABLE) 
	# Import the execution report (.csexe file) into the .csmes file
	cmcsexeimport -e $(CSEXE_EXECUTABLE) -m $(CSMES_EXECUTABLE) -t "CppUTests/Unknown" 
	# HTML report generation
	cmreport --title="$(EXECUTABLE)" -m $(CSMES_EXECUTABLE) --select='.*' --bargraph --toc --global=all --method=all --source=all --execution=all --html=$(HTML_REPORT)

# Execute the unit tests, the execution generates the .csexe file
$(CSEXE_EXECUTABLE): $(EXECUTABLE)
	-rm $(CSEXE_EXECUTABLE)
	-./$(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CXX) -o $@  $(OBJECTS) $(LFLAGS)
