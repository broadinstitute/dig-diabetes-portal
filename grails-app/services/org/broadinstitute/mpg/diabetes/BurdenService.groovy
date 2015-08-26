package org.broadinstitute.mpg.diabetes
import dport.RestServerService
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
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
    protected JSONObject getVariantsForGene(String sampleGroup, String geneString, int mostDelScore) {
        // local variables
        String jsonString = "";
        JSONObject resultJson;

        // get the json string to send to the getData call
        try {
            jsonString = this.getBurdenJsonBuilder().getKnowledgeBaseQueryPayloadForVariantSearch(sampleGroup, geneString, mostDelScore);

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
    public JSONObject callBurdenTest(String sampleGroup, String geneString, int mostDelScore) {
        // local variables
        JSONObject jsonObject, returnJson;
        List<String> variantList;

        try {
            // get the getData results payload
            jsonObject = this.getVariantsForGene(sampleGroup, geneString, mostDelScore);
            log.info("got burden getData results: " + jsonObject);

            // get the list of variants back
            variantList = this.getBurdenJsonBuilder().getVariantListFromJson(jsonObject);
            log.info("got burden variant list: " + variantList);

            // create the json payload for the burden call
            jsonObject = this.getBurdenJsonBuilder().getBurdenPostJson(variantList, null);
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
}
