package dport

import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class DataPassController {

    private static final log = LogFactory.getLog(this)
    RestServerService restServerService
    def index() {
         log.error ">>>>> The default routine for DataPassController should never be called  <<<<<"
     }



    def dataPassThrough() {
        String incomingJson = params.incomingJson
        if (incomingJson)      {
            JSONObject jsonObject =  restServerService.postGetDataCall(incomingJson)
            render(status:200, contentType:"application/json") {
                [jsonObject:jsonObject]
            }

        }
    }




}
