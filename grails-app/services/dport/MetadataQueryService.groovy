package dport

import grails.plugins.rest.client.RestResponse
import org.codehaus.groovy.grails.web.json.JSONElement

/**
 * Manages access to the getMetadata API
 */
class MetadataQueryService {

    private static RestResponse cachedMetadataResult;

    private static long CACHE_QUERY_TIME;

    private static final long CACHE_EXPIRATION_MILLISECONDS = 1000 * 60 * 5;

    /**
     * Queries the metadata API directly and updates
     * CACHE_QUERY_TIME
     */
    private RestResponse queryMetadataDirectly() {
        def rest = new grails.plugins.rest.client.RestBuilder()
        // todo arz replace with environment variable and make it play nice with other config
        def restResponse = rest.get("http://dig-dev.broadinstitute.org:8888/dev/gs/getMetadata")
        CACHE_QUERY_TIME = System.currentTimeMillis();
        return restResponse;
    }

    /**
     * Queries the getMetadata API.  May returned cached
     * data.
     */
    public JSONElement queryMetadata() {
         if (isStale()) {
            cachedMetadataResult = queryMetadataDirectly();
        }

        return cachedMetadataResult.json;
    }

    private boolean isStale() {
        return cachedMetadataResult == null || (System.currentTimeMillis() - CACHE_QUERY_TIME > CACHE_EXPIRATION_MILLISECONDS)
    }
}
