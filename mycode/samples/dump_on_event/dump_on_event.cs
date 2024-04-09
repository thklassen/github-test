using System;
using System.Runtime.InteropServices;

// open event with error handling
class DumpOnEvent 
{
    [DllImport("Kernel32.dll", CharSet=CharSet.Ansi)] static extern IntPtr OpenEventA(UInt32 dwDesiredAccess, Boolean bInheritHandle, String lpName);
    [DllImport("kernel32.dll")] static extern bool SetEvent(IntPtr hEvent);
    [DllImport("kernel32.dll", SetLastError=true)]  static extern bool CloseHandle(IntPtr hObject) ;
    const uint EVENT_MODIFY_STATE        = 0x0002 ;
    const long ERROR_FILE_NOT_FOUND        = 2L;

    static int Main( string[] args ) 
    {
        if ( args.Length != 1 )
        {
            Console.Error.WriteLine( "Usage:" );
            Console.Error.WriteLine( "  dump_on_event_cs.exe <event_name>" );
            return 1;
        }
        string name = args[0];
        IntPtr handle= OpenEventA( EVENT_MODIFY_STATE, false, name );
        string errorMsg = new System.ComponentModel.Win32Exception( Marshal.GetLastWin32Error() ).Message;
        if ( handle==IntPtr.Zero ) 
        {
            Console.Error.WriteLine( "OpenEvent - Error: {0}", errorMsg );
            return 1;
        }

        if ( !SetEvent( handle ) )
        {
            Console.Error.WriteLine( "SetEvent - Error: {0}", errorMsg );
            return 1;
        }
        CloseHandle( handle );

        return 0;
    }
}

