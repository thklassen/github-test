using Tutorial;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace TestTutorial
{
    
    
    /// <summary>
    ///This is a test class for HelloTest and is intended
    ///to contain all HelloTest Unit Tests
    ///</summary>
    [TestClass()]
    public class HelloTest : Coverage
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public override TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for Message
        ///</summary>
        [TestMethod()]
        public void MessageTestEmpty()
        {
            string[] args = new string[0];
            string expected = "Hello World";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for Message
        ///</summary>
        [TestMethod()]
        public void MessageTestOneArgument()
        {
            string[] args = new string[] { "John" };
            string expected = "Hello John";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for Message
        ///</summary>
        [TestMethod()]
        public void MessageTestTwoArgument()
        {
            string[] args = new string[] { "John", "Joe" };
            string expected = "Hello John and Joe";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for Message
        ///</summary>
        [TestMethod()]
        public void MessageTestALotOfArgument()
        {
            string[] args = new string[] { "John", "Joe", "Sarah", "Ben" };
            string expected = "Hello John, Joe, Sarah and Ben";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }
    }
}
