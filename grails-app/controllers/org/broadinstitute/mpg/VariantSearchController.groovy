package org.broadinstitute.mpg

import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
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

    def retrieveJSTreeAjax(){
        def slurper = new JsonSlurper()
        String phenotypeName = params.phenotype
        String sampleGroupName = params.sampleGroup
        String convertedSampleGroupName = restServerService.convertKnownDataSetsToRealNames(sampleGroupName)
        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(convertedSampleGroupName)
        String jsonDescr = sharedToolsService.packageSampleGroupsHierarchicallyForJsTree(sampleGroup,phenotypeName)
        def result = slurper.parseText(jsonDescr)
        render(status: 200, contentType: "application/json") {
            result
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
        List<String> listOfFilters = getDataQueryHolder.listOfEncodedFilters()

        if ((listOfFilters) &&
                (listOfFilters.size() > 0)) {
            displayCombinedVariantSearch(listOfFilters, listOfProperties)
            return
        }

        // NOTE: we should never get here. Error condition, but a better way to fail
        log.error("relaunchAVariantSearch Was unable to process encoded parameters = ${encodedParameters}.")

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
//        String receivedParameters = params.filter
        String significanceString = params.sig//
        String dataset = params.dataset
        String region = params.region//
        String phenotype = params.phenotype//
        String parmType = params.parmType
        String parmVal = params.parmVal
        Float significance = 0f
        try {
            significance = Float.parseFloat(significanceString)
        } catch (ex) {
            log.error("receive nonnumeric significance value = (${params.sig}) in action=gene, VariantSearchController")
        }
        String technology = metaDataService.getTechnologyPerSampleGroup(dataset)

        List <String> listOfCodedFilters = []
        if (parmVal) { // MAF table
            List<String> listOfProperties = parmVal.tokenize("~")
            if (listOfProperties.size() > 4) {
                if ((listOfProperties[0] == "lowerValue") && (listOfProperties[2] == "higherValue")) {
                    String mafTechnology = listOfProperties[4]
                    Float lowerValue = 0F
                    Float higherValue = 1F
                    try {
                        lowerValue = Float.parseFloat(listOfProperties[1])
                    } catch (Exception e) {
                        log.error("Failed conversion of numbers from MAF request: low==${listOfProperties[1]}")
                        e.printStackTrace()
                    }
                    try {
                        higherValue = Float.parseFloat(listOfProperties[3])
                    } catch (Exception e) {
                        log.error("Failed conversion of numbers from MAF request: higher=${listOfProperties[3]}")
                        e.printStackTrace()
                    }
                    listOfCodedFilters.addAll(filterManagementService.generateSampleGroupLevelQueries(geneId, dataset, mafTechnology, lowerValue, higherValue, "MAF"))
                }
            }
        } else {  // variants and associations table
            listOfCodedFilters = filterManagementService.storeParametersInHashmap (geneId,significance,dataset,region,technology,phenotype)
        }

        //  we must have generated coded filters or we're going to be in trouble
        if ((listOfCodedFilters) &&
                (listOfCodedFilters.size() > 0)){
            displayCombinedVariantSearch(listOfCodedFilters,[])
            return
        }

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
     * Given a phenotype, return all matching technologies
     * @return
     */
    def retrieveTechnologiesAjax() {
        String phenotypeName
        if (params.phenotype) {
            phenotypeName = params.phenotype
            log.debug "variantSearch params.phenotype = ${params.phenotype}"
        }

        List<String> technologyList = this.metaDataService.getTechnologyListByPhenotypeAndVersion(phenotypeName,sharedToolsService.getCurrentDataVersion())
        String technologyListAsJson = sharedToolsService.packageUpAListAsJson(technologyList)
        def slurper = new JsonSlurper()
        def technologyListJsonObject = slurper.parseText(technologyListAsJson)

        render(status: 200, contentType: "application/json") {
            [technologyList:technologyListJsonObject]
        }
    }

    /***
     * Given one phenotype and one or more technologies, return every matching sample group
     * @return
     */
    def retrieveTopSGsByTechnologyAndPhenotypeAjax() {
        String phenotypeName
        if (params.phenotype) {
            phenotypeName = params.phenotype
            log.debug "variantSearch params.phenotype = ${params.phenotype}"
        }

        List<String> technologies = sharedToolsService.convertAnHttpList(params."technologies[]")

        List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups( phenotypeName,"",  technologies)

        JSONObject sampleGroupMapJsonObject = filterManagementService.convertSampleGroupListToJson(fullListOfSampleGroups, phenotypeName)

        render(status: 200, contentType: "application/json") {
            [sampleGroupMap:sampleGroupMapJsonObject]
        }
    }

    /***
     * Given a single phenotype and a single technology, get a list of all relevant ancestries. We can make this happen by
     * retrieving all of the matching sample groups, and from these retrieving all ancestries (filtered for uniqueness)
     * @return
     */
    def retrieveAncestriesAjax() {
        String phenotypeName
        String technologyName
        if (params.phenotype) {
            phenotypeName = params.phenotype
        }
        if (params.technology) {
            technologyName = params.technology
        }

        List<SampleGroup> sampleGroupList = this.metaDataService.getSampleGroupForPhenotypeDatasetTechnologyAncestry(phenotypeName,"",
                technologyName,
                sharedToolsService.getCurrentDataVersion(), "")
        List<String> ancestryList = sampleGroupList.unique{ a,b -> a.getAncestry() <=> b.getAncestry() }*.getAncestry()
        String ancestryListAsJson = sharedToolsService.packageUpAListAsJson(ancestryList)
        def slurper = new JsonSlurper()
        def ancestryListJsonObject = slurper.parseText(ancestryListAsJson)

        render(status: 200, contentType: "application/json") {
            [ancestryList:ancestryListJsonObject]
        }
    }



    /***
     * Given a combination of one phenotype, one technology, and one ancestry, return a list of all matching sample groups
     *
     * @return
     */
    def retrieveSampleGroupsAjax() {
        String phenotypeName
        String technologyName
        String ancestryName
        if (params.phenotype) {
            phenotypeName = params.phenotype
        }
        if (params.technology) {
            technologyName = params.technology
        }
        if (params.ancestry) {
            ancestryName = params.ancestry
        }

        List<SampleGroup> sampleGroupList = this.metaDataService.getSampleGroupForPhenotypeDatasetTechnologyAncestry(phenotypeName,"",
                technologyName,
                sharedToolsService.getCurrentDataVersion(), ancestryName)
        JSONObject dataSetMapJsonObject = filterManagementService.convertSampleGroupListToJson(sampleGroupList, phenotypeName)

        render(status: 200, contentType: "application/json") {
            [dataSetList:dataSetMapJsonObject]
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
            filters:revisedFiltersRaw,
            metadata:metadata,
            propertiesPerSampleGroup:propertiesPerSampleGroupJsonObject,
            cProperties:commonPropertiesJsonObject
            ]
        }

    }






    private void displayCombinedVariantSearch(List <String> listOfCodedFilters, List <LinkedHashMap> listOfProperties) {
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(listOfCodedFilters,searchBuilderService,metaDataService)
        if (getDataQueryHolder.isValid()) {
            String requestForAdditionalProperties = filterManagementService.convertPropertyListToTransferableString(listOfProperties)
            String revisedFiltersRaw = java.net.URLEncoder.encode(getDataQueryHolder.retrieveAllFiltersAsJson())
             List<String> encodedFilters = getDataQueryHolder.listOfEncodedFilters()
            List<String> urlEncodedFilters = getDataQueryHolder.listOfUrlEncodedFilters(encodedFilters)
            List<String> displayableFilters = getDataQueryHolder.listOfReadableFilters(encodedFilters)
            LinkedHashMap genomicExtents = sharedToolsService.validGenomicExtents (getDataQueryHolder.retrieveGetDataQuery())
            List<String> identifiedGenes = sharedToolsService.allEncompassedGenes(genomicExtents)
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
            String regionSpecifier = ""
            LinkedHashMap<String,String> positioningInformation = getDataQueryHolder.positioningInformation()
            if (positioningInformation.size() > 2) {
                regionSpecifier = "chr${positioningInformation.chromosomeSpecified}:${positioningInformation.beginningExtentSpecified}-${positioningInformation.endingExtentSpecified}"
                List<Gene> geneList = Gene.findAllByChromosome("chr" + positioningInformation.chromosomeSpecified)
                for (Gene gene in geneList) {
                    try {
                        int startExtent = positioningInformation.beginningExtentSpecified as Long
                        int endExtent = positioningInformation.endingExtentSpecified as Long
                        if (((gene.addrStart > startExtent) && (gene.addrStart < endExtent)) ||
                                ((gene.addrEnd > startExtent) && (gene.addrEnd < endExtent))) {
                            identifiedGenes << gene.name1 as String
                        }
                    } catch (e) {
                        redirect(controller: 'home', action: 'portalHome')
                    }

                }
            }



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
                            regionSearch        : (positioningInformation.size() > 2),
                            regionSpecification : regionSpecifier,
                            geneNamesToDisplay  : identifiedGenes
                    ])
        }
    }




}
