package org.broadinstitute.mpg

import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {
    MetaDataService metaDataService
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
            List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(metaDataService?.getDefaultPhenotype(),
                    'GWAS',metaDataService.getDataVersion(),'') // try to get a GWAS result
            if (sampleGroupList.size()==0){
                sampleGroupList = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(metaDataService?.getDefaultPhenotype(),
                        '',metaDataService.getDataVersion(),'') // if no GWAS then take whatever we can get
            }
            List<SampleGroup> orderedSampleGroupList = sampleGroupList.sort{ it.subjectsNumber }
            SampleGroup preferredSampleGroup = orderedSampleGroupList?.last()

            if ((!encounteredErrors)&&(sampleGroupList.size()>0)){
                // Grails/Groovy does not seem to play nicely with JSON
                ArrayList<String> query = [
                    ([
                        prop: 'chromosome',
                        value: extractedNumbers['chromosomeNumber'] + ':' + startExtent + '-' + endExtent,
                        comparator: '='
                    ] as JSONObject).toString(),
                    ([
                        phenotype: metaDataService?.getDefaultPhenotype(),
                        dataset: preferredSampleGroup.systemId,
                        prop: 'P_VALUE',
                        value: '1',
                        comparator:'<'
                    ] as JSONObject).toString()
                ]

                String encodedQuery = URLEncoder.encode(query.toString())
                redirect(url:'/variantSearch/launchAVariantSearch/?filters=' + encodedQuery)
                return
            }

        }

        redirect(controller: 'home', action: 'portalHome') //   We should never get here, but in case the previous parsing fails
        return
    }


}
