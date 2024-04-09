#include "CppUTest/TestHarness.h"
#include "CppUTest/SimpleString.h"
#include "CppUTest/PlatformSpecificFunctions.h"
#include "CppUTest/TestMemoryAllocator.h"
#include "CppUTest/TestRegistry.h"
#include "CppUTest/CommandLineTestRunner.h"
#include "cococpputestplugin.h"
#include "code.h"
#include <math.h>
#ifdef _MSC_VER 
#define isnan _isnan
#endif

int main(int ac, char** av)
{
#ifdef __COVERAGESCANNER__
    __coveragescanner_install(av[0]);
#endif

    TestRegistry* r = TestRegistry::getCurrentRegistry();
    CocoCppUtestPlugin plugin("CocoCppUtestPlugin");
    r->installPlugin(&plugin);
    return CommandLineTestRunner::RunAllTests(ac, av);
}

TEST_GROUP(IncrementGroup)
{
};

TEST(IncrementGroup, IncrementTest)
{
   LONGS_EQUAL( 2, increment( 1 ));
}

TEST_GROUP(InvertGroup)
{
};

TEST(InvertGroup, InvertTest1)
{
   DOUBLES_EQUAL( 1.0 , invert( 1.0 ) , 0.1);
}

TEST(InvertGroup, InvertTest2)
{
   DOUBLES_EQUAL( 0.0 , invert( 0.0 ) , 0.1);
}

