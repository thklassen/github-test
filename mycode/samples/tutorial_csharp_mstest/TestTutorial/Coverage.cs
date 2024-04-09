using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Reflection;

namespace TestTutorial
{
    [TestClass]
    public abstract class Coverage
    {
        public abstract TestContext TestContext { get; set; }

        static String outputDir = "";

        public static void CoverageCleanup()
        {
            AppDomain MyDomain = AppDomain.CurrentDomain;
            Assembly[] AssembliesLoaded = MyDomain.GetAssemblies();

            foreach (Assembly a in AssembliesLoaded)
            {
                Type coco = a.GetType("CoverageScanner");
                if (coco != null)
                {
                    // clear all coverage information to only get the code coverage of the current executed unit test
                    coco.InvokeMember("__coveragescanner_clear", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                }
            }
        }

        public static void CoverageRecord(TestContext TestContext)
        {
            AppDomain MyDomain = AppDomain.CurrentDomain;
            Assembly[] AssembliesLoaded = MyDomain.GetAssemblies();

            foreach (Assembly a in AssembliesLoaded)
            {
                Type coco = a.GetType("CoverageScanner");
                if (coco != null)
                {
                    String testfile = outputDir + "coverage";
                    String name = "unknown";
                    String state = "";
                    if (TestContext != null)
                    {
                        switch (TestContext.CurrentTestOutcome)
                        {
                            case UnitTestOutcome.Aborted:
                            case UnitTestOutcome.Error:
                            case UnitTestOutcome.Failed:
                            case UnitTestOutcome.Timeout:
                                state = ("FAILED");
                                break;
                            case UnitTestOutcome.Inconclusive:
                            case UnitTestOutcome.InProgress:
                                state = ("CHECK_MANUALLY");
                                break;
                            case UnitTestOutcome.Passed:
                                state = ("PASSED");
                                break;
                            case UnitTestOutcome.Unknown:
                                break;
                        }
                        name = TestContext.FullyQualifiedTestClassName + "." + TestContext.TestName;
                        name = name.Replace('.', '/');

                        testfile = outputDir + TestContext.FullyQualifiedTestClassName;

                    }
                    // set the execution state: PASSES, FAILED or CHECK_MANUALLY
                    coco.InvokeMember("__coveragescanner_teststate", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { state });
                    // Test name: Namespace/Class/Testfunction
                    coco.InvokeMember("__coveragescanner_testname", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { name });

                    // File name is <classname>.csexe 
                    coco.InvokeMember("__coveragescanner_filename", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { testfile });
                    // saves the code coverage data
                    coco.InvokeMember("__coveragescanner_save", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                    // clear all coverage information to only get the code coverage of the current executed unit test
                    coco.InvokeMember("__coveragescanner_clear", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                }
            }
        }

        [TestInitialize()]
        public void TestInitialize()
        {
            CoverageRecord(null);
            CoverageCleanup();
        }

        [TestCleanup()]
        public void TestCleanup()
        {
            CoverageRecord(TestContext);
        }

        [AssemblyInitialize()]
        public static void AssemblyInit(TestContext context)
        {
            outputDir = context.TestDir + "\\..\\";
            CoverageCleanup();
        }

        [AssemblyCleanup()]
        public static void AssemblyCleanup()
        {
            CoverageRecord(null);
        }
    }
}
