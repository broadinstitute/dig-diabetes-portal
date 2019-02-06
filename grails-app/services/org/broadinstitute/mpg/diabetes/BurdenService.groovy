package org.broadinstitute.mpg.diabetes

import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.FilterManagementService
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.WidgetService
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.json.JSONTokener

@Transactional
class BurdenService {

    RestServerService restServerService;
    SharedToolsService sharedToolsService;
    GrailsApplication grailsApplication
    MetaDataService metaDataService
    WidgetService widgetService
    FilterManagementService filterManagementService

    final static Integer MINIMUM_ALLOWABLE_NUMBER_OF_SAMPLES = 100

    def serviceMethod() {

    }

    /**
     * return the singleton burden json builder
     *
     * @return
     */
    private BurdenJsonBuilder getBurdenJsonBuilder() {
        return BurdenJsonBuilder.getBurdenJsonBuilder();
    }

    /**
     * call the burden test rest service with the given json payload string
     *
     * @param burdenCallJsonPayloadString
     * @return
     */
    protected JSONObject getBurdenRestCallResults(String burdenCallJsonPayloadString) {
        JSONObject burdenJson = this.restServerService.postBurdenRestCall(burdenCallJsonPayloadString);
        return burdenJson;
    }


    protected JSONObject getBurdenRestMetaData(String burdenCallJsonPayloadString) {
        JSONObject burdenJson = this.restServerService.postRestBurdenMetaData(burdenCallJsonPayloadString);
        return burdenJson;
    }



private Integer interpretDeleteriousnessParameterToGenerateMds (int variantSelectionOptionId){
    int mostDelScore
    switch (variantSelectionOptionId){
        case PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING:
            mostDelScore = 1;
            break;
        case PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE:
            mostDelScore = 2;
            break;
        case PortalConstants.BURDEN_VARIANT_OPTION_ALL_CODING:
            mostDelScore = 3;
            break;
        case PortalConstants.BURDEN_VARIANT_OPTION_ALL:
        case PortalConstants.BURDEN_VARIANT_OPTION_NS_STRICT: // filter locally
        case PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD:  // filter locally
        case PortalConstants.BURDEN_VARIANT_OPTION_NS:  // filter locally
        case PortalConstants.BURDEN_VARIANT_OPTION_ALL:
            mostDelScore = 5;
            break;
        default:
            mostDelScore = 5;
            break;
    }
    return mostDelScore
}


    private String interpretDeleteriousnessParameterToGenerateOperator (int variantSelectionOptionId){
        String operand = PortalConstants.OPERATOR_LESS_THAN_EQUALS;
        switch (variantSelectionOptionId){
            case PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING:
                operand = PortalConstants.OPERATOR_EQUALS;
                break;
            default:
                break;
        }
        return operand
    }

    private String interpretDeleteriousnessParameterToGenerateHackOperator (int variantSelectionOptionId){
        String operand = "le";
        switch (variantSelectionOptionId){
            case PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING:
                operand = PortalConstants.OPERATOR_EQUALS;
                break;
            default:
                break;
        }
        return operand
    }




