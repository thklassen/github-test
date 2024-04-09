using System;
public class HelloDll
{
    public static void Message( string[] args ) 
    {
        String message = "Hello " ;

        if ( args.Length == 1 ) 
            message += "World";

        for ( int i = 1; i < args.Length; i++ )
        {
            if ( i== args.Length - 1 && args.Length > 2 )
                message += " and ";
            else if ( i > 1 )
                message += ", ";
            message += args[ i ].ToString() ;
        }

        System.Console.WriteLine( message );
    }
}
