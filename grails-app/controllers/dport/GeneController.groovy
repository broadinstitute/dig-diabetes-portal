package dport


class GeneController {
    GeneManagementService geneManagementService
    def index() {
        String attemptedMatcher = params.q
        String partialMatches = geneManagementService.deliverPartialMatchesInJson(params.query,20)
        String tester = "number of matches =${partialMatches} for string =${attemptedMatcher}"
        render ("<html><body><h1>${tester}<h1><body></html>")
    }
}
