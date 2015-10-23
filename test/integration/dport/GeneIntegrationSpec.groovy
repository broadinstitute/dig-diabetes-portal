package dport

import org.broadinstitute.mpg.Gene
import grails.test.spock.IntegrationSpec

/**
 * Created by balexand on 7/17/2014.
 */
class GeneIntegrationSpec extends IntegrationSpec{
    void setup() {


    }

    void tearDown() {


    }
    void  "test functions on gene domain object"()  {
        when:
        Gene gene = new Gene (
                name1:"columnData0",
                name2:"columnData1",
                chromosome:"columnData2",
                addrStart :0L,
                addrEnd:0L )

        then:
        gene.save()
    }
}
