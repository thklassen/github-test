#include <string>

#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/ui/text/TestRunner.h>

#include "parser.h"

#define ASSERT_RESULT(term, result) \
  CPPUNIT_ASSERT_EQUAL(std::string(result), std::string(ps.parse(term)))
#define ASSERT_PARSE(term, result)    ASSERT_RESULT(term, "Ans = " result)
#define ASSERT_PARSE_ERROR(term, msg) ASSERT_RESULT(term, "Error: " msg)

class ParserTest : public CppUnit::TestFixture {

  CPPUNIT_TEST_SUITE(ParserTest);
  CPPUNIT_TEST(testPlus);
  CPPUNIT_TEST(testMinus);
  CPPUNIT_TEST(testMultiply);
  CPPUNIT_TEST(testDivide);
  CPPUNIT_TEST(testPi);
  CPPUNIT_TEST(testVar);
  CPPUNIT_TEST(testNoVar);
  CPPUNIT_TEST(testSyntax);
  CPPUNIT_TEST(testFloat);
  CPPUNIT_TEST(testFloatExp);
  CPPUNIT_TEST(testFloatExpPlus);
  CPPUNIT_TEST(testFloatExpMinus);
  CPPUNIT_TEST(testInt);
  CPPUNIT_TEST(testInvalidNumber);
  CPPUNIT_TEST_SUITE_END();

  Parser ps;

protected:
  void testPlus(void)          { ASSERT_PARSE("2 + 4"  , "6"); }
  void testFloatExp(void)      { ASSERT_PARSE("1.1e1"  , "11"); }
  void testFloatExpPlus(void)  { ASSERT_PARSE("1.1e+1" , "11"); }
  void testFloatExpMinus(void) { ASSERT_PARSE("1.1e-1" , "0.11"); }
  void testFloat(void)         { ASSERT_PARSE("1.1"    , "1.1"); }
  void testInt(void)           { ASSERT_PARSE("1"      , "1"); }
  void testMinus(void)         { ASSERT_PARSE("2 - 4"  , "-2"); }
  void testMultiply(void)      { ASSERT_PARSE("2 * 4"  , "8"); }
  void testDivide(void)        { ASSERT_PARSE("2 / 4"  , "0.5"); }
  void testPi(void)            { ASSERT_PARSE("Pi"     , "3.14159"); }
  void testVar(void) {
    ASSERT_PARSE("xx = 4" , "4");
    ASSERT_PARSE("xx"     , "4");
  }
  void testNoVar(void)         { ASSERT_PARSE_ERROR("xx"    , "Unknown variable xx (col 1)"); }
  void testSyntax(void)        { ASSERT_PARSE_ERROR("\n"    , "Syntax error in part \"\n\" (col 1)"); }
  void testInvalidNumber(void) { ASSERT_PARSE_ERROR("1.1e+" , "Syntax error in part \"1.1e+\" (col 4)"); }
};

CPPUNIT_TEST_SUITE_REGISTRATION(ParserTest);

int main(int, char **)
{
  CppUnit::TextUi::TestRunner runner;
  CppUnit::TestFactoryRegistry &registry = CppUnit::TestFactoryRegistry::getRegistry();

  runner.addTest(registry.makeTest());
  runner.run();
  
  return 0;
}
