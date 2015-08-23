package org.broadinstitute.mpg.diabetes
import grails.test.spock.IntegrationSpec
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.burden.parser.BurdenJsonBuilder
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


    @Before
    void setup() {

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
        String burdenJsonString = jsonBuilder.getBurdenPostJson(variantList, null);
        generatedJson = this.burdenService.getBurdenRestCallResults(burdenJsonString);

        // reference result string
        String referenceJsonString = "{\"is_error\": false, \"oddsRatio\": \"1.0138318997464533\",\"pValue\": \"0.4437344659074216\"}";
        referenceJson = slurper.parseText(referenceJsonString);

        then:
        assert referenceJson == generatedJson
    }


}
