package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.codehaus.groovy.grails.web.json.JSONObject

class RegionInfoController {
    RestServerService restServerService
    MetaDataService metaDataService
    WidgetService widgetService

    def regionInfo() {
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(params.id)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            List<String> identifiedGenes = restServerService.retrieveGenesInExtents(
                    [chromosomeSpecified:extractedNumbers.chromosomeNumber,
                    beginningExtentSpecified:extractedNumbers.startExtent,
                    endingExtentSpecified:extractedNumbers.endExtent])
            render (view: 'regionInfo', model:[regionDescription:extractedNumbers,
                                               identifiedGenes:identifiedGenes])
            return
        }
        render (view: 'regionInfo', model:[])
    }



    def fillCredibleSetTable() {
        JSONObject jsonReturn;
        String chromosome = params.chromosome; // ex "22"
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String phenotype = params.phenotype;
        String dataSet = params.dataSet
        String dataType = params.datatype
        String propertyName = params.propertyName


        int startInteger;
        int endInteger;

        String errorJsonString = "{\"data\": {}, \"error\": true}";
        def slurper = new JsonSlurper()

        // if have all the information, call the widget service
        try {
            startInteger = Integer.parseInt(startString);
            endInteger = Integer.parseInt(endString);

            if (chromosome != null) {

                if (chromosome.startsWith('chr')) { chromosome = chromosome.substring(3) }

                if ((dataType=='static')&&(dataSet!='')){ // dynamically get the property name for static datasets
                    Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSet,propertyName)
                    propertyName = property.name
                }
                jsonReturn = widgetService.getCredibleOrAlternativeSetInformation(chromosome, startInteger, endInteger, dataSet, phenotype,propertyName);
                jsonReturn["credibleSetInfoCode"] = g.message(code: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode(), default: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode())
            } else {
                jsonReturn = slurper.parse(errorJsonString);
            }

            // log
            log.info("got LZ result: " + jsonReturn);

            // log end
            Date endTime = new Date();

        } catch (NumberFormatException exception) {
            log.error("got incorrect parameters for LZ call: " + params);
            jsonReturn =  slurper.parse(errorJsonString);
        }
        jsonReturn.datasetReadable = g.message(code: "metadata." + jsonReturn.dataset, default: jsonReturn.dataset)
        jsonReturn.phenotypeReadable = g.message(code: "metadata." + jsonReturn.phenotype, default: jsonReturn.phenotype)
        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }



}
