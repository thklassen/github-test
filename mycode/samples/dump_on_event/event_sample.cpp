#include <Windows.h>
#include <iostream>

int main( int argc, char *argv[] )
{
    std::cerr << "\n" ;
    std::cerr << "  dump_on_event COVERAGE\n" ;
    for ( int j = 0; j < 10; j++ )
    {
        for ( int i = 0; i < 30; i++ )
        {
            Sleep( 1000 );
            std::cerr << "." ;
        }
        std::cerr << "\n" ;
    }
    return 0;
}
