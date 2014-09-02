package dport
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {
    FilterManagementService filterManagementService
    RestServerService restServerService
    SharedToolsService sharedToolsService

    def index() {}

    /***
     * set up the search page. There may or may not be parameters, but there is no immediate follow-up Ajax call
     * encParams can be null (in which case we take on the default values in the search page) or else they can
     * tell us what the last known form values were "1:3,23:0"
     * @return
     */
    def variantSearch() {
        String encParams
        if (params.encParams) {
            encParams = params.encParams
            //String param1AfterDecoding = URLDecoder.decode(encParams, "UTF-8");
            println("params.encParams = ${params.encParams}")
            //println("params.encParams2 = ${param1AfterDecoding}")
        }
        render(view: 'variantSearch',
                model: [show_gwas : 1,
                        show_exchp: 1,
                        show_exseq: 1,
                        show_sigma: 0,
                        encParams : encParams])

    }

    /***
     * User has posted a search request.  The search was made through a traditional form (the GO button on the variant search page).
     * A service then laboriously parses the request, thereby generating filters which we can pass to the backend. The associated Ajax
     * retrieval for this call is -->  variantSearchAjax
     * @return
     */
    def variantSearchRequest() {
        //String receivedParameters = request.parameters.toString()
        //String receivedParameters = params.toString();
        Map paramsMap = new HashMap()

        params.each { key, value ->
            paramsMap.put(key, value)
        }
        if (paramsMap) {
            displayVariantSearchResults(paramsMap, false)
        }

    }


    def gene() {
        String geneId = params.id
        String receivedParameters = params.filter

        Map paramsMap = filterManagementService.storeParametersInHashmap (geneId,"","","",receivedParameters)

        if (paramsMap) {
            displayVariantSearchResults(paramsMap, false)
        }

//        if (geneId) {
//            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.constructGeneSearch(geneId, receivedParameters)
//            if (parsedFilterParameters) {
//
//                String enc = sharedToolsService.packageUpFiltersForRoundTrip(parsedFilterParameters.filters)
//                String encodedParameters = sharedToolsService.packageUpEncodedParameters(parsedFilterParameters.parameterEncoding)
//                String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
//
//                render(view: 'variantSearchResults',
//                        model: [show_gene           : 1,
//                                show_gwas           : 1,
//                                show_exchp          : 1,
//                                show_exseq          : 1,
//                                show_sigma          : 0,
//                                filter              : enc,
//                                filterDescriptions  : parsedFilterParameters.filterDescriptions,
//                                proteinEffectsList  : encodedProteinEffects,
//                                encodedParameters   : encodedParameters,
//                                dataSetDetermination: 1])
//            }
//        }


    }


    def geneWide() {
        String geneId = params.id
        String significance = params.sig
        String dataset = params.dataset
        String region = params.region

        Map paramsMap = filterManagementService.storeParametersInHashmap (geneId,significance,dataset,region,"")

        if (paramsMap) {
            displayVariantSearchResults(paramsMap, false)
        }


//        if (geneId) {
//            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.constructGeneWideSearch(geneId, significance, dataset, region)
//            if (parsedFilterParameters) {
//
//                String enc = sharedToolsService.packageUpFiltersForRoundTrip(parsedFilterParameters.filters)
//                String encodedParameters = sharedToolsService.packageUpEncodedParameters(parsedFilterParameters.parameterEncoding)
//                String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
//                render(view: 'variantSearchResults',
//                        model: [show_gene           : 1,
//                                show_gwas           : 1,
//                                show_exchp          : 1,
//                                show_exseq          : 1,
//                                show_sigma          : 0,
//                                filter              : enc,
//                                filterDescriptions  : parsedFilterParameters.filterDescriptions,
//                                proteinEffectsList  : encodedProteinEffects,
//                                encodedParameters   : encodedParameters,
//                                dataSetDetermination: 1])
//            }
//        }


    }

    /***
     * a variant display table is on screen and the page is now asking for data. Perform the search.  This call retrieves the data
     * for the original page format call -> variantSearchRequest
     * @return
     */
    def variantSearchAjax() {
        // String filters=params.getRequest().parameters.keySet()[0]
        String filtersRaw = params['keys']
        String filters = URLDecoder.decode(filtersRaw)
        println(filters);
        JSONObject jsonObject = restServerService.searchGenomicRegionByCustomFilters(filters)
        render(status: 200, contentType: "application/json") {
            [variants: jsonObject['variants']]
        }
    }


    private void displayVariantSearchResults(HashMap paramsMap, boolean currentlySigma) {
        LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.parseVariantSearchParameters(paramsMap, currentlySigma)
        if (parsedFilterParameters) {

            Integer dataSetDetermination = filterManagementService.distinguishBetweenDataSets(paramsMap)
            String encodedFilters = sharedToolsService.packageUpFiltersForRoundTrip(parsedFilterParameters.filters)
            String encodedParameters = sharedToolsService.packageUpEncodedParameters(parsedFilterParameters.parameterEncoding)
            String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()

            render(view: 'variantSearchResults',
                    model: [show_gene           : 1,
                            show_gwas           : 1,
                            show_exchp          : 1,
                            show_exseq          : 1,
                            show_sigma          : 0,
                            filter              : encodedFilters,
                            filterDescriptions  : parsedFilterParameters.filterDescriptions,
                            proteinEffectsList  : encodedProteinEffects,
                            encodedParameters   : encodedParameters,
                            dataSetDetermination: dataSetDetermination])
        }
    }


}