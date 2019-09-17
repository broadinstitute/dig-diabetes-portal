package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import groovy.json.*

class RegionInfoController {
    RestServerService restServerService
    MetaDataService metaDataService
    WidgetService widgetService
    SharedToolsService sharedToolsService

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
        String gene = params.gene;
        String dataSet = params.dataSet
        String dataType = params.datatype
        String propertyName = params.propertyName

        float minimumAllowablePosteriorProbability = -1f
        if (params.minimumAllowablePosteriorProbability){
            minimumAllowablePosteriorProbability = Float.parseFloat(params.minimumAllowablePosteriorProbability)
        }

        int startInteger;
        int endInteger;

        String errorJsonString = "{\"data\": {}, \"error\": true}";
        def slurper = new JsonSlurper()

        // let's allow a user to omit the region information if they include a gene name In that case we can derive a region around the gene
        if ((gene)&&
                (!chromosome)&&
                (!startString)&&
                (!endString)){
            LinkedHashMap geneExtents = sharedToolsService.getGeneExpandedExtent(gene,restServerService.EXPAND_ON_EITHER_SIDE_OF_GENE)
            if (!geneExtents.is_error){
                startInteger = geneExtents.startExtent
                endInteger = geneExtents.endExtent
                chromosome = geneExtents.chrom
            }
        }else {
            try {
                startInteger = Integer.parseInt(startString);
                endInteger = Integer.parseInt(endString);
            } catch (NumberFormatException exception) {
                log.error("got incorrect parameters for fillCredibleSetTable call: " + params);
                jsonReturn =  slurper.parse(errorJsonString);
            }
        }


