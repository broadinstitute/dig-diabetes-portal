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



    void "test that we can change to test"() {
        given:
        service.initialize ()
        when:
        service.goWithTheTestServer ()
        then:
        assert service.getCurrentServer ()   == service.getTestserver()

    }


    void "test that we can change to qa"() {
        given:
        service.initialize ()
        when:
        service.goWithTheQaServer ()
        then:
        assert service.getCurrentServer ()   == service.getQaserver()

    }



    void "test that we can change to newdev"() {
        given:
        service.initialize ()
        when:
        service.goWithTheNewDevServer ()
        then:
        assert service.getCurrentServer ()   == service.getNewdevserver()

    }


    void "test that we can change to prod"() {
        given:
        service.initialize ()
        when:
        service.goWithTheProdServer ()
        then:
        assert service.getCurrentServer ()   == service.getProdserver()

    }


}
