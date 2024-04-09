using Tutorial;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace TestTutorial
{
    
    
    /// <summary>
    ///This is a test class for MessageTest and is intended
    ///to contain all MessageTest Unit Tests
    ///</summary>
    [TestClass()]
    public class MessageTest : Coverage
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
        ///A test for Print
        ///</summary>
        [TestMethod()]
        public void PrintTestNotEmpty()
        {
            string m = "Message";
            bool expected = true;
            bool actual;
            actual = Message.Print(m);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for Print
        ///</summary>
        [TestMethod()]
        public void PrintTestEmpty()
        {
            string m = string.Empty; 
            bool expected = false;
            bool actual;
            actual = Message.Print(m);
            Assert.AreEqual(expected, actual);
        }
    }
}
