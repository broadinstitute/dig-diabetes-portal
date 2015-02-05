/*
 * Copyright 2012 the original author or authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package googlesignin

import dport.GoogleRestService
import dport.SpringManipService
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject
import uk.co.desirableobjects.oauth.scribe.OauthService

/**
 * Simple helper controller for handling OAuth authentication and integrating it
 * into Spring Security.
 */
class SpringSecurityOAuthController {

    GrailsApplication grailsApplication
    OauthService oauthService
    GoogleRestService googleRestService
    SpringManipService springManipService
    private static final log = LogFactory.getLog(this)

    /**
     * This can be used as a callback for a successful OAuth authentication
     * attempt. It logs the associated user in if he or she has an internal
     * Spring Security account and redirects to <tt>targetUri</tt> (provided as a URL
     * parameter or in the session). Otherwise it redirects to a URL for
     * linking OAuth identities to Spring Security accounts. The application must implement
     * the page and provide the associated URL via the <tt>oauth.registration.askToLinkOrCreateAccountUri</tt>
     * configuration setting.
     */
    def onSuccess = {
        redirect controller: 'login', action: 'auth'
    }

    def onFailure = {
        redirect controller: 'login', action: 'auth'
    }

    /***
     *  This URL is activated only by an authenticating service (right now we are using Google, others may follow).
     *  The call has to describe the provider ('google', for now), and it has to provide a one time login code,
     *  we will swap that one time login code for an access key, then use the access key to obtain user information,
     *  and then use the email address we get from that user information to key into our local security system.
     */
    def codeExchange  = {

       String code = params.code
       String authProvider =   params.provider
       LinkedHashMap map =   googleRestService.buildCallToRetrieveOneTimeCode(code)
       if (!map) { // something went wrong.  Go back to the homepage, but this user is currently not getting in
           redirect( controller: 'home', action: 'portalHome' )
           return
       }
       JSONObject jsonObject = map["identityInformation"]
       String accessToken = map["accessToken"]

       String accessKey = oauthService.findSessionKeyForAccessToken(authProvider)
       session[accessKey] = new org.scribe.model.Token(accessToken, grailsApplication.config.oauth.providers.google.secret,jsonObject.toString())

        springManipService.forceLogin(jsonObject,session)

       redirect( controller: 'home', action: 'portalHome' )
   }



}

