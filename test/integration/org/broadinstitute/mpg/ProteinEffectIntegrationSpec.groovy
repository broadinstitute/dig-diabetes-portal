package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.ProteinEffect

/**
 * Created by balexand on 7/17/2014.
 */
class ProteinEffectIntegrationSpec extends IntegrationSpec{
    void setup() {


    }

    void tearDown() {


    }
    void  "test functions on gene domain object"()  {
        when:
        ProteinEffect proteinEffect  = new ProteinEffect (
                key:"columnData0",
                name:"columnData1",
                description:"columnData2" )

        then:
        proteinEffect.save()
    }
}
