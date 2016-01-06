package org.broadinstitute.mpg.diabetes.metadata.result;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.List;
import java.util.Scanner;

/**
 * Test case class to test the trait search result json translator
 *
 */
public class KnowledgeBaseFlatSearchTranslatorTest extends TestCase {
    JsonParser jsonParser;
    String jsonString;
    KnowledgeBaseFlatSearchTranslator translator;
    KnowledgeBaseResultParser resultParser;

    // test constants
    private final String DATASET_KEY        = "ExSeq_17k_mdv2";
    private final String PHENOTYPE_KEY      = "T2D";
    private final String PROPERTY_KEY       = "P_FIRTH_FE_IV";


    @Before
    public void setUp() throws Exception {
        // set up the service
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream("../parser/metadata.json");
        this.jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);

        // read the variant results file and create the parser
        InputStream inputStream1 = this.getClass().getResourceAsStream("./flattened/standardResultOutput.json");
        String resultString = new Scanner(inputStream1).useDelimiter("\\A").next();
        this.resultParser = new KnowledgeBaseResultParser(resultString);

        // create the translator
        this.translator = new KnowledgeBaseFlatSearchTranslator(this.DATASET_KEY, this.PHENOTYPE_KEY, this.PROPERTY_KEY);
    }

    @Test
    public void testSetup() {
        assertNotNull(this.jsonParser);
        try {
            assertNotNull(this.jsonParser.getMetaDataRoot());

        } catch (PortalException exception) {
            fail("Got test setup error: " + exception.getMessage());
        }

        assertNotNull(this.resultParser);
        try {
            assertTrue(this.resultParser.parseResult().size() > 0);

        } catch (PortalException exception) {
            fail("Got test setup error: " + exception.getMessage());
        }
    }

    @Test
    public void testTranslate() {
        // local variables
        InputStream compareStream = this.getClass().getResourceAsStream("./flattened/flatResultOutput.json");
        String compareString = new Scanner(compareStream).useDelimiter("//A").next();
        JSONObject compareJson = new JSONObject(compareString);
        JSONObject compareDataJsonObject = null;
        JSONObject dataJsonObject = null;
        List<Variant> variantList = null;
        JSONObject resultJson = null;

        // make sure the com pare data structures exist
        assertNotNull(compareStream);
        assertNotNull(compareString);
        assertNotNull(compareJson);
        compareDataJsonObject = compareJson.getJSONObject(KnowledgeBaseFlatSearchTranslator.KEY_DATA);
        assertNotNull(compareDataJsonObject);

        // get the variant list from the result parser and create the json
        try {
            variantList = this.resultParser.parseResult();

        } catch (PortalException exception) {
            fail("got flat search exception: " + exception.getMessage());
        }

        // create the resulting flat json and compare it
        try {
            resultJson = this.translator.translate(variantList);

        } catch (PortalException exception) {
            fail("got flat search exception: " + exception.getMessage());
        }

        // get the data object
        assertNotNull(resultJson);
        dataJsonObject = resultJson.getJSONObject(KnowledgeBaseFlatSearchTranslator.KEY_DATA);
        assertNotNull(dataJsonObject);

        // compare each individual array of values
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_ID), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_ID));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_ANALYSIS), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_ANALYSIS));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_CHROMOSOME), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_CHROMOSOME));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_REF_ALLELE), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_REF_ALLELE));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_REF_ALLELE_FREQ), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_REF_ALLELE_FREQ));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_POSITION), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_POSITION));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_P_VALUE), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_P_VALUE));
        assertEquals(compareDataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_SCORE_TEST_STAT), dataJsonObject.getJSONArray(KnowledgeBaseFlatSearchTranslator.KEY_SCORE_TEST_STAT));

        // compare the json result
        assertEquals(compareJson, resultJson);
    }
}
