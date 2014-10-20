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
    SharedToolsService sharedToolsService


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
        assertNotNull( service.whatIsMyCurrentServer () )
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




}
