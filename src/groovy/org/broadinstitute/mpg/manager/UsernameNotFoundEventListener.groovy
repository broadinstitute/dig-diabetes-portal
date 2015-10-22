package org.broadinstitute.mpg.manager

import dport.SharedToolsService
import org.springframework.context.ApplicationListener
import org.springframework.security.core.userdetails.UsernameNotFoundException

/**
 * Created by balexand on 8/26/2014.
 */
class UsernameNotFoundEventListener implements ApplicationListener<UsernameNotFoundException> {
    SharedToolsService sharedToolsService

    void onApplicationEvent(UsernameNotFoundException event) {
        println "UsernameNotFoundEventListener fired"
        sharedToolsService.sendForgottenPasswordEmail('balexand@broadinstitute.org')
    }
}