        if (chromosome != null) {
            // if have all the information, call the widget service
            if (chromosome.startsWith('chr')) { chromosome = chromosome.substring(3) }

            if ((dataType=='static')&&(dataSet!='')){ // dynamically get the property name for static datasets
                Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSet,
                                            propertyName,MetaDataService.METADATA_VARIANT)
                propertyName = property.name
            }
            jsonReturn = widgetService.getCredibleOrAlternativeSetInformation(chromosome, startInteger, endInteger, dataSet, phenotype,propertyName,minimumAllowablePosteriorProbability, false);
            jsonReturn["credibleSetInfoCode"] = g.message(code: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode(), default: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode())
        } else {
            jsonReturn = slurper.parse(errorJsonString);
        }




        jsonReturn.datasetReadable = g.message(code: "metadata." + jsonReturn.dataset, default: jsonReturn.dataset)
        jsonReturn.phenotypeReadable = g.message(code: "metadata." + jsonReturn.phenotype, default: jsonReturn.phenotype)
        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }





    def getVariantsForNearbyCredibleSets() {
        JSONObject jsonReturn;
        String chromosome = params.chromosome; // ex "22"
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String phenotype = params.phenotype;
        String gene = params.gene;
        String propertyName = "POSTERIOR_PROBABILITY"

        float minimumAllowablePosteriorProbability = -1f
        if (params.minimumAllowablePosteriorProbability){
            minimumAllowablePosteriorProbability = Float.parseFloat(params.minimumAllowablePosteriorProbability)
        }

        int startInteger;
        int endInteger;

        String errorJsonString = "{\"data\": {}, \"error\": true}";
        def slurper = new JsonSlurper()

        // let's allow a user to omit the region information if they include a gene name In that case we can derive a region around the gene
        if ((gene)&&
                (!chromosome)&&
                (!startString)&&
                (!endString)){
            LinkedHashMap geneExtents = sharedToolsService.getGeneExpandedExtent(gene,restServerService.EXPAND_ON_EITHER_SIDE_OF_GENE)
            if (!geneExtents.is_error){
                startInteger = geneExtents.startExtent
                endInteger = geneExtents.endExtent
                chromosome = geneExtents.chrom
            }
        }else {
            try {
                startInteger = Integer.parseInt(startString);
                endInteger = Integer.parseInt(endString);
            } catch (NumberFormatException exception) {
                log.error("got incorrect parameters for fillCredibleSetTable call: " + params);
                jsonReturn =  slurper.parse(errorJsonString);
            }
        }


        if (chromosome != null) {
            // if have all the information, call the widget service
            if (chromosome.startsWith('chr')) { chromosome = chromosome.substring(3) }

            List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupsBasedOnPhenotypeAndMeaning(phenotype,propertyName,
                    MetaDataService.METADATA_VARIANT)
            String dataSet
            if (sampleGroupList.size()>0){
                List<SampleGroup> orderedSampleGroupList = sampleGroupList.sort{SampleGroup a,SampleGroup b-> b.subjectsNumber<=>a.subjectsNumber}
                dataSet = orderedSampleGroupList.first().getSystemId()
            }

            jsonReturn = widgetService.getCredibleOrAlternativeSetInformation(chromosome, startInteger, endInteger, dataSet, phenotype,propertyName,minimumAllowablePosteriorProbability, false);
            jsonReturn["credibleSetInfoCode"] = g.message(code: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode(), default: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode())
        } else {
            jsonReturn = slurper.parse(errorJsonString);
        }




        jsonReturn.datasetReadable = g.message(code: "metadata." + jsonReturn.dataset, default: jsonReturn.dataset)
        jsonReturn.phenotypeReadable = g.message(code: "metadata." + jsonReturn.phenotype, default: jsonReturn.phenotype)
        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }












    def fillGeneComparisonTable() {
        JSONObject jsonReturn;
        String chromosome = params.chromosome; // ex "22"
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String phenotype = params.phenotype;
        String dataSet = params.dataSet
        String dataType = params.datatype
        String propertyName = params.propertyName


        Long startLong;
        Long endLong;

        String errorJsonString = "{\"data\": {}, \"error\": true}";
        def slurper = new JsonSlurper()

        // if have all the information, call the widget service
        try {
            startLong = Long.parseLong(startString);
            endLong = Long.parseLong(endString);

            if (chromosome != null) {

                Map mapContainingGeneList = Gene.retrieveListOfGenesInARange( startLong, endLong,  chromosome )
                Map returnInformation = [:]
                if ((mapContainingGeneList!=null)&&
                        (!mapContainingGeneList.is_error)){
                    jsonReturn = new JSONObject()
                    JSONArray supplementedGenes = new JSONArray()
                    for (Map gene in mapContainingGeneList.listOfGenes){
                        String geneJsonObject = new JsonBuilder(gene).toPrettyString()
                        JSONObject jsonForGene =  slurper.parseText(geneJsonObject)
                        if (dataSet!=''){ // dynamically get the property name for static datasets
                            Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSet,
                                    propertyName,MetaDataService.METADATA_VARIANT)
                            propertyName = property.name
                        }
                        jsonForGene["annotations"] = widgetService.getCredibleOrAlternativeSetInformation(  (gene.chromosome-"chr") as String,
                                                                                                            gene.addrStart as int,
                                                                                                            gene.addrEnd  as int,
                                                                                                            dataSet,
                                                                                                            phenotype,
                                                                                                            propertyName,
                                                                                                            -1f, // use the default value for minimumAllowablePosteriorProbability
                                                                                                            true );
                        //jsonForGene["annotations"] = widgetService.buildTheIncredibleSet((gene.chromosome-"chr") as String, gene.addrStart as int, gene.addrEnd  as int, phenotype, 1000 )
                        supplementedGenes.add(jsonForGene)
                    }
                    jsonReturn["phenotype"] = phenotype
                    jsonReturn["propertyName"] = propertyName
                    jsonReturn["dataset"] = dataSet
                    jsonReturn["datasetReadable"] = g.message(code: "metadata." + dataSet, default: dataSet)
                    jsonReturn["numRecords"] = 1000

                    jsonReturn["error"] = false
                    jsonReturn["data"] = supplementedGenes
                    jsonReturn["credibleSetInfoCode"] = g.message(code: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode(), default: restServerService.retrieveBeanForCurrentPortal().getCredibleSetInfoCode())
                }
            } else {
                jsonReturn = slurper.parse(errorJsonString);
            }


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


    def retrieveVariantsWithQtlRelationships(){
        JSONObject jsonReturn
        int startPosition =  0
        int endPosition =  0
        String chromosome = params.chromosome
        String startString = params.startPos
        String endString = params.endPos
        def slurper = new JsonSlurper()
        try{
            startPosition = Integer.parseInt(startString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }
        try{
            endPosition = Integer.parseInt(endString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }


        // We want to get a set of phenotypes to begin with.  Let's gather all of the variance with the strongest associations inside
        //  of the current range, and pull out all of the phenotypes that match those variants
        Map phenotypeViaVariantMap = restServerService.gatherBottomLinePhenotypesVariantsPerRange(chromosome, startPosition, endPosition )

        String proposedJsonString = new JsonBuilder( phenotypeViaVariantMap ).toPrettyString()

        jsonReturn =  slurper.parseText(proposedJsonString)

        render(status: 200, contentType: "application/json") {jsonReturn}
        return

    }






    def calculateGeneRanking() {
        def slurper = new JsonSlurper()
        JSONObject jsonReturn
        String chromosome = params.chromosome; // ex "22"
        String phenotype = params.phenotype
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String maximumAssociationString = params.maximumAssociation; // ex ".0001"
        String minimumWeightString = params.minimumWeight; // ex "1"
        int startPosition =  0
        int endPosition =  0
        float maximumAssociation = 0.0
        float minimumWeight = 0.0
        JSONArray arrayOfPhenotypeCoefficients
        Map phenotypeCoefficientMap = [:]
        List tissueToInclude = []
        boolean validParameters = false
        try{
            arrayOfPhenotypeCoefficients = slurper.parseText(params.phenotypeCoefficients as String)
            tissueToInclude = slurper.parseText(params.tissueToInclude as String)
            validParameters = true
            for(JSONObject jsonObject in arrayOfPhenotypeCoefficients){
                Float numericalCoefficient = 1.0
                try {
                    numericalCoefficient = Float.parseFloat(jsonObject.phenotypeCoefficient)
                    phenotypeCoefficientMap[jsonObject.phenotypeName as String] = numericalCoefficient
                } catch (Exception e){
                    e.printStackTrace()
                }
            }
        } catch ( Exception e ) {
            e.printStackTrace()
        }
        try{
            startPosition = Integer.parseInt(startString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }
        try{
            endPosition = Integer.parseInt(endString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }
        try{
            maximumAssociation = Float.parseFloat(maximumAssociationString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }
        try{
            minimumWeight = Float.parseFloat(minimumWeightString)
        } catch ( Exception e ) {
            e.printStackTrace()
        }


        // We want to get a set of phenotypes to begin with.  Let's gather all of the variance with the strongest associations inside
        //  of the current range, and pull out all of the phenotypes that match those variants
        Map phenotypeViaVariantMap = restServerService.gatherBottomLinePhenotypesVariantsPerRange(chromosome, startPosition, endPosition )

        // now throw out every variant that doesn't reach our P value cut off, and consider whatever's left over to be our list of phenotypes.
        //  Use that same list of variants to come up with a list of genes that we will pay attention to
        Map phenotypesWeightsAndGenes =  widgetService.determinePhenotypeWeightsAndCutOff(phenotypeViaVariantMap, [maximumAssociationValue:maximumAssociation])

        // the first time through we aren't going to have any phenotype coefficients sent up from the browser, but we can derive them.
        //  So let's generate those values, and create a data structure to mimic the one that we would have received from the browser
        if (((arrayOfPhenotypeCoefficients == null)||(arrayOfPhenotypeCoefficients.size() == 0))&& (phenotypesWeightsAndGenes!=null)&& (phenotypesWeightsAndGenes.phenotypePValueMap!=null)){
            arrayOfPhenotypeCoefficients = []
            Map revisedPhenotypePValueMap = [:]
            phenotypesWeightsAndGenes.phenotypePValueMap.each{ k, v ->
                String phenotypeName = "${k}".toString()
                Double phenotypeCoefficient = Double.parseDouble("${v}".toString())
                Double logPhenotypeCoefficient = 0-Math.log10(phenotypeCoefficient)
                revisedPhenotypePValueMap[phenotypeName] = logPhenotypeCoefficient as float
                arrayOfPhenotypeCoefficients << ["phenotypeName":phenotypeName,"phenotypeCoefficient":logPhenotypeCoefficient.toString()]
            }
            phenotypeCoefficientMap = revisedPhenotypePValueMap
        }


        // Now for each phenotype, generate a list of tissues.  We will filter the list of tissues and require that each one have a weight
        //   greater than our threshold cut off
        phenotypesWeightsAndGenes =  widgetService.gatherTheTissuesAssociatedWithEachPhenotype(phenotypesWeightsAndGenes, [maximumAssociationWeight:minimumWeight,
                                                                                                                           phenotype: phenotype
        ])

        // Now for every gene gather the expression data
        Map dataReadyForCalculation =  widgetService.gatherExpressionDataForEachGene( phenotypesWeightsAndGenes, [:] )

        // Now sum across the tree we've built
        Map finalFormData = widgetService.buildFinalDataStructureBeforeTransmission( dataReadyForCalculation, [phenotypeCoefficientMap:phenotypeCoefficientMap,
                                                                                                               restrictTissues:validParameters,
                                                                                                               tissueToInclude:tissueToInclude] )

        List uniqueTissues = finalFormData.genefullCalculatedGraph.collect{it.tissues}.flatten().unique{ tissueRec->tissueRec.tissue }

        List tissuesToConsider = []
        for (def tissueRec in  uniqueTissues){
            String tissueName = tissueRec?.tissue
            String includeIt
            if (validParameters) {
                includeIt = (tissueToInclude.contains(tissueName)) ? "checked" : ""
            } else {
                includeIt = "checked"
            }
            tissuesToConsider << [nameOfTissue:tissueName,isPresent:includeIt]
        }

        // create our final data structure, and send it down to the browser
        finalFormData["maximumAssociation"] = maximumAssociation
        finalFormData["minimumWeight"] = minimumWeight
        finalFormData["phenotype"] = phenotype
        finalFormData["startPosition"] = startPosition
        finalFormData["endPosition"] = endPosition
        finalFormData["uniqueTissues"] = uniqueTissues
        finalFormData["tissuesToConsider"] = tissuesToConsider
        String proposedJsonString = new JsonBuilder( finalFormData ).toPrettyString()

        jsonReturn =  slurper.parseText(proposedJsonString)

        render(status: 200, contentType: "application/json") {jsonReturn}
        return

    }




    def availableAssayIdsJson() {
        JSONObject jsonReturn;
        ArrayList assayInformation = [
                [assayID: 0, name: "none", quantile: [0,0,0,0,0], selectionOptions: [[value:"none",name:"none", map: 0] ] ],
                [assayID: 1, name: "h3k27ac", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"H3K27ac",name:"H3K27ac", map: 0] ] ],
                [assayID: 2, name: "dnase", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"DNase",name:"DNase", map: 0] ] ],
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
                [assayID: 4, name: "ATACSEQ", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"ATAC-Seq peak",name:"ATAC-Seq peak", map: 0] ] ],
                [assayID: 5, name: "TFBS", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"Transcription factor binding sites",name:"Transcription factor binding sites", map: 0] ] ],
                [assayID: 6, name: "ENHANCER", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"Enhancer",name:"Enhancer", map: 0] ] ],
                [assayID: 7, name: "SEGWAY", quantile: [0,0,0,0,0], selectionOptions:
                        [            [value:"CTCF",name:"Active transcription start site", map: 1],
                                     [value:"Coding",name:"Weak transcription start site", map: 2],
                                     [value:"Enhancer",name:"Flanking transcription start site", map:3 ],
                                     [value:"Intron",name:"Strong transcription", map: 5],
                                     [value:"NA",name:"Weak transcription", map: 6],
                                     [value:"Promoter",name:"Genic enhancer", map: 8],
                                     [value:"PromoterFlanking",name:"Active enhancer 1", map: 9],
                                     [value:"Repressed",name:"Active enhancer 2", map: 9],
                                     [value:"TSS",name:"Weak enhancer", map: 11],
                                     [value:"Transcribed",name:"Bivalent/poised transcription start site", map: 4],
                                     [value:"UTR_3",name:"Repressed polycomb", map: 16],
                                     [value:"UTR_5",name:"Weak repressed polycomb", map: 17],
                                     [value:"WeakEnhancer",name:"Quiescent/low signal", map: 18]] ],
                [assayID: 8, name: "CHROMHMM_SEGWAY", quantile: [0,0,0,0,0], selectionOptions:
                        [            [value:"Bivalent",name:"Active transcription start site", map: 1],
                                     [value:"ConstitutiveHet",name:"Weak transcription start site", map: 2],
                                     [value:"Enhancer",name:"Flanking transcription start site", map:3 ],
                                     [value:"FacultativeHet",name:"Strong transcription", map: 5],
                                     [value:"LowConfidence",name:"Weak transcription", map: 6],
                                     [value:"Promoter",name:"Genic enhancer", map: 8],
                                     [value:"Quiescent",name:"Active enhancer 1", map: 9],
                                     [value:"RegPermissive",name:"Active enhancer 2", map: 9],
                                     [value:"Transcribed",name:"Weak enhancer", map: 11]] ],
                [assayID: 9, name: "H3KME1", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"H3KMe1",name:"H3KMe1", map: 0] ] ],
                [assayID: 10, name: "H3KME3", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"H3KMe3",name:"H3KMe3", map: 0] ] ],
                [assayID: 11, name: "H3K9AC", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"H3K9ac",name:"H3K9ac", map: 0] ] ],
                [assayID: 12, name: "SUPER_ENHANCER", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"Super enhancer",name:"Super enhancer", map: 0] ] ],
                [assayID: 13, name: "UCSC annotation", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"UCSC annotation",name:"UCSC annotation", map: 0] ] ],
                [assayID: 14, name: "H3K27AC_QTL", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"H3K27ac QTL",name:"H3K27ac QTL", map: 0] ] ],
                [assayID: 15, name: "DNASE_QTL", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"DNase QTL",name:"DNase QTL", map: 0] ] ],
                [assayID: 16, name: "ATACSeq_QTL", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"ATACSeq_QTL",name:"ATACSeq_QTL", map: 0] ] ],
                [assayID: 17, name: "Enhancer-gene link", quantile: [0,167.9,888.4,2649.9,9213115], selectionOptions: [ [value:"Enhancer-gene link",name:"Enhancer-gene link", map: 0] ] ],
                [assayID: 18, name: "PROMOTER", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"Promoter pred",name:"Promoter pred", map: 0] ] ],
                [assayID: 19, name: "eQTL", quantile: [0,207.8,389.6,1248.1,854238], selectionOptions: [ [value:"eQTL",name:"eQTL", map: 0] ] ]

        ]

        ArrayList tissueInformation = [
                                   [value: 1, name:"Adipose",description:"adipose tissue"],
                                   [value: 2, name:"AnteriorCaudate",description:"brain anterior caudate"],
                                   [value: 3, name:"CD34-PB",description:"CD34-PB primary hematopoietic stem cells"],
                                   [value: 4, name:"CingulateGyrus",description:"brain cingulate gyrus"],
                                   [value: 5, name:"ColonicMucosa",description:"colonic mucosa"],
                                   [value: 6, name:"DuodenumMucosa",description:"duodenum mucosa"],
                                   [value: 7, name:"ES-HUES6",description:"ES-HUES6 embryonic stem cells"],
                                   [value: 8, name:"ES-HUES64",description:"ES-HUES64 embryonic stem cells"],
                                   [value: 9, name:"GM12878",description:"GM12878 lymphoblastoid cells"],
                                   [value: 10, name:"H1",description:"H1 cell line"],
                                   [value: 11, name:"hASC-t1",description:"hASC-t1 adipose stem cells"],
                                   [value: 12, name:"hASC-t2",description:"hASC-t2 adipose stem cells"],
                                   [value: 13, name:"hASC-t3",description:"hASC-t3 adipose stem cells"],
                                   [value: 14, name:"hASC-t4",description:"hASC-t4 adipose stem cells"],
                                   [value: 15, name:"HepG2",description:"HepG2 hepatocellular carcinoma cell line"],
                                   [value: 16, name:"HippocampusMiddle",description:"brain hippocampus middle"],
                                   [value: 17, name:"HMEC",description:"HMEC mammary epithelial primary cells"],
                                   [value: 18, name:"HSMM",description:"HSMM skeletal muscle myoblast cells"],
                                   [value: 19, name:"Huvec",description:"HUVEC umbilical vein endothelial primary cells"],
                                   [value: 20, name:"InferiorTemporalLobe",description:"brain inferior temporal lobe"],
                                   [value: 21, name:"Islets",description:"pancreatic islets"],
                                   [value: 22, name:"K562",description:"K562 leukemia cells"],
                                   [value: 23, name:"Liver",description:"liver"],
                                   [value: 24, name:"MidFrontalLobe",description:"brain mid-frontal lobe"],
                                   [value: 25, name:"NHEK",description:"NHEK epidermal keratinocyte primary cells"],
                                   [value: 26, name:"NHLF",description:"NHLF lung fibroblast primary cells"],
                                   [value: 27, name:"RectalMucosa",description:"rectal mucosa"],
                                   [value: 28, name:"RectalSmoothMuscle",description:"rectal smooth muscle"],
                                   [value: 29, name:"SkeletalMuscle",description:"skeletal muscle"],
                                   [value: 30, name:"StomachSmoothMuscle",description:"stomach smooth muscle"],
                                   [value: 31, name:"SubstantiaNigra",description:"brain substantia nigra"]
                ]
        ArrayList annotationInformation = [
                                    [annotationID: 1, value: 'coding', name: "Coding", description: "coding", type: "BINARY", sort_order: 1, group: "annotation" ],
                                    [annotationID: 2, value: 'spliceSite', name: "Splice site", description: "splice site", type: "BINARY", sort_order: 2, group: "annotation" ],
                                    [annotationID: 3, value: 'utr', name: "UTR", description: "untranslated region", type: "BINARY", sort_order: 3, group: "annotation"  ],
                                    [annotationID: 4, value: 'promoter', name: "Promoter", description: "promoter", type: "BINARY", sort_order: 4, group: "annotation"  ],
                                    //[annotationID: 5, value: 'tfBindingMotif', name: "TF binding motif", description: "TF binding motif", type: "COMPOUND", sort_order: 5, group: "annotation"  ],
                                    [annotationID: 6, value: 'posteriorProbability', name: "Posterior probability", description: "Posterior probability", type: "REAL", sort_order: 6, group: "association" ],
                                    [annotationID: 7, value: 'pValue', name: "P value", description: "P value", type: "REAL", sort_order: 7, group: "association" ]
                ]


        String proposedJsonString = new JsonBuilder( [ assays: assayInformation,
                                                       tissues: tissueInformation,
                                                       annotations: annotationInformation ]).toPrettyString()
        def slurper = new JsonSlurper()
        jsonReturn =  slurper.parseText(proposedJsonString);

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }



    def retrieveListOfGenesInARange() {
        Long startPos = 0L
        Long endPos = 0L
        String chromosome = ""
        boolean looksOkay = true

        if (params.startPos) {
            try {
                startPos = Double.parseDouble(params.startPos).longValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveListOfGenesInARange:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPos = Double.parseDouble(params.endPos).longValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveListOfGenesInARange:failed to convert endPos value=${params.startPos}")
            }
        }
        if (!params.chromosome) {
            looksOkay = false
        } else {
            chromosome = params.chromosome
        }

        Map geneSearchResults

        if (looksOkay){
            geneSearchResults = Gene.retrieveListOfGenesInARange( startPos,  endPos, chromosome)
        } else {
            geneSearchResults = [is_error: true, error_message: "calling parameter problem"]
        }


        String proposedJsonString = new JsonBuilder( geneSearchResults ).toPrettyString()
        def slurper = new JsonSlurper()
        JSONObject jsonReturn =  slurper.parseText(proposedJsonString);

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }




    def retrieveEqtlData() {
        String gene = ""
        String tissue = ""
        String variant = ""
        boolean looksOkay = true
        JSONArray jsonReturn

        if (params.gene) {
            gene = params.gene
        }

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variant) {
            variant = params.variant
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherEqtlData( gene,  variant, tissue)
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            def slurper = new JsonSlurper()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }



    def retrieveEqtlDataWithVariants() {
        String gene = ""
        String tissue = ""
        boolean looksOkay = true
        JSONArray jsonReturn
        JSONArray variants
        List <String> variantList = []
        def slurper = new JsonSlurper()

        if (params.gene) {
            gene = params.gene
        }

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variants) {
            variants = slurper.parseText( params.variants as String)  as JSONArray
            variantList = variants as List <String>
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherEqtlDataForVariantList( gene,  variantList, tissue)
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()

            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }




    def retrieveAbcData() {
        String gene = ""
        String tissue = ""
        int startPosition = -1
        int endPosition = -1
        String chromosome = ""
        boolean looksOkay = true
        JSONArray jsonReturn
        JSONArray variants
        List <String> variantList = []
        def slurper = new JsonSlurper()

        if (params.gene) {
            gene = params.gene
        }

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert endPos value=${params.startPos}")
            }
        }

        if (params.variants) {
            variants = slurper.parseText( params.variants as String)  as JSONArray
            variantList = variants as List <String>
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherAbcData( gene, tissue, startPosition, endPosition, chromosome, variantList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }






    def retrieveDepictData() {
        String gene = ""
        String phenotype = ""
        int startPosition = -1
        int endPosition = -1
        String chromosome = ""
        boolean looksOkay = true
        JSONArray jsonArray
        def slurper = new JsonSlurper()

        if (params.gene) {
            gene = params.gene
        }

        if (params.phenotype) {
            phenotype = params.phenotype
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert endPos value=${params.startPos}")
            }
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        }

        if (looksOkay){
            jsonArray = restServerService.gatherDepictData( gene, phenotype, startPosition, endPosition, chromosome )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonArray =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonArray}
        return
    }




    def retrieveDepictTissues() {
        String phenotype = ""
        boolean looksOkay = true
        JSONArray jsonArray
        def slurper = new JsonSlurper()

        if (params.phenotype) {
            phenotype = params.phenotype  ?: restServerService.retrieveBeanForCurrentPortal().phenotype
        }

        if (looksOkay){
            jsonArray = restServerService.gatherDepictTissues(  phenotype )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonArray =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonArray}
        return
    }






    def retrieveGregorData() {
        String phenotype = ""
        boolean looksOkay = true
        JSONObject jsonObject
        def slurper = new JsonSlurper()

        if (params.phenotype) {
            phenotype = params.phenotype
        } else {
            looksOkay = falls
        }

        if (looksOkay){
            jsonObject = restServerService.gatherGregorData(  phenotype )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonObject =  slurper.parseText(proposedJsonString) as JSONObject;
        }

        render(status: 200, contentType: "application/json") {jsonObject}
        return
    }





    def retrieveLdsrData() {
        String phenotype = ""
        boolean looksOkay = true
        JSONObject jsonObject
        def slurper = new JsonSlurper()

        if (params.phenotype) {
            phenotype = params.phenotype
        } else {
            looksOkay = falls
        }

        if (looksOkay){
            jsonObject = restServerService.gatherLdsrData(  phenotype )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonObject =  slurper.parseText(proposedJsonString) as JSONObject;
        }

        render(status: 200, contentType: "application/json") {jsonObject}
        return
    }







    def retrieveDepictGeneSetData() {
        String gene = ""
        String phenotype = ""
        float pValueThreshold = 0.0005
        boolean looksOkay = true
        JSONObject jsonReturn
        def slurper = new JsonSlurper()

        if (params.gene) {
            gene = params.gene
        }

        if (params.phenotype) {
            phenotype = params.phenotype
        }

        if (params.pValueThreshold) {
            try {
                pValueThreshold = Double.parseDouble(params.pValueThreshold).toFloat()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert pValueThreshold value=${params.pValueThreshold}")
            }
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherDepictGeneSetData( gene, phenotype, pValueThreshold )
            jsonReturn["gene"]=gene
        } else {
            String proposedJsonString = new JsonBuilder( "{is_error: true, error_message: \"calling parameter problem\"}" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString)
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }






    def retrieveVariantsInRange() {
        String phenotype = ""
        int startPosition = -1
        int endPosition = -1
        int limit = -1
        String chromosome = ""
        boolean looksOkay = true
        JSONObject jsonReturn
        Map geneNameMap = [:]

        if (params.phenotype) {
            phenotype = params.phenotype
        } else {
            looksOkay = false
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveVariantsInRange:failed to convert startPos value=${params.startPos}")
            }
        } else {
            looksOkay = false
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveVariantsInRange:failed to convert endPos value=${params.endPos}")
            }
        } else {
            looksOkay = false
        }

        if (params.limit) {
            try {
                limit = Double.parseDouble(params.limit).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveVariantsInRange:failed to convert limit value=${params.limit}")
            }
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        } else {
            looksOkay = false
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherVariantsInRange( phenotype, chromosome, startPosition, endPosition, limit)
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            def slurper = new JsonSlurper()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONObject;
        }

