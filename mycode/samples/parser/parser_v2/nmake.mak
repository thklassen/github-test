CXX           = cl.exe
LINK          = cl.exe
DEFINES       = /D _DEBUG
CFLAGS        = $(DEFINES)
CXXFLAGS      = /nologo /EHsc /MDd $(DEFINES)
INCPATH       = /I ..\..\cppunit-1.12.1\include
LFLAGS        = /nologo
LIBS          = 
DEL_FILE      = del

####### Files

SOURCES       = error.cpp \
		functions.cpp \
		main.cpp \
		parser.cpp \
		variablelist.cpp 
OBJECTS       = error.obj \
		functions.obj \
		main.obj \
		parser.obj \
		variablelist.obj

UNITTEST_OBJECTS = CppUnitListener.obj unittests.obj parser.obj error.obj functions.obj variablelist.obj \
                   AdditionalMessage.obj Asserter.obj BeOsDynamicLibraryManager.obj BriefTestProgressListener.obj CompilerOutputter.obj DefaultProtector.obj DllMain.obj DynamicLibraryManager.obj DynamicLibraryManagerException.obj Exception.obj Message.obj PlugInManager.obj PlugInParameters.obj Protector.obj ProtectorChain.obj RepeatedTest.obj ShlDynamicLibraryManager.obj SourceLine.obj StringTools.obj SynchronizedObject.obj Test.obj TestAssert.obj TestCase.obj TestCaseDecorator.obj TestComposite.obj TestDecorator.obj TestFactoryRegistry.obj TestFailure.obj TestLeaf.obj TestNamer.obj TestPath.obj TestPlugInDefaultImpl.obj TestResult.obj TestResultCollector.obj TestRunner.obj TestSetUp.obj TestSuccessListener.obj TestSuite.obj TestSuiteBuilderContext.obj TextOutputter.obj TextTestProgressListener.obj TextTestResult.obj TextTestRunner.obj TypeInfoHelper.obj UnixDynamicLibraryManager.obj Win32DynamicLibraryManager.obj XmlDocument.obj XmlElement.obj XmlOutputter.obj XmlOutputterHook.obj
TARGET        = parser.exe

first: all

####### Testing (added)

tests: unittests.exe
	-unittests.exe

check: $(TARGET) tests

unittests.exe: $(UNITTEST_OBJECTS) $(TARGET)
	$(LINK) $(LFLAGS) $(UNITTEST_OBJECTS) /Feunittests.exe

testclean:
	-$(DEL_FILE) unittests.exe $(UNITTEST_OBJECTS)

####### Implicit rules

.SUFFIXES: .obj .cpp

.cpp.obj:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) "$<"

####### Build rules

all: nmake.mak $(TARGET)

$(TARGET):  $(OBJECTS)  
	$(LINK) $(LFLAGS) $(OBJECTS) $(OBJCOMP) $(LIBS) /Fe$(TARGET)

clean: testclean
	-$(DEL_FILE) $(TARGET)
	-$(DEL_FILE) $(OBJECTS)
	-$(DEL_FILE) *~ core *.core
	-$(DEL_FILE) *.obj.csmes       # (added)

distclean: clean
	-$(DEL_FILE) $(TARGET) 
	-$(DEL_FILE) *.csmes *.csexe # (added)

####### Compile

error.obj: error.cpp error.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) error.cpp

functions.obj: functions.cpp error.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) functions.cpp

main.obj: main.cpp parser.h \
		constants.h \
		error.h \
		functions.h \
		variablelist.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) main.cpp

parser.obj: parser.cpp parser.h \
		constants.h \
		error.h \
		functions.h \
		variablelist.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) parser.cpp

variablelist.obj: variablelist.cpp variablelist.h \
		constants.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) variablelist.cpp

CppUnitListener.obj: CppUnitListener.cpp
	$(CXX) -c --cs-on $(CXXFLAGS) $(INCPATH) CppUnitListener.cpp

AdditionalMessage.obj: ..\..\cppunit-1.12.1\src\cppunit\AdditionalMessage.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\AdditionalMessage.cpp

Asserter.obj: ..\..\cppunit-1.12.1\src\cppunit\Asserter.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Asserter.cpp

BeOsDynamicLibraryManager.obj: ..\..\cppunit-1.12.1\src\cppunit\BeOsDynamicLibraryManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\BeOsDynamicLibraryManager.cpp

BriefTestProgressListener.obj: ..\..\cppunit-1.12.1\src\cppunit\BriefTestProgressListener.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\BriefTestProgressListener.cpp

CompilerOutputter.obj: ..\..\cppunit-1.12.1\src\cppunit\CompilerOutputter.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\CompilerOutputter.cpp

DefaultProtector.obj: ..\..\cppunit-1.12.1\src\cppunit\DefaultProtector.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\DefaultProtector.cpp

DllMain.obj: ..\..\cppunit-1.12.1\src\cppunit\DllMain.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\DllMain.cpp

DynamicLibraryManager.obj: ..\..\cppunit-1.12.1\src\cppunit\DynamicLibraryManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\DynamicLibraryManager.cpp

DynamicLibraryManagerException.obj: ..\..\cppunit-1.12.1\src\cppunit\DynamicLibraryManagerException.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\DynamicLibraryManagerException.cpp

Exception.obj: ..\..\cppunit-1.12.1\src\cppunit\Exception.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Exception.cpp

Message.obj: ..\..\cppunit-1.12.1\src\cppunit\Message.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Message.cpp

