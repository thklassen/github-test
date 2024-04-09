using Tutorial;
using NUnit.Framework;
using System;

namespace TestTutorial
{
    [TestFixture]
    public class HelloTest 
    {
        [Test]
        public void MessageTestEmpty()
        {
            string[] args = new string[0];
            string expected = "Hello World";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        [Test]
        public void MessageTestOneArgument()
        {
            string[] args = new string[] { "John" };
            string expected = "Hello John";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        [Test]
        public void MessageTestTwoArgument()
        {
            string[] args = new string[] { "John", "Joe" };
            string expected = "Hello John and Joe";
            string actual;
            actual = Hello.Message(args);
            Assert.AreEqual(expected, actual);
        }

        [Test]
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
