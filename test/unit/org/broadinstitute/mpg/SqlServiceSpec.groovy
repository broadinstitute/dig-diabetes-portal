package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import org.broadinstitute.mpg.SqlService
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(SqlService)
class SqlServiceSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test is dbSnpId string"() {
        expect:
        assert service.isDbSnpIdString(x) == y

        where:
        x | y
        "RS12345" | true
        "rs10203" | true
        "10_100294_A_G" | false
        "GMAV" | false
    }

    void "test if string is varId string"() {
        expect:
            assert service.isVarIdString(x) == y

        where:
            x | y
            "16_3367831_T_T" | true
            "1_3367831_T_T" | true
        "10_3367831_T_T" | true
        "3_3367831_T_T" | true
        "20_3367831_T_T" | true
        "MT_13790_A_G" | true
        "Mt_13790_A_G" | true
        "Y_3631296_T_G" | true
        "y_3631296_T_G" | true
        "X_12767059_G_A" | true
        "GTN435" | false
        "rs27384" | false
        "RSAHD" | false
    }
}