//        JSONArray jsonArray = new JSONArray()
//        for (JSONObject jsonObject in jsonReturn) {
//            jsonObject.put("common_name", geneNameMap[jsonObject.gene] ?: jsonObject.gene)
//            jsonObject.put("tissue_trans",g.message(code: "metadata.${jsonObject.tissue}", default: jsonObject.tissue))
//            jsonArray.put(jsonObject)
//        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }

    /***
     * This is a special case of retrieveECaviarData. Here we want to first issue a region-based call to
     * get every variant associated with a phenotype in a range. From this list we will extract the credible sets
     * that are referenced, and then execute a second call to pull back every variant in each of these credible sets.
     * @return
     */
    def retrieveECaviarDataViaCredibleSets() {
        String phenotype = ""
        int startPosition = -1
        int endPosition = -1
        String chromosome = ""
        JSONArray intermediateResult

        if (params.phenotype) {
            phenotype = params.phenotype
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert endPos value=${params.startPos}")
            }
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        }

        intermediateResult = restServerService.gatherECaviarData(   "", "", "",
                phenotype,startPosition, endPosition,
                chromosome, [] )
    }



    def retrieveECaviarData() {
        String gene = ""
        String tissue = ""
        String variant = ""
        String phenotype = ""
        int startPosition = -1
        int endPosition = -1
        String chromosome = ""
        JSONArray credibleSets
        List <String> credibleSetList = []
        boolean looksOkay = true
        JSONArray jsonReturn
        Map ensemblMapper
        Map geneNameMap = [:]
        def slurper = new JsonSlurper()

        if (params.gene) {
            gene = params.gene
        }

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variant) {
            variant = params.variant
        }

        if (params.phenotype) {
            phenotype = params.phenotype
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert endPos value=${params.startPos}")
            }
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        }

        if (params.credibleSets) {
            credibleSets = slurper.parseText( params.credibleSets as String)  as JSONArray
            credibleSetList = credibleSets.collect{o->o}
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherECaviarData(   gene, tissue, variant,
                                                                phenotype,startPosition, endPosition,
                                                                chromosome, credibleSetList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()

            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        JSONArray jsonArray = new JSONArray()
        for (JSONObject jsonObject in jsonReturn) {
            jsonObject.put("common_name", geneNameMap[jsonObject.gene] ?: jsonObject.gene)
            jsonObject.put("tissue_trans",g.message(code: "metadata.${jsonObject.tissue}", default: jsonObject.tissue))
            jsonArray.put(jsonObject)
        }

        render(status: 200, contentType: "application/json") {jsonArray}
        return
    }





    def retrieveColocData() {
        String gene = ""
        String tissue = ""
        String variant = ""
        String phenotype = ""
        int startPosition = -1
        int endPosition = -1
        String chromosome = ""
        boolean looksOkay = true
        JSONArray jsonReturn
        Map ensemblMapper
        Map geneNameMap = [:]

        if (params.gene) {
            gene = params.gene
        }

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variant) {
            variant = params.variant
        }

        if (params.phenotype) {
            phenotype = params.phenotype
        }

        if (params.startPos) {
            try {
                startPosition = Double.parseDouble(params.startPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert startPos value=${params.startPos}")
            }
        }
        if (params.endPos) {
            try {
                endPosition = Double.parseDouble(params.endPos).intValue()
            } catch (Exception e) {
                looksOkay = false
                e.printStackTrace()
                log.error("retrieveAbcData:failed to convert endPos value=${params.startPos}")
            }
        }

        if (params.chromosome) {
            chromosome = params.chromosome
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherEColocData( gene, tissue, variant, phenotype,startPosition, endPosition, chromosome)
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            def slurper = new JsonSlurper()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        JSONArray jsonArray = new JSONArray()
        for (JSONObject jsonObject in jsonReturn) {
            jsonObject.put("common_name", geneNameMap[jsonObject.gene] ?: jsonObject.gene)
            jsonObject.put("tissue_trans",g.message(code: "metadata.${jsonObject.tissue}", default: jsonObject.tissue))
            jsonArray.put(jsonObject)
        }

        render(status: 200, contentType: "application/json") {jsonArray}
        return
    }



    def retrieveEffectorGeneInformation() {
        boolean looksOkay = true

        def slurper = new JsonSlurper()
        List<String> geneList = []
        if (params.geneList) {
            geneList = slurper.parseText( params.geneList as String)  as JSONArray
            looksOkay = true
        }

        JSONObject jsonReturn
        if (looksOkay){
            jsonReturn = restServerService.gatherEffectorGeneData( geneList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString)
        }
        render(status: 200, contentType: "application/json") {jsonReturn}
        return
}





    def retrieveGeneLevelAssociations() {
        String gene = ""
        String phenotype = ""
        boolean looksOkay = true
        String preferredSampleGroup = ""

        def slurper = new JsonSlurper()
        List<String> propertyList = []
        if (params.propertyNames) {
            propertyList = slurper.parseText( params.propertyNames as String)  as JSONArray
        }
        JSONObject jsonReturn

        if (params.preferredSampleGroup) {
            preferredSampleGroup = params.preferredSampleGroup
        }

        if (params.gene) {
            gene = params.gene
        } else {
            log.error("retrieveGeneLevelAssociations: did not receive the required gene parameter")
            looksOkay = false
        }

        if (params.phenotype) {
            phenotype = params.phenotype
        } else {
            log.error("retrieveGeneLevelAssociations: did not receive the required phenotype parameter")
            looksOkay = false
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherGenePhenotypeAssociations( phenotype, gene, propertyList, preferredSampleGroup)
            // insert translations if they exist
            LinkedHashMap<String, String> tissueTranslations = [:] as LinkedHashMap
            if ((jsonReturn?.variants)&&(jsonReturn?.variants?.size()>0)){
                for (Map map in jsonReturn?.variants[0]){
                    map.each{String k,v->
                        if (k!="Gene"){
                            String translation = g.message(code: "metadata.$k", default: "no translation")
                            if ((!tissueTranslations.containsKey(k)) &&
                                    (translation != "no translation")){
                                tissueTranslations[k]=translation
                            }
//                            if (translation != "no translation"){
//                                map[translation]=v
//                                map.remove(k)
//                            }
                        }

                    }
                }
                JSONObject translationTable = new JSONObject()
                tissueTranslations.each{k,v->
                    translationTable[k]=v
                }
                JSONObject holdTranslationTable = new JSONObject()
                holdTranslationTable.put("TISSUE_TRANSLATIONS",translationTable)
                jsonReturn?.variants[0] << holdTranslationTable
            }
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()

            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }
        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }








    def retrieveModData() {
        String gene = ""
        boolean looksOkay = true
        JSONObject jsonReturn = new JSONObject()


        if (params.gene) {
            gene = params.gene
        }

        jsonReturn['gene']=gene
        jsonReturn['records']=new JSONArray()

        if (looksOkay){
            jsonReturn = restServerService.gatherModsData( gene )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            def slurper = new JsonSlurper()
            jsonReturn =  slurper.parseText(proposedJsonString)
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }




    def retrieveDnaseData() {
        String tissue = ""
        boolean looksOkay = true
        JSONArray jsonReturn
        JSONArray variants
        List <String> variantList = []
        def slurper = new JsonSlurper()

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variants) {
            variants = slurper.parseText( params.variants as String)  as JSONArray
            variantList = variants as List <String>
        } else {
            looksOkay = false
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherDnaseData( tissue, variantList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }



    def retrieveH3k27acData() {
        String tissue = ""
        boolean looksOkay = true
        JSONArray jsonReturn
        JSONArray variants
        List <String> variantList = []
        def slurper = new JsonSlurper()

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variants) {
            variants = slurper.parseText( params.variants as String)  as JSONArray
            variantList = variants as List <String>
        } else {
            looksOkay = false
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherH3k27acData( tissue, variantList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }






    def retrieveChromatinState() {
        String tissue = ""
        boolean looksOkay = true
        JSONObject jsonReturn
        JSONArray variants
        List <String> variantList = []
        def slurper = new JsonSlurper()

        if (params.tissue) {
            tissue = params.tissue
        }

        if (params.variants) {
            variants = slurper.parseText( params.variants as String)  as JSONArray
            //variantList = variants as List <String>
            variantList = variants.collect{o->o}
        } else {
            looksOkay = false
        }

        if (looksOkay){
            jsonReturn = restServerService.gatherChromatinStateData( tissue, variantList )
        } else {
            String proposedJsonString = new JsonBuilder( "[is_error: true, error_message: \"calling parameter problem\"]" ).toPrettyString()
            jsonReturn =  slurper.parseText(proposedJsonString) as JSONArray;
        }

        render(status: 200, contentType: "application/json") {jsonReturn}
        return
    }




}
