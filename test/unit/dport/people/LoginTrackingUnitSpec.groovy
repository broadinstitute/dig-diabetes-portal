package dport.people

import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(LoginTracking)
@Unroll
class LoginTrackingUnitSpec extends Specification {

    User user = new User ()

    def setup() {
    }

    def cleanup() {
    }

    void "test empty constructor"() {
        when:
        LoginTracking loginTracking = new LoginTracking()

        then:
        assertNotNull(loginTracking)
    }


    void "test non-empty constructor"() {
        given:
        Long timeOfLogin = (new Date()).getTime()

        when:
        LoginTracking loginTracking = new LoginTracking(user: user,
                timeOfLogin: timeOfLogin,
                accountNonExpired: 0,
                accountNonLocked: 1,
                credentialsNonExpired: 0,
                remoteAddress: "47.147.247.347",
                additionalNotes: "")

        then:
        assertNotNull(loginTracking)
        assertNotNull(loginTracking.user)
        assertNotNull(loginTracking.timeOfLogin)
        assertNotNull(loginTracking.accountNonExpired)
        assertNotNull(loginTracking.accountNonLocked)
        assertNotNull(loginTracking.credentialsNonExpired)
        assertNotNull(loginTracking.remoteAddress)
        assertNull(loginTracking.additionalNotes)
    }




}
