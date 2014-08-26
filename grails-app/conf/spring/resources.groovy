// Place your Spring DSL code here
import dport.mgr.AuthenticationFailedEventListener
import dport.mgr.UsernameNotFoundEventListener
import dport.SharedToolsService
beans = {
    authenticationFailedEventListener(AuthenticationFailedEventListener) {
        sharedToolsService = ref('sharedToolsService')
    }
    usernameNotFoundEventListener(UsernameNotFoundEventListener) {
        sharedToolsService = ref('sharedToolsService')
    }
}
