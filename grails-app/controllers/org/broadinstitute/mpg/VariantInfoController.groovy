package org.broadinstitute.mpg

import grails.converters.JSON
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
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
        String phenotype = "T2D"
        String portalType = g.portalTypeString() as String
        String igvIntro = ""
        switch (portalType){
            case 't2d':
                igvIntro = g.message(code: "gene.igv.intro1", default: "Use the IGV browser")
                phenotype = 'T2D'
                break
            case 'mi':
                igvIntro = g.message(code: "gene.mi.igv.intro1", default: "Use the IGV browser")
                phenotype = 'EOMI'
                break
            case 'stroke':
                igvIntro = g.message(code: "gene.stroke.igv.intro1", default: "Use the IGV browser")
                phenotype = 'Stroke_all'
                break
            default:
                break
        }

        locusZoomDataset = grailsApplication.config.portal.data.default.dataset.abbreviation.map[portalType]+metaDataService.getDataVersion()



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
                            locusZoomDataset:locusZoomDataset,
                            phenotype:phenotype,
                            igvIntro: igvIntro
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
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase(), "ExSeq_17k_"+metaDataService.getDataVersion())
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
        String chromosome = ''
        int startPos
        int endPos
        int pageStart = 0
        int pageEnd = 1000
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


        JSONObject dataJsonObject

         dataJsonObject = restServerService.gatherRegionInformation( chromosome, startPos, endPos, pageStart, pageEnd )

        if (dataJsonObject.variants) {
            for (Map pval in dataJsonObject.variants){

//                if (pval.containsKey("Consequence")){
//                    List<String> consequenceList = pval["Consequence"]?.tokenize(",")
//                    List<String> translatedConsequenceList = []
//                    for (String consequence in consequenceList){
//                        translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
//                    }
//                    pval["Consequence"] = translatedConsequenceList.join(", ")
//                }
//                if (pval.containsKey("dataset")){
//                    pval["dsr"] = g.message(code: "metadata." + pval["dataset"], default: pval["dataset"])
//                }
//                if (pval.containsKey("phenotype")){
//                    pval["pname"] = g.message(code: "metadata." + pval["phenotype"], default: pval["phenotype"])
//                }

            }

        }


        render(status: 200, contentType: "application/json") {
            [variants: dataJsonObject]
        }

    }




    /***
     * Returns the names for available data sets so that the user can choose between them
     *
     * @return
     */
    def sampleMetadataExperimentAjax() {
        List<SampleGroup> sampleGroupList

        sampleGroupList =  metaDataService.getSampleGroupListForPhenotypeAndVersion("", "", MetaDataService.METADATA_SAMPLE)


        JSONObject jsonObject = burdenService.convertSampleGroupListToJson (sampleGroupList)

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

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

    /***
     * Let's assume a data set ( take the first one that comes back.  Currently there is only one option, so that works, but it won't forever)
     * @return
     */
    def sampleMetadataAjaxWithAssumedExperiment() {
        List<SampleGroup> sampleGroupList =  metaDataService.getSampleGroupListForPhenotypeAndVersion("", "", MetaDataService.METADATA_SAMPLE)
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

        String dataset = params.dataset
        /***
         * Superkludge:  currently the burden server can only take preset data versions.  We are going to convert whatever data set we get
         * to a predefined MDV number until we can find a more general solution
         */
        grailsApplication.config.portal.data.version.map[portalType]
        dataset = dataset?.replaceAll(~/mdv\d+/,"${grailsApplication.config.portal.data.version.map[portalType]}")
//        if (portalType == 't2d'){
//            dataset = dataset?.replaceAll(~/mdv\d+/,"mdv${restServerService.SAMPLE_DATA_VERSION_T2D}")
//        } else if (portalType == 'stroke'){
//            dataset = dataset?.replaceAll(~/mdv\d+/,"mdv${restServerService.SAMPLE_DATA_VERSION_STROKE}")
//        }


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
            result = this.burdenService.callBurdenTestForTraitAndDbSnpId(traitFilterOptionId, variantNameList, covariateJsonObject, sampleJsonObject, filtersJsonObject, phenotypeFilterValues, dataset  );
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
