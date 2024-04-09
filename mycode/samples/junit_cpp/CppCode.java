import java.io.File;
import java.lang.reflect.Field;

public class CppCode
{
    static 
    { 
        // Set the search path to the current working directory
        String path = new File(".").getAbsolutePath() ;
        System.setProperty("java.library.path", path);

        try
        {
            final Field sysPathsField = ClassLoader.class.getDeclaredField("sys_paths");
            sysPathsField.setAccessible(true);
            sysPathsField.set(null, null);
        }
        catch ( java.lang.NoSuchFieldException e )
        {
        }
        catch (  java.lang.IllegalAccessException e )
        {
        }

        // Load Code.Dll/libcode.so
        System.loadLibrary("code"); 
    } 

    // functions to test
    public static native int increment( int v ) ;
    public static native int division( int a, int b ) ;

    // CoverageScanner API functions
    public static native void  __coveragescanner_clear() ;
    public static native void  __coveragescanner_save() ;
    public static native void  __coveragescanner_filename( String f ) ;
    public static native void  __coveragescanner_testname( String f ) ;
    public static native void  __coveragescanner_teststate( String f ) ;
    public static native void  __coveragescanner_clear_html_comment() ;
    public static native void  __coveragescanner_add_html_comment( String f ) ;
}
