package org.broadinstitute.mpg

import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {

    RestServerService   restServerService
    SharedToolsService sharedToolsService

    /***
     * This is where we go to process a region.
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(regionSpecification)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            boolean encounteredErrors = false
            Long  startExtent  = sharedToolsService.convertRegionString(extractedNumbers["startExtent"])
            Long  endExtent  = sharedToolsService.convertRegionString(extractedNumbers["endExtent"])
            if ((startExtent<0) ||(endExtent<0)) {
                encounteredErrors = true
            }
            if (!encounteredErrors){
                // Grails/Groovy does not seem to play nicely with JSON
                ArrayList<String> query = [
                    ([
                        prop: 'chromosome',
                        value: extractedNumbers['chromosomeNumber'] + ':' + startExtent + '-' + endExtent,
                        comparator: '='
                    ] as JSONObject).toString(),
                    ([
                        phenotype: 'T2D',
                        dataset: 'GWAS_DIAGRAM_mdv2',
                        prop: 'P_VALUE',
                        value: '1',
                        comparator:'<'
                    ] as JSONObject).toString()
                ]

                String encodedQuery = URLEncoder.encode(query.toString())
                redirect(url:'/variantSearch/launchAVariantSearch/?' + encodedQuery)
                return
            }

        }

        redirect(controller: 'home', action: 'portalHome') //   We should never get here, but in case the previous parsing fails
        return
    }


}
