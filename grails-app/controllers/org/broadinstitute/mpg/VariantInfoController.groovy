package org.broadinstitute.mpg

import grails.converters.JSON
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils


/**
 * Controller class to control the /variantInfo section of the T2D site
 */
class VariantInfoController {
    RestServerService   restServerService
    SharedToolsService sharedToolsService
    BurdenService burdenService
    WidgetService widgetService
    MetaDataService metaDataService
    def grailsApplication


    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String locale = RequestContextUtils.getLocale(request)
        JSONObject phenotypeDatasetMapping = metaDataService.getPhenotypeDatasetMapping()
        String variantToStartWith = params.id
        String locusZoomDataset
        //List <String> defaultTissues = []   -- no need for tissues when looking at a particular variant
        String phenotype = metaDataService.getDefaultPhenotype()
        String portalType = g.portalTypeString() as String
        String igvIntro = ""
        switch (portalType){
            case 't2d':
                igvIntro = g.message(code: "gene.igv.intro1", default: "Use the IGV browser")
                break
            case 'mi':
                igvIntro = g.message(code: "gene.mi.igv.intro1", default: "Use the IGV browser")
                break
            case 'stroke':
                igvIntro = g.message(code: "gene.stroke.igv.intro1", default: "Use the IGV browser")
                break
            case 'ibd':
                igvIntro = g.message(code: "gene.ibd.igv.intro1", default: "Use the IGV browser")
                break
            default:
                break
        }

       // this supports variant searches coming from links inside of LZ plots
        if(params.lzId) {
            // if defined, lzId will look like: 8:118184783_C/T
            // need to get format like: 8_118184783_C_T
            variantToStartWith = params.lzId.replaceAll(/\:|\//, '_')
        }

        List<PhenotypeBean> lzOptions = this.widgetService?.getHailPhenotypeMap()

        if (variantToStartWith) {

            render(view: 'variantInfo',
                    model: [variantToSearch: variantToStartWith.trim(),
                            show_gwas      : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            locale:locale,
                            phenotypeDatasetMapping: (phenotypeDatasetMapping as JSON),
                            restServer: restServerService.currentRestServer(),
                            lzOptions   : lzOptions,
                            phenotype:phenotype,
                            igvIntro: igvIntro,
                            portalVersionBean:restServerService.retrieveBeanForCurrentPortal()
                    ])

        }
    }

    /***
     * provide  a nice collection of information about a single variant. This is the Ajax call associated with variantInfo
     * @return
     */
    def variantAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            if (jsonObject.variants) {
                for (List variant in jsonObject.variants){
                    for (Map field in variant){
                        String key = field.keySet()[0]
                        String value = field.values()[0]
                        if (  ( (key == "Consequence")||
                                (key == "SIFT_PRED")||
                                (key == "PolyPhen_PRED") ) &&
                             ( value != null) ){
                            List<String> consequenceList = value.tokenize(",")
                            List<String> translatedConsequenceList = []
                            for (String consequence in consequenceList){
                                translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
                            }
                            field[key]=(translatedConsequenceList.join(", "))
                        }
                    }
                }
            }

