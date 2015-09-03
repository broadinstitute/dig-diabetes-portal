package org.broadinstitute.mpg.diabetes
import dport.RestServerService
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.json.JSONTokener

@Transactional
class BurdenService {

    RestServerService restServerService;

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
    protected JSONObject getVariantsForGene(String geneString, int variantSelectionOptionId) {
        // local variables
        String jsonString = "";
        JSONObject resultJson;
        int mostDelScore = 2;
        String operand = PortalConstants.OPERATOR_LESS_THAN_EQUALS;

        // set the most del score based on the variant filtering option given
        // TODO - possibly combine this and polyphen/sift filtering into one mwethod for clarity
        if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING) {
            mostDelScore = 1;
            operand = PortalConstants.OPERATOR_EQUALS;
        } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_CODING) {
            mostDelScore = 3;
        } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL) {
            mostDelScore = 4;
        }

        // get the json string to send to the getData call
        try {
            jsonString = this.getBurdenJsonBuilder().getKnowledgeBaseQueryPayloadForVariantSearch(geneString, operand, mostDelScore);

        } catch (PortalException exception) {
            log.error("Got json building error for getData payload creation: " + exception.getMessage());
        }

        // call the post REST call
        resultJson = this.restServerService.postGetDataCall(jsonString);

        // return the result
        return resultJson;
    }

    /**
     * method to return the burden test REST payload
     *
     * @param sampleGroup
     * @param geneString
     * @param mostDelScore
     * @return
     */
    public JSONObject callBurdenTest(String sampleGroup, String geneString, int variantSelectionOptionId) {
        // local variables
        JSONObject jsonObject, returnJson;
        List<Variant> variantList;
        List<String> burdenVariantList;

        // log
        log.info("called burden test for gene: " + geneString + " and variant select option: " + variantSelectionOptionId + " and sample group: " + sampleGroup);

        try {
            // get the getData results payload
            jsonObject = this.getVariantsForGene(geneString, variantSelectionOptionId);
            log.info("got burden getData results: " + jsonObject);

            // get the list of variants back
            variantList = this.getBurdenJsonBuilder().getVariantListFromJson(jsonObject);
            log.info("got first pass variant list of size: " + variantList.size());

            // filter variant list based on polyphen/sift
            burdenVariantList = this.transformAndFilterVariantList(variantList, variantSelectionOptionId);
            log.info("got filtered variant list of size: " + burdenVariantList.size());

            // create the json payload for the burden call
            jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(burdenVariantList, null);
            log.info("created burden rest payload: " + jsonObject);

            // get the results of the burden call
            returnJson = this.getBurdenRestCallResults(jsonObject.toString());
            log.info("got burden rest result: " + returnJson);

        } catch (PortalException exception) {
            log.error("Got error creating burden test for gene: " + geneString + " and sample group: " + sampleGroup + ": " + exception.getMessage());
        }

        if (returnJson == null) {
            JSONTokener tokener = new JSONTokener("{\"pValue\": \"0.0\", \"oddsRatio\": \"0.0\", \"is_error\": false}");
            returnJson = new JSONObject(tokener);
        }

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

        // loop through all variants in the list
        for (Variant variant: variantList) {
            // depending on the variant selection option passed in, add appropriate variants to the list
            if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS) {
                if (variant.getPolyphenPredictor()?.equals(PortalConstants.POLYPHEN_PRED_POSSIBLY_DAMAGING)) {
                    qualifyingVariant = true;
                }

            } else if (variantSelectionOptionId == PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS) {
                if (variant.getPolyphenPredictor()?.equals(PortalConstants.POLYPHEN_PRED_PROBABLY_DAMAGING) &&
                    variant.getSiftPredictor()?.equals(PortalConstants.SIFT_PRED_PROBABLY_DAMAGING)) {
                    qualifyingVariant = true;
                }

            } else {
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
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_POSS_DELETERIOUS, "All missense possibly deletrious variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_MISSENSE_PROB_DELETERIOUS, "All missense probably deletrious variants", true));
        builder.append(this.buildOptionString(PortalConstants.BURDEN_VARIANT_OPTION_ALL_PROTEIN_TRUNCATING, "All protein truncating variants", false));
        builder.append(" ]}");

        // create the json object and return
        JSONTokener tokener = new JSONTokener(builder.toString());
        JSONObject returnObject = new JSONObject(tokener);

        // return
        return returnObject;
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
}
