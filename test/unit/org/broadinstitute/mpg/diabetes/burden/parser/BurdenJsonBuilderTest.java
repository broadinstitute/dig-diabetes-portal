package org.broadinstitute.mpg.diabetes.burden.parser;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.codehaus.groovy.grails.web.json.JSONTokener;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * Created by mduby on 8/21/15.
 */
public class BurdenJsonBuilderTest extends TestCase {
    // instance variables
    BurdenJsonBuilder burdenJsonBuilder;
    String jsonString = null;

    @Before
    public void setUp() throws Exception {
        // set up the service
        this.burdenJsonBuilder = BurdenJsonBuilder.getBurdenJsonBuilder();
        InputStream inputStream = getClass().getResourceAsStream("burdenRequest.json");
        jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
    }

    @Test
    public void testGetBurdenPostJsonString() {
        // local variables
        List<String> variantList = new ArrayList<String>();
        JSONObject referenceJson = null;
        JSONObject generatedJson = null;

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

        // read in the test file
        referenceJson = new JSONObject(this.jsonString);

        // test to make sure reference works
        assertNotNull(referenceJson);

        // create the new json object from the builder call
        try {
            generatedJson = this.burdenJsonBuilder.getBurdenPostJson(variantList, null);

        } catch (PortalException exception) {
            fail("Got exception generating burden call json payload: " + exception.getMessage());
        }

        // test
        assertNotNull(generatedJson);
        assertEquals(referenceJson.toString(), generatedJson.toString());
    }

    public void testGetKnowledgeBaseQueryPayloadForVariantSearch() {
        // local variables
        JSONObject referenceJson = null;
        JSONObject generatedJson = null;
        String sampleGroup = "ExSeq_17k_mdv2";
        String geneString = "SLC30A8";
        int mostDelScore = 4;

        // read the reference json from the stored file
        InputStream inputStream = getClass().getResourceAsStream("variantQuery.json");
        String readJsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        referenceJson = new JSONObject(readJsonString);

        // create the json from the builder
        try {
            String generatedJsonString = this.burdenJsonBuilder.getKnowledgeBaseQueryPayloadForVariantSearch(sampleGroup, geneString, mostDelScore);
            generatedJson = new JSONObject(generatedJsonString);

        } catch (PortalException exception) {
            fail("Got error creating getData for variant search: " + exception.getMessage());
        }

        // test
        assertNotNull(generatedJson);
        assertEquals(referenceJson.toString(), generatedJson.toString());
    }

    /**
     * test parsing the getData variant list return json object
     *
     */
    @Test
    public void testGetVariantListFromJson() {
        // local variables
        JSONObject inputJsonObject;
        JSONTokener tokener;
        String referenceString = "{\"is_error\": false, \"numRecords\": 2, \"variants\": [[{\"VAR_ID\": \"8_118184783_C_T\"}],[{\"VAR_ID\": \"8_118170004_C_T\"}]], \"passback\": \"123abc\"}";
        List<String> variantList = null;

        // create the reference to input to the builder
        tokener = new JSONTokener(referenceString);
        inputJsonObject = new JSONObject(tokener);

        // call the builder
        try {
            variantList = this.burdenJsonBuilder.getVariantListFromJson(inputJsonObject);

        } catch (PortalException exception) {
            fail("got variant list parsing error: " + exception.getMessage());
        }

        // test
        assertNotNull(variantList);
        assertTrue(variantList.size() > 0);
        assertEquals("[8_118184783_C_T, 8_118170004_C_T]", variantList.toString());
    }

}