            render(status:200, contentType:"application/json") {
                [variant:jsonObject]
            }

        }
    }
    def variantAndDsAjax() {
        String variantToStartWith = params.varid
        String dataSet = params.dataSet
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByNameAndDs (variantToStartWith.trim(),dataSet)
            if (jsonObject.variants) {
                for (List variant in jsonObject.variants){
                    for (Map field in variant){
                        String key = field.keySet()[0]
                        String value = field.values()[0]
                        if (  ( (key == "Consequence")||
                                (key == "SIFT_PRED")||
                                (key == "PolyPhen_PRED") ) &&
                                ( value != null) ){
                            List<String> consequenceList = value.tokenize(",")
                            List<String> translatedConsequenceList = []
                            for (String consequence in consequenceList){
                                translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
                            }
                            field[key]=(translatedConsequenceList.join(", "))
                        }
                    }
                }
            }

            render(status:200, contentType:"application/json") {
                [variant:jsonObject]
            }

        }
    }


    /**
     * method to service ajax call for the 'What effect on the encoded protein' section/accordion
     *
     * @return
     */
    def proteinEffect (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.gatherProteinEffect ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service ajax call for the 'Variant frequency difference for patients with disease' section/accordion
     *
     * @return
     */
    def variantDiseaseRisk (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase(),  metaDataService.getDefaultDataset())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service the ajax call for the 'variant association statistics (pvalue/OR)' section/accordion
     *
     * @return
     */
    def variantDescriptiveStatistics (){
        String variantId = params.variantId
        String datasetStructs = params.datasets
        String phenotype = params.phenotype
        JSONArray jsonArray = JSON.parse(datasetStructs)
        Iterator<JSONObject> iterator = jsonArray.iterator()
        List<LinkedHashMap> linkedHashMapList = []
        while (iterator.hasNext()) {
            JSONObject value = iterator.next();
            LinkedHashMap linkedHashMap = [:]
            linkedHashMap['technology']=value.technology
            linkedHashMap['name']=value.name
            linkedHashMap['pvalue']=value.pvalue
            linkedHashMap['orvalue']=value.orvalue
            linkedHashMap['betavalue']=value.betavalue
            linkedHashMap['maf']=value.maf
            linkedHashMapList << linkedHashMap
        }
        JSONObject jsonObject =  restServerService.combinedVariantAssociationStatistics ( variantId.trim().toUpperCase(),phenotype, linkedHashMapList)
        jsonObject.displayName = g.message(code: "metadata." + phenotype, default: phenotype);
        render(status:200, contentType:"application/json") {
            jsonObject
        }
    }

    /**
     * method to service the ajax call for the 'How common is' section/accordion
     *
     * @return
     */
    def howCommonIsVariant(){
        String variantId = params.variantId
        String showAll = params.showAll
        JSONObject jsonObject =  restServerService.howCommonIsVariantAcrossEthnicities ( variantId.trim().toUpperCase(),showAll)
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }



    /***
     * retrieves samples with values along all requested properties
     *
     * @return
     */
    def retrieveSampleListAjax() {
        JsonSlurper slurper = new JsonSlurper()
        String jsonDataAsString = params.data
        JSONObject sampleCallSpecifics = slurper.parseText(jsonDataAsString)

        String dataset =  sampleCallSpecifics.dataset
        JSONArray requestedData = sampleCallSpecifics.requestedData as JSONArray
        List<String> requestedDataList = []
        for (Map map in requestedData){
            if (map.name){
                requestedDataList << """ "${map.name}":["${dataset}"]""".toString()
            }
        }
        requestedDataList << """ "ID":["${dataset}"]""".toString()
        JSONObject jsonObject = widgetService.getSampleDistribution ( dataset, requestedDataList, false, sampleCallSpecifics.filters  as JSONArray, true )

        //JSONObject jsonObject =  widgetService.getSampleList ( sampleCallSpecifics)
        render(status:200, contentType:"application/json") {
            [metaData:jsonObject]
        }
    }



    def retrieveFunctionalDataAjax (){
        String portalType = g.portalTypeString() as String
        String chromosome = ''
        String source = ''
        String assayName = 'notused'
        int startPos
        int endPos
        int pageStart = 0
        int pageEnd = 500
        Boolean lzFormat =  false
        if (params.chromosome) {
            chromosome = params.chromosome
            log.debug "retrieveFunctionalData params.chromosome = ${params.chromosome}"
        }
        if (params.startPos) {
            startPos = Integer.parseInt(params.startPos)
            log.debug "retrieveFunctionalData params.startPos = ${params.startPos}"
        }
        if (params.endPos) {
            endPos =  Integer.parseInt(params.endPos)
            log.debug "retrieveFunctionalData params.endPos = ${params.endPos}"
        }
        if (params.source) {
            source =  params.source
            log.debug "retrieveFunctionalData params.source = ${params.source}"
        }


        if (params.lzFormat) {
            int formatIndicator =  Integer.parseInt(params.lzFormat)
            if (formatIndicator>0){
                lzFormat = true
            }
            log.debug "retrieveFunctionalData params.lzFormat = ${params.lzFormat}"
        }

        LinkedHashMap<String,LinkedHashMap> elementMapper = [:]


        JSONObject dataJsonObject

        elementMapper["1_Active_TSS"] = [name:"Active transcription start site",state_id:1]
        elementMapper["2_Weak_TSS"] = [name:"Weak transcription start site",state_id:2]
        elementMapper["3_Flanking_TSS"] = [name:"Flanking transcription start site",state_id:3]
        elementMapper["5_Strong_transcription"] = [name:"Strong transcription",state_id:4]
        elementMapper["6_Weak_transcription"] = [name:"Weak transcription",state_id:5]
        elementMapper["8_Genic_enhancer"] = [name:"Genic enhancer",state_id:6]
        elementMapper["9_Active_enhancer_1"] = [name:"Active enhancer 1",state_id:7]
        elementMapper["10_Active_enhancer_2"] = [name:"Active enhancer 2",state_id:8]
        elementMapper["11_Weak_enhancer"] = [name:"Weak enhancer",state_id:9]
        elementMapper["14_Bivalent/poised_TSS"] = [name:"Bivalent poised TSS",state_id:10]
        elementMapper["16_Repressed_polycomb"] = [name:"Repressed polycomb",state_id:11]
        elementMapper["17_Weak_repressed_polycomb"] = [name:"Weak repressed polycomb",state_id:12]
        elementMapper["18_Quiescent/low_signal"] = [name:"Quiescent low signal",state_id:13]

        List requestedAssays = []
        String assayIdListWithDefaults = ((params.assayIdList=="[undefined]")||(params.assayIdList==null)) ? "[3]" : params.assayIdList
        if (assayIdListWithDefaults){
            String assayIdStringContents = (assayIdListWithDefaults - "]") - "["
            requestedAssays = assayIdStringContents.split(",")
        }
        if (!requestedAssays.contains("5")){
            dataJsonObject = restServerService.gatherRegionInformation( chromosome, startPos, endPos, pageStart, pageEnd,
                    source, assayIdListWithDefaults )
        } else { // this is a temporary hack to call directly to UCSD.  Should be removed.
            dataJsonObject = restServerService.getUcsdRangeData([],[],[],[],"binding footprints",
            "chr${chromosome}:${startPos}-${endPos}", pageStart, pageEnd,source)
        }





        if (lzFormat){
            JSONObject root = new JSONObject()

            root["lastPage"] = null;
            JSONObject rootData = new JSONObject()
            rootData["chromosome"]=new JSONArray()
            rootData["start"]=new JSONArray()
            rootData["end"]=new JSONArray()
            rootData["id"]=new JSONArray()
            rootData["public_id"]=new JSONArray()
            rootData["value"]=new JSONArray()
            rootData["state_id"]=new JSONArray()
            rootData["state_name"]=new JSONArray()
            rootData["strand"]=new JSONArray()
            JSONArray sorted = dataJsonObject.variants.sort{it["START"]}
            for (Map pval in sorted) {
                rootData["chromosome"].push(pval["CHROM"])
                rootData["start"].push(pval["START"])
                rootData["end"].push(pval["STOP"])
                rootData["id"].push(16)
                rootData["value"].push(pval["VALUE"])
                rootData["public_id"].push(null)
                rootData["strand"].push(null)
                String individualAssayIdString = pval["ANNOTATION"]
                int individualAssayId = (individualAssayIdString) ? Integer.parseInt(individualAssayIdString) : 3

                // map the Parker chromatin state information by hand
                String element = pval["ELEMENT"]
                LinkedHashMap map = elementMapper[element]
                String elementTrans = g.message(code: "metadata." + element, default: element)

                rootData["state_id"].push(map?.state_id ?: individualAssayId)
                rootData["state_name"].push(map?.name ?: "3_Flanking_TSS")

            }
            root["data"] = rootData
            dataJsonObject = root
        } else {
            if (!requestedAssays.contains("5")){
                if (dataJsonObject.variants) {
                    dataJsonObject['region_start'] = startPos;
                    dataJsonObject['region_end'] = endPos;
                    for (Map pval in dataJsonObject.variants){

                        if (pval.containsKey("ELEMENT")){
                            pval["element_trans"] = g.message(code: "metadata." + pval["ELEMENT"], default: pval["ELEMENT"])
                        }
                        if (pval.containsKey("SOURCE")){
                            pval["source_trans"] = g.message(code: "metadata." + pval["SOURCE"], default: pval["SOURCE"])
                        }
                        pval["assayName"] = assayName

                    }

                }

            } else {
                if (dataJsonObject."binding footprints") {
                    dataJsonObject['region_start'] = startPos;
                    dataJsonObject['region_end'] = endPos;
                    for (Map pval in dataJsonObject."binding footprints"){
                        pval["element"] = "null"
                        pval["element_trans"] = "null_trans"
                        pval["source"] = pval["biosample_term_name"]
                        pval["source_trans"] = pval["biosample_term_name"]
                        pval["assayName"] = assayName
                        LinkedHashMap decipheredRange =  restServerService.parseARange (pval["region"] as String)
                        pval["START"] = decipheredRange["start"]
                        pval["STOP"] = decipheredRange["end"]
                        pval["CHROM"] = decipheredRange["chromosome"]
                        pval["VALUE"] = pval["value"]
                        pval["ANNOTATION"] = 5
                    }
                    dataJsonObject['variants'] = dataJsonObject."binding footprints"
                }
            }

        }



        if (lzFormat){
            render(status: 200, contentType: "application/json") {
                dataJsonObject
            }
        } else {
            if (!requestedAssays.contains("5")) {
                render(status: 200, contentType: "application/json") {
                    [variants: dataJsonObject]
                }
            } else {
                render(status: 200, contentType: "application/json") {
                    [variants: dataJsonObject]
                }
            }

        }


    }




    /***
     * Returns the names for available data sets so that the user can choose between them
     *
     * @return
     */
    def sampleMetadataExperimentAjax() {
        List<SampleGroup> sampleGroupList
        boolean isGeneBurden = params.boolean('isGeneBurden');
        boolean isGrsVariantSet = params.boolean('isGrsVariantSet');

        sampleGroupList =  metaDataService.getSampleGroupListForPhenotypeAndVersion("", "", MetaDataService.METADATA_SAMPLE)

        // TODO: we should be able to eliminate this switch when we havean allele specific burden test in place.
        //       Until then, however, GRS specificity trumps the gene/variant dataset switch
        if (isGrsVariantSet) {
            List<SampleGroup> tempList = new ArrayList<SampleGroup>();
            for (SampleGroup sampleGroup : sampleGroupList) {
                if (sampleGroup.hasMeaning(PortalConstants.BurdenTest.GRS_SPECIFIC)) {
                    tempList.add(sampleGroup)
                }
            }
            sampleGroupList = tempList;
        } else {
            List<SampleGroup> tempList = new ArrayList<SampleGroup>();
            for (SampleGroup sampleGroup : sampleGroupList) {
                if (!sampleGroup.hasMeaning(PortalConstants.BurdenTest.GRS_SPECIFIC)) {
                    tempList.add(sampleGroup)
                }
            }
            sampleGroupList = tempList;
        }
        if (isGeneBurden) {
            List<SampleGroup> tempList = new ArrayList<SampleGroup>();
            for (SampleGroup sampleGroup : sampleGroupList) {
                if (sampleGroup.hasMeaning(PortalConstants.BurdenTest.GENE)) {
                    tempList.add(sampleGroup)
                }
            }

            // replace the list
            sampleGroupList = tempList;
        }

        JSONObject jsonObject = burdenService.convertSampleGroupListToJson (sampleGroupList)
        JSONObject jsonConversionObject = new JSONObject()
        for (SampleGroup sampleGroup in sampleGroupList) {
            if (sampleGroup.parent) {
                jsonConversionObject[sampleGroup.systemId] = "${sampleGroup?.parent?.name}_${sampleGroup?.parent?.version}"
            }
        }
        jsonObject['conversion'] = jsonConversionObject

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

    /***
     *  returns lists of  filters, covariates, and phenotypes given a starting data set
     *
     * @return
     */
    def sampleMetadataAjax() {
        String dataset = params.dataset
        SampleGroup sampleGroup = metaDataService.getSampleGroupByFromSamplesName(dataset)
        JSONObject jsonConversionObject = new JSONObject()

        // TODO - DIGKB-217: store linked variant sample group in dataset sample group meaning field
        Iterator<String> meaningIterator = sampleGroup?.getMeaningSet().iterator();
        String variantDataSet = null;
        String variantDataSetMeaning = null;
        while (meaningIterator.hasNext()) {
            variantDataSetMeaning = meaningIterator.next();
            if (variantDataSetMeaning.contains("DATASET_")) {
                variantDataSet = variantDataSetMeaning.substring(variantDataSetMeaning.indexOf("DATASET_") + 8);
                break;
            }
        }

        if (variantDataSet == null) {
                if (sampleGroup?.parent) {
                jsonConversionObject[sampleGroup.systemId] = "${sampleGroup?.parent?.name}_${sampleGroup?.parent?.version}"
            }
        } else {
            jsonConversionObject[sampleGroup.systemId] = variantDataSet
        }

        JSONObject jsonObject = burdenService.convertSampleGroupPropertyListToJson (sampleGroup)
        List filtersOfTypeString = jsonObject?.filters?.findAll{it.type=="STRING"}
        for (Map allLevels in filtersOfTypeString){
            List filteredLevels = []
            for (def eachLevel in allLevels.levels){
                if ((eachLevel.name!="null")||
                        (eachLevel.samples!=0)){
                    filteredLevels << eachLevel
                }
            }
            allLevels.levels = filteredLevels
        }
        jsonObject['conversion'] = jsonConversionObject
        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

    /***
     * Let's assume a data set ( take the first one that comes back.  Currently there is only one option, so that works, but it won't forever)
     * @return
     */
    def sampleMetadataAjaxWithAssumedExperiment() {
        boolean isGrsVariantSet = params.boolean('isGrsVariantSet');
        List<SampleGroup> sampleGroupList =  metaDataService.getSampleGroupListForPhenotypeAndVersion("", "", MetaDataService.METADATA_SAMPLE)
        JSONObject jsonConversionObject = new JSONObject()

        // if this is not a GRS specific query then exclude data sets that are GRS specific
        if (!isGrsVariantSet) {
            List<SampleGroup> tempList = new ArrayList<SampleGroup>();
            for (SampleGroup sampleGroup : sampleGroupList) {
                if (!sampleGroup.hasMeaning(PortalConstants.BurdenTest.GRS_SPECIFIC)) {
                    tempList.add(sampleGroup)
                }
            }
            sampleGroupList = tempList;
        }

        for (SampleGroup sampleGroup in sampleGroupList) {
            Iterator<String> meaningIterator = sampleGroup?.getMeaningSet().iterator();
            String variantDataSet = null;
            while (meaningIterator.hasNext()) {
                String variantDataSetMeaning = meaningIterator.next();
                if (variantDataSetMeaning.contains("DATASET_")) {
                    variantDataSet = variantDataSetMeaning.substring(variantDataSetMeaning.indexOf("DATASET_") + 8);
                    break;
                }
            }

            if (variantDataSet == null) {
                if (sampleGroup.parent) {
                    jsonConversionObject[sampleGroup.systemId] = "${sampleGroup?.parent?.name}_${sampleGroup?.parent?.version}"
                }
            } else {
                jsonConversionObject[sampleGroup.systemId] = variantDataSet
            }



        }

        if (sampleGroupList.size()>0){
            SampleGroup sampleGroup = metaDataService.getSampleGroupByFromSamplesName(sampleGroupList.first().systemId)
            JSONObject jsonObject = burdenService.convertSampleGroupPropertyListToJson (sampleGroup)
            List filtersOfTypeString = jsonObject?.filters?.findAll{it.type=="STRING"}
            for (Map allLevels in filtersOfTypeString){
                List filteredLevels = []
                for (def eachLevel in allLevels.levels){
                    if ((eachLevel.name!="null")||
                            (eachLevel.samples!=0)){
                        filteredLevels << eachLevel
                    }
                }
                allLevels.levels = filteredLevels
            }
            jsonObject['conversion'] = jsonConversionObject
            render(status: 200, contentType: "application/json") {jsonObject}
            return
        }
        render(status: 200, contentType: "application/json")

    }


def retrieveSampleSummary (){
    JsonSlurper slurper = new JsonSlurper()
    String jsonDataAsString = params.data
    JSONObject querySpecification = slurper.parseText(jsonDataAsString)

    // right way
//JSONObject sampleSummary = widgetService.getSampleDistribution ( querySpecification )
    String dataset =  querySpecification.dataset
    JSONArray requestedData = querySpecification.requestedData as JSONArray
    List<String> requestedDataList = []
    Boolean categorical = false
    for (Map map in requestedData){
        if (map.name){
            requestedDataList << """ "${map.name}":["${dataset}"]""".toString()
            if (map.categorical==1){
                categorical = true
            }
        }
    }
    JSONObject sampleSummary = widgetService.getSampleDistribution ( dataset, requestedDataList, true, querySpecification.filters as JSONArray, categorical )

    render(status:200, contentType:"application/json") {
        [sampleData:sampleSummary]
    }

}


    def metadataAjax(){
        JsonSlurper slurper = new JsonSlurper()
        JSONArray valueArray = slurper.parseText(params.valueArray)  as JSONArray
        String categorical = valueArray.find()?.'ca'
        JSONObject result = this.burdenService.getBurdenResultForMetadata( valueArray  );
        if (result){
            if (categorical=='1'){
                result.put('categorical',categorical)
            } else {
                result.put('categorical','0')
            }
        }
        render(status: 200, contentType: "application/json") {result}

    }






    /***
     * This call supports the burden test on the variant info page
     * @return
     */
    def burdenTestAjax() {
        // log parameters received
        // Here are some example parameters, as they show up in the params variable
        // params.filterNum=="2" // value=id from burdenTestVariantSelectionOptionsAjax, or 0 if no selection was made (which is a legal choice)
        // params.dataSet=="1" // where 1->13k, 2->26k"
        // params.variantName=="SLC30A8" // string representing gene name

        String portalType = g.portalTypeString() as String

        // Really?  Different names for phenotypes?  Well, okay, let's translate them
        String traitFilterOptionId = (params.traitFilterSelectedOption ? params.traitFilterSelectedOption : "t2d");     // default to t2d if none given

        String stratum = params.stratum ?: ''
        JsonSlurper slurper = new JsonSlurper()
        JSONObject covariateJsonObject = slurper.parseText(params.covariates)
        JSONObject sampleJsonObject = slurper.parseText(params.samples)
        JSONObject filtersJsonObject = slurper.parseText(params.filters)
        JSONArray phenotypeFilterValues = slurper.parseText(params.compoundedFilterValues) as JSONArray
        JSONArray variantNameJsonList = slurper.parseText(params.variantList) as JSONArray
        String variantSetId = params.variantSetId

        String dataset = params.dataset

        // cast the parameters
        String variantName = params.variantName
        List<String> variantNameList = []
        if (variantNameJsonList.size () > 0){
            variantNameList = variantNameJsonList.collect{it} as List<String>
        }else {
            variantNameList << variantName
        }

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        JSONObject result
        try {
            result = this.burdenService.callBurdenTestForTraitAndDbSnpId(traitFilterOptionId, variantNameList, covariateJsonObject, sampleJsonObject, filtersJsonObject, phenotypeFilterValues, dataset, variantSetId  );
        } catch (Exception e){
            e.printStackTrace()
        }

        // send json response back
        if (!result){
            result = new JSONObject()
        }
        if (stratum){
            result.put('stratum',stratum)
        }
        render(status: 200, contentType: "application/json") {result}
    }

    /***
     * Get the contents for the filter drop-down box on the burden test section of the gene info page
     * @return
     */
    def burdenTestTraitSelectionOptionsAjax() {
        JSONObject jsonObject = this.burdenService.getBurdenTraitSelectionOptions()

        // log
        log.info("got burden trait options: " + jsonObject);

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

}
