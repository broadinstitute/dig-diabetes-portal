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
            String encParams
            if (params.encParams){
                 encParams =  params.encParams
                //String param1AfterDecoding = URLDecoder.decode(encParams, "UTF-8");
                println("params.encParams = ${params.encParams}")
                //println("params.encParams2 = ${param1AfterDecoding}")
            }
                render (view: 'variantSearch',
                        model:[show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0,
                               encParams:encParams] )

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
                String encodedFilters = java.net.URLEncoder.encode(sb.toString())

                // we need to  encode the list of parameters so that we can reset them when we reenter
                //  the filter setting form.  It is certainly true that this is a different form of the
                //  same information that is held in BOTH the filter list and the filterDescription
                //  list.  This one could be passed from a different page, however, so we really want
                //  a simple, unambiguous way to store it and pass it around
                List <String> listOfAllEncodedParameters = parsedFilterParameters.parameterEncoding
                StringBuilder sbEncoded = new  StringBuilder()
                for ( int i=0 ; i<listOfAllEncodedParameters.size() ; i++ ) {
                    sbEncoded <<  listOfAllEncodedParameters[i]
                    if ((i+1)<listOfAllEncodedParameters.size()) {
                        sbEncoded << ","
                    }
                }
                //String encodedParameters = java.net.URLEncoder.encode(sbEncoded.toString())
                String encodedParameters = sbEncoded.toString()



                String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
                render (view: 'variantSearchResults',
                        model:[show_gene: 1,
                               show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0,
                               filter: encodedFilters,
                               filterDescriptions: parsedFilterParameters.filterDescriptions,
                               proteinEffectsList:encodedProteinEffects,
                               encodedParameters:encodedParameters,
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



                // we need to  encode the list of parameters so that we can reset them when we reenter
                //  the filter setting form.  It is certainly true that this is a different form of the
                //  same information that is held in BOTH the filter list and the filterDescription
                //  list.  This one could be passed from a different page, however, so we really want
                //  a simple, unambiguous way to store it and pass it around
                List <String> listOfAllEncodedParameters = parsedFilterParameters.parameterEncoding
                StringBuilder sbEncoded = new  StringBuilder()
                for ( int i=0 ; i<listOfAllEncodedParameters.size() ; i++ ) {
                    sbEncoded <<  listOfAllEncodedParameters[i]
                    if ((i+1)<listOfAllEncodedParameters.size()) {
                        sbEncoded << ","
                    }
                }
                //String encodedParameters = java.net.URLEncoder.encode(sbEncoded.toString())
                String encodedParameters = sbEncoded.toString()

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
                               encodedParameters:encodedParameters,
                               dataSetDetermination:1] )
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
