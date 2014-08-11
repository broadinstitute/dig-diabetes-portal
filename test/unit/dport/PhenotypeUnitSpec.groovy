package dport

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(Phenotype)
class PhenotypeUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test non-empty constructor"() {
        when:
        Gene gene = new Gene (
                name1:"columnData0",
                name2:"columnData1",
                chromosome:"columnData2",
                addrStart :0L,
                addrEnd:0L )

        then:
        assertNotNull(gene)
        assertNotNull(gene.name1)

    }
}
