package dport

import grails.plugins.rest.client.RestResponse
import groovy.json.JsonSlurper

class ResultsFilterController {

    MetadataQueryService metadataQueryService

    def index() {}

    def resultsfilter() {
        render(view:"filtermodal")
    }

    def metadata() {
        render(status:200, contentType:"application/json") {
            [metadataQueryService.queryMetadata()]
        }
    }

    def dataversion() {
        render(status:200, contentType:"application/json") {
            ['mdv2']
        }
    }
}
