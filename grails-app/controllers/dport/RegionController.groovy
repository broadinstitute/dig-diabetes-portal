package dport

import grails.plugin.springsecurity.annotation.Secured
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {
    private static final log = LogFactory.getLog(this)
    RestServerService   restServerService
    SharedToolsService sharedToolsService

    def regionInfo() {
        String regionSpecification = params.id
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(regionSpecification)
        List <Gene> identifiedGenes = []
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            String startExtentString = extractedNumbers["startExtent"]
            String endExtentString = extractedNumbers["endExtent"]
            String chromosomeNumber = extractedNumbers["chromosomeNumber"]
            Long  startExtent
            Long  endExtent
            boolean encounteredErrors = false
            try {
                startExtent = Long.parseLong(startExtentString)
            } catch (NumberFormatException nfe) {
                encounteredErrors = true
                log.info("RegionController.regionInfo: User supplied nonnumeric start extent= ${startExtentString}")
            }
            try {
                endExtent = Long.parseLong(endExtentString)
            } catch (NumberFormatException nfe) {
                encounteredErrors = true
                log.info("RegionController.regionInfo: User supplied nonnumeric start extent= ${endExtentString}")
            }
            if (!encounteredErrors){
                String searchParms = "8=${chromosomeNumber}^9=${startExtent}^10=${endExtent}^11=all-effects^17=T2D[GWAS_DIAGRAM_mdv2]P_VALUE<1^".toString()
                redirect(controller:'variantSearch',action:'launchAVariantSearch', params: [savedValue0: searchParms])
                return
            }

        }

        redirect(controller: 'home', action: 'portalHome') //   We should never get here, but in case the previous parsing fails
    }


}
