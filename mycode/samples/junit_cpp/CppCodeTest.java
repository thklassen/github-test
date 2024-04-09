import org.junit.Test;
import static org.junit.Assert.assertEquals;


public class CppCodeTest 
{
    CppCode cppCode = new CppCode() ; // To load the DLL code.dll

    @Test
    public void testIncrement() throws Exception 
    {
        assertEquals( 2, CppCode.increment( 1 ) );
    }

    @Test
    public void testDiv0() throws Exception 
    {
        assertEquals( 1, CppCode.division( 1, 0 ) ); // failure
    }

    @Test
    public void testDiv() throws Exception 
    {
        assertEquals( 2, CppCode.division( 4, 2 ) );
    }
}
