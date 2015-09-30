package dport
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.metadata.query.JsNamingQueryTranslator
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {
    FilterManagementService filterManagementService
    RestServerService restServerService
    SharedToolsService sharedToolsService
    MetaDataService metaDataService
    SearchBuilderService searchBuilderService
    private static final log = LogFactory.getLog(this)

    def index() {}


    /***
     *   Pull back a phenotype hierarchy across all data sets
     * @return
     */
    def retrievePhenotypesAjax(){
        LinkedHashMap<String, List<String>> propertyTree = metaDataService.getHierarchicalPhenotypeTree()
        String phenotypesForTransmission = sharedToolsService.packageUpAHierarchicalListAsJson (propertyTree)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(phenotypesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }

    }

    /***
     * Pullback of phenotypes hierarchy, though only for GWAS data
     * @return
     */
    def retrieveGwasSpecificPhenotypesAjax(){
        LinkedHashMap<String, List<String>> propertyTree = metaDataService.getHierarchicalPhenotypeTree()
        String phenotypesForTransmission = sharedToolsService.packageUpAHierarchicalListAsJson (propertyTree)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(phenotypesForTransmission)


        render(status: 200, contentType: "application/json") {
            [datasets: result]
        }

    }

    /***
     *  Someone has requested the 'search builder' page.  If they are coming to this page without a search
     *  context then encParamswill be empty.   If instead they are trying to revise their search then
     *  encParams is going to hold a list of every encoded filter that they want to use.
     *
     * @return
     */
    def variantSearchWF() {
        String encParams
        if (params.encParams) {
            encParams = params.encParams
            log.debug "variantSearch params.encParams = ${params.encParams}"
        }
        List<LinkedHashMap> encodedFilterSets = []
        List<String> encodedFilters
        GetDataQueryHolder getDataQueryHolder
        List<String> urlEncodedFilters

        if ((encParams) && (encParams.length()>0)) {
            String urlDecodedEncParams = URLDecoder.decode(encParams.trim())
            getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(urlDecodedEncParams?.replaceAll(~/,/,"^") , searchBuilderService, metaDataService)
            encodedFilters = getDataQueryHolder.listOfEncodedFilters()
            urlEncodedFilters = getDataQueryHolder.listOfUrlEncodedFilters(encodedFilters)
//            for ( int  i = 0 ; i < encodedFilters.size() ; i++ ) {
//
//                String encodedFilter = encodedFilters[i];
//                List<String> decodedPieces=  encodedFilter.split("=");
//
//                // make sure we have two parts
//                if (decodedPieces.size() > 1) {
//                    encodedFilterSets << ["filter${i}": decodedPieces[1]]
//                }
//            }
        }

        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        variantWorkflowParmList:[],
                        encodedFilterSets : encodedFilters])
    }



    /***
     * This call occurs when you press the 'submit search request' button.
     * @return
     */
    def launchAVariantSearch(){
        log.info("got params: " + params);
        List <String> listOfCodedFilters = filterManagementService.observeMultipleFilters (params)
        if ((listOfCodedFilters) &&
                (listOfCodedFilters.size() > 0)){
            displayCombinedVariantSearch(listOfCodedFilters,[])
            return
        }

//
//        List <LinkedHashMap> combinedFilters =  filterManagementService.handleFilterRequestFromBrowser (params)
//
//        List <LinkedHashMap> listOfParameterMaps = filterManagementService.storeCodedParametersInHashmap (combinedFilters)
//
//        List <LinkedHashMap> listOfProperties = []
//
//        if ((listOfParameterMaps) &&
//                (listOfParameterMaps.size() > 0)){
//            displayCombinedVariantSearchResults(listOfParameterMaps, listOfProperties)
//        }


    }

    /***
     * I think the action below is never, ever used.
     * @return
     */
    def relaunchAVariantSearch() {
        String encodedParameters = params.encodedParameters

        String urlDecodedEncParams = URLDecoder.decode(encodedParameters.trim())
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(urlDecodedEncParams?.replaceAll(~/,/,"^") , searchBuilderService, metaDataService)

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
//        List<LinkedHashMap> combinedFilters = sharedToolsService.convertFormOfFilters(encodedParameters)
//        List<LinkedHashMap> listOfParameterMaps = filterManagementService.storeCodedParametersInHashmap(combinedFilters)
        List<String> listOfFilters = getDataQueryHolder.listOfEncodedFilters()

        if ((listOfFilters) &&
                (listOfFilters.size() > 0)) {
            displayCombinedVariantSearch(listOfFilters, listOfProperties)
            return
        }

        // NOTE: we should never get here. Error condition, but a better way to fail
        log.error("relaunchAVariantSearch Was unable to process encoded parameters = ${encodedParameters}.")
      //  displayCombinedVariantSearchResults(listOfParameterMaps, listOfProperties)


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


        List <String> listOfCodedFilters = filterManagementService.observeMultipleFilters (paramsMap)
        if ((listOfCodedFilters) &&
                (listOfCodedFilters.size() > 0)){
            displayCombinedVariantSearch(listOfCodedFilters,[])
            return
        }


//        if (paramsMap) {
//
//            List <LinkedHashMap> listOfProperties = []
//
//            displayCombinedVariantSearchResults([paramsMap], listOfProperties)
//           // displayVariantSearchResults(paramsMap, false)
//        }

    }


    /***
     * get data sets given a phenotype.  This Ajax call takes place on the search builder page after
     * choosing a phenotype
     * @return
     */
    def retrieveDatasetsAjax() {
        List <String> phenotypeList = []
        String dataset = ""
        if((params.phenotype) && (params.phenotype !=  null )){
            phenotypeList << params.phenotype
        }
        if ((params.dataset) && (params.dataset !=  null )){
            dataset = params.dataset
        }

        // DIGP_60: using new medatata data structure to retrieve datasets
        String dataSetString = this.metaDataService.getSampleGroupNameListForPhenotypeAsJson(params.phenotype);
        def slurper = new JsonSlurper()
        def result = slurper.parseText(dataSetString)
        String sampleGroupForTransmission  = """{"sampleGroup":"${dataset}"}"""
        def defaultSampleGroup = slurper.parseText(sampleGroupForTransmission)

        render(status: 200, contentType: "application/json") {
            [datasets: result,
             sampleGroup:defaultSampleGroup]
        }
    }





    /***
     * get properties given a data set. This Ajax call takes place on the search builder
     * after selecting a data set.
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

        List <String> listOfProperties = metaDataService.getAllMatchingPropertyList(datasetChoice,params.phenotype)

        String propertiesForTransmission = sharedToolsService.packageUpAListAsJson (listOfProperties)
        def slurper = new JsonSlurper()
        def result = slurper.parseText(propertiesForTransmission)

        render(status: 200, contentType: "application/json") {
            [datasets: result,
             chosenDataset:datasetChoice]
        }

    }

    /***
     * this is the action associated with the 'build a request' button
     * @return
     */
    def variantVWRequest(){

        LinkedHashMap encodedFilterSets = filterManagementService.handleFilterRequestFromBrowser (params)
        List<String> encodedFilterList = encodedFilterSets.values() as List<String>
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(encodedFilterList,searchBuilderService,metaDataService)
        List <String> encodedFilters = getDataQueryHolder.listOfEncodedFilters()

        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        encodedFilterSets : getDataQueryHolder.listOfEncodedFilters()])

    }





    /***
     *  This is the main variant page. Wait a minute: how does this differ from launch a variant search?
     */
    def variantSearchAndResultColumnsAjax() {
        String filtersRaw = params['keys']
        String propertiesRaw = params['properties']
        String filters = URLDecoder.decode(filtersRaw, "UTF-8")
        String properties = URLDecoder.decode(propertiesRaw, "UTF-8")
        LinkedHashMap requestedProperties = sharedToolsService.putPropertiesIntoHierarchy(properties)

        log.debug "variantSearch variantSearchAjax = ${filters}"

        // build up filters our data query
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters,searchBuilderService,metaDataService)
        String revisedFiltersRaw = java.net.URLEncoder.encode(getDataQueryHolder.retrieveAllFiltersAsJson())

        // determine columns to display
        LinkedHashMap resultColumnsToDisplay= restServerService.getColumnsToDisplay("[${getDataQueryHolder.retrieveAllFiltersAsJson()}]",requestedProperties)

        // make the call to REST server
        JsonSlurper slurper = new JsonSlurper()
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        String dataJsonObjectString = restServerService.postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)

        JsonOutput resultColumnsJsonOutput = new JsonOutput()
        String resultColumnsJsonObjectString = resultColumnsJsonOutput.toJson(resultColumnsToDisplay)
        JSONObject resultColumnsJsonObject = slurper.parseText(resultColumnsJsonObjectString)

        LinkedHashMap fullPropertyTree = metaDataService.getFullPropertyTree()
        LinkedHashMap fullSampleTree = metaDataService.getSampleGroupTree()

        String jsonFormOfRelevantMetadataPhenotype = sharedToolsService.packageUpATreeAsJson(fullPropertyTree)
        JSONObject metadata = slurper.parseText(jsonFormOfRelevantMetadataPhenotype)

        String jsonFormOfCommonProperties = this.metaDataService.getCommonPropertiesAsJson(true);
        JSONObject commonPropertiesJsonObject = slurper.parseText(jsonFormOfCommonProperties)

        String jsonFormPropertiesPerSampleGroup = sharedToolsService.packageUpSortedHierarchicalListAsJson(fullSampleTree)
        JSONObject propertiesPerSampleGroupJsonObject = slurper.parseText(jsonFormPropertiesPerSampleGroup)

        render(status: 200, contentType: "application/json") {
            [variants: dataJsonObject.variants,
            columns: resultColumnsJsonObject,
           // filters:filtersRaw,
            filters:revisedFiltersRaw,
            metadata:metadata,
            propertiesPerSampleGroup:propertiesPerSampleGroupJsonObject,
            cProperties:commonPropertiesJsonObject
            ]
        }

    }






    private void displayCombinedVariantSearch(List <String> listOfCodedFilters, List <LinkedHashMap> listOfProperties) {
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(listOfCodedFilters,searchBuilderService,metaDataService)
        // Let's start stepping through our big list of filters
        if (getDataQueryHolder.isValid()) {
            String requestForAdditionalProperties = filterManagementService.convertPropertyListToTransferableString(listOfProperties)
            String revisedFiltersRaw = java.net.URLEncoder.encode(getDataQueryHolder.retrieveAllFiltersAsJson())
            //String encodedFilters = filterManagementService.convertFilterListToTransferableString(getDataQuery)
            //List<String> displayableFilters = filterManagementService.convertFilterListToDisplayableString(getDataQuery)
            List<String> encodedFilters = getDataQueryHolder.listOfEncodedFilters()
            List<String> urlEncodedFilters = getDataQueryHolder.listOfUrlEncodedFilters(encodedFilters)
            List<String> displayableFilters = getDataQueryHolder.listOfReadableFilters(encodedFilters)
            LinkedHashMap genomicExtents = sharedToolsService.validGenomicExtents (getDataQueryHolder.retrieveGetDataQuery())
            List<String> identifiedGenes = sharedToolsService.allEncompassedGenes(genomicExtents)
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
            String regionSpecifier = ""




            render(view: 'variantSearchResults',
                    model: [show_gene           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                            show_gwas           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            filterForResend     : urlEncodedFilters.join("^"), //encodedFilters,
                            filter              : revisedFiltersRaw, //encodedFilters,
                            filterDescriptions  : displayableFilters,
                            proteinEffectsList  : encodedProteinEffects,
                            encodedFilters      : encodedFilters,
                            encodedParameters   : urlEncodedFilters,
                            dataSetDetermination: 2,
                            additionalProperties: requestForAdditionalProperties,
                            regionSearch        : (genomicExtents.size() > 0),
                            regionSpecification : regionSpecifier,
                            geneNamesToDisplay  : identifiedGenes
                    ])
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
                encodedParameters = "${encodedParameters},${parsedFilterParameters.transferableFilter.join(',')}"
            }
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
            String regionSpecifier = ""
            List<String> identifiedGenes = []
            if (parsedFilterParameters.positioningInformation.size() > 2) {
                regionSpecifier = "chr${parsedFilterParameters.positioningInformation.chromosomeSpecified}:${parsedFilterParameters.positioningInformation.beginningExtentSpecified}-${parsedFilterParameters.positioningInformation.endingExtentSpecified}"
                List<Gene> geneList = Gene.findAllByChromosome("chr" + parsedFilterParameters.positioningInformation.chromosomeSpecified)
                for (Gene gene in geneList) {
                    try {
                        int startExtent = parsedFilterParameters.positioningInformation.beginningExtentSpecified as Long
                        int endExtent = parsedFilterParameters.positioningInformation.endingExtentSpecified as Long
                        if (((gene.addrStart > startExtent) && (gene.addrStart < endExtent)) ||
                                ((gene.addrEnd > startExtent) && (gene.addrEnd < endExtent))) {
                            identifiedGenes << gene.name1 as String
                        }
                    } catch (e){
                        redirect(controller:'home',action:'portalHome')
                    }

                }
            }



            render(view: 'variantSearchResults',
                    model: [show_gene           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                            show_gwas           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            filter              : encodedFilters,
                            filterDescriptions  : parsedFilterParameters.filterDescriptions,
                            proteinEffectsList  : encodedProteinEffects,
                            encodedParameters   : encodedParameters,
                            dataSetDetermination: dataSetDetermination,
                            additionalProperties: requestForAdditionalProperties,
                            regionSearch        : (parsedFilterParameters.positioningInformation.size() > 2),
                            regionSpecification : regionSpecifier,
                            geneNamesToDisplay  : identifiedGenes
                    ])
        }
    }



}
