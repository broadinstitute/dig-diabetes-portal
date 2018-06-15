package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import groovy.json.*

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
                    Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSet,
                                                propertyName,MetaDataService.METADATA_VARIANT)
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




    def availableAssayIdsJson() {
        JSONArray jsonReturn;
        ArrayList assayInformation = [
                [assayID: 0, name: "none", quantile: [0,0,0,0,0], selectionOptions: [[value:"none",name:"none", map: 0] ] ],
                [assayID: 1, name: "h3k27ac", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"H3K27ac",name:"h3k27ac", map: 0] ] ],
                [assayID: 2, name: "dnase", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"DNase",name:"dnase", map: 0] ] ],
                [assayID: 3, name: "parker", quantile: [0,0,0,0,0], selectionOptions:
                        [            [value:"1_Active_TSS",name:"Active transcription start site", map: 1],
                                     [value:"2_Weak_TSS",name:"Weak transcription start site", map: 2],
                                     [value:"3_Flanking_TSS",name:"Flanking transcription start site", map:3 ],
                                     [value:"5_Strong_transcription",name:"Strong transcription", map: 5],
                                     [value:"6_Weak_transcription",name:"Weak transcription", map: 6],
                                     [value:"8_Genic_enhancer",name:"Genic enhancer", map: 8],
                                     [value:"9_Active_enhancer_1",name:"Active enhancer 1", map: 9],
                                     [value:"10_Active_enhancer_2",name:"Active enhancer 2", map: 9],
                                     [value:"11_Weak_enhancer",name:"Weak enhancer", map: 11],
                                     [value:"14_Bivalent/poised_TSS",name:"Bivalent/poised transcription start site", map: 4],
                                     [value:"16_Repressed_polycomb",name:"Repressed polycomb", map: 16],
                                     [value:"17_Weak_repressed_polycomb",name:"Weak repressed polycomb", map: 17],
                                     [value:"18_Quiescent/low_signal",name:"Quiescent/low signal", map: 18]] ],
                [assayID: 4, name: "varshney", quantile: [0,0,0,0,0], selectionOptions:
                        [            [value:"1_Active_TSS",name:"Active transcription start site", map: 1],
                                     [value:"2_Weak_TSS",name:"Weak transcription start site", map: 2],
                                     [value:"3_Flanking_TSS",name:"Flanking transcription start site", map:3 ],
                                     [value:"5_Strong_transcription",name:"Strong transcription", map: 5],
                                     [value:"6_Weak_transcription",name:"Weak transcription", map: 6],
                                     [value:"8_Genic_enhancer",name:"Genic enhancer", map: 8],
                                     [value:"9_Active_enhancer_1",name:"Active enhancer 1", map: 9],
                                     [value:"10_Active_enhancer_2",name:"Active enhancer 2", map: 9],
                                     [value:"11_Weak_enhancer",name:"Weak enhancer", map: 11],
                                     [value:"14_Bivalent/poised_TSS",name:"Bivalent/poised transcription start site", map: 4],
                                     [value:"16_Repressed_polycomb",name:"Repressed polycomb", map: 16],
                                     [value:"17_Weak_repressed_polycomb",name:"Weak repressed polycomb", map: 17],
                                     [value:"18_Quiescent/low_signal",name:"Quiescent/low signal", map: 18]] ],
                [assayID: 5, name: "not used", quantile: [9,10,11,12,13], selectionOptions: [[value:"none",name:"none", map: 0]] ]
        ]

        String proposedJsonString = new JsonBuilder( assayInformation ).toPrettyString()
        def slurper = new JsonSlurper()
        jsonReturn =  slurper.parseText(proposedJsonString);

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }





}
