package dport

import grails.plugins.rest.client.RestResponse
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class ResultsFilterController {

    SharedToolsService sharedToolsService

    private static final String DATASET_VERSION_FIELD = "restrictDatasetVersionTo";

    def index() {}

    def resultsfilter() {
        render(view:"filtermodal")
    }

    /**
     * Returns the cached metadata object and adds
     * a "restrictedDatasetVersionTo" field so that
     * the client knows how to display the right
     * version of the data.
     */
    def metadata() {
        render(status:200, contentType:"application/json") {
            JSONObject metadata = sharedToolsService.retrieveMetadata();
            metadata.put(DATASET_VERSION_FIELD,sharedToolsService.getDatasetVersion())
            [metadata]
        }
    }

    def dataversion() {
        render(status:200, contentType:"application/json") {
            [sharedToolsService.getDatasetVersion()]
        }
    }
}
