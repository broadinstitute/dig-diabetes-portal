package dport.load

import grails.plugins.rest.client.RestResponse

import java.util.concurrent.atomic.AtomicInteger;

class LoadSpec extends GroovyTestCase {

    private static final int METADATA_RESPONSE_TEXT_SIZE = 36685;

    private static final int DATA_RESPONSE_TEXT_SIZE = 333669;

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

            RESPONSES.add(reportResponse(restResponse, duration, METADATA_RESPONSE_TEXT_SIZE));
        }
    }

    private class GetDataRequestThread implements Runnable {

        private static final String QUERY2 = "{\n" +
                "\"passback\": \"123abc\",\n" +
                "\"entity\": \"variant\",\n" +
                "\"page_number\": 50,\n" +
                "\"page_size\": 100,\n" +
                "\"limit\": 5,\n" +
                "\"count\": true,\n" +
                "\"properties\": {\n" +
                "          \"cproperty\": [\"VAR_ID\", \"CHROM\", \"POS\"],\n" +
                "                  \"orderBy\": [\"CHROM\"],\n" +
                "                  \"dproperty\": {\n" +
                "                \"HETA\" : [\"ExSeq_13k_v1\", \"ExSeq_26k_v2\"],\n" +
                "                \"OBSU\" : [\"ExSeq_26k_v2\", \"ExSeq_13k_v1\"]\n" +
                "                },\n" +
                "                \"pproperty\": {\n" +
                "            \"P_EMMAX_FE_IV\": {\n" +
                "              \"ExSeq_13k_v1\": [\"T2D\"],\n" +
                "              \"ExSeq_26k_v2\": [\"T2D\"]\n" +
                "              },\n" +
                "                \"OR_WALD_DOS_FE_IV\": {\n" +
                "                \"ExSeq_13k_v1\": [\"T2D\"],\n" +
                "                \"ExSeq_26k_v2\": [\"T2D\"]\n" +
                "                }\n" +
                "                }\n" +
                "                },\n" +
                "\"filters\": [ \n" +
                "        {\"dataset_id\": \"blah\", \"phenotype\": \"blah\", \"operand\": \"POS\", \"operator\": \"GTE\", \"value\": 2000, \"operand_type\": \"INTEGER\"},\n" +
                "                {\"dataset_id\": \"ExSeq_26k_v2\", \"phenotype\": \"T2D\", \"operand\": \"P_EMMAX_FE_IV\", \"operator\": \"LTE\", \"value\": 1, \"operand_type\": \"FLOAT\"}\n" +
                "\n" +
                "            ]\n" +
                "}"

        private static final String QUERY1 = "{\n" +
                "\"passback\": \"123abc\",\n" +
                "\"entity\": \"variant\",\n" +
                "\"page_number\": 50,\n" +
                "\"page_size\": 100,\n" +
                "\"limit\": 1000,\n" +
                "\"count\": false,\n" +
                "\"properties\": {\n" +
                "          \"cproperty\": [\"VAR_ID\", \"CHROM\", \"POS\"],\n" +
                "                  \"orderBy\": [\"CHROM\"],\n" +
                "                  \"dproperty\": {\n" +
                "                \"HETA\" : [\"ExSeq_13k_v1\", \"ExSeq_26k_v2\"],\n" +
                "                \"OBSU\" : [\"ExSeq_26k_v2\", \"ExSeq_13k_v1\"]\n" +
                "                },\n" +
                "                \"pproperty\": {\n" +
                "            \"P_EMMAX_FE_IV\": {\n" +
                "              \"ExSeq_13k_v1\": [\"T2D\"],\n" +
                "              \"ExSeq_26k_v2\": [\"T2D\"]\n" +
                "              },\n" +
                "                \"OR_WALD_DOS_FE_IV\": {\n" +
                "                \"ExSeq_13k_v1\": [\"T2D\"],\n" +
                "                \"ExSeq_26k_v2\": [\"T2D\"]\n" +
                "                }\n" +
                "                }\n" +
                "                },\n" +
                "\"filters\": [ \n" +
                "        {\"dataset_id\": \"blah\", \"phenotype\": \"blah\", \"operand\": \"POS\", \"operator\": \"GTE\", \"value\": 195000, \"operand_type\": \"INTEGER\"},\n" +
                "                {\"dataset_id\": \"ExSeq_26k_v2\", \"phenotype\": \"T2D\", \"operand\": \"P_EMMAX_FE_IV\", \"operator\": \"LTE\", \"value\": 1, \"operand_type\": \"FLOAT\"}\n" +
                "\n" +
                "            ]\n" +
                "}"

        @Override
        void run() {
            def rest = new grails.plugins.rest.client.RestBuilder()
            // todo arz replace with environment variable and make it play nice with other config
            long startTime = System.currentTimeMillis();
            def restResponse = rest.post("http://dig-dev.broadinstitute.org:8888/dev/gs/getData") {
                json QUERY1
            }
            long duration = System.currentTimeMillis() - startTime;

            RESPONSES.add(reportResponse(restResponse, duration, DATA_RESPONSE_TEXT_SIZE));
        }
    }

    private ResponseMetrics reportResponse(RestResponse response,long responseTime, int expectedJsonTextSize) {
        if (response == null) {
            return new ResponseMetrics(RESPONSE_TYPE.UNACCOUNTED_FOR,responseTime);
        }
        else {
            if (response.getStatus() == 200 && response.json.toString().length() == expectedJsonTextSize) {
                return new ResponseMetrics(RESPONSE_TYPE.PASS,responseTime);
            }
            else if (response.getStatus() != 200) {
                return new ResponseMetrics(RESPONSE_TYPE.NON_200,responseTime);
            }
            else if (response.getStatus() == 200 && response.json.toString().length() != expectedJsonTextSize) {
                println(response.json.toString().length())
                return new ResponseMetrics(RESPONSE_TYPE.TRUNCATED_RESULT,responseTime);
            }
        }
        throw new IllegalStateException("Failed to generate metrics for response.");
    }

    void testGetData() {

        println("Clients\tResponseTime\tResponseType")
        for (int numThreads = 1; numThreads < 20; numThreads++) {
            RESPONSES.clear();
            Collection<Thread> threads = new ArrayList<>();
            for (int i = 0; i < numThreads; i++) {
                Thread t = new Thread(new GetDataRequestThread());
                threads.add(t);
            }

            for (Thread t : threads) {
                t.start();
            }

            for (Thread t : threads) {
                t.join();
            }

            for (ResponseMetrics responseMetrics : RESPONSES) {
                println(numThreads + "\t" + responseMetrics.responseTime + "\t" + responseMetrics.responseType);
            }

            try {
                Thread.sleep(10 * 1000)
            }
            catch(InterruptedException e) {}
        }

    }

    void testGetMetadata() {

        println("Clients\tResponseTime\tResponseType")
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

            for (ResponseMetrics responseMetrics : RESPONSES) {
                println(numThreads + "\t" + responseMetrics.responseTime + "\t" + responseMetrics.responseType);
            }

            try {
                Thread.sleep(10 * 1000)
            }
            catch(InterruptedException e) {}
        }

    }
}
