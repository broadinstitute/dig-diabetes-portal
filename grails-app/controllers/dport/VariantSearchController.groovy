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
        LinkedHashMap <String,String> customFilters=filterManagementService.retrieveCustomFilters(params)
        LinkedHashMap newParameters = filterManagementService.processNewParameters (
                customFilters,
                params.dataSet,
                params.esValue,
                params.esEquivalence,
                params.phenotype,
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
        LinkedHashMap <String,String> customFilters=filterManagementService.retrieveCustomFilters(params)
        LinkedHashMap newParameters = filterManagementService.processNewParameters (
                customFilters,
                params.dataSet,
                params.esValue,
                params.esEquivalence,
                params.phenotype,
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
       // Map paramsMap = filterManagementService.storeCodedParametersInHashmap (combinedFilters)
        List <LinkedHashMap> listOfParameterMaps = filterManagementService.storeCodedParametersInHashmap (combinedFilters)


        if ((listOfParameterMaps) &&
                (listOfParameterMaps.size() > 0)){
            displayCombinedVariantSearchResults(listOfParameterMaps, false)
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

    /***
     * get data sets given a phenotype
     * @return
     */
    def retrieveDatasetsAjax() {
        List <String> phenotypeList = []
        List <String> experimentList = []
        if((params.phenotype) && (params.phenotype !=  null )){
            phenotypeList << params.phenotype
        }
        if ((params.experiment) && (params.experiment !=  null )){
            experimentList << params.experiment
        }
        JSONObject jsonObject = sharedToolsService.retrieveMetadata()

        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<String,List<String>> annotatedPhenotypes =  processedMetadata.sampleGroupsPerPhenotype
        List <String> listOfDataSets  = sharedToolsService.extractASingleList(params.phenotype,annotatedPhenotypes)
        String datasetsForTransmission = sharedToolsService.packageUpAListAsJson (listOfDataSets)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(datasetsForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }
    }

    /***
     * get properties given a data set
     */
    def retrievePropertiesAjax(){
        List <String> datasetList = []
        if((params.dataset) && (params.dataset !=  null )){
            datasetList << params.dataset
        }
        List <String> phenotypeList = []
        if((params.phenotype) && (params.phenotype !=  null )){
            phenotypeList << params.phenotype
        }

        JSONObject jsonObject = sharedToolsService.retrieveMetadata()

        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<String,List<String>> annotatedSampleGroups =  processedMetadata.propertiesPerSampleGroups
        LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties = processedMetadata['phenotypeSpecificPropertiesPerSampleGroup']
        List <String> listOfProperties  = sharedToolsService.combineToCreateASingleList( params.phenotype, params.dataset,
                                                                                             annotatedSampleGroups,
                                                                                             phenotypeSpecificSampleGroupProperties )
        String propertiesForTransmission = sharedToolsService.packageUpAListAsJson (listOfProperties)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(propertiesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }

    }




    def retrievePhenotypesAjax(){

        JSONObject jsonObject = sharedToolsService.retrieveMetadata()

        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties = processedMetadata.phenotypeSpecificPropertiesPerSampleGroup
        List <String> listOfPhenotypes = sharedToolsService.extractAPhenotypeList( phenotypeSpecificSampleGroupProperties )
        String phenotypesForTransmission = sharedToolsService.packageUpAListAsJson (listOfPhenotypes)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(phenotypesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }

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




    private void displayCombinedVariantSearchResults(List <LinkedHashMap> listOfParameterMaps, boolean currentlySigma) {
        // Let's start stepping through our big list of filters
        LinkedHashMap  parsedFilterParameters
        if (listOfParameterMaps){
            for (LinkedHashMap singleParameterMap in listOfParameterMaps){
                parsedFilterParameters =   filterManagementService.parseExtendedVariantSearchParameters (singleParameterMap,false,parsedFilterParameters)
            }
        }
        if (parsedFilterParameters) {

            Integer dataSetDetermination = filterManagementService.identifyAllRequestedDataSets(listOfParameterMaps)
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