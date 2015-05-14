package dport

import grails.plugins.rest.client.RestResponse

class ResultsFilterController {

    private static RestResponse cachedMetadataResult;

    private static long CACHE_QUERY_TIME;

    private static final long CACHE_EXPIRATION_MILLISECONDS = 1000 * 60 * 5;

    def index() {}

    def resultsfilter() {
        render(view:"filtermodal")
    }

    /**
     * Queries the metadata API directly and updates
     * CACHE_QUERY_TIME
     */
    private RestResponse queryMetadata() {
        def rest = new grails.plugins.rest.client.RestBuilder()
        def restResponse = rest.get("http://dig-dev.broadinstitute.org:8888/dev/gs/getMetadata")
        CACHE_QUERY_TIME = System.currentTimeMillis();
        return restResponse;
    }

    def metadata() {
        // todo replace with environment variable, move to service
        if (cachedMetadataResult == null) {
            cachedMetadataResult = queryMetadata();
        }
        else {
            if (System.currentTimeMillis() - CACHE_QUERY_TIME > CACHE_EXPIRATION_MILLISECONDS) {
                cachedMetadataResult = queryMetadata();
            }
        }

        render(status:200, contentType:"application/json") {
            [cachedMetadataResult.json]
        }
    }
}
