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

    // array keys
    private final String ARRAY_ID_KEY               = "id";
    private final String ARRAY_ANALYSIS_KEY         = "analysis";
    private final String ARRAY_CHROMOSOME_KEY       = "chr";
    private final String ARRAY_POSITION_KEY         = "position";
    private final String ARRAY_REF_ALLELE_KEY       = "refAllele";
    private final String ARRAY_REF_ALLELE_FREQ_KEY  = "refAlleleFreq";
    private final String ARRAY_P_VALUE_KEY          = "pvalue";
    private final String ARRAY_SCORE_TEST_STAT_KEY  = "scoreTestStat";


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
        List<Variant> variantList = null;
        JSONObject resultJson = null;

        // make sure the com pare data structures exist
        assertNotNull(compareStream);
        assertNotNull(compareString);
        assertNotNull(compareJson);

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

        // compare each individual array of values
        assertEquals(compareJson.getJSONArray(this.ARRAY_ID_KEY), resultJson.getJSONArray(this.ARRAY_ID_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_ANALYSIS_KEY), resultJson.getJSONArray(this.ARRAY_ANALYSIS_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_CHROMOSOME_KEY), resultJson.getJSONArray(this.ARRAY_CHROMOSOME_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_REF_ALLELE_KEY), resultJson.getJSONArray(this.ARRAY_REF_ALLELE_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_REF_ALLELE_FREQ_KEY), resultJson.getJSONArray(this.ARRAY_REF_ALLELE_FREQ_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_POSITION_KEY), resultJson.getJSONArray(this.ARRAY_POSITION_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_P_VALUE_KEY), resultJson.getJSONArray(this.ARRAY_P_VALUE_KEY));
        assertEquals(compareJson.getJSONArray(this.ARRAY_SCORE_TEST_STAT_KEY), resultJson.getJSONArray(this.ARRAY_SCORE_TEST_STAT_KEY));

        // compare the json result
        assertEquals(compareJson, resultJson);
    }
}
