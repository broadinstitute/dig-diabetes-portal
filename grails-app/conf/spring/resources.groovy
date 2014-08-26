// Place your Spring DSL code here
import dport.mgr.AuthenticationFailedEventListener
import dport.mgr.UsernameNotFoundEventListener
beans = {
    authenticationFailedEventListener(AuthenticationFailedEventListener)
    usernameNotFoundEventListener(UsernameNotFoundEventListener)
}
