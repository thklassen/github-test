JAVA_HOME="C:\Program Files\Java\jdk1.7.0_45"
JAVA_BIN=$(JAVA_HOME)\bin
JAVAH=$(JAVA_BIN)\javah
JAVAC=$(JAVA_BIN)\javac
JAVA=$(JAVA_BIN)\java

all: each_unit_test

clean:
	-del /Q *.obj *.exp *.dll *.lib *.class CppCode.h *.csexe *.csmes

code.obj: code.cpp code.h
	cscl /nologo /c code.cpp /Focode.obj

code.dll: code.obj CppCode.obj
	cslink --cs-output-abs /NOLOGO /DLL code.obj CppCode.obj /OUT:code.dll

CppCode.h: CppCode.java
	$(JAVAH) CppCode

CppCode.obj: CppCode.h CppCode.cpp
	cscl /nologo /c /I $(JAVA_HOME)\include\win32 /I $(JAVA_HOME)\include CppCode.cpp /FoCppCode.obj

CppCode.class: CppCode.java
	$(JAVAC) CppCode.java

TestRunner.class: TestRunner.java
	$(JAVAC) -cp .;junit-4.11.jar TestRunner.java

CppCodeTest.class: CppCodeTest.java  CodeCoverageListener.class
	$(JAVAC) -cp .;junit-4.11.jar CppCodeTest.java  

CodeCoverageListener.class: CodeCoverageListener.java
	$(JAVAC) -cp .;junit-4.11.jar CodeCoverageListener.java

all_unit_test: CppCodeTest.class CppCode.class code.dll
	-$(JAVA)  -cp .;junit-4.11.jar;hamcrest-core-1.3.jar  org.junit.runner.JUnitCore CppCodeTest
	"$(SQUISHCOCO)\cmcsexeimport.exe" -m code.lib.csmes -t "Unit Tests/Unknown" --delete code.lib.csexe 
	"$(SQUISHCOCO)\cmreport.exe" -m code.lib.csmes -s ".*" --html=code.html --title="JUnit Unit Tests for code.cpp" --bargraph --toc --global=all --method=all --source=all --execution=all 


each_unit_test: CppCodeTest.class TestRunner.class CppCode.class code.dll
	-$(JAVA)  -cp .;junit-4.11.jar;hamcrest-core-1.3.jar  TestRunner
	"$(SQUISHCOCO)\cmcsexeimport.exe" -m code.lib.csmes -t "Unit Tests/Unknown" --delete code.lib.csexe 
	"$(SQUISHCOCO)\cmreport.exe" -m code.lib.csmes -s ".*" --html=code.html --title="JUnit Unit Tests for code.cpp" --bargraph --toc --global=all --method=all --source=all --execution=all 
