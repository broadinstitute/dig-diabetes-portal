package org.broadinstitute.mpg.diabetes.json.builder;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.Scanner;

/**
 * Created by mduby on 12/21/15.
 */
public class LocusZoomJsonBuilderTest extends TestCase {
    // instance variables
    String metadataJsonString = null;
    String locusZoomJsonString = null;
    JsonParser jsonParser;

    @Before
    public void setUp() throws Exception {
        // set up the service
        InputStream inputStream = getClass().getResourceAsStream("locusZoomGetDataRequest.json");
        this.locusZoomJsonString = new Scanner(inputStream).useDelimiter("\\A").next();

        // this is to make sure the parser is initialized
        jsonParser = JsonParser.getService();
        InputStream metadataInputStream = getClass().getResourceAsStream("../../metadata/parser/metadata.json");
        this.metadataJsonString = new Scanner(metadataInputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.metadataJsonString);
    }

    @Test
    public void testGetLocusZoomQueryString() {
        // local variables
        InputStream expectedInputStream = getClass().getResourceAsStream("locusZoomGetDataRequest.json");
        String expectedLocusZoomJsonString = new Scanner(expectedInputStream).useDelimiter("\\A").next();
        LocusZoomJsonBuilder locusZoomJsonBuilder = new LocusZoomJsonBuilder("ExSeq_17k_mdv2", "T2D");
        String jsonString = null;
        JSONObject testJsonObject = null;
        JSONObject locusZoomJsonObject = null;

        // make sur etest string is not null
        assertNotNull(this.locusZoomJsonString);
        testJsonObject = new JSONObject(expectedLocusZoomJsonString);
        assertNotNull(testJsonObject);

        // get the json string
        try {
            jsonString = locusZoomJsonBuilder.getLocusZoomQueryString("8", 118000000, 121000000, null, 500, "verbose");

            // create the json object
            locusZoomJsonObject = new JSONObject(jsonString);

        } catch (PortalException exception) {
            fail("got error building LZ getData string: " + exception.getMessage());
        }

        // compare to the test string
        assertNotNull(locusZoomJsonObject);
        assertEquals(testJsonObject.toString(), locusZoomJsonObject.toString());
//        assertEquals(testJsonObject, locusZoomJsonObject);
    }
}