    /**
     * method to get the variants from the getData call
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    protected JSONObject getBiallelicVariantsForGene(String geneString, int variantSelectionOptionId, List<QueryFilter> additionalQueryFilterList, String dataSet) {
        // local variables
        String jsonString = "";
        JSONObject resultJson;
        int mostDelScore = interpretDeleteriousnessParameterToGenerateMds (variantSelectionOptionId)
        String operand = interpretDeleteriousnessParameterToGenerateHackOperator (variantSelectionOptionId)

        List <String> filterList = []

        filterList << """{"parameter": "most_del_score", "operator": "${operand}", "value": ${mostDelScore}}""".toString()

        // super hack
        //filterList << """{"parameter": "p_value", "operator": "lt", "value": "0.01"}""".toString()

        if (geneString){
            filterList << """{"parameter": "gene", "operator": "eq", "value": "${geneString}"}""".toString()
        }

        // get the json string to send to the getData call
        try {
            jsonString = """{   "version": "${metaDataService?.getDataVersion()}",
                "dataset": "${dataSet}",
                "phenotype": "T2D",
                "filters": [
                ${filterList.join(",")}
            ]
            }""".toString ()


        } catch (PortalException exception) {
            log.error("Got json building error for getData payload creation: " + exception.getMessage());
        }

        // call the post REST call
        resultJson = this.restServerService.postMultiAllelicHackRestCall(jsonString);

        // return the result
        return resultJson;
    }







    protected JSONObject getMultiallelicVariantsForGene(String geneString, int variantSelectionOptionId, List<QueryFilter> additionalQueryFilterList, String dataSet) {
        // local variables
        String jsonString = "";
        JSONObject resultJson;
        int mostDelScore = interpretDeleteriousnessParameterToGenerateMds (variantSelectionOptionId)
        String operand = interpretDeleteriousnessParameterToGenerateOperator (variantSelectionOptionId)

        Property macProperty = metaDataService.getSampleGroupProperty(dataSet,"MAC",MetaDataService.METADATA_VARIANT)
        List<Property> additionalProperties = []
        if (macProperty != null){
            additionalProperties << macProperty
        }
        Property mafProperty = metaDataService.getSampleGroupProperty(dataSet,"MAF",MetaDataService.METADATA_VARIANT)
        if (mafProperty) {
            additionalProperties << mafProperty
        }

        // get the json string to send to the getData call
        try {
            jsonString = this.getBurdenJsonBuilder().getKnowledgeBaseQueryPayloadForVariantSearch(geneString, operand, mostDelScore, additionalQueryFilterList, additionalProperties);

        } catch (PortalException exception) {
            log.error("Got json building error for getData payload creation: " + exception.getMessage());
        }

        // call the post REST call
        resultJson = this.restServerService.postGetDataCall(jsonString);

        // return the result
        return resultJson;
    }









    /**
     * based on a configuration value determine whether we should pull variance from our traditional multiallelics store, or else decide that
     * we should attempt to pull back there biallele at counterparts
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    protected JSONObject getVariantsForGene(String geneString, int variantSelectionOptionId, List<QueryFilter> additionalQueryFilterList, String dataSet) {
        JSONObject returnValue


        String alleleType = ""
        SampleGroup sampleGroupObj = metaDataService.getSampleGroupByName(dataSet,MetaDataService.METADATA_SAMPLE)
        if (sampleGroupObj?.getMeaningSet()?.contains(PortalConstants.PROPERTY_MEANING_MULTI_ALLELE_KEY)){
            alleleType=  PortalConstants.JSON_BURDEN_OPERATION_ALLELE_TYPE_KEY;
        }

        if (( restServerService.retrieveBeanForCurrentPortal().utilizeBiallelicGait )&&
                (alleleType ==  PortalConstants.JSON_BURDEN_OPERATION_ALLELE_TYPE_KEY)){
            returnValue = getBiallelicVariantsForGene ( geneString,  variantSelectionOptionId,  additionalQueryFilterList,  dataSet)
        }else{
            returnValue = getMultiallelicVariantsForGene ( geneString,  variantSelectionOptionId,  additionalQueryFilterList,  dataSet)
        }

        return returnValue
    }




    public JSONObject convertSampleGroupListToJson (List <SampleGroup> sampleGroupList){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        List <String> sampleGroupNamesAsJson = []
        for (SampleGroup sampleGroup in sampleGroupList) {
            sampleGroupNamesAsJson << """{"name":"${sampleGroup.systemId}", "trans":"${
                g.message(code: 'metadata.' + sampleGroup.systemId, default: sampleGroup.systemId)
            }"  }""".toString()
        }
         String jsonString = """{"sampleGroups":[${sampleGroupNamesAsJson.join(",")}]
}""".toString()
        JsonSlurper slurper = new JsonSlurper()
        return slurper.parseText(jsonString)
    }






    public JSONObject convertSampleGroupPropertyListToJson (SampleGroup sampleGroup){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        if (sampleGroup == null) { return new JSONObject() }

        List <String> phenotypeList = []
        List <String> covariateList = []
        List <String> filterList = []
        List <String> filtersRequiringMoreInfo = []

        // preview filter list and then go and retrieve categorical levels
        List <Property> propertyList = sampleGroup.properties.findAll{it.meaningSet.contains("FILTER")}
        propertyList = propertyList.sort{a,b->return a.sortOrder<=>b.sortOrder}
        for (Property property in propertyList){
            if (property.variableType!="FLOAT"){
                filtersRequiringMoreInfo <<  property.name
            }
        }

        LinkedHashMap<String,List<String>> categoryLevelInfo = []
        for (String filterName in filtersRequiringMoreInfo){
            JSONObject sampleSummary = widgetService.getSampleDistribution ( sampleGroup.getSystemId(),
                                                                             [""" "${filterName}":["${sampleGroup.getSystemId()}"]""".toString()],
                                                                             true, [], true )
            categoryLevelInfo[filterName] = sampleSummary.distribution_array.collect{return """{"samples":${it.count},"name":"${it.value}"}""".toString()}
        }

        // now go back through the filter list, generating the strings we need, and supplementing them with category information
        for (Property property in propertyList){
            if (property.variableType!="FLOAT"){
                String levels = "["+categoryLevelInfo[property.name].join(",")+"]"
                filterList << """{"name":"${property.name}", "type":"${property.variableType}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}","levels":${levels}  }""".toString()
            } else {
                filterList << """{"name":"${property.name}", "type":"${property.variableType}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}"  }""".toString()
            }
        }



        // collect phenotypes
        propertyList = sampleGroup.properties.findAll{it.meaningSet.contains("PHENOTYPE")}
        propertyList = propertyList.sort{a,b->return a.sortOrder<=>b.sortOrder}
        for (Property property in propertyList){
            phenotypeList << """{"name":"${property.name}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}"  }""".toString()
        }

        // collect covariates that are selected by default
        propertyList = sampleGroup.properties.findAll{it.meaningSet.contains("COVARIATE")&&(it.meaningSet.contains("DEFAULT_COVARIATE"))}
        propertyList = propertyList.sort{a,b->return a.sortOrder<=>b.sortOrder}
        for (Property property in propertyList){
            covariateList << """{"name":"${property.name}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}","def":1}""".toString()
        }

        // collect covariates that are not selected by default
        propertyList = sampleGroup.properties.findAll{it.meaningSet.contains("COVARIATE")&&(!it.meaningSet.contains("DEFAULT_COVARIATE"))}
        propertyList = propertyList.sort{a,b->return a.sortOrder<=>b.sortOrder}
        for (Property property in propertyList){
             covariateList << """{"name":"${property.name}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}","def":0}""".toString()
        }

        String jsonString = """{"dataset":"${sampleGroup.systemId}",
"phenotypes":[${phenotypeList.join(",")}],
"covariates":[${covariateList.join(",")}],
"filters":[${filterList.join(",")}]
}""".toString()
        JsonSlurper slurper = new JsonSlurper()
        return slurper.parseText(jsonString)
    }











    public String  generateListOfVariantsFromFilters(String phenotype, String geneString, int variantSelectionOptionId, int mafSampleGroupOption, Float mafValue, String dataSet, Boolean explicitlySelectSamples) {
        // local variables
        JSONObject jsonObject, returnJson;
        List<Variant> variantList;
        List<String> burdenVariantList;
        int dataVersionId = this.sharedToolsService.getDataVersion();

        String dataVersion = metaDataService.getDataVersion()


        List<QueryFilter> queryFilterList;
        String retval

        // log
        log.info("called burden test for gene: " + geneString + " and variant select option: " + variantSelectionOptionId + " and data version id: " + dataVersionId);
        log.info("also had MAF option: " + mafSampleGroupOption + " and MAF value: " + mafValue);
        // when the phenotypes no longer have multiple names each then we can remove this kludgefest
        String convertedPhenotype = phenotype
        switch (phenotype){
            case "t2d": convertedPhenotype = "T2D"; break
            case "ICH_Status": convertedPhenotype = "ICH"; break
            default:
                convertedPhenotype = phenotype;
                break
        }

        try {
//            if ((variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD)||
//                    (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS)){
//                mafValue = 0.01
//            }
            queryFilterList = this.getBurdenJsonBuilder().getMinorAlleleFrequencyFiltersByString(dataVersion, mafSampleGroupOption, mafValue, dataSet, metaDataService);

            // get the getData results payload
            jsonObject = this.getVariantsForGene(geneString, variantSelectionOptionId, queryFilterList, dataSet);
            log.info("got burden getData results: " + jsonObject);


            // get the list of variants back
            variantList = this.getBurdenJsonBuilder().getVariantListFromJson(jsonObject);
            log.info("got first pass variant list of size: " + variantList.size());

            // filter variant list based on polyphen/sift
            burdenVariantList = this.transformAndFilterVariantList(variantList, variantSelectionOptionId,dataSet);
            log.info("got filtered variant list of size: " + burdenVariantList.size());

            // filter the larger json object based on the variants that passed the above
            if (restServerService.retrieveBeanForCurrentPortal().utilizeBiallelicGait){
               // jsonObject.variants = jsonObject.variants?.findAll{Map v->return burdenVariantList.contains(v["VAR_ID"])}
                jsonObject.variants = jsonObject.variants?.findAll{List vals->vals.find{Map props->burdenVariantList.contains(props.VAR_ID)}}
            } else {
                jsonObject.variants = jsonObject.variants?.findAll{List vals->vals.find{Map props->burdenVariantList.contains(props.VAR_ID)}}
            }

            jsonObject.numRecords = jsonObject.variants?.size()

            // get the list of variants back
            retval = restServerService.processInfoFromGetDataCall ( jsonObject, "\"d\":1", "", MetaDataService.METADATA_VARIANT )

        } catch (PortalException exception) {
            log.error("Got error creating burden test for gene: " + geneString + " and phenotype: " + phenotype + ": " + exception.getMessage());
        }

        // return
        return retval;
    }

























    /**
     * method to return the burden test REST payload
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    public JSONObject callBurdenTest(String phenotype, String geneString, int variantSelectionOptionId, int mafSampleGroupOption, Float mafValue, String dataSet, String sampleDataSet,
                                     Boolean explicitlySelectSamples, String portalTypeString, String variantSetId, String biallelicCheckboxValue) {
        // local variables
        JSONObject jsonObject, returnJson;
        List<Variant> variantList;
        List<String> burdenVariantList;
        int dataVersionId = this.sharedToolsService.getDataVersion();
        String dataVersion = metaDataService.getDataVersion();
        List<QueryFilter> queryFilterList;

        // log
        log.info("called burden test for gene: " + geneString + " and variant select option: " + variantSelectionOptionId + " and data version id: " + dataVersionId);
        log.info("also had MAF option: " + mafSampleGroupOption + " and MAF value: " + mafValue);
        // when the phenotypes no longer have multiple names each then we can remove this kludgefest
        String convertedPhenotype = phenotype
        switch (phenotype){
            case "t2d": convertedPhenotype = "T2D"; break
            default: break
        }





        try {
            String dataset = (dataSet == null ? metaDataService.getDefaultDataset() : dataSet)
            if ((variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD)||
                    (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS)){
                mafValue = 0.01
            }
            queryFilterList = this.getBurdenJsonBuilder().getMinorAlleleFrequencyFiltersByString(dataVersion, mafSampleGroupOption, mafValue, dataSet, metaDataService);

            // get the getData results payload
            jsonObject = this.getVariantsForGene(geneString, variantSelectionOptionId, queryFilterList, dataSet);
            log.info("got burden getData results: " + jsonObject);

            // get the list of variants back
            variantList = this.getBurdenJsonBuilder().getVariantListFromJson(jsonObject);
            log.info("got first pass variant list of size: " + variantList.size());

            // filter variant list based on polyphen/sift
            burdenVariantList = this.transformAndFilterVariantList(variantList, variantSelectionOptionId,dataSet);
            log.info("got filtered variant list of size: " + burdenVariantList.size());

            JSONObject samplesObject = new JSONObject()
            JSONArray samplesArray = new JSONArray()
            samplesObject.put(PortalConstants.JSON_BURDEN_SAMPLES_KEY, samplesArray)

            JSONObject covariatesObject = new JSONObject()
            JSONArray covariatesArray
            if (portalTypeString=='mi'){
                covariatesArray = new JSONArray(["C1","C2","C3","C4","SEX"])
            } else {
                covariatesArray = new JSONArray(["C1","C2","C3","C4","Age","SEX"])
            }
            JSONArray
            covariatesObject.put(PortalConstants.JSON_BURDEN_COVARIATES_KEY, covariatesArray);

            JSONObject filtersObject = new JSONObject()


            returnJson = this.getBurdenResultForVariantIdList( "mdv${dataVersionId}".toString(), phenotype, burdenVariantList, covariatesObject, samplesObject, filtersObject, [] as JSONArray,
                                                               sampleDataSet, explicitlySelectSamples, variantSetId, biallelicCheckboxValue );

        } catch (PortalException exception) {
            log.error("Got error creating burden test for gene: " + geneString + " and phenotype: " + phenotype + ": " + exception.getMessage());
        }

        if (returnJson == null) {
            JSONTokener tokener = new JSONTokener("{\"stats\": { \"pValue\": \"0.0\", \"beta\": \"0.0\", \"stdError\": 0, \"is_error\": false, \"variants\": []}}");
            returnJson = new JSONObject(tokener);
            log.info("returning empty burden rest result: " + returnJson);
        }

        // return
        return returnJson;
    }




    public JSONObject getBurdenResultForMetadata(JSONArray statsObjectList) throws PortalException {

        // create the json payload for the burden call
        List<String> metadataList = []
        if (statsObjectList) {
            metadataList = statsObjectList.collect{return """{ "beta":${it.be}, "stdError": ${it.st}  }""".toString()} as List
        }
        String jsonObject = """{
    "stats": [ ${metadataList.join(",")}
    ],
    "passback": "123pass",
    "method": "inverse_variance"
}""".toString()

        // get the results of the burden call
        JSONObject returnJson = this.getBurdenRestMetaData(jsonObject.toString())

        // return
        return returnJson
    }













    /**
     * call burden test for single variant
     *
     * @param traitOption
     * @param burdenVariantDbSnpId
     * @return
     * @throws PortalException
     */
    protected JSONObject callBurdenTestForTraitAndDbSnpId(String traitOption, List <String> burdenVariantList,
                                                          JSONObject covariateJsonObject,
                                                          JSONObject sampleJsonObject,
                                                          JSONObject filtersJsonObject,
                                                          JSONArray phenotypeFilterValues,
                                                          String dataset,
                                                          String variantSetId,
                                                          String biallelicCheckboxValue) throws PortalException {
        // local variables
        org.broadinstitute.mpg.Variant burdenVariant;
        JSONObject returnJson = null;

        List<String> variantIds = []
        if ((burdenVariantList)&& (burdenVariantList.size()==1) && (burdenVariantList[0].size()>0))      {
           JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (burdenVariantList[0])
            if ((jsonObject) &&
                    (!jsonObject.is_error)&&
                    (jsonObject.variants.size()>0)){
                variantIds << jsonObject.variants[0]*.find{key,value->key=="VAR_ID"}.value[0]
            }
        } else {
            variantIds = burdenVariantList
        }

        // call shared method
        returnJson = this.callBurdenTestForTraitAndVariantId(traitOption, variantIds, covariateJsonObject, sampleJsonObject, filtersJsonObject,
                phenotypeFilterValues, dataset, variantSetId, biallelicCheckboxValue );

        // return
        return returnJson;
    }

