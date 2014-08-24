package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantController {
    RestServerService   restServerService
    FilterManagementService filterManagementService

    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String variantToStartWith = params.id
        if (variantToStartWith) {
            render (view: 'variantInfo',
                    model:[variantToSearch: variantToStartWith.trim(),
                           show_gwas:1,
                           show_exchp: 1,
                           show_exseq: 1,
                           show_sigma: 0] )

        }
   }

    /***
     * provide  a nice collection of information about a single variant. This is the Ajax call associated with variantInfo
     * @return
     */
    def variantAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variant-info']]
            }

        }
    }





}
