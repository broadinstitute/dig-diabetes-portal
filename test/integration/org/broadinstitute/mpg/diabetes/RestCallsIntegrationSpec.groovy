package org.broadinstitute.mpg.diabetes
import dport.RestServerService
import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.*
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.After
import org.junit.Before
import spock.lang.Unroll
/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class RestCallsIntegrationSpec extends IntegrationSpec {
    BurdenService burdenService
    RestServerService restServerService
    JsonParser jsonParser;
    QueryJsonBuilder queryJsonBuilder;

    @Before
    void setup() {
        this.jsonParser = JsonParser.getService()
        this.jsonParser.setJsonString(this.restServerService.getMetadata())
        this.queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
    }

    @After
    void tearDown() {

    }


    void "test json builder variant count rest call"() {
        setup:
        Property property = this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID);
        Property geneProperty = this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_GENE);
        QueryFilter queryFilter = new QueryFilterBean(geneProperty, PortalConstants.OPERATOR_EQUALS, "SLC30A8");
        GetDataQuery query = new GetDataQueryBean();
        Boolean isCount = true;
        String passbackString = "123abc";
        JSONObject jsonObject = new JSONObject("{\"is_error\": false,\"passback\": \"123abc\",\"numRecords\": 207}");
        JSONObject resultJson = null;

        when:
        query.addQueryFilter(queryFilter);
        query.addQueryProperty(property);
        query.addQueryProperty(geneProperty);
        query.setPassback(passbackString);

        // also set to count = true
        query.isCount(isCount);

        // execute the query
        resultJson = this.restServerService.postGetDataCall(this.queryJsonBuilder.getQueryJsonPayloadString(query));

        then:
        assert resultJson != null
        assert jsonObject.toString() == resultJson.toString()
    }

}