    /**
     * call burden for single variant
     *
     * @param traitOption
     * @param burdenVariantId
     * @return
     * @throws PortalException
     */
    protected JSONObject callBurdenTestForTraitAndVariantId(String traitOption, List<String> burdenVariantList,
                                                            JSONObject covariateJsonObject,
                                                            JSONObject sampleJsonObject,
                                                            JSONObject filtersJsonObject,
                                                            JSONArray phenotypeFilterValues,
                                                            String dataset,
                                                            String variantSetId,
                                                            String biallelicCheckboxValue) throws PortalException {
        // local variables
        JSONObject returnJson = null;
        //int dataVersion = this.sharedToolsService.getDataVersion();
        String stringDataVersion = metaDataService.getDataVersion()

        returnJson = this.getBurdenResultForVariantIdList(stringDataVersion , traitOption, burdenVariantList, covariateJsonObject, sampleJsonObject,  filtersJsonObject,
                phenotypeFilterValues, dataset, false, variantSetId, biallelicCheckboxValue );

        // return
        return returnJson;
    }

    /**
     * common method used whether we have one or more variants
     *
     * @param sampleGroupName                   - if null, use default
     * @param burdenVariantList
     * @return
     * @throws PortalException
     */
    protected JSONObject getBurdenResultForVariantIdList(String stringDataVersion, String phenotype, List<String> burdenVariantList,
                                                         JSONObject covariateJsonObject, JSONObject sampleJsonObject, JSONObject filtersJsonObject,
                                                         JSONArray phenotypeFilterValues, String dataset, Boolean explicitlySelectSamples,
                                                         String variantSetId, String biallelicCheckboxValue) throws PortalException {
        // local variables
        JSONObject jsonObject = null;
        JSONObject returnJson = null;
        JSONObject returnJsonVector = null;


        // TODO: remove this workaround when the backend can gather samples on its own


        // Look at the samples data set, and determine if it has been marked in the database as having undergone
        // an operation that converts multi-allelics broken into bi-jjjallelic
        String alleleType = ""
        SampleGroup sampleGroupObj = metaDataService.getSampleGroupByName(dataset,MetaDataService.METADATA_SAMPLE)
        if ((sampleGroupObj.getMeaningSet().contains(PortalConstants.PROPERTY_MEANING_MULTI_ALLELE_KEY)) &&
                (biallelicCheckboxValue == "1")){
            alleleType=  PortalConstants.JSON_BURDEN_OPERATION_ALLELE_TYPE_KEY;
        }

        List<String> sampleList = []
        String goWithDataSet
        if ((dataset)&&( dataset.length() > 0 )){
            goWithDataSet = dataset
        }
        if (explicitlySelectSamples){
            if (sampleJsonObject?.samples) {
                sampleList = sampleJsonObject.samples.collect{return it.toString()} as List
            }
        }

        String filters = widgetService.buildFilterDesignation (filtersJsonObject.filters  as JSONArray,
                phenotypeFilterValues,
                goWithDataSet)

        // check to make sure we have at least one variant
        if ((burdenVariantList) == null || (burdenVariantList.size() < 1)) {
            throw new PortalException("Got no variants to match filters");
        }

        // create the json payload for the burden call
        List<String> covariateList = []
        if (covariateJsonObject?.covariates) {
            covariateList = covariateJsonObject.covariates.collect{return it.toString()} as List
        }

        if (!explicitlySelectSamples){
            jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(stringDataVersion, phenotype, burdenVariantList, covariateList, sampleList, filters,dataset, variantSetId,alleleType);
        } else {
            if (sampleList?.size()>MINIMUM_ALLOWABLE_NUMBER_OF_SAMPLES){
                jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(stringDataVersion, phenotype, burdenVariantList, covariateList, sampleList, filters,dataset, variantSetId,alleleType);
            } else {
                log.info("needed more samples than ${MINIMUM_ALLOWABLE_NUMBER_OF_SAMPLES}");
            }
        }

        if (jsonObject){

            // get the results of the burden call
            returnJson = this.getBurdenRestCallResults(jsonObject.toString());
           // JSONObject resultLZJson = tranlsateVector(returnJsonVector);
           // log.info("got Vector Data result: " + resultLZJson);
            log.info("got burden rest result: " + returnJson);

            // add json array of variant strings to the return json
            Collections.sort(burdenVariantList);
            JSONArray variantArray = new JSONArray(burdenVariantList);
            returnJson.put(PortalConstants.JSON_VARIANTS_KEY, variantArray);
            log.info("passing enhanced burden rest result: " + returnJson);

        }

        // return
        return returnJson;
    }



//    def tranlsateVector(JSONObject returnJsonVector){
//        // returnJsonVector.regions.val
//        JSONObject resultLZJson = new JSONObject();
//        List<String> pvalueList = [];
//        List<String> chrList = [];
//        List<String> positionList = [];
//        List<String> scoreTestStatList = [];
//        List<String> refAlleleFreqList = []
//        List<String> refAlleleList = [];
//        List<String> analysisList = [];
//        List<String>  idList = [];
//        for (Map map in returnJsonVector.regions){
//            pvalueList <<  """${map.val}""".toString();
//            chrList  <<  """${map.chr}""".toString()
//            positionList << """${(map.start + map.stop)/2}"""
//            scoreTestStatList << """null""".toString()
//            refAlleleFreqList << """null""".toString()
//            refAlleleList << """null""".toString()
//            analysisList << """null""".toString();
//            idList << """${pvalueList.size()}""".toString();
//        }
//        resultLZJson['pvalue'] = pvalueList;
//        resultLZJson['chr'] = chrList;
//        resultLZJson['position'] = positionList;
//        resultLZJson['scoreTestStat'] = scoreTestStatList;
//        resultLZJson['refAlleleFreq'] = refAlleleFreqList;
//        resultLZJson['refAllele'] = refAlleleList;
//        resultLZJson['analysis'] = analysisList;
//        resultLZJson['id'] = idList;
//
//
//        return resultLZJson.toString();
//    }

