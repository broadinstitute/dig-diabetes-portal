package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.junit.After
import org.junit.Before

/**
 * Created by mduby on 12/21/15.
 */
class WidgetServiceIntegrationSpec extends IntegrationSpec{
    // instance variables
    RestServerService restServerService
    JsonParser jsonParser
    WidgetService widgetService;

    @Before
    void setup() {
        this.jsonParser = JsonParser.getService()
        this.jsonParser.setJsonString(this.restServerService.getMetadata())
    }

    @After
    void tearDown() {

    }

    void "test LZ rest call"() {
        when:
        String resultJsonString = null;
        String chromosome = "8";
        int startPosition = 118000000;
        int endPosition = 121000000;
        resultJsonString = this.widgetService.getVariantJsonForLocusZoomString(chromosome, startPosition, endPosition,
                "ExSeq_19k_mdv31", "T2D", "P_FIRTH_FE_IV", "static", [], -1);

        then:
        assert resultJsonString != null
        // Hail is currently failing
//        assert resultJsonString.length() > 50
    }
}
