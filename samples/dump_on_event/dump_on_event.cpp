#include <windows.h>
#include <stdio.h>
#include <strsafe.h>
#include <iostream>


void DisplayError( LPTSTR lpszMessage )
{
    // Retrieve the system error message for the last-error code

    LPSTR lpMsgBuf;
    DWORD dw = GetLastError();

    FormatMessageA(
            FORMAT_MESSAGE_ALLOCATE_BUFFER |
            FORMAT_MESSAGE_FROM_SYSTEM |
            FORMAT_MESSAGE_IGNORE_INSERTS,
            NULL,
            dw,
            MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ),
            ( LPSTR ) &lpMsgBuf,
            0, NULL );

    // Display the error message and exit the process
    std::cerr << lpszMessage << " (error " << dw << "): " << lpMsgBuf << '\n';

    LocalFree( lpMsgBuf );
}

int main( int argc, char *argv[] )
{
    if ( argc != 2 )
    {
        std::cerr << "Usage: " <<  argv[0] << " <event_name>" << '\n';
        return 1;
    }

    const char * eventName = argv[1] ;

    HANDLE ghEvent = OpenEventA(
            EVENT_MODIFY_STATE,
            FALSE,
            eventName
            );

    if ( ghEvent == NULL )
    {
        DisplayError( "Opening event failed" );
        return 1;
    }

    if ( ! SetEvent( ghEvent ) )
    {
        DisplayError( "Raising event failed" );
        CloseHandle( ghEvent );
        return 1;
    }

    CloseHandle( ghEvent );
    return 0;
}
