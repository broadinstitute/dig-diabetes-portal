package org.broadinstitute.mpg

import groovy.json.JsonSlurper

/***
 * TODO this controller needs to be entirely removed!  Let's do it by stages...
 */
class ResultsFilterController {

    MetadataQueryService metadataQueryService

    def index() {}

    def resultsfilter() {
        render(view:"filtermodal")
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

    private void doStuff() {
        def metadata = new JsonSlurper().parseText(cachedMetadataResult.json.toString());

        Set<String> datasets = new LinkedHashSet<>();
        Set<String> phenotypes = new LinkedHashSet<>();
        Set<String> technologies = new LinkedHashSet<>();
        for (def experiment  : metadata.experiments) {
            technologies.add(experiment.technology);
            parseDatasets(experiment,datasets);
            parsePhenotypes(experiment,phenotypes);
        }
    }

    def metadata() {
        render(status:200, contentType:"application/json") {
            [metadataQueryService.queryMetadata()]
        }
    }
}
