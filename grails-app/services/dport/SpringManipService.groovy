package dport

import dport.people.Role
import dport.people.User
import dport.people.UserRole
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.oauth.OAuthToken
import grails.transaction.Transactional
import dport.people.User
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
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
//            springSecurityService.reauthenticate username
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

    /***
     * Given the identity information we have about this user we need to first of all decide whether
     * or not we have a record for them.  If we do then go with the existing record.  If we don't
     * then create a new record, and squeeze and everything we can.  If we're lacking a core minimum
     * of data (notably an email) then give up and return without logging in the user.
     *
     * @param identityInformation
     * @param session
     */
    public Boolean forceLogin(JSONObject identityInformation,javax.servlet.http.HttpSession session) {
        if ((!identityInformation) ||
            (!identityInformation.emails) ||
            (identityInformation.emails.size()<1) ) {
            return  // no email.  This is the one identifier we cannot do without
        }
        Boolean weHaveSeenYouBefore = false
        String email = identityInformation.emails[0]['value']
        String username = email
        String password = 'bloodglucose'
        String fullName = "default"
        String nickname = "default"
        String primaryOrganization = "default"
        String webSiteUrl = "default"
        String preferredLanguage = "en" // default to English
        // find better values if we can
        if (identityInformation.displayName){
            fullName = identityInformation.displayName
        }
        if (identityInformation.name){
            JSONObject nameObject = identityInformation.name
            if (nameObject?.names()){
                if (nameObject['givenName']) {
                   nickname = nameObject['givenName']
                }
            }
        }
        if (identityInformation.organizations){
            JSONArray organizationArray = identityInformation.organizations
            if (organizationArray.size()>0){
                for ( int i = 0 ; i < organizationArray.size() ; i++ ){
                    JSONObject oneOrganization = organizationArray[i]
                    if ((oneOrganization.primary) &&
                        (oneOrganization.name)) {
                        primaryOrganization = oneOrganization.name
                    }
                }
            }
        }
        if (identityInformation.url){
            webSiteUrl = identityInformation.url
        }
        if (identityInformation.language){
            preferredLanguage = identityInformation.language
        }
        User user = User.findByUsername(email)
        if (user){ // we arty have a user.  Connect to it
            signIn(email,'bloodglucose')
            weHaveSeenYouBefore = true
        } else { // we don't have a user record.  Create one

            user = new User (
                    username: username,
                    password: password,
                    email: email,
                    fullName: fullName,
                    nickname:nickname,
                  //  primaryOrganization:primaryOrganization,
                 //   webSiteUrl:webSiteUrl,
                  //  preferredLanguage:preferredLanguage,
                    enabled: true )
            if (user.validate ()){
                Role userRole = Role.findByAuthority('ROLE_USER')
                log.info( "Creating user ${email}")
                user.save(flush: true)
                UserRole.create user,userRole
            } else {
                log.error( "Problem validating user: ${email}")
                log.error( "specs=${user.errors.toString()}")
            }
            signIn(email,'bloodglucose')
        }
        return weHaveSeenYouBefore

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
         return
    }

}
