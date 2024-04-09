using System;
class HelloExe 
{
    static void Main() 
    {
        string[] args = Environment.GetCommandLineArgs(); 
        HelloDll.Message( args );
    }
}
