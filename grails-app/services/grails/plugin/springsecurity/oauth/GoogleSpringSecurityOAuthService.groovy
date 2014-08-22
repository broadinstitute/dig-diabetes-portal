package grails.plugin.springsecurity.oauth

import grails.converters.JSON
import grails.transaction.Transactional

@Transactional
class GoogleSpringSecurityOAuthService {

    def oauthService

    /*
     * Requires scope of "https://www.googleapis.com/auth/userinfo.email"
     * Expected response:
     *   { "email": "username@gmail.com", "verified_email": true }
     */
    def createAuthToken(accessToken) {
        def response = oauthService.getGoogleResource(accessToken, 'https://www.googleapis.com/oauth2/v1/userinfo')
        def user
        try {
            user = JSON.parse(response.body)
        } catch (Exception e) {
            log.error "Error parsing response from Google. Response:\n${response.body}"
            throw new RuntimeException ('Error parsing response from Google', e)
        }
        if (!user?.email) {
            log.error "No user email from Google. Response:\n${response.body}"
            throw new RuntimeException ('No user email from Google')
        }
        return// new GoogleOAuthToken(accessToken, user.email)
    }
}
