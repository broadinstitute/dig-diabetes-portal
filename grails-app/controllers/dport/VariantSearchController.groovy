package dport

import grails.rest.render.json.JsonRenderer
import groovy.json.JsonOutput
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


    def variantSearchWF() {
        String encParams
        if (params.encParams) {
            encParams = params.encParams
            log.debug "variantSearch params.encParams = ${params.encParams}"
        } else if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma)) {
            // if sigma default data set is sigma
            encParams = ""
        }
        List<LinkedHashMap> encodedFilterSets = [[:]]
        List<LinkedHashMap> reconstitutedFilterSets = [[:]]


        if ((encParams) && (encParams.length())) {
            LinkedHashMap simulatedParameters = filterManagementService.generateParamsForSearchRefinement(encParams)
            encodedFilterSets = filterManagementService.handleFilterRequestFromBrowser(simulatedParameters)
            reconstitutedFilterSets = filterManagementService.grouper(encodedFilterSets)
            encodedFilterSets = reconstitutedFilterSets
        }

        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_sigma: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                        variantWorkflowParmList:[],
                        encodedFilterSets : encodedFilterSets])
    }


    def variantVWRequest(){

        List <LinkedHashMap> encodedFilterSets = filterManagementService.handleFilterRequestFromBrowser (params)

            render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_sigma: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma),
                        encodedFilterSets : encodedFilterSets])

    }



    def launchAVariantSearch(){

        List <LinkedHashMap> combinedFilters =  filterManagementService.handleFilterRequestFromBrowser (params)

        List <LinkedHashMap> listOfParameterMaps = filterManagementService.storeCodedParametersInHashmap (combinedFilters)

        List <LinkedHashMap> listOfProperties = []

        if ((listOfParameterMaps) &&
                (listOfParameterMaps.size() > 0)){
            displayCombinedVariantSearchResults(listOfParameterMaps, listOfProperties)
        }


    }


    def relaunchAVariantSearch() {
        String encodedParameters = params.encodedParameters

        LinkedHashMap propertiesToDisplay = params.findAll { it.key =~ /^savedValue/ }
        List<LinkedHashMap> listOfProperties = []
        if ((propertiesToDisplay) &&
                (propertiesToDisplay.size() > 0)) {
            propertiesToDisplay.each { String key, value ->
                if ((value) &&
                        (value != null)) {
                    if (value.class.isArray()) {  // two identical keys will result in an array of keys
                        for (String oneProperty in value) {
                            List<String> disambiguator = oneProperty.tokenize("^")
                            LinkedHashMap valuePasser = [:]
                            valuePasser["phenotype"] = disambiguator[1]
                            valuePasser["dataset"] = disambiguator[2]
                            valuePasser["property"] = disambiguator[3]
                            listOfProperties << valuePasser
                        }
                    } else {
                        List<String> disambiguator = value.tokenize("^")
                        LinkedHashMap valuePasser = [:]
                        valuePasser["phenotype"] = disambiguator[1]
                        valuePasser["dataset"] = disambiguator[2]
                        valuePasser["property"] = disambiguator[3]
                        listOfProperties << valuePasser
                    }

                }

            }
        }

        // now convert these coded parameters into a form we can handle, combine in the properties, and reproduce the table
        List<LinkedHashMap> combinedFilters = sharedToolsService.convertFormOfFilters(encodedParameters)
        List<LinkedHashMap> listOfParameterMaps = filterManagementService.storeCodedParametersInHashmap(combinedFilters)


        if ((listOfParameterMaps) &&
                (listOfParameterMaps.size() > 0)) {
            displayCombinedVariantSearchResults(listOfParameterMaps, listOfProperties)
        }

        // NOTE: we should never get here. Error condition, but a better way to fail
        log.error("relaunchAVariantSearch Was unable to process encoded parameters = ${encodedParameters}.")
        displayCombinedVariantSearchResults(listOfParameterMaps, listOfProperties)


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

            List <LinkedHashMap> listOfProperties = []

            displayCombinedVariantSearchResults([paramsMap], listOfProperties)
           // displayVariantSearchResults(paramsMap, false)
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
       // LinkedHashMap<String,List<String>> annotatedPhenotypes =  processedMetadata.sampleGroupsPerPhenotype
        List <PhenoKey> listOfDataSets  = sharedToolsService.extractASingleList(params.phenotype,processedMetadata.sampleGroupsPerAnnotatedPhenotype)
        String datasetsForTransmission = sharedToolsService.packageUpAStaggeredListAsJson (listOfDataSets)
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
        String datasetChoice = []
        if((params.dataset) && (params.dataset !=  null )){
            datasetChoice = params.dataset
        }
        List <String> phenotypeList = []
        if((params.phenotype) && (params.phenotype !=  null )){
            phenotypeList << params.phenotype
        }

        JSONObject jsonObject = sharedToolsService.retrieveMetadata()

        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<PhenoKey,List<String>> annotatedSampleGroups =  processedMetadata.propertiesPerOrderedSampleGroups
        LinkedHashMap<String, LinkedHashMap <PhenoKey,List <String>>> phenotypeSpecificSampleGroupProperties = processedMetadata['phenotypeSpecificPropertiesAnnotatedPerSampleGroup']
        List <String> listOfProperties  = sharedToolsService.combineToCreateASingleList( params.phenotype, datasetChoice,
                                                                                             annotatedSampleGroups,
                                                                                             phenotypeSpecificSampleGroupProperties )
        String propertiesForTransmission = sharedToolsService.packageUpAListAsJson (listOfProperties)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(propertiesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result,
            chosenDataset:datasetChoice]
        }

    }




    def retrievePhenotypesAjax(){

        JSONObject jsonObject = sharedToolsService.retrieveMetadata()
        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties = processedMetadata.phenotypeSpecificPropertiesPerSampleGroup
        LinkedHashMap<String, List<String>> listOfPhenotypes = sharedToolsService.extractAPhenotypeListofGroups( phenotypeSpecificSampleGroupProperties )
       String phenotypesForTransmission = sharedToolsService.packageUpAHierarchicalListAsJson (listOfPhenotypes)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(phenotypesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }

    }


    def retrieveGwasSpecificPhenotypesAjax(){

        JSONObject jsonObject = sharedToolsService.retrieveMetadata()
        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap phenotypeMap = processedMetadata.gwasSpecificPhenotypes
        LinkedHashMap<String, List<String>> listOfPhenotypes = sharedToolsService.extractAPhenotypeListofGroups( phenotypeMap )
        String phenotypesForTransmission = sharedToolsService.packageUpAHierarchicalListAsJson (listOfPhenotypes)
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
     *
     */
    def variantSearchAndResultColumnsAjax() {
        String filtersRaw = params['keys']
        String propertiesRaw = params['properties']
        String filters = URLDecoder.decode(filtersRaw, "UTF-8")
        String properties = URLDecoder.decode(propertiesRaw, "UTF-8")
        LinkedHashMap requestedProperties = sharedToolsService.putPropertiesIntoHierarchy(properties)

        List<String> additionalProperties = []

        log.debug "variantSearch variantSearchAjax = ${filters}"


        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = restServerService.postRestCallFromFilters(filters,requestedProperties)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)

        LinkedHashMap resultColumnsToDisplay= restServerService.getColumnsToDisplay("[" + filters + "]",requestedProperties)
        JsonOutput resultColumnsJsonOutput = new JsonOutput()
        String resultColumnsJsonObjectString = resultColumnsJsonOutput.toJson(resultColumnsToDisplay)
        JSONObject resultColumnsJsonObject = slurper.parseText(resultColumnsJsonObjectString)

        //JsonSlurper slurper2 = new JsonSlurper()
        String jsonFormOfRelevantMetadata = sharedToolsService.packageUpATreeAsJson(sharedToolsService.getProcessedMetadata()?.phenotypeSpecificPropertiesPerSampleGroup)
        JSONObject metadataJsonObject = slurper.parseText(jsonFormOfRelevantMetadata)

        String jsonFormOfCommonProperties = sharedToolsService.sortAndPackageAMapOfListsAsJson(sharedToolsService.getProcessedMetadata()?.commonProperties, true)
        JSONObject commonPropertiesJsonObject = slurper.parseText(jsonFormOfCommonProperties)

        String jsonFormPropertiesPerSampleGroup = sharedToolsService.packageUpSortedHierarchicalListAsJson(sharedToolsService.getProcessedMetadata()?.propertiesPerOrderedSampleGroups)
        JSONObject propertiesPerSampleGroupJsonObject = slurper.parseText(jsonFormPropertiesPerSampleGroup)

        render(status: 200, contentType: "application/json") {
            [variants: dataJsonObject.variants,
            columns: resultColumnsJsonObject,
            filters:filtersRaw,
            metadata:metadataJsonObject,
            propertiesPerSampleGroup:propertiesPerSampleGroupJsonObject,
            cProperties:commonPropertiesJsonObject
            ]
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







    /***
     * This is the meat of dynamic filtering. Start with a list of filters (the filters are grouped into maps),
     * and convert these into three different products:
     * 1) a description of the filters that a user could understand
     * 2) a coded form of the filters we can pass down to the browser and expect to get back again
     * 3) the actual filters that were gonna send to the rest API, written out in JSON and ready to go
     * @param listOfParameterMaps
     * @param currentlySigma
     */
    private void displayCombinedVariantSearchResults(List<LinkedHashMap> listOfParameterMaps, List <LinkedHashMap> listOfProperties) {
        // Let's start stepping through our big list of filters
        LinkedHashMap parsedFilterParameters
        if (listOfParameterMaps) {
            for (LinkedHashMap singleParameterMap in listOfParameterMaps) {
                parsedFilterParameters = filterManagementService.parseExtendedVariantSearchParameters(singleParameterMap, false, parsedFilterParameters)
            }
        }
        if (parsedFilterParameters) {
            String requestForAdditionalProperties = filterManagementService.convertPropertyListToTransferableString(listOfProperties)
            Integer dataSetDetermination = filterManagementService.identifyAllRequestedDataSets(listOfParameterMaps)
            String encodedFilters = sharedToolsService.packageUpFiltersForRoundTrip(parsedFilterParameters.filters)
            String encodedParameters = sharedToolsService.packageUpEncodedParameters(parsedFilterParameters.parameterEncoding)
            if (parsedFilterParameters.transferableFilter){
                encodedParameters += "${encodedParameters},${parsedFilterParameters.transferableFilter.join(',')}"
            }
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
            String regionSpecifier = ""
            List<String> identifiedGenes = []
            if (parsedFilterParameters.positioningInformation.size() > 2) {
                regionSpecifier = "chr${parsedFilterParameters.positioningInformation.chromosomeSpecified}:${parsedFilterParameters.positioningInformation.beginningExtentSpecified}-${parsedFilterParameters.positioningInformation.endingExtentSpecified}"
                List<Gene> geneList = Gene.findAllByChromosome("chr" + parsedFilterParameters.positioningInformation.chromosomeSpecified)
                for (Gene gene in geneList) {
                    int startExtent = parsedFilterParameters.positioningInformation.beginningExtentSpecified as int
                    int endExtent = parsedFilterParameters.positioningInformation.endingExtentSpecified as int
                    if (((gene.addrStart > startExtent) && (gene.addrStart < endExtent)) ||
                            ((gene.addrEnd > startExtent) && (gene.addrEnd < endExtent))) {
                        identifiedGenes << gene.name1 as String
                    }

                }
            }



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
                            additionalProperties: requestForAdditionalProperties,
                            newApi              : sharedToolsService.getNewApi(),
                            regionSearch        : (parsedFilterParameters.positioningInformation.size() > 2),
                            regionSpecification : regionSpecifier,
                            geneNamesToDisplay  : identifiedGenes
                    ])
        }
    }



}
