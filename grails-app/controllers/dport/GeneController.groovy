package dport

import grails.plugin.springsecurity.annotation.Secured
import org.codehaus.groovy.grails.web.json.JSONObject

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService

    /***
     * return partial matches as Json for the purposes of the twitter typeahead handler
     * @return
     */
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,20)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }


    /***
     * display all information about a gene. This call displays only the core of the page -- the data all come back
     * with the Jace on
     * @return
     */
    def geneInfo() {
        String geneToStartWith = params.id
        if (geneToStartWith)  {
            String geneUpperCase =   geneToStartWith.toUpperCase()
            String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()
            render (view: 'geneInfo', model:[show_gwas:sharedToolsService.sectionsToDisplay.show_gwas,
                                             show_exchp:sharedToolsService.sectionsToDisplay.show_exchp,
                                             show_exseq:sharedToolsService.sectionsToDisplay.show_exseq,
                                             show_sigma:sharedToolsService.sectionsToDisplay.show_sigma,
                                             geneName:geneUpperCase,
                                             phenotypeList:encodedString,
            ] )
        }
     }

    /***
     *
     * @return
     */
    def geneInfoAjax() {
        String geneToStartWith = params.geneName
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim().toUpperCase())
            render(status:200, contentType:"application/json") {
                [geneInfo:jsonObject['gene-info']]
            }

        }
    }


}
