package dport


class GeneController {

    GeneManagementService geneManagementService

    // return partial matches as Json for the purposes of the twitter typeahead handler
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,20)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }
}
