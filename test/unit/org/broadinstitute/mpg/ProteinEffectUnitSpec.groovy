package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import org.broadinstitute.mpg.ProteinEffect
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(ProteinEffect)
class ProteinEffectUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test empty constructor"() {
        when:
        ProteinEffect proteinEffect = new ProteinEffect()

        then:
        assertNotNull(proteinEffect)

    }


    void "test non-empty constructor"() {
        when:
        ProteinEffect proteinEffect = new ProteinEffect (
                name:"columnData0",
                key:"columnData1",
                description:"columnData2" )

        then:
        assertNotNull(proteinEffect)
        assertNotNull(proteinEffect.name)
        assertNotNull(proteinEffect.key)
        assertNotNull(proteinEffect.description)


    }


}
