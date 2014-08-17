package dport

import dport.Gene
import dport.Phenotype
import grails.test.spock.IntegrationSpec

/**
 * Created by balexand on 7/17/2014.
 */
class PhenotypeIntegrationSpec extends IntegrationSpec{
    void setup() {


    }

    void tearDown() {


    }
    void  "test functions on phenotype domain object"()  {
        when:
        Phenotype phenotype = new Phenotype (
                key: "columnData0",
                name:"columnData1",
                databaseKey: "columnData2",
                dataSet :"columnData3",
                category:"columnData4" )

        then:
        phenotype.save()
    }
}
