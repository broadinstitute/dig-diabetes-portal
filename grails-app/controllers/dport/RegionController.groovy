package dport

import grails.plugin.springsecurity.annotation.Secured
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {
    private static final log = LogFactory.getLog(this)
    RestServerService   restServerService
    SharedToolsService sharedToolsService

    @Secured (['ROLE_USER','IS_AUTHENTICATED_FULLY'])
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
                List<Gene>  geneList = Gene.findAllByChromosome("chr"+chromosomeNumber)
                for ( Gene gene in geneList) {
                    if (((gene.addrStart>startExtent) &&(gene.addrStart<endExtent)) ||
                            ((gene.addrEnd>startExtent) &&(gene.addrEnd<endExtent))) {
                        identifiedGenes << gene
                    }

                }
            }

        }


        List<String> geneNamesToDisplay = []
        for ( Gene gene in identifiedGenes) {
            geneNamesToDisplay <<  gene.name1
        }
        String encodedProteinEffects = sharedToolsService.urlEncodedListOfProteinEffect()
        render (view: 'regionInfo',
                model:[regionSpecification: regionSpecification,
                       show_gene:1,
                       show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0,
                       proteinEffectsList:encodedProteinEffects,
                       geneNamesToDisplay:geneNamesToDisplay
                ] )
    }

    def regionAjax() {
        String regionsSpecification = params.id
        if (regionsSpecification)  {
            JSONObject jsonObject =  restServerService.searchGenomicRegionAsSpecifiedByUsers (regionsSpecification)
            render(status:200, contentType:"application/json") {
                [variants:jsonObject['variants']]
            }
        }
     }

}
