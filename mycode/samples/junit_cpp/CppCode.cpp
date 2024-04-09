#include "code.h"
#include "CppCode.h"

JNIEXPORT jint JNICALL Java_CppCode_increment (JNIEnv *env, jclass thiz, jint v )
{
    return increment( v );
}

JNIEXPORT jint JNICALL Java_CppCode_division (JNIEnv *env, jclass thiz, jint a, jint b )
{
    return division( a, b );
}

#ifdef __COVERAGESCANNER__
// CoverageScanner Wrapper For the DLL
#pragma CoverageScanner( cov-off ) 
JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1clear (JNIEnv *env, jclass thiz)
{
    __coveragescanner_clear();   
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1save (JNIEnv *env, jclass thiz)
{
    __coveragescanner_save();   
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1clear_1html_1comment (JNIEnv *env, jclass thiz)
{
    __coveragescanner_clear_html_comment();   
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1filename ( JNIEnv *env, jclass thiz, jstring s )
{
    const char* str = env->GetStringUTFChars( s, 0 );  
    __coveragescanner_filename( str );   
    env->ReleaseStringUTFChars( s, str );
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1testname (JNIEnv *env, jclass thiz , jstring s ) 
{
    const char* str = env->GetStringUTFChars( s, 0 );  
    __coveragescanner_testname( str );   
    env->ReleaseStringUTFChars( s, str );
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1teststate (JNIEnv *env, jclass thiz , jstring s ) 
{
    const char* str = env->GetStringUTFChars( s, 0 );  
    __coveragescanner_teststate( str );   
    env->ReleaseStringUTFChars( s, str );
}

JNIEXPORT void JNICALL Java_CppCode__1_1coveragescanner_1add_1html_1comment (JNIEnv *env, jclass thiz , jstring s ) 
{
    const char* str = env->GetStringUTFChars( s, 0 );  
    __coveragescanner_add_html_comment( str );   
    env->ReleaseStringUTFChars( s, str );
}
#pragma CoverageScanner( pop ) 
#endif
