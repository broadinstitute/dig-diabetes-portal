package dport

import dport.people.Role
import dport.people.User
import dport.people.UserRole
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.oauth.OAuthToken
import grails.transaction.Transactional
import dport.people.User
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken



@Transactional
class SpringManipService {
    SpringSecurityService springSecurityService
    AuthenticationManager authenticationManager

    void signIn(String username, String password) {
        try {
            def authentication = new UsernamePasswordAuthenticationToken(username, password)
            SCH.context.authentication = authenticationManager.authenticate(authentication)
        } catch (BadCredentialsException e) {
            throw new SecurityException("Invalid username/password")
        }
    }

    void signOut() {
        SCH.context.authentication = null
    }

    boolean isSignedIn() {
        return springSecurityService.isLoggedIn()
    }

    public void forceLogin(String email,javax.servlet.http.HttpSession session) {
        User user = User.findByUsername(email)
        if (user){ // we arty have a user.  Connect to it
            signIn(email,'bloodglucose')
        } else { // we don't have a user record.  Create one

            user = new User (
                    username: email,
                    password: 'bloodglucose',
                    email: 'bloodglucose',
                    enabled: true )
            if (user.validate ()){
                Role userRole = Role.findByAuthority('ROLE_USER')
                log.info( "Creating user ${email}")
                user.save(flush: true)
                UserRole.create user,userRole
            }
            signIn(email,'bloodglucose')
        }
        //   OAuthToken oAuthToken = session[SPRING_SECURITY_OAUTH_TOKEN]
        //   assert oAuthToken, "There is no auth token in the session!"

//        if (request.post) {
//            boolean linked = command.validate() && User.withTransaction { status ->
//                User user = User.findByUsernameAndPassword(
//                        command.username, springSecurityService.encodePassword(command.password))
//                if (user) {
//                    user.addToOAuthIDs(provider: oAuthToken.providerName, accessToken: oAuthToken.socialId, user: user)
//                    if (user.validate() && user.save()) {
//                        oAuthToken = updateOAuthToken(oAuthToken, user)
//                        return true
//                    }
//                } else {
//                    command.errors.rejectValue("username", "OAuthLinkAccountCommand.username.not.exists")
//                }
//
//                status.setRollbackOnly()
//                return false
//            }
//
//            if (linked) {
//                authenticateAndRedirect(oAuthToken, defaultTargetUrl)
//                return
//            }
//        }
//
//        render view: 'askToLinkOrCreateAccount', model: [linkAccountCommand: command]
        return
    }

}
