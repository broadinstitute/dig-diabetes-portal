package grails.plugin.springsecurity

import grails.test.mixin.TestFor
import org.broadinstitute.mpg.people.User
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.AuthenticationTrustResolver
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(LoginController)
class LoginControllerUnitSpec extends Specification {

    def  webAttributes

    def setup() {
        webAttributes = [ : ]
        LoginController.metaClass.webAttributes = { Map args -> redirectParams = args  }

        SpringSecurityService springSecurityServiceMock = Mock(SpringSecurityService)
        controller.springSecurityService = springSecurityServiceMock

        AuthenticationTrustResolver authenticationTrustResolverMock = Mock(AuthenticationTrustResolver)
        controller.authenticationTrustResolver = authenticationTrustResolverMock

        User userMock = Mock(User)

    }

    def cleanup() {
//        def remove = GroovySystem.metaClassRegistry.&removeMetaClass
//        remove LoginController
    }


    void "test auth"() {
        given:
        controller.params.userId = "paneer"
        controller.params.password = "fake"


        when:
        controller.auth()

        then:
        view=="/login/auth"
        response.getStatus()==200
        model.postUrl
        model.rememberMeParameter
        //       springSecurityServiceMock.getCurrentUser() >> userMock
        //       userMock.getDefaultRoleForApplication("MYAPP") >> "ROLE"

    }


    void "test authAjax"() {
        when:
        controller.authAjax()

        then:
        response.getHeader('Location')=="/login/authAjax"
        response.getStatus()==401
    }


    void "test denied"() {

        when:
        controller.denied()

        then:
        response.getStatus()==200
    }


    void "test full"() {

        when:
        controller.full()

        then:
        response.getStatus()==200
        model.postUrl
        model.hasCookie == false
    }


    void "test authfail"() {
        given:
        //request.session['SPRING_SECURITY_LAST_EXCEPTION'] = new AccountExpiredException('testing')
        request.session['SPRING_SECURITY_LAST_EXCEPTION'] = particularProblem


        when:
        controller.authfail()

        then:
        response.getStatus()==status
        println "flash['message'].toString()=${flash['message'].toString()}"
        flash['message'].toString().contains(messageText)

        where:
        particularProblem                                                                       | status    | messageText
        new AccountExpiredException('testing')                                                  |   302     | 'springSecurity.errors.login.fail'
        new CredentialsExpiredException('testing')                                              |   302     | 'springSecurity.errors.login.fail'
        new DisabledException('testing')                                                        |   302     | 'springSecurity.errors.login.fail'
        new LockedException('testing')                                                          |   302     | 'springSecurity.errors.login.fail'
        new org.springframework.security.authentication.BadCredentialsException('testing')      |   302     | 'Sorry, but we have changed'
    }



}
