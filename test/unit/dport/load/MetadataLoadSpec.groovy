package dport.load

import grails.test.mixin.TestFor
import org.junit.Test
import spock.lang.Specification;

class MetadataLoadSpec extends GroovyTestCase {


    private class MetadataRequestThread implements Runnable {
        @Override
        void run() {
            def rest = new grails.plugins.rest.client.RestBuilder()
            // todo arz replace with environment variable and make it play nice with other config
            long startTime = System.currentTimeMillis();
            println("Making request...")
            def restResponse = rest.get("http://dig-dev.broadinstitute.org:8888/dev/gs/getMetadata");
            long duration = System.currentTimeMillis() - startTime;
            int size = restResponse.json.toString().length();
            println(duration + " " + restResponse.getStatus() + " size " + size);
        }
    }

    void testStuff() {
        for (int i = 0; i < 10; i++) {
            new Thread(new MetadataRequestThread()).start();
        }

        try {
            Thread.sleep(30 * 1000);
        }
        catch(InterruptedException e) {}
    }
}
