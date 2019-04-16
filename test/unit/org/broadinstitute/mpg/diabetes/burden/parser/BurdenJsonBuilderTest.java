package org.broadinstitute.mpg.diabetes.burden.parser;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
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
    String burdenJsonString = null;
    JsonParser jsonParser;

    @Before
    public void setUp() throws Exception {
        // set up the service
        this.burdenJsonBuilder = BurdenJsonBuilder.getBurdenJsonBuilder();
        InputStream inputStream = getClass().getResourceAsStream("burdenRequest.json");
        burdenJsonString = new Scanner(inputStream).useDelimiter("\\A").next();

        // this is to make sure the parser is initialized
        jsonParser = JsonParser.getService();
        InputStream metadataInputStream = getClass().getResourceAsStream("../../metadata/parser/metadata.json");
        this.jsonString = new Scanner(metadataInputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);
    }

    @Test
    public void testGetBurdenPostJsonString() {
        // local variables
        List<String> variantList = new ArrayList<String>();
        JSONObject referenceJson = null;
        JSONObject generatedJson = null;
        String dataVertsion = "mdv2";
        String filters = "";
        String phenotype = "t2d";
        List<String> sampleList = new ArrayList<String>();
        List<String> covariatesList = new ArrayList<String>();

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
        referenceJson = new JSONObject(this.burdenJsonString);

        // test to make sure reference works
        assertNotNull(referenceJson);

        // create the new json object from the builder call
        try {
            generatedJson = this.burdenJsonBuilder.getBurdenPostJson(dataVertsion, phenotype, variantList, covariatesList, sampleList, filters,"ExSeq_17k_mdv2", "", "");

        } catch (PortalException exception) {
            fail("Got exception generating burden call json payload: " + exception.getMessage());
        }

        // test
        assertNotNull(generatedJson);
        assertEquals(referenceJson.toString(), generatedJson.toString());
    }

    /**
     * test building the getData payload generation
     *
     */
    public void testGetKnowledgeBaseQueryPayloadForVariantSearch() {
        // local variables
        JSONObject referenceJson = null;
        JSONObject generatedJson = null;
        String geneString = "SLC30A8";
        String mostDelScoreOperand = PortalConstants.OPERATOR_LESS_THAN_EQUALS;
        int mostDelScore = 3;

        // read the reference json from the stored file
        InputStream inputStream = getClass().getResourceAsStream("variantQuery.json");
        String readJsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        referenceJson = new JSONObject(readJsonString);

        List<Property> additionalProperties = new ArrayList<Property>();

        // create the json from the builder
        try {
            String generatedJsonString = this.burdenJsonBuilder.getKnowledgeBaseQueryPayloadForVariantSearch(geneString, mostDelScoreOperand, mostDelScore, new ArrayList<QueryFilter>(),additionalProperties);
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
        List<Variant> variantList = null;

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

    @Test
    public void testGetMinorAlleleFrequencyFilters() {
        // local variables
        List<QueryFilter> queryFilterList = null;

        // get the query filter list
        try {
            queryFilterList = this.burdenJsonBuilder.getMinorAlleleFrequencyFilters(PortalConstants.BURDEN_DATASET_OPTION_ID_13K, PortalConstants.BURDEN_MAF_OPTION_ID_ALL, new Float("0.5"));

        } catch (PortalException exception) {
            fail("got exception creating burden MAF filters: " + exception.getMessage());
        }

        // test
        assertNotNull(queryFilterList);
        assertTrue(queryFilterList.size() > 0);
        // 2 filters (one for greater than 0, to avoid null results, then the one for upper limit
        assertEquals(2, queryFilterList.size());

        // get the query filter list
        try {
            queryFilterList = this.burdenJsonBuilder.getMinorAlleleFrequencyFilters(PortalConstants.BURDEN_DATASET_OPTION_ID_26K, PortalConstants.BURDEN_MAF_OPTION_ID_ALL, new Float("0.5"));

        } catch (PortalException exception) {
            fail("got exception creating burden MAF filters: " + exception.getMessage());
        }

        // test
        assertNotNull(queryFilterList);
        assertTrue(queryFilterList.size() > 0);
        // 2 filters (one for greater than 0, to avoid null results, then the one for upper limit
        assertEquals(2, queryFilterList.size());

        // get the query filter list
        try {
            queryFilterList = this.burdenJsonBuilder.getMinorAlleleFrequencyFilters(PortalConstants.BURDEN_DATASET_OPTION_ID_13K, PortalConstants.BURDEN_MAF_OPTION_ID_ANCESTRY, new Float("0.5"));

        } catch (PortalException exception) {
            fail("got exception creating burden MAF filters: " + exception.getMessage());
        }

        // test
        assertNotNull(queryFilterList);
        assertTrue(queryFilterList.size() > 0);
        assertEquals(6, queryFilterList.size());

        // get the query filter list
        try {
            queryFilterList = this.burdenJsonBuilder.getMinorAlleleFrequencyFilters(PortalConstants.BURDEN_DATASET_OPTION_ID_26K, PortalConstants.BURDEN_MAF_OPTION_ID_ANCESTRY, new Float("0.5"));

        } catch (PortalException exception) {
            fail("got exception creating burden MAF filters: " + exception.getMessage());
        }

        // test
        assertNotNull(queryFilterList);
        assertTrue(queryFilterList.size() > 0);
        assertEquals(6, queryFilterList.size());
    }
}
