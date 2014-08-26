package dport.mgr

import dport.SharedToolsService
import org.springframework.context.ApplicationListener
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent
/**
 * Created by balexand on 8/26/2014.
 */
class AuthenticationFailedEventListener implements ApplicationListener<AuthenticationFailureBadCredentialsEvent > {
    SharedToolsService sharedToolsService

    void onApplicationEvent(AuthenticationFailureBadCredentialsEvent event) {
        println "AuthenticationFailedEventListener fired"

            sharedToolsService.sendForgottenPasswordEmail('balexand@broadinstitute.org')
    }
}
