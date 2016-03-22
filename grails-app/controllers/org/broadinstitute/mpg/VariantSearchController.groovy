package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

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
        JSONObject result = sharedToolsService.packageUpAHierarchicalListAsJson (propertyTree)

        // process `result` so that metadata is translated
        String[] keys = result.dataset.keySet().toArray()
        LinkedHashMap<String, String[]> translatedNames = []

        LinkedHashMap<String, Object> toReturn = []
        toReturn.is_error = result.is_error
        toReturn.numRecords = result.numRecords

        for( int j=0; j < keys.length; j++) {
            def key = keys[j];
            translatedNames[key] = new ArrayList<String>()
            String[] termsToProcess = result.dataset[key]
            for( int i=0; i < termsToProcess.length; i++ ) {
                String thisTerm = termsToProcess[i]
                translatedNames[key] << [thisTerm, g.message(code:"metadata." + thisTerm, default: thisTerm)]
            }
        }

        toReturn.dataset = translatedNames

        render(status: 200, contentType: "application/json") {
            [datasets: toReturn]
        }

    }

    def retrieveJSTreeAjax(){
        def slurper = new JsonSlurper()
        String phenotypeName = params.phenotype
        String sampleGroupName = params.sampleGroup
        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(sampleGroupName)

        if (sampleGroup?.sampleGroupList?.size()>0){
            sampleGroup.sampleGroupList = sampleGroup.sampleGroupList.sort{g.message(code:"metadata." + it.systemId, default: it.systemId)}
        }
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
        JSONObject result = sharedToolsService.packageUpAHierarchicalListAsJson (propertyTree)

        // process `result` so that metadata is translated
        String[] keys = result.dataset.keySet().toArray()
        LinkedHashMap<String, String> translatedNames = []

        LinkedHashMap<String, Object> toReturn = []
        toReturn.is_error = result.is_error
        toReturn.numRecords = result.numRecords

        for( int j=0; j < keys.length; j++) {
            def key = keys[j];
            translatedNames[key] = new ArrayList<String>()
            String[] termsToProcess = result.dataset[key]
            for( int i=0; i < termsToProcess.length; i++ ) {
                String thisTerm = termsToProcess[i]
                translatedNames[key] << [thisTerm, g.message(code:"metadata." + thisTerm, default: thisTerm)]
            }
        }

        toReturn.dataset = translatedNames

        render(status: 200, contentType: "application/json") {
            [datasets: toReturn]
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

        JSONArray jsonQueries = new JSONArray()

        if ((encParams) && (encParams.length()>0)) {
            String urlDecodedEncParams = URLDecoder.decode(encParams.trim())
            // urlDecodedEncParams are in the old query format (ex. "17=T2D[GWAS_DIAGRAM_mdv2]P_VALUE<1")
            // need to convert that back to JSON before handing back to the client
            // trim the opening and closing bracket from the array-turned-into-a-string
            String trimmedParams = urlDecodedEncParams[1..-2];
            List<String> listOfParams = trimmedParams.split(',')

            // This is broken out here because we don't know what chromosome-related
            // params we might have--could have none, just a chromosome number, or
            // a chromosome number + start/end. So, dump anything chromosome-related
            // here, then process it afterwards
            JSONObject chromosomeQuery = []

            for(int i = 0; i < listOfParams.size(); i++) {
                String currentQuery = listOfParams[i]
                JSONObject processedQuery = []

                // id is the field that identifies what property the query refers to
                def (id, data) = currentQuery.trim().split('=')
                switch(id) {
                    case '7':
                        // gene
                        processedQuery = [
                            prop: 'gene',
                            translatedName: 'gene',
                            value: data,
                            comparator: '='
                        ]
                        jsonQueries << processedQuery
                        break;
                    case ['8','9','10']:
                        chromosomeQuery[id] = data;
                        break;
                    case '11':
                        // predicted effect
                        def (specificEffect, value) = data.split(/\|/)
                        processedQuery = [
                            prop: specificEffect,
                            translatedName: g.message(code:'metadata.'+specificEffect, default: specificEffect),
                            value: value,
                            comparator: '='
                        ]
                        jsonQueries << processedQuery
                        break;
                    case '17':
                        // every other query--looks like
                        // "T2D[GWAS_DIAGRAM_mdv2]ODDS_RATIO<2"
                        def (phenotype, restOfQuery) = data.split(/\[/)
                        def (dataset, param) = restOfQuery.split(/\]/)
                        // split the param (ex. ODDS_RATION<2)--the comparator can be <, >, or =
                        def prop, comparator, value
                        if(param.indexOf('<') > -1) {
                            (prop, value) = param.split(/\</)
                            comparator = '<'
                        } else if (param.indexOf('=') > -1) {
                            (prop, value) = param.split(/\=/)
                            comparator = '='
                        } else if (param.indexOf('>') > -1) {
                            (prop, value) = param.split(/\>/)
                            comparator = '>'
                        }
                        processedQuery = [
                            phenotype: phenotype,
                            translatedPhenotype: g.message(code: 'metadata.' + phenotype, default: phenotype),
                            dataset: dataset,
                            translatedDataset: g.message(code: 'metadata.' + dataset, default: dataset),
                            prop: prop,
                            translatedName: g.message(code: 'metadata.' + prop, default: prop),
                            comparator: comparator,
                            value: value
                        ]
                        jsonQueries << processedQuery
                        break;
                }
            }

            // see if chromosomeQuery has key 8 defined--if it does, then we have
            // something and should also see if keys 9/10 are defined
            if( chromosomeQuery['8'] ) {
                JSONObject processedChromosomeQuery = [
                    prop: 'chromosome',
                    translatedName: 'chromosome',
                    comparator: '='
                ]
                if( chromosomeQuery['9'] && chromosomeQuery['10'] ) {
                    processedChromosomeQuery.value = chromosomeQuery['8'] + ':' + chromosomeQuery['9'] + '-' + chromosomeQuery['10']
                } else {
                    processedChromosomeQuery.value = chromosomeQuery['8']
                }
                jsonQueries << processedChromosomeQuery
            }
        }

        render(view: 'variantWorkflow',
                model: [show_gwas : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq: sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        variantWorkflowParmList:[],
                        encodedFilterSets: URLEncoder.encode(jsonQueries.toString())])
    }



    /***
     * This call occurs when you press the 'submit search request' button.
     * @return
     */
    def launchAVariantSearch(){
        // process the incoming JSON and build strings reflecting what the server is expecting
        def jsonSlurper = new JsonSlurper();
        String decodedQuery = URLDecoder.decode(request.queryString)
        ArrayList<JSONObject> listOfQueries = jsonSlurper.parseText(decodedQuery)

        ArrayList<String> computedStrings = new ArrayList<String>();

        for(int i = 0; i < listOfQueries.size(); i++) {
            JSONObject currentQuery = listOfQueries[i]
            String processedQuery;
            // if there is a phenotype defined, this is a query that has a
            // phenotype, dataset, prop, comparator, and value
            if( currentQuery.phenotype ) {
                processedQuery = '17=' +
                                 currentQuery.phenotype + '[' + currentQuery.dataset + ']' +
                                 currentQuery.prop + currentQuery.comparator + currentQuery.value
                computedStrings << processedQuery
            } else {
                switch(currentQuery.prop) {
                    case 'gene':
                        // convert gene into chromosome and start/end points
                        // also be prepared to handle ±value

                        // assume that value is just the gene name
                        def gene = currentQuery.value
                        def adjustment

                        // if the gene contains '±', then split to get the start and end
                        // adjustments
                        if(gene.indexOf('±') > -1) {
                            (gene, adjustment) = currentQuery.value.split(' ± ')
                        }
                        Gene geneObject = Gene.retrieveGene(gene)
                        String chromosome = geneObject.getChromosome()
                        Long start = geneObject.getAddrStart()
                        Long end = geneObject.getAddrEnd()
                        if(adjustment) {
                            start -= Integer.parseInt(adjustment)
                            end += Integer.parseInt(adjustment)
                        }
                        // trim off 'chr' before the chromosome number
                        processedQuery = '8=' + chromosome.substring(3)
                        computedStrings << processedQuery
                        processedQuery = '9=' + start
                        computedStrings << processedQuery
                        processedQuery = '10=' + end
                        computedStrings << processedQuery
                        break;
                    case 'chromosome':
                        // there are two types of inputs: either of the form <chromosome> or
                        // the form <chrom>:<start>-<end>
                        if(currentQuery.value =~ /^\d{1,2}$/ ) {
                            // we have just the chromosome number
                            processedQuery = '8=' + currentQuery.value;
                            computedStrings << processedQuery
                        } else {
                            // looks like <chrom>:<start>-<end>
                            // first split chrom from start/end
                            def (chromNumber, startEnd) = currentQuery.value.split(':')
                            def (start, end) = startEnd.split('-')
                            processedQuery = '8=' + chromNumber
                            computedStrings << processedQuery
                            processedQuery = '9=' + start
                            computedStrings << processedQuery
                            processedQuery = '10=' + end
                            computedStrings << processedQuery
                        }
                        break;
                    case [PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY, PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY, PortalConstants.JSON_VARIANT_SIFT_PRED_KEY, PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY]:
                        processedQuery = '11=' + currentQuery.prop + '|' + currentQuery.value
                        computedStrings << processedQuery
                        break;
                }
            }

        }

        if ((computedStrings) &&
                (computedStrings.size() > 0)){
            displayCombinedVariantSearch(computedStrings,[])
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
            String technology = metaDataService.getTechnologyPerSampleGroup(dataset)
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

        JSONObject result = this.metaDataService.getSampleGroupNameListForPhenotypeAsJson(params.phenotype)
        JSONObject sampleGroupForTransmission  = [sampleGroup: dataset]

        render(status: 200, contentType: "application/json") {
            [datasets: result,
             sampleGroup:sampleGroupForTransmission]
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
        JSONObject technologyListJsonObject = sharedToolsService.packageUpAListAsJson(technologyList)

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
        JSONObject ancestryListAsJson = sharedToolsService.packageUpAListAsJson(ancestryList)

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

        List <String> listOfProperties = metaDataService.getAllMatchingPropertyList(datasetChoice,params.phenotype)
        JSONObject result = sharedToolsService.packageUpAListAsJson(listOfProperties)

        // attach translated names
        ArrayList<JSONObject> translatedObjects = new ArrayList<JSONObject>()
        for(int i = 0; i < result.dataset.size(); i++) {
            String prop = result.dataset[i]
            JSONObject translated = [
                prop: prop,
                translatedName: g.message(code: "metadata." + prop, default: prop)
            ]
            translatedObjects << translated
        }

        result.dataset = translatedObjects

        render(status: 200, contentType: "application/json") {
            [datasets: result,
             chosenDataset:datasetChoice]
        }

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
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JSONObject dataJsonObject = restServerService.postDataQueryRestCall(getDataQueryHolder)

        JSONObject resultColumnsJsonObject = resultColumnsToDisplay as JSONObject

        LinkedHashMap fullPropertyTree = metaDataService.getFullPropertyTree()
        LinkedHashMap fullSampleTree = metaDataService.getSampleGroupTree()

        JSONObject metadata = sharedToolsService.packageUpATreeAsJson(fullPropertyTree)

        JSONObject commonPropertiesJsonObject = this.metaDataService.getCommonPropertiesAsJson(true);

        JSONObject propertiesPerSampleGroupJsonObject = sharedToolsService.packageUpSortedHierarchicalListAsJson(fullSampleTree)

        // prepare translation object
        // this object contains metadata translations, where the database-form metadata
        // text is a key to the translated text (ex. T2D -> Type 2 Diabetes).
        // metadataNames contains most of what we need, but doesn't contain strings of the
        // type <datasource>_<metadataVersion> (ex. GWAS_DIAGRAM_mdv2), so also go through
        // the datasources applicable to this request
        // (found in propertiesPerSampleGroupJsonObject.dataset) and add those strings to
        // metadataNames
        Set<String> metadataNames = metaDataService.parseMetadataNames()
        Set<String> datasetNames = propertiesPerSampleGroupJsonObject.dataset.keySet()
        metadataNames.addAll(datasetNames)

        JSONObject translationDictionary = []
        metadataNames.each { name ->
            translationDictionary[name] = g.message(code: "metadata." + name, default: name)
        }

        render(status: 200, contentType: "application/json") {
            [variants: dataJsonObject.variants,
            columns: resultColumnsJsonObject,
            filters:revisedFiltersRaw,
            metadata:metadata,
            propertiesPerSampleGroup:propertiesPerSampleGroupJsonObject,
            cProperties:commonPropertiesJsonObject,
            translationDictionary: translationDictionary
            ]
        }

    }






    private void displayCombinedVariantSearch(List <String> listOfCodedFilters, List <LinkedHashMap> listOfProperties) {
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(listOfCodedFilters,searchBuilderService,metaDataService)
        if (getDataQueryHolder.isValid()) {
            String requestForAdditionalProperties = filterManagementService.convertPropertyListToTransferableString(listOfProperties)
            String revisedFiltersRaw = URLEncoder.encode(getDataQueryHolder.retrieveAllFiltersAsJson())
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

            // get locale to provide to table-building plugin
            String locale = RequestContextUtils.getLocale(request)
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
                            geneNamesToDisplay  : identifiedGenes,
                            locale              : locale
                    ])
        }
    }




}
