package dport

import grails.transaction.Transactional
import  grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {

    def hitService() {
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        def resp = rest.get("http://grails.org/api/v1.0/plugin/acegi/")
       println resp.toString ()
    }

   String getServiceBody (String url) {
       String returnValue = ""
       RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
       RestResponse response = rest.get(url)
       if (response.getStatus () == 200)  {
           returnValue =  response.getBody()
       }
       return returnValue
   }


    JSONObject getServiceJson (String url) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.get(url)
        returnValue =  response.json
        return returnValue
    }


    JSONObject postServiceJson (String url,
                                String jsonString) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.post(url)   {
            contentType "application/json"
            json jsonString
        }
        returnValue =  response.json
        return returnValue
    }




}
