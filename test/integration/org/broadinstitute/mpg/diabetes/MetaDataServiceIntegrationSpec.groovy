package org.broadinstitute.mpg.diabetes

import dport.RestServerService
import dport.SharedToolsService
import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.junit.After
import org.junit.Before
import spock.lang.Unroll
import org.broadinstitute.mpg.diabetes.metadata.Property

/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class MetaDataServiceIntegrationSpec extends IntegrationSpec {
    SharedToolsService sharedToolsService
    MetaDataService metaDataService
    RestServerService restServerService

    @Before
    void setup() {
        JsonParser jsonParser = JsonParser.getService()
        jsonParser.setJsonString(this.restServerService.getMetadata())
    }

    @After
    void tearDown() {

    }

    /*
    void "test urlEncodedListOfPhenotypes smoke"() {
        when:
        String encodedPhenotypes = sharedToolsService.urlEncodedListOfPhenotypes()
        then:
        assert !encodedPhenotypes.isEmpty()
    }

    void "test urlEncodedListOfProteinEffect smoke"() {
        when:
        String encodedPhenotypes = sharedToolsService.urlEncodedListOfProteinEffect()
        then:
        assert !encodedPhenotypes.isEmpty()
    }

    void "test packageUpFiltersForRoundTrip with empty parameter list"() {
        given:
        List <String> emptyParameter = []

        when:
        String encodedPhenotypes = sharedToolsService.packageUpFiltersForRoundTrip(emptyParameter)
        then:
        assert encodedPhenotypes.isEmpty()
    }


    void "test packageUpEncodedParameters with typical parameter list"() {
        given:
        List <String> typicalParameters = [
                "1:3",
                "2:1",
                "23:1"]

        when:
        String encodedPhenotypes = sharedToolsService.packageUpEncodedParameters(typicalParameters)
        then:
        assert !encodedPhenotypes.isEmpty()
    }



    void "test packageUpEncodedParameters with empty parameters"() {
        given:
        List <String> emptyParameter = []

        when:
        String encodedPhenotypes = sharedToolsService.packageUpEncodedParameters(emptyParameter)
        then:
        assert encodedPhenotypes.isEmpty()
    }
    */

    // I think we need one non-null test to avoid a compilation error(?)
    void "get property by type list"() {
        when:
        List<Property> commonPropertyList = this.metaDataService.getPropertyListByPropertyType(PortalConstants.TYPE_COMMON_PROPERTY_KEY, 20);

        then:
        assert commonPropertyList != null
        assert commonPropertyList.size() < 20
    }


    void "test url encoded phenotype string"() {
        when:
        String phenotypeUrlString = this.metaDataService.urlEncodedListOfPhenotypes();

        then:
        assert phenotypeUrlString != null
        assert phenotypeUrlString.length() > 0
    }

}
