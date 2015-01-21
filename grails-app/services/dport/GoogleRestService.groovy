package dport

import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject
import grails.plugins.rest.client.RestBuilder
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap

@Transactional
class GoogleRestService {

    GrailsApplication grailsApplication
    private static final log = LogFactory.getLog(this)

    private  String MYSQL_REST_SERVER = ""

    JSONObject buildCallToRetrieveOneTimeCode(String oneTimeCode) {
        String destination =   "https://${grailsApplication.config.googleapi.baseUrl}/oauth2/v3/token"
        //  String encodedRedirectUrl=URLEncoder.encode(grailsApplication.config.oauth.providers.google.successUri, "UTF-8")
        String encodedRedirectUrl=URLEncoder.encode(grailsApplication.config.oauth.providers.google.callback, "UTF-8")
        String contents = "code=${oneTimeCode}&"+
                "client_id=${grailsApplication.config.oauth.providers.google.key}&"+
                "client_secret=${grailsApplication.config.oauth.providers.google.secret}&"+
                "redirect_uri=${encodedRedirectUrl}&"+
                "grant_type=authorization_code"
        JSONObject jsonObject = postGoogleRestCallBase (contents,destination)
        String idToken = jsonObject.id_token
        String accessToken = jsonObject.access_token
        JSONObject identityInformation =  postAuthorizedGoogleRestCall(accessToken,"https://www.googleapis.com/plus/v1/people/me")
        log.info(""+
                identityInformation.emails['value']+
                identityInformation.id+
                identityInformation.name ['familyName']+
                identityInformation.name ['givenName']+
                identityInformation.displayName+
                identityInformation.domain+
                identityInformation.gender+
                identityInformation.language+
                identityInformation.etag)
        return identityInformation

//                identityInformation.emails['value']
//                identityInformation.id
//                identityInformation.name ['familyName']
//                identityInformation.name ['givenName']
//                identityInformation.displayName
//                identityInformation.domain
//                identityInformation.gender
//                identityInformation.language
//                identityInformation.etag
    }

    private JSONObject postGoogleRestCallBase(String drivingContents, String targetUrl){
        JSONObject returnValue = null as JSONObject
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response  = rest.post(targetUrl)   {
                contentType "application/x-www-form-urlencoded"
                json drivingContents
            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingContents}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingContents}"
            afterCall  = new Date()
        }
        logStatus << """
SERVER CALL:
url=${targetUrl},
parm=${drivingContents},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.json
            logStatus << """status: ok""".toString()
        }  else {
            JSONObject tempValue =  response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if  (tempValue)  {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            }  else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }









    private JSONObject postAuthorizedGoogleRestCall(String authorization,String targetUrl){
        JSONObject returnValue = null as JSONObject
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response  = rest.get(targetUrl)   {
                contentType "application/x-www-form-urlencoded"
                header "Authorization", "Bearer ${authorization}"
            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}, no message body")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}, no message body"
            afterCall  = new Date()
        }
        logStatus << """
