import org.junit.runner.JUnitCore;

public class TestRunner
{
    public static void main(String[] args)
    {
        JUnitCore runner = new JUnitCore();
        //Adding listener here
        runner.addListener(new CodeCoverageListener());
        runner.run(CppCodeTest.class);
    }
} 
