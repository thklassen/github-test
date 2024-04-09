CXX           = g++
LINK          = g++
DEFINES       = 
CFLAGS        = -g -D_REENTRANT $(DEFINES)
CXXFLAGS      = -g -D_REENTRANT $(DEFINES)
INCPATH       = -I../../cppunit-1.12.1/include
LFLAGS        = -g 
LIBS          =
DEL_FILE      = rm -f

####### Files

SOURCES       = error.cpp \
		functions.cpp \
		main.cpp \
		parser.cpp \
		variablelist.cpp 
OBJECTS       = error.o \
		functions.o \
		parser.o \
		variablelist.o
TARGET        = parser

UNITTEST_OBJECTS = AdditionalMessage.o Asserter.o BriefTestProgressListener.o CompilerOutputter.o DefaultProtector.o Exception.o Message.o Protector.o ProtectorChain.o RepeatedTest.o SourceLine.o StringTools.o SynchronizedObject.o Test.o TestAssert.o TestCase.o TestCaseDecorator.o TestComposite.o TestDecorator.o TestFactoryRegistry.o TestFailure.o TestLeaf.o TestNamer.o TestPath.o TestResult.o TestResultCollector.o TestRunner.o TestSetUp.o TestSuccessListener.o TestSuite.o TestSuiteBuilderContext.o TextOutputter.o TextTestProgressListener.o TextTestResult.o TextTestRunner.o TypeInfoHelper.o XmlDocument.o XmlElement.o XmlOutputter.o XmlOutputterHook.o

first: all

####### Testing (added)

tests: unittests
	-./unittests

unittests: $(OBJECTS) unittests.o CppUnitListener.o $(UNITTEST_OBJECTS)
	$(LINK) $(LFLAGS) -o $@ $^ 

testclean:
	-@$(DEL_FILE) unittests unittests.o CppUnitListener.o $(UNITTEST_OBJECTS)

####### Implicit rules

.SUFFIXES: .o .cpp

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o $@ $<

####### Build rules

all: $(TARGET)

$(TARGET):  $(OBJECTS) main.o 
	$(LINK) $(LFLAGS) -o $(TARGET) $(OBJECTS) main.o $(OBJCOMP) $(LIBS)

clean: testclean
	-@$(DEL_FILE) $(TARGET) unittests.o
	-@$(DEL_FILE) $(OBJECTS) main.o
	-@$(DEL_FILE) *~ core *.core
	-@$(DEL_FILE) *.o.csmes       # (added)

distclean: clean
	-@$(DEL_FILE) $(TARGET) 
	-@$(DEL_FILE) *.csmes *.csexe # (added)

####### Compile

error.o: error.cpp error.h

functions.o: functions.cpp error.h

main.o: main.cpp parser.h \
		constants.h \
		error.h \
		functions.h \
		variablelist.h

parser.o: parser.cpp parser.h \
		constants.h \
		error.h \
		functions.h \
		variablelist.h

variablelist.o: variablelist.cpp variablelist.h \
		constants.h

$(UNITTEST_OBJECTS): %.o : ../../cppunit-1.12.1/src/cppunit/%.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) $< -o $@ 
