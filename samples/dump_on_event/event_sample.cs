using System;
class Hello 
{
    static void Main() 
    {
        System.Console.WriteLine( "To generate a code coverage report execute:" );
        System.Console.WriteLine( "  dump_on_event COVERAGE" );
        for ( int j = 1; j < 10; j++ )
        {
            for ( int i = 1; i < 30; i++ )
            {
                System.Threading.Thread.Sleep( 1000 );
                System.Console.Write( "." );
            }
            System.Console.WriteLine( "" );
        }

    }
}
