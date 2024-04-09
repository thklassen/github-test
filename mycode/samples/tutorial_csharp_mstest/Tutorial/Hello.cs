using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Tutorial
{
    public class Hello
    {
        static public String Message(String[] args)
        {

            String message = "Hello ";

            if (args.Length == 0)
                message += "World";

            for (int i = 0; i < args.Length; i++)
            {
                if (i == args.Length - 1 && args.Length > 1)
                    message += " and ";
                else if (i > 1)
                    message += ", ";
                message += args[i].ToString();
            }

            return message;
        }
    }
}
