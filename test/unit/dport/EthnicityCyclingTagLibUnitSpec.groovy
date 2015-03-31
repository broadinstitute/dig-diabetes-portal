package dport

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.GroovyPageUnitTestMixin} for usage instructions
 */
@TestFor(EthnicityCyclingTagLib)
class EthnicityCyclingTagLibUnitSpec extends Specification {



    void "test selectAllItemsInPage #label"() {
        given:
        mockTagLib HelpTextTagLib
        String template = '<g:alleleFrequencyRange></g:alleleFrequencyRange>'

        when:
        String actualResults = applyTemplate(template).toString()

        then:
        assert actualResults.contains("""<input type="text" class="form-control" id="ethnicity_af_""".toString())
    }
}
