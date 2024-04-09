using Tutorial;
using NUnit.Framework;
using System;

namespace TestTutorial
{
    [TestFixture]
    public class MessageTest 
    {
        [Test]
        public void PrintTestNotEmpty()
        {
            string m = "Message";
            bool expected = true;
            bool actual;
            actual = Message.Print(m);
            Assert.AreEqual(expected, actual);
        }

        [Test]
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
