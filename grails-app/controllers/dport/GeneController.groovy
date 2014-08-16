package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService

    // return partial matches as Json for the purposes of the twitter typeahead handler
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,20)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }

    def geneInfo() {
        String geneToStartWith = params.id
        if (geneToStartWith)  {
            String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()
            render (view: 'geneInfo', model:[show_gwas:1,
                                             show_exchp: 1,
                                             show_exseq: 1,
                                             show_sigma: 0,
                                             geneName:geneToStartWith,
                                             phenotypeList:encodedString,
            ] )
        }
     }

    def geneAjax() {
        String geneToStartWith = params.id
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variant-info']]
            }

        }
    }
    def geneInfoAjax() {
        String geneToStartWith = params.geneName
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [geneInfo:jsonObject['gene-info']]
            }

        }
    }


}
