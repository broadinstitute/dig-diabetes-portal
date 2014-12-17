package dport

import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(Gene)
@Unroll
class GeneUnitSpec extends Specification {

    def setup() {

    }

    def cleanup() {
    }

    void "test empty constructor"() {
        when:
        Gene gene = new Gene()

        then:
        assertNotNull(gene)
        assertNotNull(gene.name1)

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
