package org.broadinstitute.mpg

import grails.converters.JSON
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.*
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
    WidgetService widgetService
    EpigenomeService epigenomeService
    private static final log = LogFactory.getLog(this)

    def index() {}

    /***
     *   Pull back a phenotype hierarchy across all data sets
     * @return
     */
    def retrievePhenotypesAjax() {
        // specify whether to include the NONE phenotype--if this is unspecified,
        // default to no
        LinkedHashMap<String, List <List <String>>>  groupedPhenotypesNames = widgetService.retrieveGroupedPhenotypesNames('')

        JSONObject result2 = [
                dataset: new JSONObject()
        ]
        result2["datasetOrder"] = new JSONArray()
        for (String groupName in groupedPhenotypesNames.keySet()){
            (result2["datasetOrder"] as JSONArray).add(groupName)
            result2.dataset[groupName] = new JSONArray()
            JSONArray phenoParts = new JSONArray()
            for (List phenoDetails in groupedPhenotypesNames[groupName]){
                phenoParts.add(phenoDetails)
            }
            result2.dataset[groupName] = phenoParts

        }
        result2.is_error = false
        result2.numRecords = groupedPhenotypesNames.keySet()?.size()

        render(status: 200, contentType: "application/json") {
            [datasets: result2]
        }

    }

    def retrieveJSTreeAjax() {
        def slurper = new JsonSlurper()
        String phenotypeName = params.phenotype
        String sampleGroupName = params.sampleGroup
        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(sampleGroupName, MetaDataService.METADATA_VARIANT)

        if (sampleGroup?.sampleGroupList?.size() > 0) {
            sampleGroup.sampleGroupList = sampleGroup.sampleGroupList.sort {
                g.message(code: "metadata." + it.systemId, default: it.systemId)
            }
        }
        String jsonDescr = sharedToolsService.packageSampleGroupsHierarchicallyForJsTree(sampleGroup, phenotypeName)
        def result = new JSONObject()
        if ((jsonDescr) && (jsonDescr.length() > 0)) {
            result = slurper.parseText(jsonDescr)
        }
        render(status: 200, contentType: "application/json") {
            result
        }

    }

    /***
     * Pullback of phenotypes hierarchy, though only for GWAS data
     * @return
     */
    def retrieveGwasSpecificPhenotypesAjax() {

        LinkedHashMap<String, List<String>> propertyTree = metaDataService.getHierarchicalPhenotypeTree()
        LinkedHashMap<String, List <List <String>>>  groupedPhenotypesNames = widgetService.retrieveGroupedPhenotypesNames('GWAS')

        JSONObject result2 = [
                dataset: new JSONObject()
        ]
        result2["datasetOrder"] = new JSONArray()
        for (String groupName in groupedPhenotypesNames.keySet()){
            (result2["datasetOrder"] as JSONArray).add(groupName)
            result2.dataset[groupName] = new JSONArray()
            JSONArray phenoParts = new JSONArray()
            for (List phenoDetails in groupedPhenotypesNames[groupName]){
                phenoParts.add(phenoDetails)
            }
            result2.dataset[groupName] = phenoParts

        }
        result2.is_error = false
        result2.numRecords = groupedPhenotypesNames.keySet()?.size()

        render(status: 200, contentType: "application/json") {
            [datasets: result2]
        }

    }

    // take a query of the form "17=T2D[DIAGRAM_GWAS]P_VAL<1" and convert it to JSON
    private ArrayList<JSONObject> encodedFiltersToJSON(ArrayList<String> listOfParams) {
        // This is broken out here because we don't know what chromosome-related
        // params we might have--could have none, just a chromosome number, or
        // a chromosome number + start/end. So, dump anything chromosome-related
        // here, then process it afterwards
        JSONObject chromosomeQuery = []

        ArrayList<JSONObject> jsonQueries = new ArrayList<JSONObject>()

        for (int i = 0; i < listOfParams.size(); i++) {
            String currentQuery = listOfParams[i]
            JSONObject processedQuery

            // id is the field that identifies what property the query refers to
            def (id, data) = currentQuery.trim().split('=')
            switch (id) {
                case '7':
                    // gene
                    processedQuery = [
                            prop          : 'gene',
                            translatedName: 'gene',
                            value         : data,
                            comparator    : '='
                    ]
                    jsonQueries << processedQuery
                    break;
                case ['8', '9', '10']:
                    chromosomeQuery[id] = data;
                    break;
                case '11':
                    // predicted effect
                    def specificEffect, comparator, value
                    if (data.indexOf('<') > -1) {
                        (specificEffect, value) = data.split(/\</)
                        comparator = '<'
                    } else if (data.indexOf('|') > -1) {
                        (specificEffect, value) = data.split(/\|/)
                        comparator = '='
                    } else if (data.indexOf('>') > -1) {
                        (specificEffect, value) = data.split(/\>/)
                        comparator = '>'
                    }
                    processedQuery = [
                            prop          : specificEffect,
                            translatedName: g.message(code: 'metadata.' + specificEffect, default: specificEffect),
                            value         : value,
                            comparator    : comparator
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
                    if (param.indexOf('<') > -1) {
                        (prop, value) = param.split(/\</)
                        comparator = '<'
                    } else if (param.indexOf('=') > -1) {
                        (prop, value) = param.split(/\=/)
                        comparator = '='
                    } else if (param.indexOf('|') > -1) {
                        (prop, value) = param.split(/\|/)
                        comparator = '='
                    } else if (param.indexOf('>') > -1) {
                        (prop, value) = param.split(/\>/)
                        comparator = '>'
                    }
                    processedQuery = [
                            phenotype          : phenotype,
                            translatedPhenotype: g.message(code: 'metadata.' + phenotype, default: phenotype),
                            dataset            : dataset,
                            translatedDataset  : g.message(code: 'metadata.' + dataset, default: dataset),
                            prop               : prop,
                            translatedName     : g.message(code: 'metadata.' + prop, default: prop),
                            comparator         : comparator,
                            value              : value
                    ]
                    jsonQueries << processedQuery
                    break;
            }
        }

        // see if chromosomeQuery has key 8 defined--if it does, then we have
        // something and should also see if keys 9/10 are defined
        if (chromosomeQuery['8']) {
            JSONObject processedChromosomeQuery = [
                    prop          : 'chromosome',
                    translatedName: 'chromosome',
                    comparator    : '='
            ]
            if (chromosomeQuery['9'] && chromosomeQuery['10']) {
                processedChromosomeQuery.value = chromosomeQuery['8'] + ':' + chromosomeQuery['9'] + '-' + chromosomeQuery['10']
            } else {
                processedChromosomeQuery.value = chromosomeQuery['8']
            }
            jsonQueries << processedChromosomeQuery
        }

        return jsonQueries
    }

    /***
     *  Someone has requested the 'search builder' page.  If they are coming to this page without a search
     *  context then encParams will be empty.   If instead they are trying to revise their search then
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

        JSONArray jsonQueriesToReturn = new JSONArray()

        if ((encParams) && (encParams.length() > 0)) {
            String urlDecodedEncParams = URLDecoder.decode(encParams.trim())
            // urlDecodedEncParams are in the old query format (ex. "17=T2D[GWAS_DIAGRAM_mdv2]P_VALUE<1")
            // need to convert that back to JSON before handing back to the client
            // trim the opening and closing bracket from the array-turned-into-a-string
            String trimmedParams = urlDecodedEncParams[1..-2];
            ArrayList<String> listOfParams = trimmedParams.split(',')

            jsonQueriesToReturn.addAll(encodedFiltersToJSON(listOfParams))
        }

        render(view: 'variantWorkflow',
                model: [show_gwas        : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        encodedFilterSets: URLEncoder.encode(jsonQueriesToReturn.toString())])
    }



    // Here's a shortcut way to display the variant search results, which we are currently using
    // in an anchor from the epilepsy gene prioritization page
    def findEveryVariantForAGene (){
        String geneName = params.gene
        String phenotypeName = params.phenotype
        String dataSetName = params.dataset
        LinkedHashMap extents = sharedToolsService.getGeneExpandedExtent( geneName)
        String chromosome = extents.chrom
        if (chromosome?.startsWith('chr')){
            chromosome = chromosome-'chr'
        }
        // for now we have some confusion about gene vs. variant phenotypes, so also but phenotype explicitly
//        if ((phenotypeName=='EE') || (phenotypeName=='GGE') || (phenotypeName=='NAFE')){
//            phenotypeName = 'EPI'
//        }

        List <String> filtersForQuery = []
        filtersForQuery << """{"value":"${chromosome}:${extents.startExtent}-${extents.endExtent}","prop":"chromosome","comparator":"="}""".toString()
        if ((dataSetName!=null) && (phenotypeName!=null)){
            filtersForQuery << """{"phenotype":"${phenotypeName}","dataset":"${dataSetName}","prop":"ACA_PH","value":"0","comparator":">"}]""".toString()
        }
        forward action: "launchAVariantSearch", params:[filters: "[${filtersForQuery.join(',')}]"]
    }





    /***
     * This call occurs when you press the 'submit search request' button.
     * @return
     */
    def launchAVariantSearch() {
        displayCombinedVariantSearch(params.filters, params.props)
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
        String significanceString = params.sig
        String dataset = params.dataset
        String region = params.region
        String phenotype = params.phenotype
        String parmType = params.parmType
        String parmVal = params.parmVal
        String ignoreMdsFilter = params.ignoreMdsFilter
        Float significance = 0f
        try {
            significance = Float.parseFloat(significanceString)
        } catch (ex) {
            log.error("receive nonnumeric significance value = (${params.sig}) in action=gene, VariantSearchController")
        }

        ArrayList<String> listOfCodedFilters = []
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
            String technology = "unknown"
            if (!ignoreMdsFilter){ // we can use the technology to add a filter to our search.  If requested, ignore this little trick
                technology = metaDataService.getTechnologyPerSampleGroup(dataset)
            }
            listOfCodedFilters = filterManagementService.storeParametersInHashmap(geneId, significance, dataset, region, technology, phenotype)
        }

        //  we must have generated coded filters or we're going to be in trouble
        if (listOfCodedFilters && (listOfCodedFilters.size() > 0)) {
            ArrayList<String> filters = new ArrayList<String>()
            encodedFiltersToJSON(listOfCodedFilters).each {
                filters.add(it.toString())
            }
            displayCombinedVariantSearch(filters.toString(), "")
        }

    }

    // given a nested structure of datasets, add a "name" field with the
    // display name to each object recursively
    private JSONObject addNamesToDatasetMap(HashMap<String, HashMap> map) {
        JSONObject toReturn = [:]
        map.each { dataset, children ->
            JSONObject newDatasetObject = [:]
            newDatasetObject.name = g.message(code: "metadata." + dataset, default: dataset)
            children.each { childDataset, grandchildren ->
                HashMap<String, HashMap> temp = [:]
                temp.put(childDataset, grandchildren)
                newDatasetObject[childDataset] = addNamesToDatasetMap(temp)[childDataset]
            }
            toReturn[dataset] = newDatasetObject
        }
        return toReturn
    }

    /***
     * get data sets given a phenotype.  This Ajax call takes place on the search builder page after
     * choosing a phenotype
     * @return
     */
    def retrieveDatasetsAjax() {
        String phenotype = params.phenotype

        HashMap<String, HashMap> datasetMap = this.metaDataService.getSampleGroupStructureForPhenotypeAsJson(phenotype)
        JSONObject sampleGroupMap = addNamesToDatasetMap(datasetMap);

        render(status: 200, contentType: "application/json") {[
                sampleGroupMap: sampleGroupMap
        ]
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

        List<String> technologyList = this.metaDataService.getTechnologyListByPhenotypeAndVersion(phenotypeName, sharedToolsService.getCurrentDataVersion())
        JSONObject technologyListJsonObject = sharedToolsService.packageUpAListAsJson(technologyList)

        render(status: 200, contentType: "application/json") {
            [technologyList: technologyListJsonObject]
        }
    }



    def retrieveTopVariantsAcrossSgsAndPhenotypes () {

    }





    def retrieveTopVariantsAcrossSgs (){
        String portalType = g.portalTypeString() as String

        Closure convertDynamicStructToJson = { incoming ->
            List<String> allOptions = []
            incoming.each { org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean ->
                List<String> perOptionFields = []

                perOptionFields << " \"trait\":\"${phenotypeBean.name}\" "
                perOptionFields << " \"dataset\":\"${phenotypeBean.dataSet}\" "
                perOptionFields << " \"name\":\"${phenotypeBean.description}\" "
                perOptionFields << " \"suitableForDefaultDisplay\":\"${phenotypeBean.suitableForDefaultDisplay}\" "
                allOptions << "{${perOptionFields.join(",")}}"
            }
            return "[${allOptions.join(",")}]"
        }

        String phenotypeName = ''
        String geneName
        int limit = -1 // how many records to pull back.  -1 = no limit
        if (params.limit) {
            limit = Integer.parseInt(params.limit)
        } else {
            limit = RestServerService.DEFAULT_NUMBER_OF_RESULTS_FROM_TOPVARIANTS
        }
        log.debug "variantSearch params.limit = ${params.limit}"


        if (params.phenotype) {
            phenotypeName = params.phenotype
            log.debug "variantSearch params.phenotype = ${params.phenotype}"
        }
        if (params.geneToSummarize) {
            geneName = params.geneToSummarize
            log.debug "variantSearch params.geneToSummarize = ${params.geneToSummarize}"
        }
        List<String> propertiesToInclude =  (params?.propertiesToInclude) ? params?.propertiesToInclude.split(",") : []
        List<String> propertiesToRemove = (params?.propertiesToRemove) ? params?.propertiesToRemove.split(",") : []


        String currentVersion = metaDataService.getDataVersion()
        List<String> allTechnologies =  metaDataService.getTechnologyListByVersion(currentVersion)
        List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups(phenotypeName, "", allTechnologies)

        JSONObject dataJsonObject

        dataJsonObject = restServerService.gatherTopVariantsFromAggregatedTables(phenotypeName,geneName,-1,limit,currentVersion)

//        if (dataJsonObject == null){
//            dataJsonObject = restServerService.gatherTopVariantsAcrossSgs( fullListOfSampleGroups, phenotypeName,geneName, 1f )
//        }

        List<org.broadinstitute.mpg.locuszoom.PhenotypeBean> phenotypeMap = widgetService.getHailPhenotypeMap()

        if (dataJsonObject.variants) {
            for (Map pval in dataJsonObject.variants){
                //for (Map pval in result) {
                if (pval.containsKey("Consequence")){
                    List<String> consequenceList = pval["Consequence"]?.tokenize(",")
                    List<String> translatedConsequenceList = []
                    for (String consequence in consequenceList){
                        translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
                    }
                    pval["Consequence"] = translatedConsequenceList.join(", ")
                }
                if (pval.containsKey("dataset")){
                    pval["dsr"] = g.message(code: "metadata." + pval["dataset"], default: pval["dataset"])
                }
                if (pval.containsKey("phenotype")){
                    pval["pname"] = g.message(code: "metadata." + pval["phenotype"], default: pval["phenotype"])
                }
                //}
            }

        }
        List<SampleGroup> sampleGroupsWithCredibleSets  = metaDataService.getSampleGroupListForPhenotypeWithMeaning(phenotypeName,"CREDIBLE_SET_ID")
        List<String> sampleGroupsWithCredibleSetNames = sampleGroupsWithCredibleSets.collect{it.systemId}

        StringBuilder sb = new StringBuilder("[")
        if (portalType=='ibd'){
            LinkedHashMap<String,List<String>> possibleExperiments =  epigenomeService.getThePossibleReadData("{\"version\":\"${ sharedToolsService.getCurrentDataVersion ()}\"}")
            List <String> allElements = []
            for (String key in possibleExperiments.keySet()){
                StringBuilder isb = new StringBuilder()
                isb << "{\"expt\":\"${key}\",\"assays\":[\""
                isb << possibleExperiments[key].join("\",\"")
                isb << "\"]}"
                allElements << isb.toString()
            }
            sb << allElements.join(",")
        }
        sb << "]"
        JsonSlurper slurper = new JsonSlurper()
        JSONArray experimentAssays = slurper.parseText(sb.toString())

        render(status: 200, contentType: "application/json") {
            [variants: dataJsonObject,
             propertiesToInclude:(slurper.parseText(groovy.json.JsonOutput.toJson(propertiesToInclude))) as JSONArray,
             propertiesToRemove:(slurper.parseText(groovy.json.JsonOutput.toJson(propertiesToRemove))) as JSONArray,
             datasetToChoose:slurper.parseText(convertDynamicStructToJson(phenotypeMap)),
             lzOptions:phenotypeMap,
             sampleGroupsWithCredibleSetNames:sampleGroupsWithCredibleSetNames,
             experimentAssays:experimentAssays
            ]
        }

    }


    def retrieveTopVariantsAcrossSgsWithSimulatedMetadata (){
        String portalType = g.portalTypeString() as String
        String phenotypeName = ''
        String geneName
        String drawReq = '2'
        if (params.draw) {
            drawReq = params.draw
        }

        if (params.phenotype) {
            phenotypeName = params.phenotype
            log.debug "variantSearch params.phenotype = ${params.phenotype}"
        }
        if (params.geneToSummarize) {
            geneName = params.geneToSummarize
            log.debug "variantSearch params.geneToSummarize = ${params.geneToSummarize}"
        }

        int pageStart = -1
        int pageSize = -1
        if ((params.start!=null)&&(params.length!=null)){
            pageStart = Integer.parseInt(params.start)
            pageSize = Integer.parseInt(params.length)
        }

        //getDataQueryHolder.setPageStartAndSize(pageStart, pageSize)
        String filtersAsJson = params.filtersAsJson


        String currentVersion = metaDataService.getDataVersion()
        List<String> allTechnologies =  metaDataService.getTechnologyListByVersion(currentVersion)
        List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups(phenotypeName, "", allTechnologies)

        JSONObject dataJsonObject
        //JSONObject dataJsonObject = restServerService.gatherTopVariantsAcrossSgs( fullListOfSampleGroups, phenotypeName,geneName, 1f )

//        String passConditionalVersionForNow = (currentVersion=="mdv91"||currentVersion=="mdv80"||currentVersion=="mdv70")?currentVersion:"";
//        dataJsonObject = restServerService.gatherTopVariantsFromAggregatedTables(phenotypeName,geneName,pageStart,pageSize,passConditionalVersionForNow)

        String passConditionalVersionForNow = (currentVersion=="mdv91"||currentVersion=="mdv80"||currentVersion=="mdv70")?currentVersion:"";
        dataJsonObject = restServerService.gatherTopVariantsFromAggregatedTables(phenotypeName,geneName,-1,-1,currentVersion)

        if (dataJsonObject == null){
            // fallback call, just in case we have an old KB.  Remove this branch when no longer necessary
            dataJsonObject = restServerService.gatherTopVariantsAcrossSgs( fullListOfSampleGroups, phenotypeName,geneName, 1f )
        }


        if (dataJsonObject.variants) {
            for (Map pval in dataJsonObject.variants){
                //for (Map pval in result) {
                if (pval.containsKey("Consequence")){
                    List<String> consequenceList = pval["Consequence"]?.tokenize(",")
                    List<String> translatedConsequenceList = []
                    for (String consequence in consequenceList){
                        translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
                    }
                    pval["Consequence"] = translatedConsequenceList.join(", ")
                }
                if (pval.containsKey("dataset")){
                    pval["dsr"] = g.message(code: "metadata." + pval["dataset"], default: pval["dataset"])
                }
                if (pval.containsKey("phenotype")){
                    pval["pname"] = g.message(code: "metadata." + pval["phenotype"], default: pval["phenotype"])
                }
                //}
            }

        }

//        LinkedHashMap resultColumnsToDisplay = restServerService.getColumnsToDisplay("[${filtersAsJson}]", requestedProperties)
//        JSONObject resultColumnsJsonObject = resultColumnsToDisplay as JSONObject

        LinkedHashMap fullPropertyTree = metaDataService.getFullPropertyTree()
        JSONObject propertyMap = sharedToolsService.packageUpATreeAsJson(fullPropertyTree)

        JSONObject datasetStructure = [:]
        List<String> allPhenotypes = this.metaDataService.getEveryPhenotype(true)
        allPhenotypes.each { phenotype ->
            HashMap<String, HashMap> datasetMap = this.metaDataService.getSampleGroupStructureForPhenotypeAsJson(phenotype)
            datasetStructure[phenotype] = addNamesToDatasetMap(datasetMap);
        }

        JSONObject commonPropertiesJsonObject = this.metaDataService.getCommonPropertiesAsJson(true);

        // prepare translation object
        Set<String> metadataNames = metaDataService.getEveryMetadataStringThatMightNeedTranslating()
        JSONObject translationDictionary = []
        metadataNames.each { name ->
            translationDictionary[name] = g.message(code: "metadata." + name, default: name)
        }

        List<LinkedHashMap> convertedDataStruct = []
        dataJsonObject["variants"].each {
            convertedDataStruct << ["VAR_ID":it."VAR_ID",
                                    "DBSNP_ID":it.DBSNP_ID,
                                    "Protein_change":it.Protein_change,
                                    "Consequence":it."Consequence",
                                    "P_VALUE":["ExChip_CAMP_mdv25":["FI":it."P_VALUE"]],
                                    "BETA":["ExChip_CAMP_mdv25":["FI":it."BETA"]]
            ]
        }
        JSONArray convertedDataJsonObject = convertedDataStruct as JSONArray

        LinkedHashMap columns = [
                "cproperty":["VAR_ID",
                             "DBSNP_ID",
                             "Protein_change",
                             "Consequence"],
                "dproperty":["FI":["ExChip_CAMP_mdv25":[]]],
                "pproperty":["FI":["ExChip_CAMP_mdv25":["P_VALUE","BETA"]]]
        ]
        JSONObject columnsAsJsonObject = columns as JSONObject


        render(status: 200, contentType: "application/json") {
            [variants                : convertedDataJsonObject,
             columns                 : columnsAsJsonObject,
             metadata                : propertyMap,
             datasetStructure        : datasetStructure,
             cProperties             : commonPropertiesJsonObject,
             translationDictionary   : translationDictionary,
             numberOfVariants        : dataJsonObject.length(),
             errorMsg                : '',
             draw           : Integer.parseInt(drawReq),
             recordsTotal   : dataJsonObject["variants"].size(),
             recordsFiltered: dataJsonObject["variants"].size(),
             data           : convertedDataJsonObject
            ]
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

        List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups(phenotypeName, "", technologies)

        JSONObject sampleGroupMapJsonObject = filterManagementService.convertSampleGroupListToJson(fullListOfSampleGroups, phenotypeName)

        render(status: 200, contentType: "application/json") {
            [sampleGroupMap: sampleGroupMapJsonObject]
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

        List<SampleGroup> sampleGroupList = this.metaDataService.getSampleGroupForPhenotypeDatasetTechnologyAncestry(phenotypeName, "",
                technologyName,
                sharedToolsService.getCurrentDataVersion(), "")
        List<String> ancestryList = sampleGroupList.unique { a, b -> a.getAncestry() <=> b.getAncestry() }*.getAncestry()
        JSONObject ancestryListAsJson = sharedToolsService.packageUpAListAsJson(ancestryList)

        render(status: 200, contentType: "application/json") {
            [ancestryList: ancestryListJsonObject]
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

        List<SampleGroup> sampleGroupList = this.metaDataService.getSampleGroupForPhenotypeDatasetTechnologyAncestry(phenotypeName, "",
                technologyName,
                sharedToolsService.getCurrentDataVersion(), ancestryName)
        JSONObject dataSetMapJsonObject = filterManagementService.convertSampleGroupListToJson(sampleGroupList, phenotypeName)

        render(status: 200, contentType: "application/json") {
            [dataSetList: dataSetMapJsonObject]
        }
    }

    /***
     * get properties given a data set. This Ajax call takes place on the search builder
     * after selecting a data set.
     */
    def retrievePropertiesAjax() {
        String phenotype = params.phenotype

        String datasetChoice = ""
        if ((params.dataset) && (params.dataset != null)) {
            datasetChoice = params.dataset
        }

        List<String> listOfProperties = metaDataService.getAllMatchingPropertyList(datasetChoice, phenotype)
        JSONObject result = sharedToolsService.packageUpAListAsJson(listOfProperties)

        // attach translated names
        ArrayList<JSONObject> translatedObjects = new ArrayList<JSONObject>()
        for (int i = 0; i < result.dataset.size(); i++) {
            String prop = result.dataset[i]
            JSONObject translated = [
                    prop          : prop,
                    translatedName: g.message(code: "metadata." + prop, default: prop)
            ]
            translatedObjects << translated
        }

        result.dataset = translatedObjects

        render(status: 200, contentType: "application/json") {
            [datasets     : result,
             chosenDataset: datasetChoice]
        }

    }

    private ArrayList<String> parseFilterJson(ArrayList<JSONObject> listOfQueries) {
        ArrayList<String> computedStrings = new ArrayList<String>();

        for (int i = 0; i < listOfQueries.size(); i++) {
            JSONObject currentQuery = listOfQueries[i]
            String processedQuery;
            // if there is a phenotype defined, this is a query that has a
            // phenotype, dataset, prop, comparator, and value
            if (currentQuery.phenotype) {
                String comparator = (currentQuery.comparator == '=') ? '|' : currentQuery.comparator
                // if anyone passes in a real = then swap it out -- we demand a coded character
                processedQuery = '17=' +
                        currentQuery.phenotype + '[' + currentQuery.dataset + ']' +
                        currentQuery.prop + comparator + currentQuery.value
                computedStrings << processedQuery
            } else {
                switch (currentQuery.prop) {
                    case 'gene':
                        // convert gene into chromosome and start/end points
                        // also be prepared to handle Â±value

                        // assume that value is just the gene name
                        def gene = currentQuery.value
                        def adjustment

                        // if the gene contains 'Â±', then split to get the start and end
                        // adjustments
                        if (gene.indexOf('Â±') > -1) {
                            (gene, adjustment) = currentQuery.value.split(' Â± ')
                        }
                        Gene geneObject = Gene.retrieveGene(gene)
                        String chromosome = geneObject.getChromosome()
                        Long start = geneObject.getAddrStart()
                        Long end = geneObject.getAddrEnd()
                        if (adjustment) {
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
                        if (currentQuery.value =~ /^\d{1,2}$/) {
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
                    case PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY:
                        if (currentQuery.value == '0') {
                            // if value is 0, then drop the query--reason: there are variants
                            // in the DB with MDS=NULL. There's no way to make SQL return those variants
                            // if the value being compared against is 0 (as far as I'm aware), so the
                            // simplest thing to do is just drop this query. If we get to the point of
                            // supporting ORing queries, this may change
                            break;
                        }
                // Otherwise, process the query like normal, so fall through to the next case
                    case [PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY, PortalConstants.JSON_VARIANT_SIFT_PRED_KEY, PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY]:
                        String comparator = currentQuery.comparator.replace("=", /|/)
                        processedQuery = '11=' + currentQuery.prop + comparator + currentQuery.value
                        computedStrings << processedQuery
                        break;
                }
            }

        }
        return computedStrings
    }

    /**
     * This function collects and returns the data to populate the search results table. It
     * expects data formatted by the Datatables function.
     */
    def variantSearchAndResultColumnsData() {
        String filtersRaw = params['filters']
        String propertiesRaw = params['properties']
        JSONArray columns = (new JsonSlurper().parseText(params.columns)) as JSONArray;
        JSONArray orderBy = (new JsonSlurper().parseText(params.order)) as JSONArray;

        String filters = URLDecoder.decode(filtersRaw, "UTF-8")
        String properties = URLDecoder.decode(propertiesRaw, "UTF-8")

        LinkedHashMap requestedProperties = sharedToolsService.putPropertiesIntoHierarchy(properties)

        // build up filters our data query
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters, searchBuilderService, metaDataService)
        // determine columns to display
        LinkedHashMap resultColumnsToDisplay = restServerService.getColumnsToDisplay("[${getDataQueryHolder.retrieveAllFiltersAsJson()}]", requestedProperties)

        int pageStart = Integer.parseInt(params.start)
        int pageSize = Integer.parseInt(params.length)
        getDataQueryHolder.setPageStartAndSize(pageStart, pageSize)

        // add ordering info
        for (orderByElement in orderBy) {
            int columnNumber = orderByElement.column
            // name gives us the property being sorted on--use it to create a PropertyBean
            String columnName = columns[columnNumber].name
            String[] propInfo = columnName.split("\\.")

            PropertyBean propertyBean = new PropertyBean()
            PhenotypeBean phenotypeBean

            // if propInfo has 3 elements, it's a pprop, 2 elements, a dprop, and 1 element, a cprop
            switch (propInfo.length) {
                case 3:
                    String phenotype = propInfo[2]

                    phenotypeBean = new PhenotypeBean()
                    phenotypeBean.setName(phenotype)
                    propertyBean.setParent(phenotypeBean)
                case 2:
                    String dataset = propInfo[1]
                    SampleGroupBean sampleGroupBean = metaDataService.getSampleGroupByName(dataset, MetaDataService.METADATA_VARIANT)

                    if (propertyBean.getParent() == null) {
                        propertyBean.setParent(sampleGroupBean)
                    } else {
                        phenotypeBean.setParent(sampleGroupBean)
                    }
                case 1:
                    String prop = propInfo[0]
                    propertyBean.setName(prop)
                    break
                default:
                    // in any other case, we'll ignore it
                    break
            }

            // convert 'asc'/'desc' to ''/'-1' to match KB expectation
            String directionOfSort = orderByElement.dir == 'asc' ? '' : '-1'
            getDataQueryHolder.addOrderByProperty(propertyBean, directionOfSort)
        }

        // make the call to REST server
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JSONObject dataJsonObject = restServerService.postDataQueryRestCall(getDataQueryHolder)

        // process the variants
        def variants = dataJsonObject.variants
        ArrayList toReturn = []
        for (variant in variants) {
            // merge all of the data into one object, which is then processed clientside
            JSONObject newVariantObject = []
            for (data in variant) {
                def keys = data.keySet()
                for (k in keys) {
                    newVariantObject[k] = data[k]
                }
            }

            toReturn << newVariantObject
        }

        render(status: 200, contentType: "application/json") {
            [
                    draw           : Integer.parseInt(params.draw),
                    recordsTotal   : params.numberOfVariants,
                    recordsFiltered: params.numberOfVariants,
                    data           : toReturn
            ]
        }
    }

    /***
     *  This function gets all of the table construction info--column names, metadata, etc--but
     *  not the actual data that populates the table
     */
    def variantSearchAndResultColumnsInfo() {
        String filtersRaw = params['filters']
        String propertiesRaw = params['properties']
        String filters = URLDecoder.decode(filtersRaw, "UTF-8")
        String properties = URLDecoder.decode(propertiesRaw, "UTF-8")
        LinkedHashMap requestedProperties = sharedToolsService.putPropertiesIntoHierarchy(properties)

        /***
         * package up as much of the kludgy workaround needed to avoid cross institution joins as we can
         */
        Closure generateInstitutionMap = { propertyList ->
            LinkedHashMap<String,Integer> institutionMap = [:]
            for (Property property in propertyList){
                String dataSetName

                if (property?.parent instanceof SampleGroup) {
                    // if the name is found on the first level parent then we have a d property to deal with
                    dataSetName =  property.parent.systemId
                } else if (property?.parent instanceof org.broadinstitute.mpg.diabetes.metadata.Phenotype) {
                    // the only other option is a p property
                    dataSetName =  property.parent.parent?.systemId
                } // else if the property doesn't have a parent than it is a common property, and we don't need to consider it
                if (dataSetName){
                    String institution = metaDataService.getInstitutionNameFromSampleGroupName(dataSetName)
                    if (institution){
                        if (institutionMap.containsKey(institution)){
                            institutionMap[institution] += 1
                        } else {
                            institutionMap[institution] = 1
                        }
                    }
                }
            }
            return institutionMap
        }


        log.debug "variantSearch variantSearchAjax = ${filters}"

        // build up filters our data query
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters, searchBuilderService, metaDataService)

        /***
         * Temporary workaround:  the federated KB does not yet support cross institution filtering.  Detect those requests and prohibit them.
         */
        String errorMsg = ''
        LinkedHashMap<String,Integer> institutionMap = generateInstitutionMap(getDataQueryHolder.getDataQuery.filterList*.property)
        if (institutionMap.size()>1){
            Map sortedInstitutionMap = institutionMap.sort { a, b -> b.value <=> a.value }
            String key
            Integer value
            for (Map.Entry<String, ArrayList<String>> entry : sortedInstitutionMap.entrySet()) {
                key = entry.getKey();
                value = entry.getValue();
            }
            errorMsg = "Currently, searches in the Oxford BioBank GWAS data set may not be combined with searches in any other data set. Please return to the Search page and modify your search."
            render(status: 200, contentType: "application/json") {
                [

                        errorMsg: errorMsg
                ]
            }
            return
        }

        // determine columns to display
        LinkedHashMap resultColumnsToDisplay = restServerService.getColumnsToDisplay("[${getDataQueryHolder.retrieveAllFiltersAsJson()}]", requestedProperties)
        JSONObject resultColumnsJsonObject = resultColumnsToDisplay as JSONObject

        // make the call to REST server
        getDataQueryHolder.addProperties(resultColumnsToDisplay)

        /***
         * Temporary workaround:  the federated KB does not yet support cross institution filtering.  Detect those requests and prohibit them.
         */
        errorMsg = ''
        institutionMap = generateInstitutionMap(getDataQueryHolder.getDataQuery.queryPropertyMap.values())
        if (institutionMap.size()>1){
            Map sortedInstitutionMap = institutionMap.sort { a, b -> b.value <=> a.value }
            String key
            Integer value
            for (Map.Entry<String, ArrayList<String>> entry : sortedInstitutionMap.entrySet()) {
                key = entry.getKey();
                value = entry.getValue();
            }
            errorMsg = "Properties can currently retrieved only from a single institution.  Please return to the Search page and restart your search"
            render(status: 200, contentType: "application/json") {
                [

                        errorMsg: errorMsg
                ]
            }
            return
        }







        // get the number of variants that this query will return
        // do this here so it doesn't have to happen after every resort or change in the table
        getDataQueryHolder.isCount(true)
        JSONObject dataJsonObjectCount = restServerService.postDataQueryRestCall(getDataQueryHolder)

        LinkedHashMap fullPropertyTree = metaDataService.getFullPropertyTree()

        JSONObject propertyMap = sharedToolsService.packageUpATreeAsJson(fullPropertyTree)

        JSONObject datasetStructure = [:]

        List<String> allPhenotypes = this.metaDataService.getEveryPhenotype(true)
        allPhenotypes.each { phenotype ->
            HashMap<String, HashMap> datasetMap = this.metaDataService.getSampleGroupStructureForPhenotypeAsJson(phenotype)
            datasetStructure[phenotype] = addNamesToDatasetMap(datasetMap);
        }

        JSONObject commonPropertiesJsonObject = this.metaDataService.getCommonPropertiesAsJson(true);

        // prepare translation object
        Set<String> metadataNames = metaDataService.getEveryMetadataStringThatMightNeedTranslating()

        JSONObject translationDictionary = []
        metadataNames.each { name ->
            translationDictionary[name] = g.message(code: "metadata." + name, default: name)
        }

        render(status: 200, contentType: "application/json") {
            [
                    columns                 : resultColumnsJsonObject,
                    metadata                : propertyMap,
                    datasetStructure        : datasetStructure,
                    cProperties             : commonPropertiesJsonObject,
                    translationDictionary   : translationDictionary,
                    numberOfVariants        : dataJsonObjectCount.numRecords,
                    errorMsg                : errorMsg
            ]
        }

    }

    private void displayCombinedVariantSearch(String filters, String requestForAdditionalProperties) {
        ArrayList<JSONObject> listOfQueries = (new JsonSlurper()).parseText(filters)
        ArrayList<String> listOfCodedFilters = parseFilterJson(listOfQueries);

        if (requestForAdditionalProperties == null || "".compareTo(requestForAdditionalProperties) == 0) {
            // if there are no specified properties, default to these
            requestForAdditionalProperties =
                    ["common-common-CLOSEST_GENE",
                     "common-common-VAR_ID",
                     "common-common-DBSNP_ID",
                     "common-common-Protein_change",
                     "common-common-Consequence",
                     "common-common-CHROM",
                     "common-common-POS",
                     "common-common-Reference_Allele",
                     "common-common-Effect_Allele"].join(":")
        }

        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(listOfCodedFilters, searchBuilderService, metaDataService)
        if (getDataQueryHolder.isValid()) {
            List<String> encodedFilters = getDataQueryHolder.listOfEncodedFilters()
            List<String> translatedFilters = []
            encodedFilters.each {
                translatedFilters.add(sharedToolsService.translatorFilter(getDataQueryHolder.decodeFilter(it)))
            }
            List<String> urlEncodedFilters = getDataQueryHolder.listOfUrlEncodedFilters(encodedFilters)
            LinkedHashMap genomicExtents = sharedToolsService.validGenomicExtents(getDataQueryHolder.retrieveGetDataQuery())
            List<String> identifiedGenes = sharedToolsService.allEncompassedGenes(genomicExtents)
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
            String regionSpecifier = ""
            LinkedHashMap<String, String> positioningInformation = getDataQueryHolder.positioningInformation()
            if (positioningInformation.size()>0){
                regionSpecifier = "chr${positioningInformation.chromosomeSpecified}:${positioningInformation.beginningExtentSpecified}-${positioningInformation.endingExtentSpecified}"
            }

            //identifiedGenes = restServerService.retrieveGenesInExtents(positioningInformation)
//            if (positioningInformation.size() > 2) {
//
//                regionSpecifier = "chr${positioningInformation.chromosomeSpecified}:${positioningInformation.beginningExtentSpecified}-${positioningInformation.endingExtentSpecified}"
//                List<Gene> geneList = Gene.findAllByChromosome("chr" + positioningInformation.chromosomeSpecified)
//                for (Gene gene in geneList) {
//                    try {
//                        int startExtent = positioningInformation.beginningExtentSpecified as Long
//                        int endExtent = positioningInformation.endingExtentSpecified as Long
//                        if (((gene.addrStart > startExtent) && (gene.addrStart < endExtent)) ||
//                                ((gene.addrEnd > startExtent) && (gene.addrEnd < endExtent))) {
//                            identifiedGenes << gene.name2 as String
//                        }
//                    } catch (e) {
//                        redirect(controller: 'home', action: 'portalHome')
//                    }
//
//                }
//            }

            List tempList = identifiedGenes.collect{return "\"$it\""};
            JSONArray JsonGeneHolder = new JSONArray();
            for (String text in tempList) {
                JsonGeneHolder.add(text);
            }

            // get locale to provide to table-building plugin
            String locale = RequestContextUtils.getLocale(request)
            render(view: 'variantSearchResults',
                    model: [show_gene           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                            show_gwas           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            // what actually constitutes the query
                            queryFilters        : urlEncodedFilters.join("^"), //encodedFilters,
                            // link to this page again
                            filtersForSharing   : filters,
                            // used for generating the filename of the csv/pdf table exports
                            // and list of search criteria above the table
                            translatedFilters   : translatedFilters.join(','),
                            // used for the adding/removing properties modal,
                            // to know which properties are part of the search
                            listOfQueries       : listOfQueries as JSON,
                            // the URL-encoded parameters to go back to the search builder with the filters saved
                            encodedParameters   : urlEncodedFilters,
                            // all the extra things added
                            proteinEffectsList  : encodedProteinEffects,
                            additionalProperties: requestForAdditionalProperties,
                            regionSearch        : (positioningInformation.size() > 2),
                            regionSpecification : regionSpecifier,
                            geneNamesToDisplay  : identifiedGenes,
                            locale              : locale
                    ])
        }
    }


}
