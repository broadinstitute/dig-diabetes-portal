// Place your Spring DSL code here
import dport.mgr.AuthenticationFailedEventListener
import dport.mgr.LoggingSecurityEventListener
import dport.mgr.SuccessfulAuthenticationEventListener
import dport.mgr.UsernameNotFoundEventListener
import dport.SharedToolsService
import org.springframework.context.ApplicationListener
import org.springframework.security.authentication.event.AuthenticationSuccessEvent

beans = {
    authenticationFailedEventListener(AuthenticationFailedEventListener) {
        sharedToolsService = ref('sharedToolsService')
    }
    usernameNotFoundEventListener(UsernameNotFoundEventListener) {
        sharedToolsService = ref('sharedToolsService')
    }
    successfulAuthenticationEventListener(SuccessfulAuthenticationEventListener){
    }
    securityEventListener(LoggingSecurityEventListener){
    }
}
