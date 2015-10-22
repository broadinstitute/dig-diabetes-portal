package dport

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.After
import org.junit.Before
import spock.lang.Unroll

/**
 * Created by ben on 8/31/2014.
 */
@Unroll
class RestServerServiceIntegrationSpec  extends IntegrationSpec {
    RestServerService restServerService
    SharedToolsService sharedToolsService
    MetaDataService metaDataService // Initialize metadata if necessary


    @Before
    void setup() {
        metaDataService.getCommonPropertiesAsJson(false)
    }

    @After
    void tearDown() {

    }



    void "test retrieveTraitAsSpecifiedByGenomicRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchForTraitBySpecifiedRegion("9","21940000","22190000")
        then:
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }


    void "test retrieveTreatByUnparsedGenomicRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchTraitByUnparsedRegion("chr9:21,940,000-22,190,000")
        then:
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }



    void "test retrieveGeneInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveGeneInfoByName("PANX1")
        then:
        assert jsonObject
    }

    void "test retrieveVariantInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveVariantInfoByName("rs13266634")
        then:
        assert jsonObject
    }


    @Unroll("testing  extractNumbersWeNeed with #label")
    void "test extractNumbersWeNeed"() {

        setup:
        restServerService.sharedToolsService = sharedToolsService

        when:
        LinkedHashMap<String, String> result = restServerService.extractNumbersWeNeed(incoming)

        then:
        result["chromosomeNumber"]  == chromosomeNumber
        result["startExtent"]  == startExtentNumber
        result["endExtent"]  == endExtentNumber


        where:
        label                       | incoming                          | chromosomeNumber  |   startExtentNumber   |   endExtentNumber
        "extents have commas"       | 'chr9:21,940,000-22,190,000'      |   "9"             |   "21940000"          |   "22190000"
        "extents have no commas"    | 'chr9:21940000-22190000'          |   "9"             |   "21940000"          |   "22190000"
        "extents have other numbers"| 'chr23:4700-9999992'              |   "23"            |   "4700"              |   "9999992"
        "extents with big numbers"  | 'chr9:2-2002190000'               |   "9"             |   "2"                 |   "2002190000"
        "sex chromosome X"          | 'chrX:700-80000'                  |   "X"             |   "700"               |   "80000"
        "sex chromosome Y"          | 'chrY:600-8098000'                |   "Y"             |   "600"               |   "8098000"
        "chromosome has no text"    | '1:2-99999'                       |   "1"             |   "2"                 |   "99999"


    }





}
