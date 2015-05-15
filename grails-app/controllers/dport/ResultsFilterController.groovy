package dport

import grails.plugins.rest.client.RestResponse
import groovy.json.JsonSlurper

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

    private void parsePhenotypes(node,Set<String> phenotypes) {
        if (node.phenotypes != null) {
            for (def phenotype  : node.phenotypes) {
                if (phenotype.name != null) {
                    phenotypes.add(phenotype.name)
                }
            }
        }
        for (def sampleGroup: node.sample_groups) {
            parsePhenotypes(sampleGroup,phenotypes)
        }
    }

    private void parseDatasets(node,Set<String> datasets) {
        if (node.sample_groups != null) {
            if (node.sample_groups.id != null) {
                datasets.add(node.sample_groups.id[0])
            }
            if (node.sample_groups.name != null) {
                datasets.add(node.sample_groups.name[0])
            }
            for (def sampleGroup: node.sample_groups) {
                parseDatasets(sampleGroup,datasets)
            }
        }
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

        def metadata = new JsonSlurper().parseText(cachedMetadataResult.json.toString());

        Set<String> datasets = new LinkedHashSet<>();
        Set<String> phenotypes = new LinkedHashSet<>();
        Set<String> technologies = new LinkedHashSet<>();
        for (def experiment  : metadata.experiments) {
            technologies.add(experiment.technology);
            parseDatasets(experiment,datasets);
            parsePhenotypes(experiment,phenotypes);
        }

        // todo arz fixme this is for ui testing
        try {
            Thread.sleep(5000)
        }
        catch(InterruptedException e) {

        }

        render(status:200, contentType:"application/json") {

            [cachedMetadataResult.json]
        }
    }
}