    /**
     * take a variant list and turn it into a variant name list, with filtering added for polyphen/sift predictors
     *
     * @param variantList
     * @param variantSelectionOptionId
     * @return
     */
    protected List<String> transformAndFilterVariantList(List<Variant> variantList, int variantSelectionOptionId, String dataset) {
        // local variables
        List<String> variantStringList = new ArrayList<String>();
        boolean qualifyingVariant = false;

        // for logic, see DIGP-102
        // loop through all variants in the list
        for (Variant variant: variantList) {
            // depending on the variant selection option passed in, add appropriate variants to the list
            if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS) {
                // include for following conditions
                // MDS == 2 and polyphen predictor = 'possibly_damaging'
                // MDS == 2 and SIFT predictor = 'deleterious'
                // MDS == 1
                if (variant.getMostDelScore() == 2) {
                    if (variant.getPolyphenPredictor()?.equalsIgnoreCase(PortalConstants.POLYPHEN_PRED_POSSIBLY_DAMAGING)) {
                        qualifyingVariant = true;
                    } else if (variant.getSiftPredictor()?.equalsIgnoreCase(PortalConstants.SIFT_PRED_DELETERIOUS)) {
                        qualifyingVariant = true;
                    }
                } else if (variant.getMostDelScore() == 1) {
                    qualifyingVariant = true;
                }

            } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS) {
                // include for following conditions
                // MDS == 2 and polyphen predictor = 'probably_damaging' and SIFT predictor = 'deleterious'
                // MDS == 1
                if (variant.getMostDelScore() == 2) {
                    if (variant.getPolyphenPredictor()?.equalsIgnoreCase(PortalConstants.POLYPHEN_PRED_PROBABLY_DAMAGING) &&
                        variant.getSiftPredictor()?.equalsIgnoreCase(PortalConstants.SIFT_PRED_DELETERIOUS)) {
                        qualifyingVariant = true;
                    }
                } else if (variant.getMostDelScore() == 1) {
                    qualifyingVariant = true;
                }

            } else if ( (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS_STRICT)||
                        (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD)||
                        (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_NS)){
                float maf = variant.getMaf()
                boolean ptv = (variant.getMostDelScore() == 1)
                boolean ptvOrMissense = (variant.getMostDelScore() == 1 || variant.getMostDelScore() == 2)
                boolean nsStrict = ((variant.getMutationTasterPredictor()?.contains("D"))&&
                        (variant.getSiftPredictor()?.contains("D"))&&
                        (variant.getLrtPredictor()?.contains("D"))&&
                        (variant.getPolyphenHvarPredictor()?.contains("D"))&&
                        (variant.getPolyphenHdivPredictor()?.contains("D")))
                boolean nsBroad = ((variant.getMutationTasterPredictor()?.contains("D"))||
                        (variant.getSiftPredictor()?.contains("D"))||
                        (variant.getLrtPredictor()?.contains("D"))||
                        (variant.getPolyphenHvarPredictor()?.contains("D"))||
                        (variant.getPolyphenHdivPredictor()?.contains("D")))
                switch (variantSelectionOptionId){
                    case PortalConstants.BURDEN_VARIANT_OPTION_NS_STRICT:
                        qualifyingVariant = (ptv || nsStrict)
                        break
                    case PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD:
                        qualifyingVariant = (ptv || nsStrict || (nsBroad && maf<0.01))
                        break
                    case PortalConstants.BURDEN_VARIANT_OPTION_NS:
                        qualifyingVariant = (ptv || nsStrict || nsBroad || (ptvOrMissense && maf<0.01))
                        break
                    default:
                        qualifyingVariant = true
                        break
                }
            } else {
            // for any other call, all the variants are included, so simply set to true
            qualifyingVariant = true;
        }

