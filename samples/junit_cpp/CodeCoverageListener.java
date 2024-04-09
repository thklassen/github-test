import org.junit.runner.Description;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;
import org.junit.runner.notification.RunListener;

public class CodeCoverageListener extends RunListener
{
    private boolean failed = false;
    private boolean noCodeCoverage = false;
    private static String txtToHtml(String s) 
    {
        StringBuilder builder = new StringBuilder();
        boolean previousWasASpace = false;
        for( char c : s.toCharArray() )
        {
            if( c == ' ' )
            {
                if( previousWasASpace )
                {
                    builder.append("&nbsp;");
                    previousWasASpace = false;
                    continue;
                }
                previousWasASpace = true;
            }
            else
                previousWasASpace = false;
            switch(c)
            {
                case '<': builder.append("&lt;"); break;
                case '>': builder.append("&gt;"); break;
                case '&': builder.append("&amp;"); break;
                case '"': builder.append("&quot;"); break;
                case '\n': builder.append("<br>"); break;
                           // We need Tab support here, because we print StackTraces as HTML
                case '\t': builder.append("&nbsp; &nbsp; &nbsp;"); break;  
                default:
                           if( c < 128 )
                               builder.append(c);
                           else 
                               builder.append("&#").append((int)c).append(";");
            }
        }
        return "<html><body>" + builder.toString() + "</body></html>" ;
    }

    /**
     ** Called before any tests have been run.
     */
    public void testRunStarted(Description description) throws java.lang.Exception
    {
        System.out.println("Number of testcases to execute : " + description.testCount());
    }

    /**
     **  Called when all tests have finished
     **/
    public void testRunFinished(Result result) throws java.lang.Exception
    {
        System.out.println("Number of testcases executed : " + result.getRunCount());
        if ( noCodeCoverage )
        {
            System.out.println( "WARNING: no code coverage report generated for each unit test." );
            System.out.println( "WARNING: but for DLL compiled with code coverage support," );
            System.out.println( "WARNING: the code coverage data are produced for the complete suite." );
        }
    }

    /**
     **  Called when an atomic test is about to be started.
     **/
    public void testStarted(Description description) throws java.lang.Exception
    {
        System.out.println("Starting execution of test case : "+ description.getDisplayName());

        try
        {
            // Clear all code coverage informations before executing a unit test
            CppCode.__coveragescanner_clear();
            CppCode.__coveragescanner_clear_html_comment();
            failed = false;
        }
        catch ( java.lang.UnsatisfiedLinkError e )
        {
            // if the code coverage API is not exported, this exception is raised.
            // Ignore it and just inform the user that the code coverage data are not produced.
            noCodeCoverage = true;
        }
    }

    /**
     **  Called when an atomic test has finished, whether the test succeeds or fails.
     **/
    public void testFinished(Description description) throws java.lang.Exception
    {
        System.out.println("Finished execution of test case : "+ description.getDisplayName() );
        try
        {
            // Save the code coverage report
            CppCode.__coveragescanner_testname( "Unit Tests/" + description.getClassName() + "/" + description.getMethodName() );
            if ( failed )
                CppCode.__coveragescanner_teststate( "FAILED" );
            else
                CppCode.__coveragescanner_teststate( "PASSED" );
            CppCode.__coveragescanner_save();
            CppCode.__coveragescanner_testname( "" );
        }
        catch ( java.lang.UnsatisfiedLinkError e )
        {
            // if the code coverage API is not exported, this exception is raised.
            // Ignore it and just inform the user that the code coverage data are not produced.
            noCodeCoverage = true;
        }
    }

    /**
     **  Called when an atomic test fails.
     **/
    public void testFailure(Failure failure) throws java.lang.Exception
    {
        System.out.println("Execution of test case failed : "+ failure.getMessage());
        try
        {
            CppCode.__coveragescanner_add_html_comment( txtToHtml( failure.getMessage() ) );
            failed = true;
        }
        catch ( java.lang.UnsatisfiedLinkError e )
        {
            // if the code coverage API is not exported, this exception is raised.
            // Ignore it and just inform the user that the code coverage data are not produced.
            noCodeCoverage = true;
        }
    }

    /**
     **  Called when a test will not be run, generally because a test method is annotated with Ignore.
     **/
    public void testIgnored(Description description) throws java.lang.Exception
    {
        System.out.println("Execution of test case ignored : "+ description.getMethodName());
    }
}
