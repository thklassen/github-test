#ifndef CODE_H
#define CODE_H

#ifdef _MSC_VER
#define DLLEXPORT __declspec( dllexport ) 
#else
#define DLLEXPORT 
#endif

#ifdef __cplusplus
extern "C" {
#endif

   DLLEXPORT int increment( int );
   DLLEXPORT int division( int a, int b );

#ifdef __cplusplus
}
#endif
#endif
