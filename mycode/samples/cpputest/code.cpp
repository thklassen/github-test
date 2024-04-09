#include "code.h"

int increment( int v )
{
    return v + 1;
}

double invert( double v )
{
    if ( v == 0.0 )
        return 0.0;
    else
        return 1.0 / v ;
}
