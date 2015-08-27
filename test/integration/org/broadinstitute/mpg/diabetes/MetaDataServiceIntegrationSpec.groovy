package org.broadinstitute.mpg.diabetes

import dport.PhenoKey
import dport.SharedToolsService
import grails.test.spock.IntegrationSpec
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.json.JSONTokener
import org.junit.After
import org.junit.Before
import spock.lang.Unroll
/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class MetaDataServiceIntegrationSpec extends IntegrationSpec {
    SharedToolsService sharedToolsService
    MetaDataService metaDataService


    @Before
    void setup() {

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

    void "test compare common properties new and old data structure json"() {
        when:
        String oldDataStructure = this.sharedToolsService.sortAndPackageAMapOfListsAsJson(sharedToolsService.getProcessedMetadata()?.commonProperties, true);
        String newDataStructure = this.metaDataService.getCommonPropertiesAsJson(true);
        JSONTokener oldTokener = new JSONTokener(oldDataStructure);
        JSONObject oldJson = new JSONObject(oldTokener);
        JSONTokener newTokener = new JSONTokener(newDataStructure);
        JSONObject newJson = new JSONObject(newTokener);

        then:
//        assert oldDataStructure == newDataStructure                   // some basic whitespace errors
        assert oldJson.toString() ==  newJson.toString()
    }




}
