#include <Windows.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
    HINSTANCE hLib = LoadLibrary( "tutorial.dll" );
    if ( hLib == NULL )
    {
        fprintf( stderr, "tutorial.dll cannot be loaded!\n" );
        return 1;
    }

    int (*tutorial)( int, char ** ) = (int (*)( int, char ** )) GetProcAddress( hLib, "tutorial" ) ;
    if ( tutorial == NULL )
    {
        fprintf( stderr, "tutorial() function not exported in tutorial.dll!\n" );
        return 1;
    }

    return tutorial( argc, argv );
}

