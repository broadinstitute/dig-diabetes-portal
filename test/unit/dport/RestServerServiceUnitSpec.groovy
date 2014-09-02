package dport
import grails.test.mixin.TestFor
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification
import spock.lang.Unroll
/**
 * Created by balexand on 7/18/2014.
 */
@Unroll
@TestFor(RestServerService)
class RestServerServiceUnitSpec extends Specification {



    void "test that there is no service  before  initialization"() {
        when:
        int i=1 // no-op
        then:
        assert service.whatIsMyCurrentServer ()  == "uninitialized"
    }

    void "test that initialize gives us a server"() {
        when:
        service.initialize ()
        then:
        assert service.whatIsMyCurrentServer ()   == "mysql"
    }


    void "test that changing the server string gives an expected result "() {
        given:
        service.initialize ()
        when:
        service.goWithTheBigQueryServer ()
        then:
        assert service.whatIsMyCurrentServer ()   == "bigquery"

    }

    void "test that we can change the server then change it back "() {
        given:
        service.initialize ()
        when:
        service.goWithTheBigQueryServer ()
        service.goWithTheMysqlServer ()
        then:
        assert service.whatIsMyCurrentServer ()   == "mysql"

    }



    @Unroll("testing  extractNumbersWeNeed with #label")
    void "test extractNumbersWeNeed"() {
        when:
        LinkedHashMap<String, Integer> result = service.extractNumbersWeNeed(incoming)

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
