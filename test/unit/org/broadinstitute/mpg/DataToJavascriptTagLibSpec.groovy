package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.web.GroovyPageUnitTestMixin} for usage instructions
 */
@TestFor(DataToJavascriptTagLib)
@Unroll
class DataToJavascriptTagLibSpec extends Specification {


    void "smoke test renderRowValues no data"() {
        given:
        Map attributes
        //Map attributes=[name:'GWAS', value:RestServerService.TECHNOLOGY_GWAS, count:'69,033']
        String template = '<g:renderRowValues></g:renderRowValues>'

        when:
        String actualResults = applyTemplate(template,[data:attributes]).toString()

        then:
        assert actualResults.size()==0

    }
}
