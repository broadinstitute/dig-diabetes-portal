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
    void "test empty constructor"() {
        when:
        Phenotype phenotype = new Phenotype()

        then:
        assertNotNull(phenotype)
        assertNotNull(phenotype.name)

    }

    void "test non-empty constructor"() {
        when:
        Phenotype phenotype = new Phenotype (
                name:"columnData0",
                key:"columnData1",
                databaseKey:"columnData2",
                dataSet :"columnData3",
                category:"columnData4" )

        then:
        assertNotNull(phenotype)
        assertNotNull(phenotype.name)
        assertNotNull(phenotype.key)
        assertNotNull(phenotype.databaseKey)
        assertNotNull(phenotype.dataSet)
        assertNotNull(phenotype.category)

    }
}