SERVER CALL:
url=${targetUrl},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.json
            logStatus << """status: ok""".toString()
        }  else {
            JSONObject tempValue =  response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if  (tempValue)  {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            }  else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }



    private JSONObject requestTwitterAuthentication(String targetUrl,
                                                    String nonce,
                                                    String callback,
                                                    String timestamp,
                                                    String consumerKey,
                                                    String oauthSignature){
        JSONObject returnValue = null as JSONObject
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        String combinedHeader = """
oauth_callback="${callback}",
oauth_consumer_key="${consumerKey}",
oauth_nonce="${nonce}",
oauth_signature_method="HMAC-SHA1",
oauth_timestamp="${timestamp}",

oauth_signature="${oauthSignature}", oauth_version="1.0"
""".toString()
        combinedHeader = combinedHeader.replaceAll(/\s*/, '')
        try {
            response  = rest.post(targetUrl)   {
                contentType "application/x-www-form-urlencoded"
                header "OAuth",   combinedHeader

            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}"
            afterCall  = new Date()
        }
        logStatus << """
SERVER CALL:
url=${targetUrl},
parm=${drivingContents},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.json
            logStatus << """status: ok""".toString()
        }  else {
            JSONObject tempValue =  response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if  (tempValue)  {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            }  else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }



    private JSONObject requestTwitterAppAuthentication(String targetUrl,
                                                       String clientId,String clientSecret){
        JSONObject returnValue = null as JSONObject
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        MultiValueMap<String, String> form = new LinkedMultiValueMap<String, String>()
        StringBuilder logStatus = new StringBuilder()
        form.add("grant_type","client_credentials")
        try {
            response  = rest.post(targetUrl)   {
                contentType "application/x-www-form-urlencoded"
                auth(clientId, clientSecret)
                body (form)
            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}"
            afterCall  = new Date()
        }
        logStatus << """
SERVER CALL:
url=${targetUrl},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.json
            logStatus << """status: ok""".toString()
        }  else {
            JSONObject tempValue =  response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if  (tempValue)  {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            }  else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }




    private JSONObject searchTwitter(String targetUrl,String accessToken,String queryText){
        JSONObject returnValue = null as JSONObject
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        MultiValueMap<String, String> form = new LinkedMultiValueMap<String, String>()
        StringBuilder logStatus = new StringBuilder()
        String codedAccessToken  =  accessToken
        try {
            response  = rest.get(targetUrl+ "?"+queryText)   {
                contentType "application/x-www-form-urlencoded"
                header 'Authorization', "Bearer $codedAccessToken"
                body (form)
            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}"
            afterCall  = new Date()
        }
        logStatus << """
SERVER CALL:
url=${targetUrl},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.json
            logStatus << """status: ok""".toString()
        }  else {
            JSONObject tempValue =  response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if  (tempValue)  {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            }  else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }




//    private String  twitterSignatureGenerator(){
//      String key = grailsApplication.config.auth.providers.twitter.key
//      String secret = grailsApplication.config.auth.providers.twitter.secret
//      String combo = "${key}:${secret}"
//      return combo.bytes.encodeBase64().toString()
//  }

    public JSONObject generateTwitterAuthenticationString () {
        int authSeconds = (int)(new Date().getTime()/1000);
        int nonce = (int)(new Date().getTime()/10);
        // JSONObject response = requestTwitterAppAuthentication  ("https://api.twitter.com/oauth2/token",  twitterSignatureGenerator())
        JSONObject response = requestTwitterAppAuthentication  ("https://api.twitter.com/oauth2/token",  grailsApplication.config.auth.providers.twitter.key, grailsApplication.config.auth.providers.twitter.secret)
//         JSONObject response = requestTwitterAuthentication  ("https://api.twitter.com/oauth2/request_token",
//                nonce.toString(),
//                URLEncoder.encode(grailsApplication.config.auth.providers.twitter.callback , "UTF-8"),
//                authSeconds.toString(),
//                grailsApplication.config.auth.providers.twitter.key,
//                grailsApplication.config.auth.providers.twitter.secret
//        )

        return response
    }


    public JSONObject executeTwitterRequest (String accessToken,String queryText) {
//        int authSeconds = (int)(new Date().getTime()/1000);
//        int nonce = (int)(new Date().getTime()/10);
        JSONObject response = searchTwitter("https://api.twitter.com/1.1/search/tweets.json", accessToken, queryText)
//         JSONObject response = requestTwitterAuthentication  ("https://api.twitter.com/oauth2/request_token",
//                nonce.toString(),
//                URLEncoder.encode(grailsApplication.config.auth.providers.twitter.callback , "UTF-8"),
//                authSeconds.toString(),
//                grailsApplication.config.auth.providers.twitter.key,
//                grailsApplication.config.auth.providers.twitter.secret
//        )

        return response
    }






}
