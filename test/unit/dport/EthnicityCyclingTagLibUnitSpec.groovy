package dport

import grails.test.mixin.TestFor
import spock.lang.Specification
import dport.SharedToolsService

/**
 * See the API for {@link grails.test.mixin.web.GroovyPageUnitTestMixin} for usage instructions
 */
@TestFor(EthnicityCyclingTagLib)
class EthnicityCyclingTagLibUnitSpec extends Specification {

    def sharedToolsService = mockFor(dport.SharedToolsService)

    void "test selectAllItemsInPage #label"() {
        given:
        mockTagLib HelpTextTagLib
//        sharedToolsService.demand.getHelpTextSetting() { -> return 1 }
//        taglib.sharedToolsService = sharedToolsService.createMock()
        String template = '<g:alleleFrequencyRange></g:alleleFrequencyRange>'

        when:
        String actualResults = applyTemplate(template).toString()

        then:
        assert actualResults.contains("""<input type="text" class="form-control" id="ethnicity_af_""".toString())
    }
}
