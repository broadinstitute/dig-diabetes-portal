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


    void "test that we can change to dev01 behind the load balancer"() {
        given:
        service.initialize ()
        when:
        service.goWithTheDev01BehindLoadBalancer ()
        then:
        assert service.getCurrentServer ()   == service.getDev01BehindLoadBalancer()

    }


    void "test that we can change to dev02 behind the load balancer"() {
        given:
        service.initialize ()
        when:
        service.goWithTheDev02BehindLoadBalancer ()
        then:
        assert service.getCurrentServer ()   == service.getDev02BehindLoadBalancer()

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
