package org.broadinstitute.mpg.diabetes

import groovy.json.JsonSlurper
import org.broadinstitute.mpg.RestServerService
import grails.transaction.Transactional
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant
import org.broadinstitute.mpg.diabetes.metadata.Experiment
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
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

    /**
     * method to get the variants from the getData call
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    protected JSONObject getVariantsForGene(String geneString, int variantSelectionOptionId, List<QueryFilter> additionalQueryFilterList) {
        // local variables
        String jsonString = "";
        JSONObject resultJson;
        int mostDelScore = 2;
        String operand = PortalConstants.OPERATOR_LESS_THAN_EQUALS;

        // set the most del score based on the variant filtering option given
        // TODO - possibly combine this and polyphen/sift filtering into one method for clarity
        if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING) {
            mostDelScore = 1;
            operand = PortalConstants.OPERATOR_EQUALS;
        } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_CODING) {
            mostDelScore = 3;
        } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL) {
            mostDelScore = 5;
        }

        // get the json string to send to the getData call
        try {
            jsonString = this.getBurdenJsonBuilder().getKnowledgeBaseQueryPayloadForVariantSearch(geneString, operand, mostDelScore, additionalQueryFilterList);

        } catch (PortalException exception) {
            log.error("Got json building error for getData payload creation: " + exception.getMessage());
        }

        // call the post REST call
        resultJson = this.restServerService.postGetDataCall(jsonString);

        // return the result
        return resultJson;
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

        List <String> phenotypeList = []
        List <String> covariateList = []
        List <String> filterList = []
        List <Property> propertyList = sampleGroup.properties.findAll{it.meaningSet[0].contains("PHENOTYPE")}
        for (Property property in propertyList){
            if (("T2D" == property.name)||
                    ("FAST_GLU" == property.name)||
                    ("FAST_INS" == property.name)||
                    ("BMI" == property.name)||
                    ("HDL" == property.name)||
                    ("LDL" == property.name)) {
                phenotypeList << """{"name":"${property.name}", "trans":"${g.message(code: 'metadata.' +property.name, default: property.name)}"  }""".toString()
            }
        }
        propertyList = sampleGroup.properties.findAll{it.meaningSet[0].contains("COVARIATE")}
        for (Property property in propertyList){

                covariateList << """{"name":"${property.name}"}""".toString()

        }
        propertyList = sampleGroup.properties.findAll{it.meaningSet[0].contains("FILTER")}
        for (Property property in propertyList){
            if (("T2D" == property.name)||
                    ("AGE" == property.name)||
                    ("FAST_GLU" == property.name)||
                    ("FAST_INS" == property.name)||
                    ("BMI" == property.name)||
                    ("WEIGHT" == property.name)||
                    ("HDL" == property.name)||
                    ("LDL" == property.name)) {
                filterList << """{"name":"${property.name}", "type":"${property.variableType}"  }""".toString()
            }
        }
        String jsonString = """{"phenotypes":[${phenotypeList.join(",")}],
"covariates":[${covariateList.join(",")}],
"filters":[${filterList.join(",")}]
}""".toString()
        JsonSlurper slurper = new JsonSlurper()
        return slurper.parseText(jsonString)
    }







    /**
     * method to return the burden test REST payload
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    public JSONObject callBurdenTest(String phenotype, String geneString, int variantSelectionOptionId, int mafSampleGroupOption, Float mafValue) {
        // local variables
        JSONObject jsonObject, returnJson;
        List<Variant> variantList;
        List<String> burdenVariantList;
        int dataVersionId = this.sharedToolsService.getDataVersion();
        List<QueryFilter> queryFilterList;

        // log
        log.info("called burden test for gene: " + geneString + " and variant select option: " + variantSelectionOptionId + " and data version id: " + dataVersionId);
        log.info("also had MAF option: " + mafSampleGroupOption + " and MAF value: " + mafValue);

        try {
            // DIGP-104: create new MAF filters if needed
            // log for clarity
            queryFilterList = this.getBurdenJsonBuilder().getMinorAlleleFrequencyFilters(dataVersionId, mafSampleGroupOption, mafValue);
            log.info("returning query MAF filter list of size: " + queryFilterList.size() + " for mafValue: " + mafValue + " and sample group ancestry option: " + mafSampleGroupOption);

            // get the getData results payload
            jsonObject = this.getVariantsForGene(geneString, variantSelectionOptionId, queryFilterList);
            log.info("got burden getData results: " + jsonObject);

            // get the list of variants back
            variantList = this.getBurdenJsonBuilder().getVariantListFromJson(jsonObject);
            log.info("got first pass variant list of size: " + variantList.size());

            // filter variant list based on polyphen/sift
            burdenVariantList = this.transformAndFilterVariantList(variantList, variantSelectionOptionId);
            log.info("got filtered variant list of size: " + burdenVariantList.size());


            /*
            // check to make sure we have at least one variant
            if (burdenVariantList.size() < 1) {
                throw new PortalException("Got no variants to match filters");
            }

            // create the json payload for the burden call
            jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(sampleGroupName, burdenVariantList, null);
            log.info("created burden rest payload: " + jsonObject);

            // get the results of the burden call
            returnJson = this.getBurdenRestCallResults(jsonObject.toString());
            log.info("got burden rest result: " + returnJson);

            // add json array of variant strings to the return json
            Collections.sort(burdenVariantList);
            JSONArray variantArray = new JSONArray(burdenVariantList);
            returnJson.put(PortalConstants.JSON_VARIANTS_KEY, variantArray);
            log.info("passing enhanced burden rest result: " + returnJson);
            */

            returnJson = this.getBurdenResultForVariantIdList(dataVersionId, phenotype, burdenVariantList, null);

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

    /**
     * call burden test for single variant
     *
     * @param traitOption
     * @param burdenVariantDbSnpId
     * @return
     * @throws PortalException
     */
    protected JSONObject callBurdenTestForTraitAndDbSnpId(String traitOption, String burdenVariantDbSnpId, JSONObject callingParameters) throws PortalException {
        // local variables
        org.broadinstitute.mpg.Variant burdenVariant;
        JSONObject returnJson = null;

        String variantId = ""
        if (burdenVariantDbSnpId)      {
           JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (burdenVariantDbSnpId)
            if ((jsonObject) &&
                    (!jsonObject.is_error)&&
                    (jsonObject.variants.size()>0)){
                variantId = jsonObject.variants[0]*.find{key,value->key=="VAR_ID"}.value[0]
            }
        }

        // call shared method
        returnJson = this.callBurdenTestForTraitAndVariantId(traitOption, variantId, callingParameters);

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
    protected JSONObject callBurdenTestForTraitAndVariantId(String traitOption, String burdenVariantId, JSONObject callingParameters) throws PortalException {
        // local variables
        List<String> burdenVariantList = new ArrayList<String>();
        JSONObject returnJson = null;
        int dataVersion = this.sharedToolsService.getDataVersion();

        // if the variant is not null, add it in (empty list will throw exception in next call)
        if (burdenVariantId != null) {
            burdenVariantList.add(burdenVariantId);
        } else {
            throw new PortalException("got null variantId for single variant burden call")
        }

        // call shared method
        returnJson = this.getBurdenResultForVariantIdList(dataVersion, traitOption, burdenVariantList, callingParameters);

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
    protected JSONObject getBurdenResultForVariantIdList(int dataVersionId, String phenotype, List<String> burdenVariantList, JSONObject callingParameters) throws PortalException {
        // local variables
        JSONObject jsonObject = null;
        JSONObject returnJson = null;

        // check to make sure we have at least one variant
        if ((burdenVariantList) == null || (burdenVariantList.size() < 1)) {
            throw new PortalException("Got no variants to match filters");
        }

        // create the json payload for the burden call
        List<String> covariateList = []
        if (callingParameters?.covariates) {
            covariateList = callingParameters.covariates.collect{return it.toString()} as List
        }
        jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(dataVersionId, phenotype, burdenVariantList, covariateList);
        log.info("created burden rest payload: " + jsonObject);

        // get the results of the burden call
        returnJson = this.getBurdenRestCallResults(jsonObject.toString());
        log.info("got burden rest result: " + returnJson);

        // add json array of variant strings to the return json
        Collections.sort(burdenVariantList);
        JSONArray variantArray = new JSONArray(burdenVariantList);
        returnJson.put(PortalConstants.JSON_VARIANTS_KEY, variantArray);
        log.info("passing enhanced burden rest result: " + returnJson);

        // return
        return returnJson;
    }

    /**
     * take a variant list and turn it into a variant name list, with filtering added for polyphen/sift predictors
     *
     * @param variantList
     * @param variantSelectionOptionId
     * @return
     */
    protected List<String> transformAndFilterVariantList(List<Variant> variantList, int variantSelectionOptionId) {
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
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_CODING, "All coding variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE, "All missense variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS, "All missense possibly deleterious variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS, "All missense probably deleterious variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING, "All protein truncating variants", false));
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