            if (qualifyingVariant) {
                variantStringList.add(variant.getVariantId());
            }

            // reset the boolean
            qualifyingVariant = false;
        }

        // return
        return variantStringList;

    }

    /**
     * returns final hard coded variant selection options
     *
     * @return
     */
    public JSONObject getBurdenVariantSelectionOptions() {
        StringBuilder builder = new StringBuilder();

        // build the default options string
        builder.append("{\"options\": [ ");
        List <String> allOptions = []
        // new fields of been introduced, but don't let users search for them if they haven't migrated to this database yet
        if ((metaDataService.getCommonPropertyByName(PortalConstants.JSON_VARIANT_MUTATION_TASTER_PRED_KEY,MetaDataService.METADATA_VARIANT))&&
                (metaDataService.getCommonPropertyByName(PortalConstants.JSON_VARIANT_POLYPHEN2_HDIV_PRED_KEY,MetaDataService.METADATA_VARIANT))&&
                (metaDataService.getCommonPropertyByName(PortalConstants.JSON_VARIANT_POLYPHEN2_HVAR_PRED_KEY,MetaDataService.METADATA_VARIANT))&&
                (metaDataService.getCommonPropertyByName(PortalConstants.JSON_VARIANT_LRT_PRED_KEY,MetaDataService.METADATA_VARIANT))){
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_NS, "Protein-truncating + missense with MAF<1%", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_NS_BROAD, "Protein-truncating + possibly deleterious missense with MAF<1%", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_NS_STRICT, "Protein-truncating + probably deleterious missense", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING, "Protein-truncating only", false)
        } else { // the old filters, retained for backwards compatibility
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_CODING, "All coding variants", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE, "All missense variants", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS, "All missense possibly deleterious variants", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS, "All missense probably deleterious variants", false)
            allOptions << this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING, "All protein truncating variants", false)
        }

        builder.append( allOptions.join(",") )
        builder.append(" ]}");

        // create the json object and return
        JSONTokener tokener = new JSONTokener(builder.toString());
        JSONObject returnObject = new JSONObject(tokener);

        // return
        return returnObject;
    }

    /**
     * returns final hard coded (for now) trait selection options
     *
     * @return
     */
    public JSONObject getBurdenTraitSelectionOptionsTest() {
        StringBuilder builder = new StringBuilder();

        // build the default options string
        builder.append("{\"phenotypes\": [ ");
        builder.append(this.buildOptionString("t2d", "Type 2 Diabetes", true));
        builder.append(this.buildOptionString("CHOL_ANAL", "Whatever CHOL_ANAL is", false));
        builder.append(" ]}");

        // create the json object and return
        JSONTokener tokener = new JSONTokener(builder.toString());
        JSONObject returnObject = new JSONObject(tokener);

        // return
        return returnObject;
    }

    /**
     * use GET call to burden web service to get burden phenotype filter list
     *
     * @return
     */
    protected JSONObject getBurdenTraitSelectionOptions() {
        JSONObject phenotypeJsonObject = this.restServerService.getRestBurdenGetPhenotypesCall();
        return phenotypeJsonObject;
    }

    /**
     * protected method to help building an option list json string
     *
     * @param optionId
     * @param optionName
     * @param addComma
     * @return
     */
    protected String buildOptionString(int optionId, String optionName, boolean addComma) {
        StringBuilder builder = new StringBuilder();

        // build the default options string
        builder.append("{ \"id\": ");
        builder.append(optionId);
        builder.append(" , \"name\": \"");
        builder.append(optionName);
        builder.append("\"}");
        if (addComma) {
            builder.append(", ");
        }

        // return
        return builder.toString()
    }

    /**
     * protected method to help building an option list json string
     *
     * @param optionId
     * @param optionName
     * @param addComma
     * @return
     */
    protected String buildOptionString(String optionId, String optionName, boolean addComma) {
        StringBuilder builder = new StringBuilder();

        // build the default options string
        builder.append("{ \"id\": ");
        builder.append(optionId);
        builder.append(" , \"name\": \"");
        builder.append(optionName);
        builder.append("\"}");
        if (addComma) {
            builder.append(", ");
        }

        // return
        return builder.toString()
    }
}
