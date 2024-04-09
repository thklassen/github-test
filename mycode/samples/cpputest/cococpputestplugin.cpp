#ifdef __COVERAGESCANNER__
#pragma CoverageScanner( cov-off )
#endif
#include "cococpputestplugin.h"
#include <string>
#include <CppUTest/Utest.h>
#include <CppUTest/TestResult.h>
using namespace std;

CocoCppUtestPlugin::CocoCppUtestPlugin( const SimpleString& name ) : TestPlugin( name )
{
}

void CocoCppUtestPlugin::preTestAction( UtestShell &testshell, TestResult & )
{
#ifdef __COVERAGESCANNER__
    int pos;
    // Adjusting the name of the test to display the tests
    // in a tree view in CoverageBrowser
    std::string testname = "CppUTest/" ;
    testname += testshell.getGroup().asCharString();
    testname += "/";
    testname += testshell.getName().asCharString();

    // Reset the code coverage data to get only the code coverage
    // of the actual unit test.
    __coveragescanner_clear();
    __coveragescanner_testname( testname.c_str() ) ;
#endif
}

void CocoCppUtestPlugin::postTestAction( UtestShell &, TestResult &testresult )
{
#ifdef __COVERAGESCANNER__
    // Recording the execution state in the coverage report
    if ( testresult.getFailureCount() > 0 )
        __coveragescanner_teststate( "FAILED" );
    else
        __coveragescanner_teststate( "PASSED" );

    // Saving the code coverage report of the unit test
    __coveragescanner_save();
    __coveragescanner_testname( "" );
    __coveragescanner_clear();
#endif
}
