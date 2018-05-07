// Place your Spring DSL code here

import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.manager.AuthenticationFailedEventListener
import org.broadinstitute.mpg.manager.LoggingSecurityEventListener
import org.broadinstitute.mpg.manager.SuccessfulAuthenticationEventListener
import org.broadinstitute.mpg.manager.UsernameNotFoundEventListener
import org.broadinstitute.mpg.SharedToolsService
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
//    userQueryContext(org.broadinstitute.mpg.meta.UserQueryContext){bean->
//        sharedToolsService = ref('sharedToolsService')
//        restServerService = ref('restServerService')
//    }
}
