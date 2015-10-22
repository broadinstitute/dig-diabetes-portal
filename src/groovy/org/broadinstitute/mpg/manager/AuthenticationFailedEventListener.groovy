package org.broadinstitute.mpg.manager

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
        if ((event) &&
            (event.exception)&&
            (event.exception.extraInformation)&&
            (event.exception.extraInformation.username)){
            sharedToolsService.sendForgottenPasswordEmail(event.exception.extraInformation.username)
        }
    }
}
