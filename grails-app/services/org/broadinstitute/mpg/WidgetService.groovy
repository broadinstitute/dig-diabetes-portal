package org.broadinstitute.mpg
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.MetaDataService
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









    public HashMap<String,HashMap<String,String>> retrieveAllPhenotypeDataSetCombos(){
        LinkedHashMap<String,HashMap<String,String>> returnValue = []
//                ['ICH_Status':[phenotype:"Stroke_all", dataSet:'GWAS_Stroke_'+metaDataService.getDataVersion()],
//                                     'Deep_ICH':[phenotype:"Stroke_deep", dataSet:'GWAS_Stroke_'+metaDataService.getDataVersion()],
//                                     'Lobar_ICH':[phenotype:"Stroke_lobar", dataSet:'GWAS_Stroke_'+metaDataService.getDataVersion()],
//                                     'FG':[phenotype:"FG", dataSet:'GWAS_MAGIC_'+metaDataService.getDataVersion()],
//                                     '2hrI':[phenotype:"2hrI", dataSet:'GWAS_MAGIC_'+metaDataService.getDataVersion()],
//                                     'CAD':[phenotype:"CAD", dataSet:'GWAS_CARDIoGRAM_'+metaDataService.getDataVersion()],
//                                     'UACR':[phenotype:"UACR", dataSet:'GWAS_CKDGenConsortium-UACR_'+metaDataService.getDataVersion()]
//        ];
        List<Phenotype> phenotypeList = metaDataService.getPhenotypeListByTechnologyAndVersion('GWAS', metaDataService.getDataVersion())
        List<Phenotype> sortedPhenotypeList = phenotypeList.sort{it.sortOrder}.unique{it.name}
        // kludge to reorder for stroke demo
        for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList.findAll{it.group=="ISCHEMIC STROKE"}){
            List<SampleGroup> sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype.name, 'GWAS', metaDataService.getDataVersion(), 'Mixed')
            if (sampleGroup.size()>0){
                SampleGroup chosenSampleGroup = sampleGroup.first()
                returnValue[phenotype.name] = [phenotype:phenotype.name, dataSet:chosenSampleGroup.systemId]
            }
        }
        for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList.findAll{it.group=="TOAST ALL STROKE"}){
            List<SampleGroup> sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype.name, 'GWAS', metaDataService.getDataVersion(), 'Mixed')
            if (sampleGroup.size()>0){
                SampleGroup chosenSampleGroup = sampleGroup.first()
                returnValue[phenotype.name] = [phenotype:phenotype.name, dataSet:chosenSampleGroup.systemId]
            }
        }
        for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in sortedPhenotypeList.findAll{it.group!="TOAST ALL STROKE"&&it.group!="ISCHEMIC STROKE"}){
            List<SampleGroup> sampleGroup = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(phenotype.name, 'GWAS', metaDataService.getDataVersion(), 'Mixed')
            if (sampleGroup.size()>0){
                SampleGroup chosenSampleGroup = sampleGroup.first()
                returnValue[phenotype.name] = [phenotype:phenotype.name, dataSet:chosenSampleGroup.systemId]
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
    public List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> getVariantListForLocusZoom(String chromosome, int startPosition, int endPosition, String dataset, String phenotype, List<String> covariateVariants) throws PortalException {
        // local variables
        List<org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant> variantList;
        String jsonResultString, jsonGetDataString;
        LocusZoomJsonBuilder locusZoomJsonBuilder = null;
        KnowledgeBaseResultParser knowledgeBaseResultParser;
        List<Covariate> covariateList = null;

        // Super hack: If we are looking at one of four different stroke data sets then we can make a dynamic call on the 17 K, but we have to
        //  insert a fake data set, property name, and phenotype
        Property property
        Boolean attemptDynamicCall = true

        if (metaDataService.portalTypeFromSession!='t2d'){ // stroke must be static only
            attemptDynamicCall = false
            HashMap phenoDataSet = retrievePhenotypeDataSetCombo( phenotype,
                    dataset )
            phenotype = phenoDataSet.phenotype
            dataset = phenoDataSet.dataSet
        }

        property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataset,'P_VALUE')
        // build the LZ json builder
        if (property) {
            locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype, property.name);
        } else { // option while we get real refs working
            locusZoomJsonBuilder = new LocusZoomJsonBuilder(dataset, phenotype);
        }

        // adding covariates for variant
        if (covariateVariants?.size() > 0) {
            covariateList = locusZoomJsonBuilder.parseLzVariants(covariateVariants);
        }

        // get json getData query string
        jsonGetDataString = locusZoomJsonBuilder.getLocusZoomQueryString(chromosome, startPosition, endPosition, covariateList);

        // submit the post request
        if ((this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_17K_ENDPOINT)||(!attemptDynamicCall)){
            jsonResultString = this.restServerService.postGetDataCall(jsonGetDataString);

        } else if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_HAIL_ENDPOINT_DEV) {
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString, RestServerService.HAIL_SERVER_URL_DEV);

        } else if (this.getLocusZoomEndpointSelection() == this.LOCUSZOOM_HAIL_ENDPOINT_QA) {
            jsonResultString = this.restServerService.postGetHailDataCall(jsonGetDataString, RestServerService.HAIL_SERVER_URL_QA);

        } else {
            throw new PortalException("Got incorrect LZ endpoint selection: " + this.getLocusZoomEndpointSelection())
        }

        // translate the returning json into variant list
        knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResultString);
        variantList = knowledgeBaseResultParser.parseResult();

        // return
        return variantList;
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
                                                   String dataset, String phenotype, List<String> covariateVariants) {
        // local variables
        List<Variant> variantList = null;
        JSONObject jsonResultObject = null;
        KnowledgeBaseFlatSearchTranslator knowledgeBaseFlatSearchTranslator;
        String jsonResultString = null;

        if((dataset == null) || (dataset == "default")) {
            dataset = "ExSeq_17k_"+metaDataService.getDataVersion()
        }
        if(phenotype == null) {
            phenotype = this.phenotypeKey
        }
        Property property
        // get the query result and translate to a json string
        try {
            // get the variant list
            variantList = this.getVariantListForLocusZoom(chromosome, startPosition, endPosition, dataset, phenotype, covariateVariants);

            // TODO: DIGP-354: Review property spoofing for Hail multiple phenotype call to see if appropriate
            // translate to json string
            if (metaDataService.portalTypeFromSession!='t2d') {
                HashMap phenoDataSet = retrievePhenotypeDataSetCombo(phenotype,
                        dataset)
                phenotype = phenoDataSet.phenotype
                dataset = phenoDataSet.dataSet
            } else {
                phenotype = "T2D"
                dataset = "ExSeq_17k_"+metaDataService.getDataVersion()
            }

            property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataset,'P_VALUE')

            //
            knowledgeBaseFlatSearchTranslator = new KnowledgeBaseFlatSearchTranslator(dataset, phenotype, property.name);

            jsonResultObject = knowledgeBaseFlatSearchTranslator.translate(variantList);

            // translate to json string
            if (jsonResultObject != null) {
                jsonResultString = jsonResultObject.toString();
            } else {
                throw PortalException("got null json object for LZ search");
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

        if (portalType.equals("stroke")) {
            HashMap<String,HashMap<String,String>> aAllPhenotypeDataSetCombos = retrieveAllPhenotypeDataSetCombos()
            boolean firstTime = true
            for (String phenotype in aAllPhenotypeDataSetCombos.keySet()){
                beanList.add(new PhenotypeBean(key: phenotype, name: phenotype,
                        description: g.message(code: "metadata." + phenotype, default: phenotype), defaultSelected: firstTime))
                firstTime = false
            }
            // build the phenotype list
//            beanList.add(new PhenotypeBean(key: "Stroke_all", name: "Stroke_all", description: "ICH Status", defaultSelected: true));
//            beanList.add(new PhenotypeBean(key: "Stroke_lobar", name: "Stroke_lobar", description: "Lobar ICH", defaultSelected: false));
//            beanList.add(new PhenotypeBean(key: "Stroke_deep", name: "Stroke_deep", description: "Deep ICH", defaultSelected: false));
//            beanList.add(new PhenotypeBean(key: "CAD", name: "CAD", description: "Coronary artery disease", defaultSelected: false));
//            beanList.add(new PhenotypeBean(key: "FG", name: "FG", description: "Fasting glucose", defaultSelected: false));
//            beanList.add(new PhenotypeBean(key: "2hrI", name: "2hrI", description: "2 hour insulin", defaultSelected: false));
//            beanList.add(new PhenotypeBean(key: "History_of_Hypertension", name: "History_of_Hypertension", description: "History of Hypertension", defaultSelected: false));

        } else {
            // build the phenotype list
            beanList.add(new PhenotypeBean(key: "T2D", name: "T2D", description: "Type 2 Diabetes", defaultSelected: true));
            beanList.add(new PhenotypeBean(key: "BMI_adj_withincohort_invn", name: "BMI", description: "Body Mass Index", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "LDL_lipidmeds_divide.7_adjT2D_invn", name: "LDL", description: "LDL Cholesterol", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "HDL_adjT2D_invn", name: "HDL", description: "HDL Cholesterol", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "logfastingInsulin_adj_invn", name: "FI", description: "Fasting Insulin", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "fastingGlucose_adj_invn", name: "FG", description: "Fasting Glucose", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "HIP_adjT2D_invn", name: "HIP", description: "Hip Circumference", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "WC_adjT2D_invn", name: "WC", description: "Waist Circumference", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "WHR_adjT2D_invn", name: "WHR", description: "Waist Hip Ratio", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "TC_adjT2D_invn", name: "TC", description: "Total Cholesterol", defaultSelected: false));
            beanList.add(new PhenotypeBean(key: "TG_adjT2D_invn", name: "TG", description: "Triglycerides", defaultSelected: false));
        }

        // return
        return beanList
    }

}
