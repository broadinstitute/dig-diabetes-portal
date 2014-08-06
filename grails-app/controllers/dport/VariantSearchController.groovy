package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {
        FilterManagementService filterManagementService
        RestServerService   restServerService

        def index() { }


        def variantSearch() {
                render (view: 'variantSearch',
                        model:[show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0] )

        }



    def variantSearchRequest() {
        println "variant post received"
        String receivedParameters = request.parameters.toString()
        if (receivedParameters)    {
            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.parseVariantSearchParameters(request.parameters,false)
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
            }  else {
                render("<h1> I heard you, but no valid JSON</h1>")
            }
        }


    }
    def variantSearchAjax() {
        String filters=params.getRequest().parameters.keySet()[0]
        println(filters);
        JSONObject jsonObject =  restServerService.searchGenomicRegionByCustomFilters(filters)
        render(status:200, contentType:"application/json") {
            [variants:jsonObject['variants']]
        }
    }



}
