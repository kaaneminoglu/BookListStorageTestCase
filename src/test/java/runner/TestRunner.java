package runner;

import com.intuit.karate.Runner;
import com.intuit.karate.Results;
import org.junit.jupiter.api.Test;

public class TestRunner {
    @Test
    void testParallel(){
        System.setProperty("karate.env", "dev");
        Results results = Runner.path("classpath:scenario").parallel(1);
    }
}