PlugInManager.obj: ..\..\cppunit-1.12.1\src\cppunit\PlugInManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\PlugInManager.cpp

PlugInParameters.obj: ..\..\cppunit-1.12.1\src\cppunit\PlugInParameters.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\PlugInParameters.cpp

Protector.obj: ..\..\cppunit-1.12.1\src\cppunit\Protector.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Protector.cpp

ProtectorChain.obj: ..\..\cppunit-1.12.1\src\cppunit\ProtectorChain.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\ProtectorChain.cpp

RepeatedTest.obj: ..\..\cppunit-1.12.1\src\cppunit\RepeatedTest.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\RepeatedTest.cpp

ShlDynamicLibraryManager.obj: ..\..\cppunit-1.12.1\src\cppunit\ShlDynamicLibraryManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\ShlDynamicLibraryManager.cpp

SourceLine.obj: ..\..\cppunit-1.12.1\src\cppunit\SourceLine.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\SourceLine.cpp

StringTools.obj: ..\..\cppunit-1.12.1\src\cppunit\StringTools.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\StringTools.cpp

SynchronizedObject.obj: ..\..\cppunit-1.12.1\src\cppunit\SynchronizedObject.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\SynchronizedObject.cpp

Test.obj: ..\..\cppunit-1.12.1\src\cppunit\Test.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Test.cpp

TestAssert.obj: ..\..\cppunit-1.12.1\src\cppunit\TestAssert.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestAssert.cpp

TestCase.obj: ..\..\cppunit-1.12.1\src\cppunit\TestCase.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestCase.cpp

TestCaseDecorator.obj: ..\..\cppunit-1.12.1\src\cppunit\TestCaseDecorator.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestCaseDecorator.cpp

TestComposite.obj: ..\..\cppunit-1.12.1\src\cppunit\TestComposite.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestComposite.cpp

TestDecorator.obj: ..\..\cppunit-1.12.1\src\cppunit\TestDecorator.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestDecorator.cpp

TestFactoryRegistry.obj: ..\..\cppunit-1.12.1\src\cppunit\TestFactoryRegistry.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestFactoryRegistry.cpp

TestFailure.obj: ..\..\cppunit-1.12.1\src\cppunit\TestFailure.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestFailure.cpp

TestLeaf.obj: ..\..\cppunit-1.12.1\src\cppunit\TestLeaf.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestLeaf.cpp

TestNamer.obj: ..\..\cppunit-1.12.1\src\cppunit\TestNamer.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestNamer.cpp

TestPath.obj: ..\..\cppunit-1.12.1\src\cppunit\TestPath.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestPath.cpp

TestPlugInDefaultImpl.obj: ..\..\cppunit-1.12.1\src\cppunit\TestPlugInDefaultImpl.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestPlugInDefaultImpl.cpp

TestResult.obj: ..\..\cppunit-1.12.1\src\cppunit\TestResult.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestResult.cpp

TestResultCollector.obj: ..\..\cppunit-1.12.1\src\cppunit\TestResultCollector.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestResultCollector.cpp

TestRunner.obj: ..\..\cppunit-1.12.1\src\cppunit\TestRunner.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestRunner.cpp

TestSetUp.obj: ..\..\cppunit-1.12.1\src\cppunit\TestSetUp.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestSetUp.cpp

TestSuccessListener.obj: ..\..\cppunit-1.12.1\src\cppunit\TestSuccessListener.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestSuccessListener.cpp

TestSuite.obj: ..\..\cppunit-1.12.1\src\cppunit\TestSuite.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestSuite.cpp

TestSuiteBuilderContext.obj: ..\..\cppunit-1.12.1\src\cppunit\TestSuiteBuilderContext.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TestSuiteBuilderContext.cpp

TextOutputter.obj: ..\..\cppunit-1.12.1\src\cppunit\TextOutputter.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TextOutputter.cpp

TextTestProgressListener.obj: ..\..\cppunit-1.12.1\src\cppunit\TextTestProgressListener.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TextTestProgressListener.cpp

TextTestResult.obj: ..\..\cppunit-1.12.1\src\cppunit\TextTestResult.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TextTestResult.cpp

TextTestRunner.obj: ..\..\cppunit-1.12.1\src\cppunit\TextTestRunner.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TextTestRunner.cpp

TypeInfoHelper.obj: ..\..\cppunit-1.12.1\src\cppunit\TypeInfoHelper.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\TypeInfoHelper.cpp

UnixDynamicLibraryManager.obj: ..\..\cppunit-1.12.1\src\cppunit\UnixDynamicLibraryManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\UnixDynamicLibraryManager.cpp

Win32DynamicLibraryManager.obj: ..\..\cppunit-1.12.1\src\cppunit\Win32DynamicLibraryManager.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\Win32DynamicLibraryManager.cpp

XmlDocument.obj: ..\..\cppunit-1.12.1\src\cppunit\XmlDocument.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\XmlDocument.cpp

XmlElement.obj: ..\..\cppunit-1.12.1\src\cppunit\XmlElement.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\XmlElement.cpp

XmlOutputter.obj: ..\..\cppunit-1.12.1\src\cppunit\XmlOutputter.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\XmlOutputter.cpp

XmlOutputterHook.obj: ..\..\cppunit-1.12.1\src\cppunit\XmlOutputterHook.cpp
	$(CXX) -c $(CXXFLAGS) $(INCPATH) ..\..\cppunit-1.12.1\src\cppunit\XmlOutputterHook.cpp

