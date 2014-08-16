package dport

import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.web.GroovyPageUnitTestMixin} for usage instructions
 */
@TestFor(HtmlTagLib)
@Unroll
class HtmlTagLibUnitSpec extends Specification {


    void "test selectAllItemsInPage #label"() {
        given:
        String template = '<g:renderGeneSummary></g:renderGeneSummary>'

        when:
        String actualResults = applyTemplate(template).toString()

        then:
        actualResults.size()==0
    }
}
