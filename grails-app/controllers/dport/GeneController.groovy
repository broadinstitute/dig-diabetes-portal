package dport

import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)


    /***
     * return partial matches as Json for the purposes of the twitter typeahead handler
     * @return
     */
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,27)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }


    /***
     * display all information about a gene. This call displays only the core of the page -- the data all come back
     * with the Jace on
     * @return
     */
    def geneInfo() {
        String geneToStartWith = params.id
        def locale = RequestContextUtils.getLocale(request)
        if (geneToStartWith)  {
            String  geneUpperCase =   geneToStartWith.toUpperCase()
            LinkedHashMap geneExtent = sharedToolsService.getGeneExpandedExtent(geneToStartWith)
            String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()
            render (view: 'geneInfo', model:[show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                             show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                             show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                             show_sigma:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma),
                                             geneName:geneUpperCase,
                                             geneExtentBegin:geneExtent.startExtent,
                                             geneExtentEnd:geneExtent.endExtent,
                                             geneChromosome:geneExtent.chrom,
                                             phenotypeList:encodedString,
                                             newApi:sharedToolsService.getNewApi()
            ] )
        }
     }

    /***
     * we've been asked to search, but we don't know what kind of string. Here is how we can figure it out:
     */
    def findTheRightDataPage () {
        String uncharacterizedString = params.id
        // Is our string a region?
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(uncharacterizedString)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            redirect(controller:'region',action:'regionInfo', params: [id: params.id])
            return
        }
        // It's not a region.  Is our string a gene?
        String possibleGene = params.id
        if (possibleGene){
            possibleGene = possibleGene.trim().toUpperCase()
        }
        Gene gene = Gene.retrieveGene(possibleGene)
        if (gene){
            redirect(controller:'gene',action:'geneInfo', params: [id: params.id])
            return
        }
        // Is our string a variant?  Build an identifying string and test
        String canonicalVariant = sharedToolsService.createCanonicalVariantName(params.id)
        if (false){ // once we have the variant database complete we can use this
            Variant variant = Variant.retrieveVariant(canonicalVariant)
            if (variant) {
                redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                return
            } else {
                redirect(controller: 'home', action: 'portalHome', params: [id: params.id])
            }
        } else {// for now we don't have to verify of variant's existence
            redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: canonicalVariant])
            return
        }
        // this is an error condition -- we should never get here in the code
        log.error("why did we never finish parsing '${uncharacterizedString}'?")
        redirect(controller: 'home', action: 'portalHome', params: [id: params.id])
       return
    }



    def geneInfoCounts() {
        String geneToStartWith = params.geneName
        String pValue = params.pValue
        String dataSet = params.dataSet
        if ((geneToStartWith) && (pValue) && (dataSet))      {
            BigDecimal pValNumber
            Integer dataSetInteger
            try {
                pValNumber = new BigDecimal(pValue);
            }catch (Exception e){
                log.error("ERROR: invalid P value = '${pValue}")
            }
            try {
                dataSetInteger = new Integer(dataSet);
            }catch (Exception e){
                log.error("ERROR: invalid P value = '${dataSet}")
            }
            JSONObject jsonObject =  restServerService.variantCountByGeneNameAndPValue ( geneToStartWith.trim().toUpperCase(),
                                                                                         pValNumber,
                                                                                         dataSetInteger )
            render(status:200, contentType:"application/json") {
                [geneInfo:jsonObject]
            }

        }
    }


    def genepValueCounts() {
        String geneToStartWith = params.geneName
        JSONObject jsonObject =  restServerService.combinedVariantCountByGeneNameAndPValue ( geneToStartWith.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [geneInfo:jsonObject]
        }
    }





    def geneEthnicityCounts (){
        String geneToStartWith = params.geneName
        JSONObject jsonObject =  restServerService.combinedEthnicityTable ( geneToStartWith.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [ethnicityInfo:jsonObject]
        }
    }


        /***
     *
     * @return
     */
    def geneInfoAjax() {
        String geneToStartWith = params.geneName
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim().toUpperCase())
            render(status:200, contentType:"application/json") {
                [geneInfo:jsonObject['gene-info']]
            }

        }
    }


}
