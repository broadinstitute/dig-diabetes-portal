package dport

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
// change to SqlService class in the TestFor section seems to solve the CI build issues where reflection
// problems were popping up

@TestFor(SqlService)
class MetadataUtilityServiceSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
    }
}
