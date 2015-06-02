package dport

import grails.plugins.rest.client.RestResponse
import groovy.json.JsonSlurper

class ResultsFilterController {

    SharedToolsService sharedToolsService

    def index() {}

    def resultsfilter() {
        render(view:"filtermodal")
    }

    def metadata() {
        render(status:200, contentType:"application/json") {
            [sharedToolsService.retrieveMetadata()]
        }
    }

    def dataversion() {
        render(status:200, contentType:"application/json") {
            [sharedToolsService.getDatasetVersion()]
        }
    }
}
