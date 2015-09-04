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



    void "test that we can change to load balanced dev"() {
        given:
        service.initialize ()
        when:
        service.goWithTheDevLoadBalancedServer ()
        then:
        assert service.getCurrentServer ()   == service.getDevLoadBalanced()

    }




    void "test that we can change to load balanced prod"() {
        given:
        service.initialize ()
        when:
        service.goWithTheProdLoadBalancedServer ()
        then:
        assert service.getCurrentServer ()   == service.getProdLoadBalanced()

    }



    void "test that we can change to load balanced QA"() {
        given:
        service.initialize ()
        when:
        service.goWithTheQaLoadBalancedServer ()
        then:
        assert service.getCurrentServer ()   == service.getQaLoadBalanced()

    }


    void "test that we can change to AWS"() {
        given:
        service.initialize ()
        when:
        service.goWithTheAws01RestServer ()
        then:
        assert service.getCurrentServer ()   == service.getAws01RestServer()

    }


}
