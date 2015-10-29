package org.broadinstitute.mpg.diabetes
import org.broadinstitute.mpg.RestServerService
import grails.test.spock.IntegrationSpec
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.After
import org.junit.Before
import spock.lang.Unroll
/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class BurdenServiceIntegrationSpec extends IntegrationSpec {
    BurdenService burdenService
    RestServerService restServerService

    @Before
    void setup() {
        JsonParser jsonParser = JsonParser.getService()
        jsonParser.setJsonString(this.restServerService.getMetadata())
    }

    @After
    void tearDown() {

    }


    void "test burden rest call using only variants"() {
        when:
        List<String> variantList = new ArrayList<String>();
        JSONObject referenceJson = null;
        JSONObject generatedJson = null;
        JsonSlurper slurper = new JsonSlurper()

        // add 10 variants to the list
        variantList.add("1_2522446_");
        variantList.add("1_2522529_");
        variantList.add("1_2523027_");
        variantList.add("1_2524110_");
        variantList.add("1_2524271_");
        variantList.add("1_2526245_");
        variantList.add("1_2529663_");
        variantList.add("1_2530211_");
        variantList.add("1_2530219_");
        variantList.add("1_2535651_");

        // get the json payload for the burden call
        BurdenJsonBuilder jsonBuilder = BurdenJsonBuilder.getBurdenJsonBuilder();
        String burdenJsonString = jsonBuilder.getBurdenPostJson(PortalConstants.BURDEN_DATASET_OPTION_13K, variantList, null);
        generatedJson = this.burdenService.getBurdenRestCallResults(burdenJsonString);

        // reference result string
        String referenceJsonString = "{\"is_error\": false, \"oddsRatio\": \"1.0138318997464533\",\"pValue\": \"0.4437344659074216\"}";
        referenceJson = slurper.parseText(referenceJsonString);

        then:
        assert generatedJson != null
        // will need to change this when data changes
//        assert referenceJson == generatedJson
    }

    void "test burden variant retrieval post call"() {
        when:
        String sampleGroup = "ExSeq_17k_mdv2";
        String geneString = "SLC30A8";
        int variantSelectionOptionId = 3;
        List<QueryFilter> queryFilterList = new ArrayList<QueryFilter>();
        String referenceJsonString = "{\"is_error\": false, \"numRecords\": 2, \"variants\": [[{\"VAR_ID\": \"8_118184783_C_T\"}],[{\"VAR_ID\": \"8_118170004_C_T\"}]], \"passback\": \"123abc\"}";
        JsonSlurper slurper = new JsonSlurper()
        JSONObject referenceJson = slurper.parseText(referenceJsonString);
        String generatedJsonString = this.burdenService.getVariantsForGene(geneString, variantSelectionOptionId, queryFilterList);
        JSONObject generatedJson = slurper.parseText(generatedJsonString);

        then:
        assert generatedJson != null
        // will need to change this when data changes
//        assert referenceJson == generatedJson
    }

    /*
    void "test burden test final call"() {
        when:
        String geneString = "SLC30A8";
        int variantSelectionOptionId = 2;
        int ancestryOptionId = PortalConstants.BURDEN_MAF_OPTION_ID_ANCESTRY;
        Float mafValue = new Float("0.5");
        int sampleGroupOptionId = PortalConstants.BURDEN_DATASET_OPTION_ID_13K;
        JSONObject generatedJson = this.burdenService.callBurdenTest(sampleGroupOptionId, geneString, variantSelectionOptionId, variantSelectionOptionId, mafValue);

        then:
        // will need to change as data changes
//        assert referenceJson == generatedJson
        assert generatedJson != null
    }
    */

    void "test burden variant selecting option call"() {
        when:
        JSONObject object = this.burdenService.getBurdenVariantSelectionOptions()

        then:
        assert object != null
        assert object.size() > 0
    }
}
