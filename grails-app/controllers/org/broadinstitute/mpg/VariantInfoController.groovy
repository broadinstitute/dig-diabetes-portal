package org.broadinstitute.mpg
import grails.converters.JSON
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Experiment
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

    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String locale = RequestContextUtils.getLocale(request)
        JSONObject phenotypeDatasetMapping = metaDataService.getPhenotypeDatasetMapping()
        String variantToStartWith = params.id

        // this supports variant searches coming from links inside of LZ plots
        if(params.lzId) {
            // if defined, lzId will look like: 8:118184783_C/T
            // need to get format like: 8_118184783_C_T
            variantToStartWith = params.lzId.replaceAll(/\:|\//, '_')
        }

        List<PhenotypeBean> lzOptions = GeneController.getHailPhenotypeMap()

        if (variantToStartWith) {

            render(view: 'variantInfo',
                    model: [variantToSearch: variantToStartWith.trim(),
                            show_gwas      : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            locale:locale,
                            phenotypeDatasetMapping: (phenotypeDatasetMapping as JSON),
                            restServer: restServerService.currentRestServer(),
                            lzOptions   : lzOptions
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
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase(), "ExSeq_17k_mdv2")
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


    /***
     * Returns the names for available data sets so that the user can choose between them
     *
     * @return
     */
    def sampleMetadataExperimentAjax() {
        List<SampleGroup> sampleGroupList

       // if (g.portalTypeString()?.equals("stroke")){

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
        // cast the parameters
        String variantName = params.variantName
        List<String> variantNameList = []
        if (variantNameJsonList.size () > 0){
            variantNameList = variantNameJsonList.collect{it} as List<String>
        }else {
            variantNameList << variantName
        }

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        JSONObject result = this.burdenService.callBurdenTestForTraitAndDbSnpId(traitFilterOptionId, variantNameList, covariateJsonObject, sampleJsonObject, filtersJsonObject, phenotypeFilterValues, dataset  );

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
