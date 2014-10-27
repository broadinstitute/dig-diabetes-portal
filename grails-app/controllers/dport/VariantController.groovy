package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantController {
    RestServerService   restServerService
    FilterManagementService filterManagementService
    SharedToolsService sharedToolsService

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
                           show_gwas:sharedToolsService.sectionsToDisplay.show_gwas,
                           show_exchp:sharedToolsService.sectionsToDisplay.show_exchp,
                           show_exseq:sharedToolsService.sectionsToDisplay.show_exseq,
                           show_sigma:sharedToolsService.sectionsToDisplay.show_sigma] )

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
