package org.broadinstitute.mpg

import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.broadinstitute.mpg.diabetes.json.builder.LocusZoomJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.Covariate
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseFlatSearchTranslator
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseResultParser
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.broadinstitute.mpg.locuszoom.PhenotypeBean
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class WidgetService {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
    RestServerService restServerService;
    MetaDataService metaDataService
    def grailsApplication

    // setting variables
    private final String LOCUSZOOM_17K_ENDPOINT = "17k data";
    private final String LOCUSZOOM_HAIL_ENDPOINT_DEV = "Hail Dev";
    private final String LOCUSZOOM_HAIL_ENDPOINT_QA = "Hail QA";
    private String locusZoomEndpointSelection = LOCUSZOOM_HAIL_ENDPOINT_QA;
    private
    final List<String> locusZoomEndpointList = [this.LOCUSZOOM_17K_ENDPOINT, this.LOCUSZOOM_HAIL_ENDPOINT_DEV, LOCUSZOOM_HAIL_ENDPOINT_QA];
    private final Integer MAXIMUM_RANGE_FOR_HAIL = 600000

    // constants for now
    private final String dataSetKey = "ExSeq_17k_mdv2";
    private final String phenotypeKey = "T2D";
    private final String propertyKey = "P_FIRTH_FE_IV";
    private final String errorResponse = "{\"data\": {}, \"error\": true}";
    private final int NUMBER_OF_DISTRIBUTION_BINS = 24

    private String singleFilter(String categorical, //
                                String comparator,
                                String propertyName,
                                String propertyValue,
                                String dataset
    ) {
        String returnValue
        String operatorType
        String operator
        Boolean generateFilter = true;
        switch (categorical) {
            case "0":
                operatorType = "FLOAT"
                break
            case "1":
                operatorType = "STRING"
                break
            case "2":
                operatorType = "INTEGER"
                break
            case "3":
                operatorType = "ORBLOCK"
                break
            case "4":
                operatorType = "ANDBLOCK"
                break
            default: operatorType = "FLOAT"; break
        }
        switch (comparator) {
            case "1":
                operator = "LT"
                break
            case "2":
                operator = "GT"
                break
            case "3":
                operator = "EQ"
                break
            default: operator = "LT"; break
        }
        switch (operatorType) {  // package up the property value if necessary
            case "FLOAT":
            case "ORBLOCK":
            case "ANDBLOCK": break;
            case "INTEGER":
//                if (propertyValue?.length() < 1) {
//                    generateFilter = false
//                } else { // currently we can only send in one value.
//                    List<String> listOfSelectedValues = propertyValue.tokenize(",")
//                    if (listOfSelectedValues.size() > 1) {
//                        generateFilter = false
//                    } else {
//                        propertyValue = "${propertyValue}"
//                    }
//                }
//                break;
            case "STRING":
                if (propertyValue?.length() < 1) {
                    generateFilter = false
                } else { // currently we can only send in one value.
                    List<String> listOfSelectedValues = propertyValue.tokenize(",")
                    if (listOfSelectedValues.size() > 1) {
                        generateFilter = false
                    } else {
                        propertyValue = "\"${propertyValue}\""
                    }
                }
                break;
            default: break
        }
        if (generateFilter) {
            returnValue = """{"dataset_id": "${dataset}", "phenotype": "b", "operand": "${
                propertyName
            }", "operator": "${operator}", "value": ${propertyValue}, "operand_type": "${operatorType}"}""".toString()
        } else {
            returnValue = ""
        }
        return returnValue
    }
//def c=s.replaceAll("\\s","").substring(s.indexOf('[')+1,s.size()-s.indexOf('[')-1)


    private List<String> addSingleFilter(String categorical, //
                                         String comparator,
                                         String propertyName,
                                         String propertyValue,
                                         String dataset,
                                         List<String> requestedFilterList) {
        String proposedFilter = singleFilter(categorical, comparator, propertyName, propertyValue, dataset)
        if (proposedFilter?.length() > 1) {
            requestedFilterList << proposedFilter
        }
        return requestedFilterList
    }


    private List<String> addCompoundFilter(String categorical,
                                           String propertyName,
                                           String rawFilterParm,
                                           String dataset,
                                           Boolean rangeFilter, // true -> look inside range, false -> look for everything outside range
                                           List<String> requestedFilterList) {
        List<String> listOfProperties = rawFilterParm?.tokenize(",")
        if (listOfProperties.size() == 2) {
            float lowerBound = Float.NaN
            float upperBound = Float.NaN
            // get the first number
            int delimiterIndex = listOfProperties[0].indexOf((rangeFilter) ? '[' : ']')
            try {
                lowerBound = Float.parseFloat(listOfProperties[0].substring(delimiterIndex + 1))
            } catch (e) {
            } // if it fails simply don't use it for now
            delimiterIndex = listOfProperties[1].indexOf((rangeFilter) ? ']' : '[')
            if (delimiterIndex > 0) {
                try {
                    upperBound = Float.parseFloat(listOfProperties[1].substring(0, delimiterIndex))
                } catch (e) {
                } // if it fails simply don't use it for now
            }
            if ((lowerBound == Float.NaN) || (upperBound == Float.NaN)) {
                return requestedFilterList
            } else {
                List<String> compoundFilterList = []
                if (rangeFilter) {
                    addSingleFilter(categorical,
                            "2",// gt
                            propertyName,
                            lowerBound as String,
                            dataset,
                            compoundFilterList)
                    addSingleFilter(categorical,
                            "1",// lt
                            propertyName,
                            upperBound as String,
                            dataset,
                            compoundFilterList)
                    addSingleFilter("4",//AND
                            "3",// eq
                            "blah",
                            "[ ${compoundFilterList.join(",").toString()} ]".toString(),
                            "blah",
                            requestedFilterList)
                } else {
                    addSingleFilter(categorical,
                            "1",// lt
                            propertyName,
                            lowerBound as String,
                            dataset,
                            compoundFilterList)
                    addSingleFilter(categorical,
                            "2",// gt
                            propertyName,
                            upperBound as String,
                            dataset,
                            compoundFilterList)
                    addSingleFilter("3",//OR
                            "3",// eq
                            "blah",
                            "[ ${compoundFilterList.join(",").toString()} ]".toString(),
                            "blah",
                            requestedFilterList)
                }

            }
        }
        return requestedFilterList
    }

    /***
     * Take the information from a single line on the UI and turn it into a filter list.  That single line might translate
     * onto a filter list with a single filter, or it might translate into multiple filters.  In this routine we can convert
     * ranges (internal or external) into a compound block (AND for an internal range, OR for an external range), and we can
     * also turn a multivalue categorical into an OR block of values.
     *
     * @param map
     * @param dataset
     * @param existingFilterList
     * @return
     */
    private List<String> processSingleFilter(Map map, String dataset, List<String> existingFilterList) {
        if (map.name) {
            String filterParameter = map.parm
         //   filterParameter = filterParameter.replaceAll("\\s", "")
            if (filterParameter ==~ /\[.+\,.+\]/) {
                // this could be a range filter -- it has square brackets under, and a "," in the middle
                existingFilterList = addCompoundFilter(map.cat, map.name, filterParameter, dataset, true, existingFilterList)
            } else if (filterParameter ==~ /\].+\,.+\[/) {  // this could be a extremes filter
                existingFilterList = addCompoundFilter(map.cat, map.name, filterParameter, dataset, false, existingFilterList)
            } else if ((filterParameter ==~ /.+\,.+/)&&(map.cat=="1")) {  // Has at least one comma and the filter is categorical.  Maybe there are multiple elements that need to be simultaneously selected
                existingFilterList = convertMultipleCategoricalsIntoFilterList(map.cat, map.cmp, map.name, filterParameter, dataset, existingFilterList)
            } else {
                existingFilterList = addSingleFilter(map.cat, map.cmp, map.name, filterParameter, dataset, existingFilterList)
            }
        }
        return existingFilterList
    }

    /***
     * Categorical filters get passed in as a single filter, but with values separated by commas.  Break apart that list of commas,
     * create a filter for each one, then combine the whole set within OR block.
     *
     * @param categorical
     * @param comparator
     * @param propertyName
     * @param rawFilterParm
     * @param dataset
     * @param requestedFilterList
     * @return
     */
    private List<String> convertMultipleCategoricalsIntoFilterList (String categorical,
                                                                    String comparator,
                                                                    String propertyName,
                                                                    String rawFilterParm,
                                                                    String dataset,
                                                                    List<String> requestedFilterList){
        List<String> listOfCategories = rawFilterParm.tokenize(",")
        List<String> developingFilterList = []
        if (listOfCategories.size() > 1) {
            for (String singleCategory in listOfCategories){
                developingFilterList = addSingleFilter(categorical, comparator, propertyName, singleCategory, dataset, developingFilterList)
            }
            requestedFilterList = combineFiltersInORBlock(developingFilterList, requestedFilterList)
        } else if (listOfCategories.size() > 0) {
            requestedFilterList = addSingleFilter(categorical, comparator, propertyName, rawFilterParm, dataset, requestedFilterList)
        }
        return requestedFilterList
    }

    /***
     * convenience routine: conbine this list of filters in an AND block
     * @param filtersToCombine
     * @param listWeAreExpanding
     * @return
     */
    private List<String> combineFiltersInANDBlock(List<String> filtersToCombine, List<String> listWeAreExpanding){
        return addSingleFilter ( "4",//AND
                "3",// eq
                "blah",
                " [  ${filtersToCombine.join(",").toString()}  ] ".toString ( ),
                "blah",
                listWeAreExpanding )
    }


    /***
     * convenience routine: conbine this list of filters in an OR block
     * @param filtersToCombine
     * @param listWeAreExpanding
     * @return
     */
    private List<String> combineFiltersInORBlock(List<String> filtersToCombine, List<String> listWeAreExpanding){
        return addSingleFilter ( "3",//OR
                "3",// eq
                "blah",
                " [  ${filtersToCombine.join(",").toString()}  ] ".toString ( ),
                "blah",
                listWeAreExpanding )
    }




    public String buildFilterDesignation (JSONArray filters, JSONArray compoundedFilterValues, String dataset){
        String filterDesignation = ""

//        if ((filters==null)||
//            (filters.size()==0)){
//            filterDesignation =  """            "filters":    [
//                ${singleFilter ( "1", "1", "ID", "ZZZZZ", dataset )}
//            ]
//""".toString()
//        }
//        else {
            List<String> masterFilterList = []
            List<String> requestedFilterList = []
            if (filters?.size()> 0){
                for (Map map in filters){
                    requestedFilterList = processSingleFilter( map, dataset, requestedFilterList)
                }
            }
            List<String> compoundFilterList = []
            if ((compoundedFilterValues?.size()> 0)&&(compoundedFilterValues[0].size()>0))
                    { // we have a group of filter groups
                List<String> intermediateFilterList = []
                for (List subFilters in compoundedFilterValues){
                    List<String> developingCompoundFilterList = []
                    for (Map map in subFilters){
                        developingCompoundFilterList = processSingleFilter( map, dataset, developingCompoundFilterList)
                    }
                    intermediateFilterList = combineFiltersInANDBlock(developingCompoundFilterList,intermediateFilterList )
                }
                compoundFilterList = combineFiltersInORBlock(intermediateFilterList,compoundFilterList )
            }
            if ((requestedFilterList.size()>0)&&(compoundFilterList.size()==0)){
                masterFilterList = requestedFilterList
            } else if ((requestedFilterList.size()==0)&&(compoundFilterList.size()>0)){
                masterFilterList = compoundFilterList
            } else if (!((requestedFilterList.size()==0)&&(compoundFilterList.size()==0))) {
                List<String> groupingFilterList = []
                groupingFilterList=combineFiltersInANDBlock(requestedFilterList,groupingFilterList )
                groupingFilterList=combineFiltersInANDBlock(compoundFilterList,groupingFilterList )
                masterFilterList=combineFiltersInANDBlock(groupingFilterList,masterFilterList )
            }
            if (masterFilterList.size()==0){
                filterDesignation =  """            "filters":    [
                 ${singleFilter ( "1", "1", "ID", "ZZZZZ", dataset )}
            ]
""".toString()
            } else {
                filterDesignation = """ "filters":    [
                ${masterFilterList.join(",")}
        ]
""".toString()
            }
//        }

        log.debug("generated filters=${filterDesignation}.")
        return filterDesignation
    }



    public JSONObject getSampleDistribution( String dataset, List<String> requestedDataList, Boolean distributionRequested, def filters, Boolean categorical ) {
        String binRequest = ""
        if ((!categorical) && distributionRequested){
            binRequest = """
"bin_number": $NUMBER_OF_DISTRIBUTION_BINS, """.toString()
        }
        String filterDesignation = buildFilterDesignation (filters as JSONArray, [] as JSONArray, dataset)
        String jsonGetDataString = """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 0,
    "limit": 100000,
    "count": false,
    "distribution": ${(distributionRequested)?'true':'false'},${binRequest}
    "properties":    {
                           "cproperty": [],
                          "orderBy":    [],
"dproperty" : { ${requestedDataList.join(",")} } ,
      "pproperty" : { }} ,
       ${filterDesignation}
}""".toString()

        // submit the post request
        JSONObject jsonResultString = this.restServerService.postGetSampleDataCall(jsonGetDataString, RestServerService.SAMPLE_SERVER_URL_QA)

        // return
        return jsonResultString

    }




    public  JSONObject  getSampleList( JSONObject jsonObject) {
        // local variables
        JSONObject jsonResultString
        def filters = jsonObject.filters
        // apparently if the list contains one object then it is not returned is a list with one object, but as an object.  Come on -- really?
        String dataset = jsonObject.dataset
        JSONArray requestedData = jsonObject.requestedData
        String jsonGetDataString
        List<String> requestedDataList = []
        List<String> requestedFilterList = []

        for (Map map in requestedData){
            if (map.name){
                requestedDataList << """ "${map.name}":["${dataset}"]""".toString()
            }
        }
        requestedDataList << """ "ID":["${dataset}"]""".toString()
        String filterDesignation = ""
        if (filters.size()==0){
            filterDesignation =  """            "filters":    [
                    {"dataset_id": "${dataset}", "phenotype": "b", "operand": "ID", "operator": "LT", "value": "ZZZZZ", "operand_type": "STRING"}
                ]
""".toString()
        } else  if (filters.size()== 1) {
            String operator = (filters.cmp[0]=="1") ? "LT" : "GT"
            filterDesignation = """ "filters":    [
                    {"dataset_id": "${dataset}", "phenotype": "b", "operand": "${filters[0].name}", "operator": "${operator}", "value": ${filters[0].parm}, "operand_type": "FLOAT"}
            ]""".toString()
        }  else { // filters > 1
            for (Map map in filters){
                String operator = (map.cmp=="1") ? "LT" : "GT"
                if (map.name){
                    requestedFilterList << """{"dataset_id": "${dataset}", "phenotype": "b", "operand": "${map.name}", "operator": "${operator}", "value": ${map.parm}, "operand_type": "FLOAT"}""".toString()
                }
            }
            filterDesignation = """ "filters":    [
                    ${requestedFilterList.join(",")}
            ]
""".toString()
        }

        jsonGetDataString = """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 0,
    "limit": 2000,
    "count": false,
    "properties":    {
                           "cproperty": [],
                          "orderBy":    [],
"dproperty" : { ${requestedDataList.join(",")} } ,
      "pproperty" : { }} ,
       ${filterDesignation}
}""".toString()

        // submit the post request
        jsonResultString = this.restServerService.postGetSampleDataCall(jsonGetDataString, RestServerService.SAMPLE_SERVER_URL_QA)

        // return
        return jsonResultString
    }



    private HashMap<String,HashMap<String,String>> buildSinglePhenotypeDataSetPropertyRecord (HashMap<String,HashMap<String,String>> holdingStructure,String phenotype){
        List<SampleGroup> sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype, '', metaDataService.getDataVersion(), '')
        // List<SampleGroup> sortedSampleGroup = sampleGroup.sort{it.sortOrder}
        List<SampleGroup> sortedSampleGroup = sampleGroup.sort{a,b->b.subjectsNumber<=>a.subjectsNumber} // pick largest number of subjects
        // KLUDGE alert
        sortedSampleGroup = sortedSampleGroup.findAll{!it.systemId.contains('SIGN')} // filter -- no sign allowed
        sortedSampleGroup = sortedSampleGroup.findAll{!it.systemId.contains('MetaStroke')}
        if (sortedSampleGroup.size()>0){
            SampleGroup chosenSampleGroup = sortedSampleGroup.first()
            Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,chosenSampleGroup.systemId,"P_VALUE")
            holdingStructure[phenotype] = [phenotype:phenotype, dataSet:chosenSampleGroup.systemId, property:property.name]
        }
        return holdingStructure
    }

    private HashMap<String,HashMap<String,String>> buildSinglePhenotypeDataSetPropertyRecordFavoringGwas (HashMap<String,HashMap<String,String>> holdingStructure,String phenotype){
        List<SampleGroup> sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype, 'GWAS', metaDataService.getDataVersion(), '')
        if (sampleGroup.size()==0) {
            sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype, '', metaDataService.getDataVersion(), '')
        }

        List<SampleGroup> sortedSampleGroup = sampleGroup.sort{a,b->b.subjectsNumber<=>a.subjectsNumber} // pick largest number of subjects
        // KLUDGE alert
        //sortedSampleGroup = sortedSampleGroup.findAll{!it.systemId.contains('SIGN')} // filter -- no sign allowed, since it is too big and stresses out LZ
        //sortedSampleGroup = sortedSampleGroup.findAll{!it.systemId.contains('MetaStroke')} // filter -- no sign allowed, since it is too big and stresses out LZ
        if (sortedSampleGroup.size()>0){
            SampleGroup chosenSampleGroup = sortedSampleGroup.first()
            Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,chosenSampleGroup.systemId,"P_VALUE")
            holdingStructure[phenotype] = [phenotype:phenotype, dataSet:chosenSampleGroup.systemId, property:property.name]
        }
        return holdingStructure
    }


    private addSinglePhenotypeNameRecord(LinkedHashMap<String, List <List <String>>> groupedPhenotypes,String phenotypeGroupName,String phenotypeCode){
        List <List <String>> groupedPhenotypesList
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        if (groupedPhenotypes.containsKey(phenotypeGroupName)) {
            groupedPhenotypesList = groupedPhenotypes[phenotypeGroupName]
        } else {
            groupedPhenotypesList  = []
            groupedPhenotypes[phenotypeGroupName] = groupedPhenotypesList
        }
        groupedPhenotypesList << [phenotypeCode, g.message(code: "metadata." + phenotypeCode, default: phenotypeCode)]

    }



    public LinkedHashMap<String,HashMap<String,String>> retrieveAllPhenotypeDataSetCombos(){
        LinkedHashMap<String,HashMap<String,String>> returnValue = []

        List<Phenotype> phenotypeList = metaDataService.getPhenotypeListByTechnologyAndVersion('GWAS', metaDataService.getDataVersion(),MetaDataService.METADATA_VARIANT)
        List<Phenotype> sortedPhenotypeList = phenotypeList.sort{it.sortOrder}.unique{it.name}

        PortalVersionBean portalVersionBean = restServerService.retrieveBeanForPortalType(metaDataService.portalTypeFromSession)
        if (portalVersionBean.getOrderedPhenotypeGroupNames().size()==0){
            for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList){
                buildSinglePhenotypeDataSetPropertyRecord(returnValue,phenotype.name)
            }
        } else {
            for (String phenotypeGroupName in portalVersionBean.getOrderedPhenotypeGroupNames()){
                for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList.findAll{it.group==phenotypeGroupName}){
                    boolean skipIt = false
                    for (String excludeString in portalVersionBean.getExcludeFromLZ()){
                        if (phenotype?.parent?.systemId?.contains(excludeString)){
                            skipIt = true
                        }
                    }
                    if (!skipIt){
                        buildSinglePhenotypeDataSetPropertyRecordFavoringGwas(returnValue,phenotype.name)
                    }
                }
            }
            for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList){
                if (!returnValue.containsKey(phenotype.name)){
                    boolean skipIt = false
                    for (String excludeString in portalVersionBean.getExcludeFromLZ()){
                        if (phenotype?.parent?.systemId?.contains(excludeString)){
                            skipIt = true
                        }
                    }
                    if (!skipIt){
                        buildSinglePhenotypeDataSetPropertyRecordFavoringGwas(returnValue,phenotype.name)
                    }
                }
            }
        }


        return returnValue
    }






    public LinkedHashMap<String, List <List <String>>> retrieveGroupedPhenotypesNames(String technology){
        LinkedHashMap<String, List <List <String>>> returnValue = []

        List<Phenotype> phenotypeList = metaDataService.getPhenotypeListByTechnologyAndVersion(technology, metaDataService.getDataVersion(), MetaDataService.METADATA_VARIANT)
        List<Phenotype> sortedPhenotypeList = phenotypeList.sort{it.sortOrder}.unique{it.name}

        LinkedHashMap<String, List <List <String>>> groupedPhenotypes = [:]
        PortalVersionBean portalVersionBean = restServerService.retrieveBeanForPortalType(metaDataService.portalTypeFromSession)
        if (portalVersionBean.getOrderedPhenotypeGroupNames().size()==0){
            for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList){
                addSinglePhenotypeNameRecord(returnValue,phenotype.group,phenotype.name)
            }
        } else {
            // let's impose any order that has been requested
            for (String phenotypeGroupName in portalVersionBean.getOrderedPhenotypeGroupNames()){
                for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList.findAll{it.group==phenotypeGroupName}){
                    boolean skipIt = false
                    for (String excludeString in portalVersionBean.getExcludeFromLZ()){
                        if (phenotype?.parent?.systemId?.contains(excludeString)){
                            skipIt = true
                        }
                    }
                    if (!skipIt){
                        addSinglePhenotypeNameRecord(returnValue,phenotype.group,phenotype.name)
                    }
                }
            }
            // now run over the list again. Anything that hasn't already been inserted goes in now
            for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList){
                if (!(returnValue.containsKey(phenotype.group)&&(returnValue[phenotype.group]).find{it[0]==phenotype.name})){
                    boolean skipIt = false
                    for (String excludeString in portalVersionBean.getExcludeFromLZ()){
                        if (phenotype?.parent?.systemId?.contains(excludeString)){
                            skipIt = true
                        }
                    }
                    if (!skipIt){
                        addSinglePhenotypeNameRecord(returnValue,phenotype.group,phenotype.name)
                    }
                }
            }
        }


        return returnValue
    }









    public HashMap<String,String> retrievePhenotypeDataSetCombo( String defaultPhenotype,
                                                                 String defaultDataSet ){
        LinkedHashMap returnValue = [phenotype:defaultPhenotype, dataSet:defaultDataSet]
        HashMap<String,HashMap<String,String>> allPhenotypeDataSetCombos =  retrieveAllPhenotypeDataSetCombos()
        if (allPhenotypeDataSetCombos.containsKey(defaultPhenotype)){
            returnValue = allPhenotypeDataSetCombos[defaultPhenotype]
        }
        return returnValue
    }





    /**
     * returns a variant list for the LZ query
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    public List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> getVariantListForLocusZoom(   String chromosome,
                                                                                                            int startPosition,
                                                                                                            int endPosition,
                                                                                                            String dataset,
                                                                                                            String phenotype,
                                                                                                            String propertyName,
                                                                                                            String dataType,
                                                                                                            List<String> covariateVariants ) throws PortalException {
        // local variables
        List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> variantList = []
        String jsonResultString, jsonGetDataString;
        LocusZoomJsonBuilder locusZoomJsonBuilder = null;
        KnowledgeBaseResultParser knowledgeBaseResultParser;
        List<Covariate> covariateList = null;

        // Super hack: If we are looking at one of four different stroke data sets then we can make a dynamic call on the 17 K, but we have to
        //  insert a fake data set, property name, and phenotype
        Property property
        Boolean attemptDynamicCall =  (dataType == 'dynamic')

        // build the LZ json builder
        // TODO - DIGKB-135: add way to programmatically determine Hail dataset
        String locusZoomDataset = metaDataService?.getDynamicLocusZoomDataset();
        if (attemptDynamicCall) {
            if (metaDataService.portalTypeFromSession=='t2d') {
                locusZoomJsonBuilder = new LocusZoomJsonBuilder(locusZoomDataset, phenotype, "P_FIRTH_FE_IV");
            } else if (metaDataService.portalTypeFromSession=='stroke') {
                locusZoomJsonBuilder = new LocusZoomJsonBuilder(locusZoomDataset, phenotype, "P_VALUE");
            }
        } else { // option while we get real refs working
            locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype, propertyName );
        }

        // adding covariates for variant
        if (covariateVariants?.size() > 0) {
            covariateList = locusZoomJsonBuilder.parseLzVariants(covariateVariants);
        }

        //
        //  Let's impose some limitations to try to get LZ not to fold
        //
        int maximumNumberOfPointsToRetrieve = 1000
        if (metaDataService.portalTypeFromSession=='t2d') {
            maximumNumberOfPointsToRetrieve = 2000
        } else if (metaDataService.portalTypeFromSession=='stroke') {
            maximumNumberOfPointsToRetrieve = 500
        }

        //
        //  Hail currently has a limit on the number of points it will return.  Therefore if we are undertaking a dynamic call make sure we don't exceed that limit!
        //
        if ((attemptDynamicCall)&&((endPosition-startPosition)>=MAXIMUM_RANGE_FOR_HAIL)){
            int midpoint = ((endPosition+startPosition)/2);
            startPosition = (midpoint-(MAXIMUM_RANGE_FOR_HAIL/2))+1
            endPosition = (midpoint+(MAXIMUM_RANGE_FOR_HAIL/2))-1
        }

        // get json getData query string
        jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, covariateList,maximumNumberOfPointsToRetrieve, "verbose");

        // submit the post request
        if (!attemptDynamicCall){
        //if ((this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_17K_ENDPOINT)||(!attemptDynamicCall)){
            log.info("Got LZ static request for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);
            jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);

        } else if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_HAIL_ENDPOINT_DEV) {
            log.info("Got LZ dynamic request to: " + RestServerService.HAIL_SERVER_URL_DEV + " for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString, RestServerService.HAIL_SERVER_URL_DEV);

        } else if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_HAIL_ENDPOINT_QA) {
            log.info("Got LZ dynamic request to: " + RestServerService.HAIL_SERVER_URL_QA + " for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString, RestServerService.HAIL_SERVER_URL_QA);

        } else {
            log.info("Got LZ dynamic request to: " + RestServerService.HAIL_SERVER_URL_DEV + " for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString, RestServerService.HAIL_SERVER_URL_DEV);
        }

        // translate the returning json into variant list
        if (metaDataService.portalTypeFromSession=='stroke'){
            jsonResultString = jsonResultString.replaceAll(~/P_FIRTH_FE_IV/,"P_VALUE")
        }

        JsonSlurper slurper = new JsonSlurper()
        log.info("Slurping json for correctness???");

        JSONObject parsedJson = slurper.parseText(jsonResultString)
        log.info("Done slurping json for correctness???");
        if (!parsedJson.is_error){
            knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResultString);
            variantList = knowledgeBaseResultParser.parseResult();
        }
        log.info("Got LZ variant result list size of: " + variantList?.size());

        // return
        return variantList;
    }





    public String getFlatDataForLocusZoom(  String chromosome,
                                            int startPosition,
                                            int endPosition,
                                            String dataset,
                                            String phenotype,
                                            String propertyName,
                                            String dataType,
                                            List<String> covariateVariants,
                                            int numberOfRequestedResults ) throws PortalException {
        // local variables
        String jsonResultString, jsonGetDataString;
        LocusZoomJsonBuilder locusZoomJsonBuilder = null;
        KnowledgeBaseResultParser knowledgeBaseResultParser;
        List<Covariate> covariateList = null;

        // build the LZ json builder
        // TODO - DIGKB-135: add way to programmatically determine Hail dataset
        locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype, propertyName );


        // adding covariates for variant
        if (covariateVariants?.size() > 0) {
            covariateList = locusZoomJsonBuilder.parseLzVariants(covariateVariants);
        }

        //
        //  Let's impose some limitations to try to get LZ not to fold
        //
        int maximumNumberOfPointsToRetrieve = numberOfRequestedResults
        if ((metaDataService.portalTypeFromSession=='t2d')&&(numberOfRequestedResults == -1) ) {
            maximumNumberOfPointsToRetrieve = 2000
        } else if ( (metaDataService.portalTypeFromSession=='stroke')&&(numberOfRequestedResults == -1) ) {
            maximumNumberOfPointsToRetrieve = 500
        }

        // get json getData query string
        jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, covariateList,maximumNumberOfPointsToRetrieve, "flat");


            //if ((this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_17K_ENDPOINT)||(!attemptDynamicCall)){
        log.info("Got LZ static request for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);
        jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);
        JSONObject jsonObject
        if (jsonResultString != null){
            jsonObject =  new JsonSlurper().parseText(jsonResultString)
            jsonObject.lastPage = null
            JSONObject dataJSONObject = jsonObject["data"] as JSONObject
            List<String> dataFields = dataJSONObject.names() as List
            int numberOfElements = 0
            boolean choseOurPValue = false
            for (String dataField in dataFields){
                if (dataField == "metadata_rootPOS" ){
                    dataJSONObject.position = dataJSONObject[dataField] as JSONArray
                    numberOfElements = (dataJSONObject[dataField] as List).size()
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootCHROM" ){
                    dataJSONObject.chr = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootVAR_ID" ){
                    dataJSONObject.id = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.id = dataJSONObject.id.collect{String it->List f=it.split("_");if (f.size()==4){return "${f[0]}:${f[1]}_${f[2]}/${f[3]}".toString()}else {return it}} as JSONArray
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootReference_Allele" ){
                    dataJSONObject.refAllele = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootConsequence" ){
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootEffect_Allele" ){
                    dataJSONObject.remove(dataField);
                } else if (dataField == "metadata_rootMOST_DEL_SCORE" ){
                    dataJSONObject.scoreTestStat = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.remove(dataField);
                } else if (dataField.contains("CREDIBLE_SET_ID") ){
                    dataJSONObject.remove(dataField);
                } else if (dataField.contains(propertyName)) { // Will capture either posterior probabilities or else P values
                    dataJSONObject.pvalue = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.remove(dataField);
                    choseOurPValue = true
                }  else if (!choseOurPValue) { // Will capture anything else, including p_values with other p_values names
                    dataJSONObject.pvalue = dataJSONObject[dataField] as JSONArray
                    dataJSONObject.remove(dataField);
                } else {
                    dataJSONObject.remove(dataField);
                }
            }
            JSONArray emptyArrays = new JSONArray()
            for (int i; i<numberOfElements; i++) { emptyArrays.put(JSONObject.NULL)}
//            dataJSONObject.scoreTestStat = emptyArrays
            dataJSONObject.analysis = emptyArrays
            dataJSONObject.refAlleleFreq = emptyArrays

            jsonObject.remove("data")
            jsonObject.data = dataJSONObject

        } else {

            jsonObject =  new JSONObject()
            jsonObject.lastPage = null
            JSONObject dataJSONObject = new JSONObject()
//            List<String> dataFields = dataJSONObject.names() as List
            int numberOfElements = 0
//            for (String dataField in dataFields){
//                if (dataField == "metadata_rootPOS" ){
//                    dataJSONObject.position = dataJSONObject[dataField] as JSONArray
//                    numberOfElements = (dataJSONObject[dataField] as List).size()
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootCHROM" ){
//                    dataJSONObject.chr = dataJSONObject[dataField] as JSONArray
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootVAR_ID" ){
//                    dataJSONObject.id = dataJSONObject[dataField] as JSONArray
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootReference_Allele" ){
//                    dataJSONObject.refAllele = dataJSONObject[dataField] as JSONArray
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootConsequence" ){
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootEffect_Allele" ){
//                    dataJSONObject.remove(dataField);
//                } else if (dataField == "metadata_rootMOST_DEL_SCORE" ){
//                    dataJSONObject.remove(dataField);
//                } else if (dataField.contains("CREDIBLE_SET_ID") ){
//                    dataJSONObject.remove(dataField);
//                } else {
//                    dataJSONObject.pvalue = dataJSONObject[dataField] as JSONArray
//                    dataJSONObject.remove(dataField);
//                }
//            }
            JSONArray emptyArrays = new JSONArray()
//            for (int i; i<numberOfElements; i++) { emptyArrays.put(JSONObject.NULL)}
            dataJSONObject.scoreTestStat = emptyArrays
            dataJSONObject.analysis = emptyArrays
            dataJSONObject.refAlleleFreq = emptyArrays
            dataJSONObject.refAllele = emptyArrays
            dataJSONObject.pvalue = emptyArrays
            dataJSONObject.id = emptyArrays
            dataJSONObject.chr = emptyArrays
            dataJSONObject.position = emptyArrays

            jsonObject.data = dataJSONObject


        }


        // return
        return jsonObject.toString();
    }








    public JSONObject getCredibleSetInformation(String chromosome, int startPosition, int endPosition,
                                                   String dataset, String phenotype, String propertyName) {

        LocusZoomJsonBuilder locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype, propertyName);

        String jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, [] as List,2000, "verbose");

        JSONObject jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);



        // return
        return jsonResultString;
    }



    private JSONObject buildTheIncredibleSet( String chromosome, int startPosition, int endPosition,
                                             String phenotype ){
        String dataSetName = metaDataService.getPreferredSampleGroupNameForPhenotype(phenotype)
        Property newlyChosenProperty = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSetName, "P_VALUE")
        LocusZoomJsonBuilder locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataSetName, phenotype, newlyChosenProperty.name);
        String jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, [] as List,10, "verbose");
        JSONObject jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);
        jsonResultString["dataset"] = dataSetName
        jsonResultString["phenotype"] = phenotype
        jsonResultString["propertyName"] = newlyChosenProperty.name
        return jsonResultString
    }




    public JSONObject getCredibleOrAlternativeSetInformation( String chromosome, int startPosition, int endPosition,
                                                              String dataset, String phenotype, String propertyName ) {
        LocusZoomJsonBuilder locusZoomJsonBuilder
        String jsonGetDataString
        JSONObject jsonResultString
        if (dataset != ''){
             locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype, propertyName);
             jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, [] as List,1, "verbose");
             jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);
            if ((jsonResultString) &&
                    (!jsonResultString.is_error) &&
                    (jsonResultString.numRecords>0) ) { // we have at least one point. Let's get the rest of them
                jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, [] as List,300, "verbose");
                jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);
                jsonResultString["dataset"] = dataset
                jsonResultString["phenotype"] = phenotype
                jsonResultString["propertyName"] = propertyName
            } else {   // We didn't have any variants in this region.  Search a different data set
                jsonResultString = buildTheIncredibleSet(  chromosome,  startPosition,  endPosition, phenotype )
            }

        } else {  // We didn't have any credible set data set for this phenotype. Let's go straight to the alternate data set
            jsonResultString = buildTheIncredibleSet(  chromosome,  startPosition,  endPosition, phenotype )
        }


        // return
        return jsonResultString;
    }





    /**
     * returns a json string for the LZ query
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     */
    public String getVariantJsonForLocusZoomString(String chromosome, int startPosition, int endPosition,
                                                   String dataset, String phenotype, String propertyName,
                                                   String dataType, List<String> covariateVariants, int numberOfRequestedResults ) {
        // local variables
        println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@REQUESTED RESULTS = ${numberOfRequestedResults}")
        List<Variant> variantList = null;
        JSONObject jsonResultObject = null;
        KnowledgeBaseFlatSearchTranslator knowledgeBaseFlatSearchTranslator;
        String jsonResultString = null;

        if((dataset == null) || (dataset == "default")) {
            dataset = metaDataService.getDefaultDataset()
           // dataset = "ExSeq_17k_"+metaDataService.getDataVersion()
        }
        if(phenotype == null) {
            phenotype = this.phenotypeKey
        }

        log.info("Got LZ request for dataset: " + dataset + " and start: " + startPosition + " and end: " + endPosition + " for phenotype: " + phenotype + " and data type: " + dataType);

        Property property
        // get the query result and translate to a json string
        try {
            // get the variant list
            if (dataType=='static') {
                jsonResultString = this.getFlatDataForLocusZoom(chromosome, startPosition, endPosition, dataset, phenotype, propertyName, dataType, covariateVariants, numberOfRequestedResults);
            } else { // dynamic data are still processed the old way, whereas static data will use the new flat format result
                variantList = this.getVariantListForLocusZoom(chromosome, startPosition, endPosition, dataset, phenotype, propertyName, dataType, covariateVariants);

                // TODO: DIGKB-135: Figure out a way to pull the Hail dataset programmatically, not hard code
                String locusZoomDataset = metaDataService?.getDynamicLocusZoomDataset();

                //
                if (metaDataService.portalTypeFromSession=='t2d') {
                    knowledgeBaseFlatSearchTranslator = new KnowledgeBaseFlatSearchTranslator(locusZoomDataset, "T2D", "P_FIRTH_FE_IV" );
                } else if (metaDataService.portalTypeFromSession=='stroke') {
                    knowledgeBaseFlatSearchTranslator = new KnowledgeBaseFlatSearchTranslator(locusZoomDataset, phenotype, "P_FIRTH_FE_IV" );
                }

                jsonResultObject = knowledgeBaseFlatSearchTranslator.translate(variantList);

                // translate to json string
                if (jsonResultObject != null) {
                    jsonResultString = jsonResultObject.toString();
                } else {
                    throw PortalException("got null json object for LZ search");
                }
            }


        } catch (PortalException exception) {
            log.error("Got LZ getData query error: " + exception.getMessage());
            jsonResultString = this.errorResponse;
        }

        // return
        return jsonResultString;
    }

    public String getLocusZoomEndpointSelection() {
        return locusZoomEndpointSelection
    }
    public Boolean getLocusZoomEndpointSelectionIsHail() {
        return ((locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT_DEV)||(locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT_QA))
    }

    /**
     * sets the LZ endpoint setting
     *
     * @param locusZoomEndpointSelection
     */
    void setLocusZoomEndpointSelection(String locusZoomEndpointSelection) {
        // log
        if (locusZoomEndpointSelection == this.LOCUSZOOM_17K_ENDPOINT) {
            log.info("now setting LZ endpoint to 17K dataset")

        } else if (locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT_DEV) {
            log.info("now setting LZ endpoint to Hail goT2D dataset")

        } else if (locusZoomEndpointSelection == this.LOCUSZOOM_HAIL_ENDPOINT_QA) {
            log.info("now setting LZ endpoint to Hail goT2D dataset")

        } else {
            log.error("now setting LZ endpoint to unknown: " + locusZoomEndpointSelection)
        }

        // set the endpoint setting
        this.locusZoomEndpointSelection = locusZoomEndpointSelection
    }

    public List<String> getLocusZoomEndpointList() {
        return locusZoomEndpointList
    }

    /**
     * returns a list of phenotypes to select from for the LZ plot display
     *
     * @return
     */
    public List<PhenotypeBean> getHailPhenotypeMap() {
        // local variables
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        List<PhenotypeBean> beanList = new ArrayList<PhenotypeBean>();
        String portalType = this.metaDataService?.getPortalTypeFromSession();


            HashMap<String,HashMap<String,String>> aAllPhenotypeDataSetCombos = retrieveAllPhenotypeDataSetCombos()
            boolean firstTime = true

        // Previously I was adding credible set datasets as an option, but I don't think they belong
//            List<SampleGroup> sampleGroupsWithCredibleSets  = metaDataService.getSampleGroupListForPhenotypeWithMeaning("T2D","CREDIBLE_SET_ID");
//
//            for (SampleGroup sampleGroupWithCredibleSets in sampleGroupsWithCredibleSets){
//                beanList.add(new PhenotypeBean(key:sampleGroupWithCredibleSets.phenotypes?.first()?.name, name: "T2D_crd",
//                        description: g.message(code: "metadata." + sampleGroupWithCredibleSets.systemId, default: sampleGroupWithCredibleSets.systemId),
//                        dataSet:sampleGroupWithCredibleSets.systemId,
//                        dataSetReadable: g.message(code: "metadata." + sampleGroupWithCredibleSets.systemId,default: sampleGroupWithCredibleSets.systemId),
//                        propertyName: "P_VALUE", dataType: "static", defaultSelected: false,
//                        suitableForDefaultDisplay: false));
//            }



            for (String phenotype in aAllPhenotypeDataSetCombos.keySet()){
                HashMap<String,String> phenotypeDataSetCombo = aAllPhenotypeDataSetCombos[phenotype]
                beanList.add(new PhenotypeBean(key: phenotype, name: phenotype, dataSet:phenotypeDataSetCombo.dataSet,
                        dataSetReadable: g.message(code: "metadata." + phenotypeDataSetCombo.dataSet, default: phenotypeDataSetCombo.dataSet),
                        propertyName:phenotypeDataSetCombo.property,dataType:"static",
                        description: g.message(code: "metadata." + phenotype, default: phenotype), defaultSelected: firstTime, suitableForDefaultDisplay: true))

                firstTime = false
            }

            // build the dynamic phenotype list by hand for now.  Clearly we need a metadata call eventually.
            if (metaDataService.portalTypeFromSession=='t2d') {
                beanList.add(new PhenotypeBean(key: "T2D", name: "T2D", description: "Type 2 Diabetes", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),
                        propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: true, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "BMI_adj_withincohort_invn", name: "BMI", description: "Body Mass Index", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "LDL_lipidmeds_divide.7_adjT2D_invn", name: "LDL", description: "LDL Cholesterol", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "HDL_adjT2D_invn", name: "HDL", description: "HDL Cholesterol", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "logfastingInsulin_adj_invn", name: "FI", description: "Fasting Insulin", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "fastingGlucose_adj_invn", name: "FG", description: "Fasting Glucose", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "HIP_adjT2D_invn", name: "HIP", description: "Hip Circumference", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "WC_adjT2D_invn", name: "WC", description: "Waist Circumference", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "WHR_adjT2D_invn", name: "WHR", description: "Waist Hip Ratio", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "TC_adjT2D_invn", name: "TC", description: "Total Cholesterol", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "TG_adjT2D_invn", name: "TG", description: "Triglycerides", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "ExSeq_13k_mdv23", default: "ExSeq_13k_mdv23"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));

            } else if (metaDataService.portalTypeFromSession=='stroke') {
/*
                beanList.add(new PhenotypeBean(key: "ICH_Status", name: "ICH_Status", description: "ICH Status", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "GWAS_Stroke_mdv70", default: "GWAS_Stroke_mdv70"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: true, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "Lobar_ICH", name: "Lobar_ICH", description: "Lobar ICH", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "GWAS_Stroke_mdv70", default: "GWAS_Stroke_mdv70"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "Deep_ICH", name: "Deep_ICH", description: "Deep ICH", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "GWAS_Stroke_mdv70", default: "GWAS_Stroke_mdv70"),propertyName:"hailProp",dataType:"dynamic",
                        defaultSelected: false, suitableForDefaultDisplay: true));
                beanList.add(new PhenotypeBean(key: "History_of_Hypertension", name: "History_of_Hypertension", description: "History of Hypertension", dataSet:"hail",
                        dataSetReadable: g.message(code: "metadata." + "GWAS_Stroke_mdv70", default: "GWAS_Stroke_mdv70"),propertyName:"hailProp",
                        defaultSelected: false, suitableForDefaultDisplay: true));
*/
            }


        // return
        beanList << new PhenotypeBean(key:"Adipose", name:"Adipose",description:"adipose tissue", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"AnteriorCaudate", name:"AnteriorCaudate",description:"brain anterior caudate", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"CD34-PB", name:"CD34-PB",description:"CD34-PB primary hematopoietic stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"CingulateGyrus", name:"CingulateGyrus",description:"brain cingulate gyrus", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"ColonicMucosa", name:"ColonicMucosa",description:"colonic mucosa", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"DuodenumMucosa", name:"DuodenumMucosa",description:"duodenum mucosa", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"ES-HUES6", name:"ES-HUES6",description:"ES-HUES6 embryonic stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"ES-HUES64", name:"ES-HUES64",description:"ES-HUES64 embryonic stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"GM12878", name:"GM12878",description:"GM12878 lymphoblastoid cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"H1", name:"H1",description:"H1 cell line", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"hASC-t1", name:"hASC-t1",description:"hASC-t1 adipose stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"hASC-t2", name:"hASC-t2",description:"hASC-t2 adipose stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"hASC-t3", name:"hASC-t3",description:"hASC-t3 adipose stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"hASC-t4", name:"hASC-t4",description:"hASC-t4 adipose stem cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"HepG2", name:"HepG2",description:"HepG2 hepatocellular carcinoma cell line", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"HippocampusMiddle", name:"HippocampusMiddle",description:"brain hippocampus middle", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"HMEC", name:"HMEC",description:"HMEC mammary epithelial primary cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"HSMM", name:"HSMM",description:"HSMM skeletal muscle myoblast cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"Huvec", name:"Huvec",description:"HUVEC umbilical vein endothelial primary cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"InferiorTemporalLobe", name:"InferiorTemporalLobe",description:"brain inferior temporal lobe", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"Islets", name:"Islets",description:"pancreatic islets", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"K562", name:"K562",description:"K562 leukemia cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"Liver", name:"Liver",description:"liver", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"MidFrontalLobe", name:"MidFrontalLobe",description:"brain mid-frontal lobe", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"NHEK", name:"NHEK",description:"NHEK epidermal keratinocyte primary cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"NHLF", name:"NHLF",description:"NHLF lung fibroblast primary cells", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"RectalMucosa", name:"RectalMucosa",description:"rectal mucosa", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"RectalSmoothMuscle", name:"RectalSmoothMuscle",description:"rectal smooth muscle", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"SkeletalMuscle", name:"SkeletalMuscle",description:"skeletal muscle", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"StomachSmoothMuscle", name:"StomachSmoothMuscle",description:"stomach smooth muscle", dataType:"tissue", suitableForDefaultDisplay: true)
        beanList << new PhenotypeBean(key:"SubstantiaNigra", name:"SubstantiaNigra",description:"brain substantia nigra", dataType:"tissue", suitableForDefaultDisplay: true)
//        beanList << new PhenotypeBean(key:"Islet1", name:"Islet1",description:"pancreatic islets 1", dataType:"tissue",  assayId:4, suitableForDefaultDisplay: true)
//        beanList << new PhenotypeBean(key:"Islet2", name:"Islet2",description:"pancreatic islets 2", dataType:"tissue",  assayId:4, suitableForDefaultDisplay: true)
//        beanList << new PhenotypeBean(key:"SkeletalMuscle", name:"SkeletalMuscle",description:"skeletal muscle", dataType:"tissue",  assayId:4, suitableForDefaultDisplay: true)
//        beanList << new PhenotypeBean(key:"Adipose", name:"Adipose",description:"adipose tissue", dataType:"tissue",  assayId:4, suitableForDefaultDisplay: true)
//        beanList << new PhenotypeBean(key:"gm12878", name:"gm12878",description:"GM12878 lymphoblastoid cells", dataType:"tissue", assayId:4, suitableForDefaultDisplay: true)

        return beanList
    }

}
