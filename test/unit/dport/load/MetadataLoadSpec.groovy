package dport.load

import grails.plugins.rest.client.RestResponse
import grails.test.mixin.TestFor
import org.junit.Test
import spock.lang.Specification

import java.util.concurrent.atomic.AtomicInteger;

class MetadataLoadSpec extends GroovyTestCase {

    private static final int CORRECT_RESPONSE_SIZE = 36685;

    private static AtomicInteger threadNumber = new AtomicInteger(0);

    private final Collection<ResponseMetrics> RESPONSES = new ArrayList<>();

    private enum RESPONSE_TYPE {
        PASS,NON_200,UNACCOUNTED_FOR,TRUNCATED_RESULT
    }

    private class ResponseMetrics {

        long responseTime = 0;

        RESPONSE_TYPE responseType;

        public ResponseMetrics(RESPONSE_TYPE responseType,long responseTime) {
            this.responseType = responseType;
            if (responseTime < 0) {
                throw new IllegalArgumentException("response time must be >= 0.");
            }
            this.responseTime = responseTime;
        }

    }


    private class MetadataRequestThread implements Runnable {

        @Override
        void run() {
            def rest = new grails.plugins.rest.client.RestBuilder()
            // todo arz replace with environment variable and make it play nice with other config
            long startTime = System.currentTimeMillis();
            def restResponse = rest.get("http://dig-dev.broadinstitute.org:8888/dev/gs/getMetadata");
            long duration = System.currentTimeMillis() - startTime;

            RESPONSES.add(reportResponse(restResponse,duration));
        }
    }

    private ResponseMetrics reportResponse(RestResponse response,long responseTime) {
        if (response == null) {
            return new ResponseMetrics(RESPONSE_TYPE.UNACCOUNTED_FOR,responseTime);
        }
        else {
            if (response.getStatus() == 200 && response.json.toString().length() == CORRECT_RESPONSE_SIZE) {
                return new ResponseMetrics(RESPONSE_TYPE.PASS,responseTime);
            }
            else if (response.getStatus() != 200) {
                return new ResponseMetrics(RESPONSE_TYPE.NON_200,responseTime);
            }
            else if (response.getStatus() == 200 && response.json.toString().length() != CORRECT_RESPONSE_SIZE) {
                return new ResponseMetrics(RESPONSE_TYPE.TRUNCATED_RESULT,responseTime);
            }
        }
        throw new IllegalStateException("Failed to generate metrics for response.");
    }

    void testStuff() {

        for (int numThreads = 1; numThreads < 20; numThreads++) {
            RESPONSES.clear();
            Collection<Thread> threads = new ArrayList<>();
            for (int i = 0; i < numThreads; i++) {
                Thread t = new Thread(new MetadataRequestThread());
                threads.add(t);
            }

            for (Thread t : threads) {
                t.start();
            }

            for (Thread t : threads) {
                t.join();
            }

            println("Clients\tResponseTime")
            for (ResponseMetrics responseMetrics : RESPONSES) {
                println(numThreads + "\t" + responseMetrics.responseTime);
            }

            try {
                Thread.sleep(10 * 1000)
            }
            catch(InterruptedException e) {}
        }

    }
}
