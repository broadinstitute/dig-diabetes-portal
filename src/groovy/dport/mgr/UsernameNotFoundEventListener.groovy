package dport.mgr

import org.springframework.context.ApplicationListener
import org.springframework.security.core.userdetails.UsernameNotFoundException

/**
 * Created by balexand on 8/26/2014.
 */
class UsernameNotFoundEventListener implements ApplicationListener<UsernameNotFoundException> {
    void onApplicationEvent(UsernameNotFoundException event) {
        println "UsernameNotFoundEventListener fired"
    }
}
