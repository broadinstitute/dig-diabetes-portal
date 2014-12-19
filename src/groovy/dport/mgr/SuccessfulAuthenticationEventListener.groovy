package dport.mgr

//import dport.people.LoginTracking
import dport.people.User
import org.apache.commons.logging.LogFactory
import org.springframework.context.ApplicationListener
import org.springframework.security.authentication.event.AuthenticationSuccessEvent

/**
 * Created by balexand on 12/16/2014.
 */
class SuccessfulAuthenticationEventListener implements ApplicationListener<AuthenticationSuccessEvent> {

    private static final log = LogFactory.getLog(this)

    void onApplicationEvent(AuthenticationSuccessEvent event){
        log.info "Successful login by username=${event.source?.principal?.username} "
        User user = User.findById(event.source?.principal?.id)
//        LoginTracking loginTracking = new LoginTracking(user: user,
//                timeOfLogin: event.timestamp,
//                accountNonExpired: 0,
//                accountNonLocked: 1,
//                credentialsNonExpired: 0,
//                remoteAddress: event.source?.getDetails()?.remoteAddress,
//                additionalNotes: "")
        log.info "login tracking record~~~~~~~~~~~~~~~~~~~~~"
        // TODO: we need to save this record if we want to be able to track users
        //loginTracking.save()
        log.info "~~~~~~~~~~~~~~~~~~~~~NOT stored!"
    }

}