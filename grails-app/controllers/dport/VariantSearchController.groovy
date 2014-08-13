package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {
        FilterManagementService filterManagementService
        RestServerService   restServerService
        SharedToolsService sharedToolsService

        def index() { }

    /***
     * allow user to specify variant search parameters
     * @return
     */
        def variantSearch() {
                render (view: 'variantSearch',
                        model:[show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0] )

        }

    /***
     * User has posted a search request.  The search was made through a traditional form, so this routine calls a service
     * that goes through and laboriously parses the request, thereby generating filters which we can pass to the backend
     * @return
     */
    def variantSearchRequest() {
        String receivedParameters = request.parameters.toString()
        if (receivedParameters)    {
            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.parseVariantSearchParameters(request.parameters,false)
            if  (parsedFilterParameters)  {

                Integer dataSetDetermination = filterManagementService.distinguishBetweenDataSets ( request.parameters )

                // get back a list of filters that we need to pass to the backend. We package them up for a round trip to the client
                // and back via the Ajax call
                List <String> listOfAllFilters = parsedFilterParameters.filters
                StringBuilder sb = new  StringBuilder()
                for ( int i=0 ; i<listOfAllFilters.size() ; i++ ) {
                    sb <<  listOfAllFilters[i]
                    if ((i+1)<listOfAllFilters.size()) {
                        sb << ","
                    }
                }
                String enc = java.net.URLEncoder.encode(sb.toString())


                String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
                render (view: 'variantSearchResults',
                        model:[show_gene: 1,
                               show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0,
                               filter: enc,
                               filterDescriptions: parsedFilterParameters.filterDescriptions,
                               proteinEffectsList:encodedProteinEffects,
                               dataSetDetermination:dataSetDetermination] )
            }
        }

    }



    def gene() {
        String geneId = params.id
        String receivedParameters = params.filter
        if (geneId)    {
            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.constructGeneSearch(geneId,receivedParameters)
            if  (parsedFilterParameters)  {
                List <String> listOfAllFilters = parsedFilterParameters.filters
                StringBuilder sb = new  StringBuilder()


                for ( int i=0 ; i<listOfAllFilters.size() ; i++ ) {
                    sb <<  listOfAllFilters[i]
                    if ((i+1)<listOfAllFilters.size()) {
                        sb << ","
                    }
                }
                String enc = java.net.URLEncoder.encode(sb.toString())
                render (view: 'variantSearchResults',
                        model:[show_gene: 1,
                               show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0,
                               filter: enc,
                               filterDescriptions: parsedFilterParameters.filterDescriptions] )
            }
        }


    }



        /***
     * a variant display table is on screen and the page is now asking for data. Perform the search.
     * @return
     */
    def variantSearchAjax() {
        String filters=params.getRequest().parameters.keySet()[0]
        println(filters);
        JSONObject jsonObject =  restServerService.searchGenomicRegionByCustomFilters(filters)
        render(status:200, contentType:"application/json") {
            [variants:jsonObject['variants']]
        }
    }



}
