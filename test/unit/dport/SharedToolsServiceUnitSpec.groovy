package dport

import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@Unroll
@TestFor(SharedToolsService)
@Mock(Phenotype)
class SharedToolsServiceUnitSpec extends Specification {

    /***
     * We can call the service method  but with mocked data  we are really only testing the behavior
     * in the case of an empty domain object
     */
    void "test urlEncodedListOfPhenotypes"() {
        when:
        String status = service.urlEncodedListOfPhenotypes()
        then:
        assertNotNull status
    }

}
