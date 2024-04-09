JAVA_HOME:=/usr
JAVA_BIN:=$(JAVA_HOME)/bin
JAVAH:=$(JAVA_BIN)/javah
JAVAC:=$(JAVA_BIN)/javac
JAVA:=$(JAVA_BIN)/java

all: each_unit_test

clean:
	-rm -f *.o lib*.so *.class CppCode.h *.csexe *.csmes

code.o: code.cpp code.h
	csg++ -fPIC -c code.cpp -o code.o

libcode.so: code.o CppCode.o
	csg++ --cs-output-abs -shared code.o CppCode.o -o libcode.so

CppCode.h: CppCode.java
	$(JAVAH) CppCode

CppCode.o: CppCode.cpp CppCode.h
	csg++ -fPIC -c CppCode.cpp -o CppCode.o

CppCode.class: CppCode.java
	$(JAVAC) CppCode.java

CodeCoverageListener.class: CodeCoverageListener.java
	$(JAVAC) -cp .:./junit-4.11.jar CodeCoverageListener.java

CppCodeTest.class: CppCodeTest.java
	$(JAVAC) -cp .:./junit-4.11.jar CppCodeTest.java

TestRunner.class: TestRunner.java  CodeCoverageListener.class
	$(JAVAC) -cp .:./junit-4.11.jar TestRunner.java

all_unit_test: CppCodeTest.class CppCode.class libcode.so
	-$(JAVA)  -cp .:./junit-4.11.jar:./hamcrest-core-1.3.jar org.junit.runner.JUnitCore  CppCodeTest
	cmcsexeimport -m libcode.so.csmes -t "Unit Tests/Unknown" --delete libcode.so.csexe
	cmreport -m libcode.so.csmes -s ".*" --html=code.html --title="JUnit Unit Tests for code.cpp"

each_unit_test: CppCodeTest.class TestRunner.class CppCode.class libcode.so
	-$(JAVA)  -cp .:./junit-4.11.jar:./hamcrest-core-1.3.jar  TestRunner
	cmcsexeimport -m libcode.so.csmes -t "Unit Tests/Unknown" --delete libcode.so.csexe
	cmreport -m libcode.so.csmes -s ".*" --html=code.html --title="JUnit Unit Tests for code.cpp"
