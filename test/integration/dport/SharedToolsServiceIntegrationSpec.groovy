package dport

import grails.test.spock.IntegrationSpec
import org.junit.After
import org.junit.Before
import spock.lang.Unroll

/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class SharedToolsServiceIntegrationSpec  extends IntegrationSpec {
    SharedToolsService sharedToolsService


    @Before
    void setup() {

    }

    @After
    void tearDown() {

    }

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

    void "test packageUpFiltersForRoundTrip Typical usage"() {
        given:
        List <String> typicalParameter = [
                """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "GTE", "value": 0 }""".toString(),
                """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 0.05 }""".toString(),
                """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 1 }""".toString()]

        when:
        String encodedPhenotypes = sharedToolsService.packageUpFiltersForRoundTrip(typicalParameter)
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


}
