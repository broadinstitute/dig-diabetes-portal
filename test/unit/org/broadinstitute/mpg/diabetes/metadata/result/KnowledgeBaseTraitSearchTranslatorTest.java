package org.broadinstitute.mpg.diabetes.metadata.result;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValueBean;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.VariantBean;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * Test case class to test the trait search result json translator
 *
 */
public class KnowledgeBaseTraitSearchTranslatorTest extends TestCase {
    JsonParser jsonParser;
    String jsonString;
    KnowledgeBaseTraitSearchTranslator translator;

    @Before
    public void setUp() throws Exception {
        // set up the service
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream("../parser/metadata.json");
        this.jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);

        // create the translator
        this.translator = new KnowledgeBaseTraitSearchTranslator();
    }

    public void testSetup() {
        assertNotNull(this.jsonParser);
        try {
            assertNotNull(this.jsonParser.getMetaDataRoot());

        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }
    }

    @Test
    public void testTranslate() {
        // local variables
        Property chromosomeProperty = null;
        Property positionProperty = null;
        Property t2dProperty = null;
        Variant variant;
        List<Variant> variantList = new ArrayList<Variant>();
        JSONObject result = null;
        JSONObject compareJson = new JSONObject("{\"variants\": [{\"CHROM\":\"8\",\"P_VALUE\":0.5,\"POS\":1000000,\"TRAIT\":\"T2D\"}, {\"CHROM\":\"9\",\"P_VALUE\":0.2,\"POS\":200000,\"TRAIT\":\"T2D\"}], \"is_error\": false, \"numRecords\": 2}");

        // test
        try {
            // set commonly used properties
            chromosomeProperty = (Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME);
            positionProperty = (Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION);
            t2dProperty = (Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_P_VALUE_GWAS_DIAGRAM_T2D);

            // create the variant
            variant = new VariantBean();
            variant.addToPropertyValues(new PropertyValueBean(chromosomeProperty, "8"));
            variant.addToPropertyValues(new PropertyValueBean(positionProperty, "1000000"));
            variant.addToPropertyValues(new PropertyValueBean(t2dProperty, ".5"));
            variantList.add(variant);


            // create the variant
            variant = new VariantBean();
            variant.addToPropertyValues(new PropertyValueBean(chromosomeProperty, "9"));
            variant.addToPropertyValues(new PropertyValueBean(positionProperty, "200000"));
            variant.addToPropertyValues(new PropertyValueBean(t2dProperty, ".2"));
            variantList.add(variant);

            // create the json object
            result = this.translator.translate(variantList);

        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }

        // test
        assertNotNull(result);
        assertEquals(compareJson.toString(), result.toString());
    }


    @Test
    public void testgetTraitSearchJsonObject() {
        // local variables
        Property chromosomeProperty = null;
        Property positionProperty = null;
        Variant variant;
        JSONObject result = null;
        JSONObject compareJson = new JSONObject("{\"CHROM\": \"8\", \"POS\": 1000000}");

        // test
        try {
            // create the variant
            variant = new VariantBean();

            // get the properties
            chromosomeProperty = (Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME);
            positionProperty = (Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION);
            variant.addToPropertyValues(new PropertyValueBean(chromosomeProperty, "8"));
            variant.addToPropertyValues(new PropertyValueBean(positionProperty, "1000000"));

            // create the json object
            result = this.translator.getTraitSearchJsonObject(variant);

        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }

        // test
        assertNotNull(result);
        assertEquals(compareJson, result);
    }


}
