package dport

import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {
    FilterManagementService filterManagementService
    RestServerService restServerService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)

    def index() {}

    /***
     * set up the search page. There may or may not be parameters, but there is no immediate follow-up Ajax call
     * encParams can be null (in which case we take on the default values in the search page) or else they can
     * tell us what the last known form values were "1:3,23:0"
     * @return
     */
    def variantSearch() {
        String encParams
        if (params.encParams) {
            encParams = params.encParams
            log.debug "variantSearch params.encParams = ${params.encParams}"
        } else if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma))  {  // if sigma default data set is sigma
            encParams = "1:0"
        }
        render(view: 'variantSearch',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_sigma: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                        encParams : encParams])

    }


    def variantSearchWF(){
        String encParams
        if (params.encParams) {
            encParams = params.encParams
            log.debug "variantSearch params.encParams = ${params.encParams}"
        } else if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma))  {  // if sigma default data set is sigma
            encParams = "1:0"
        }

        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_sigma: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                        encParams : encParams,
                        variantWorkflowParmList:[],
                        encodedFilterSets : [[:]]])
    }


    def variantVWRequest(){
        LinkedHashMap newParameters = filterManagementService.processNewParameters (params.dataSet,
                params.esValue,
                params.esEquivalence,
                params.phenotype,
                params.pvValue,
                params.pvEquivalence,
                params.orValue,
                params.orEquivalence,
                params.filters,
                params.datasetExomeChip,
                params.datasetExomeSeq,
                params.datasetGWAS,
                params.region_stop_input,
                params.region_start_input,
                params.region_chrom_input,
                params.region_gene_input,
                params.predictedEffects,
                params.condelSelect,
                params.polyphenSelect,
                params.siftSelect
        )

        List <String> oldFilters=filterManagementService.observeMultipleFilters(params)
        List <LinkedHashMap> combinedFilters = filterManagementService.combineNewAndOldParameters(newParameters,
                oldFilters)
        List <LinkedHashMap> encodedFilterSets = filterManagementService.encodeAllFilters (combinedFilters)


        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_sigma: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                        encodedFilterSets : encodedFilterSets])

    }

    def launchAVariantSearch(){
        LinkedHashMap newParameters = filterManagementService.processNewParameters (params.dataSet,
                params.esValue,
                params.esEquivalence,
                params.phenotype,
                params.pvValue,
                params.pvEquivalence,
                params.orValue,
                params.orEquivalence,
                params.filters,
                params.datasetExomeChip,
                params.datasetExomeSeq,
                params.datasetGWAS,
                params.region_stop_input,
                params.region_start_input,
                params.region_chrom_input,
                params.region_gene_input,
                params.predictedEffects,
                params.condelSelect,
                params.polyphenSelect,
                params.siftSelect
        )

        List <String> oldFilters=filterManagementService.observeMultipleFilters(params)
        List <LinkedHashMap> combinedFilters = filterManagementService.combineNewAndOldParameters(newParameters,
                oldFilters)
        String geneId = params.id
        String receivedParameters = params.filter
        String significance = params.sig
        String dataset = params.dataset
        String region = params.region
        String filter = params.filter
        Map paramsMap = filterManagementService.storeCodedParametersInHashmap (geneId,significance,dataset,region,combinedFilters)

        if (paramsMap) {
            displayVariantSearchResults(paramsMap, false)
        }


    }


    /***
     * User has posted a search request.  The search was made through a traditional form (the GO button on the variant search page).
     * A service then laboriously parses the request, thereby generating filters which we can pass to the backend. The associated Ajax
     * retrieval for this call is -->  variantSearchAjax
     * @return
     */
    def variantSearchRequest() {
         Map paramsMap = new HashMap()

        params.each { key, value ->
            paramsMap.put(key, value)
        }
        if (paramsMap) {
            displayVariantSearchResults(paramsMap, sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma))
        }

    }

    /***
     * A collection of specialized searches are handled here, mostly from the geneinfo page. The idea is that we interpret those
     * special requests in storeParametersInHashmap and convert them into  a parameter map, which can then be interpreted
     * with our usual machinery.
     *
     * @return
     */
    def gene() {
        String geneId = params.id
        String receivedParameters = params.filter
        String significance = params.sig
        String dataset = params.dataset
        String region = params.region

        Map paramsMap = filterManagementService.storeParametersInHashmap (geneId,significance,dataset,region,receivedParameters)

        if (paramsMap) {
            displayVariantSearchResults(paramsMap, false)
        }

    }



    def retrieveDatasetsAjax() {
        List <String> phenotypeList = []
        List <String> experimentList = []
        if((params.phenotype) && (params.phenotype !=  null )){
            phenotypeList << params.phenotype
        }
        if ((params.experiment) && (params.experiment !=  null )){
            experimentList << params.experiment
        }
       // JSONObject jsonObject = restServerService.retrieveDatasets(phenotypeList, experimentList)
        JSONObject jsonObject = restServerService.pseudoRetrieveDatasets(phenotypeList, experimentList)
//        String v = """
//{"is_error": false,
// "numRecords":1,
// "dataset":["MAGIC 2014"]
//}""".toString()
//        def slurper = new JsonSlurper()
//        def result = slurper.parseText(v)

        render(status: 200, contentType: "application/json") {
            [datasets: jsonObject]
        }
//        render(status: 200, contentType: "application/json") {
//            [datasets: jsonObject]
//        }
    }



    /***
     * a variant display table is on screen and the page is now asking for data. Perform the search.  This call retrieves the data
     * for the original page format call -> variantSearchRequest
     * @return
     */
    def variantSearchAjax() {
        String filtersRaw = params['keys']
        String filters = URLDecoder.decode(filtersRaw, "UTF-8")
        log.debug "variantSearch variantSearchAjax = ${filters}"
        JSONObject jsonObject
        if (sharedToolsService.getNewApi()){
            jsonObject = restServerService.generalizedVariantTable(filters)
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['results']]
            }
        }else {

            jsonObject = restServerService.searchGenomicRegionByCustomFilters(filters)
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }

        }
    }



    /***
     *  This method launches a table presenting all of the variants that match the user specified search criteria.  Note that there are two ways
     *  to get to this point: 1) the user can specify the individual parameters that want using a form; or else 2) the user clicks on an anchor
     *  that contains a prebuilt search.  The idea of this routine is that both of those paths should lead to exactly the same result.
     *
     * @param paramsMap
     * @param currentlySigma
     */
    private void displayVariantSearchResults(HashMap paramsMap, boolean currentlySigma) {
        LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.parseVariantSearchParameters(paramsMap, currentlySigma)
        if (parsedFilterParameters) {

            Integer dataSetDetermination = filterManagementService.distinguishBetweenDataSets(paramsMap)
            String encodedFilters = sharedToolsService.packageUpFiltersForRoundTrip(parsedFilterParameters.filters)
            String encodedParameters = sharedToolsService.packageUpEncodedParameters(parsedFilterParameters.parameterEncoding)
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()

            render(view: 'variantSearchResults',
                    model: [show_gene           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                            show_gwas           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            show_sigma          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                            filter              : encodedFilters,
                            filterDescriptions  : parsedFilterParameters.filterDescriptions,
                            proteinEffectsList  : encodedProteinEffects,
                            encodedParameters   : encodedParameters,
                            dataSetDetermination: dataSetDetermination,
                            newApi              : sharedToolsService.getNewApi()])
        }
    }


}