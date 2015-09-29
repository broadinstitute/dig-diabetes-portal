package org.broadinstitute.mpg.diabetes.metadata.result

import junit.framework.TestCase
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.Before
import org.junit.Test
import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValue;

/**
 * Test class to test the json parsing service for the metadata objects
 */
class KnowledgeBaseResultsParserTest extends TestCase {
    JsonParser jsonParser;
    String jsonString;

    @Before
    public void setUp() throws Exception {
        // set up the service
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream('../parser/metadata.json');
        this.jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);
    }

    public void testSetup() {
        assertNotNull(this.jsonParser);
        assertNotNull(this.jsonParser.getJsonMetadata());
    }

    @Test
    public void testCommonPropertyResult() {
        // local variables
        String jsonResult = "{\"CHROM\": \"7\"}";
        PropertyValue propertyValue = null;
        JSONObject jsonObject = null;

        // parse string and see what we get
        try {
            // passing in this string just done to create object and test it's protected method by itself
            KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResult);
            jsonObject = new JSONObject(jsonResult);
            propertyValue = knowledgeBaseResultParser.parseProperty(jsonObject);

        } catch (PortalException exception) {
            fail("Got error parsing common property: " + exception.getMessage());
        }

        // test
        assertNotNull(jsonObject);
        assertNotNull(propertyValue);
        assertEquals("7", propertyValue.getValue());
        assertNotNull(propertyValue.getProperty());
        assertEquals(PortalConstants.TYPE_COMMON_PROPERTY_KEY, propertyValue.getProperty().getPropertyType());
        assertEquals("metadata_rootCHROM", propertyValue.getProperty().getId());
    }

    @Test
    public void testSampleGroupPropertyResult() {
        // local variables
        String jsonResult = "{\"MAF\": {\"ExSeq_17k_eu_mdv2\": 0.000441209 }}";
        PropertyValue propertyValue = null;
        JSONObject jsonObject = null;

        // parse string and see what we get
        try {
            // passing in this string just done to create object and test it's protected method by itself
            KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResult);
            jsonObject = new JSONObject(jsonResult);
            propertyValue = knowledgeBaseResultParser.parseProperty(jsonObject);

        } catch (PortalException exception) {
            fail("Got error parsing sample group property: " + exception.getMessage());
        }

        // test
        assertNotNull(jsonObject);
        assertNotNull(propertyValue);
        assertEquals("4.41209E-4", propertyValue.getValue());
        assertNotNull(propertyValue.getProperty());
        assertEquals(PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY, propertyValue.getProperty().getPropertyType());
        assertEquals("metadata_root_ExSeq_17k_mdv2_17k_17k_euMAF", propertyValue.getProperty().getId());
    }

    @Test
    public void testPhenotypePropertyResult() {
        // local variables
        String jsonResult = "{\"OR_FIRTH_FE_IV\": {\"ExSeq_17k_eu_mdv2\": { \"T2D\": 27.8295943657392}}}";
        PropertyValue propertyValue = null;
        JSONObject jsonObject = null;

        // parse string and see what we get
        try {
            // passing in this string just done to create object and test it's protected method by itself
            KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResult);
            jsonObject = new JSONObject(jsonResult);
            propertyValue = knowledgeBaseResultParser.parseProperty(jsonObject);

        } catch (PortalException exception) {
            fail("Got error parsing sample group property: " + exception.getMessage());
        }

        // test
        assertNotNull(jsonObject);
        assertNotNull(propertyValue);
        assertEquals("27.8295943657392", propertyValue.getValue());
        assertNotNull(propertyValue.getProperty());
        assertEquals(PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY, propertyValue.getProperty().getPropertyType());
        assertEquals("metadata_root_ExSeq_17k_mdv2_17k_17k_euT2DOR_FIRTH_FE_IV", propertyValue.getProperty().getId());
    }

    @Test
    public void testParsePropertyValues() {
        // local variables
        String jsonResult = "[{\"VAR_ID\": \"7_50121444_G_A\"},{\"MAF\": {\"ExSeq_17k_eu_mdv2\": 0.000441209 }},{\"OR_FIRTH_FE_IV\": {\"ExSeq_17k_eu_mdv2\": { \"T2D\": 27.8295943657392}}}]";
        List<PropertyValue> propertyValueList = null;
        JSONArray jsonArray = null;

        // parse
        KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResult);
        jsonArray = new JSONArray(jsonResult);
        propertyValueList = knowledgeBaseResultParser.parsePropertyValues(jsonArray);

        // test
        assertNotNull(jsonArray);
        assertNotNull(propertyValueList);
        assertEquals(3, propertyValueList.size());
    }

    @Test
    public void testParseResult() {
        // local variables
        String jsonResult = null;
        List<Variant> variantList = null;

        // load the test file
        InputStream inputStream = getClass().getResourceAsStream('getDataResult.json');
        jsonResult = new Scanner(inputStream).useDelimiter("\\A").next();
        KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonResult);

        // parse
        variantList = knowledgeBaseResultParser.parseResult();

        // test
        assertNotNull(jsonResult);
        assertNotNull(variantList);
        assertEquals(2, variantList.size());

        // loop and test properties on variants
        for (Variant variant : variantList) {
            assertEquals(13, variant.propertyValues.size());
        }
    }
}
