using System;
using System.Collections.Generic;
using System.Text;

namespace Tutorial
{
    class Message
    {
        static public bool Print(String m)
        {
            if (m.Length == 0)
                return false;
            Console.WriteLine(m);
            return true;
        }
    }
}
