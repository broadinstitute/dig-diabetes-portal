package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService

    // return partial matches as Json for the purposes of the twitter typeahead handler
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,20)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }

    def geneInfo() {
        String geneToStartWith = params.id
        JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith)
        render (view: 'geneInfo', model:[gene_info:jsonObject['gene-info'],
                                         show_gwas:1,
                                         show_exchp: 1,
                                         show_exseq: 1,
                                         show_sigma: 0] )
    }


}
