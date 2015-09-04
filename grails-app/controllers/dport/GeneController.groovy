package dport

import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.BurdenService
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService
    BurdenService burdenService

    /***
     * return partial matches as Json for the purposes of the twitter typeahead handler
     * @return
     */
    def index() {
        String partialMatches = geneManagementService.partialGeneMatchesUsingStringLists(params.query,27)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }
    def geneOnlyTypeAhead() {
        String partialMatches = geneManagementService.partialGeneOnlyMatches(params.query,27)
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
                                             geneName:geneUpperCase,
                                             geneExtentBegin:geneExtent.startExtent,
                                             geneExtentEnd:geneExtent.endExtent,
                                             geneChromosome:geneExtent.chrom,
                                             phenotypeList:encodedString
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

        // KDUXTD-99: check to see if dbSnpId provided so that it gets past search box filter
        if (sharedToolsService.getRecognizedStringsOnly()!=0) {
            // once we have the variant database complete we can use this
            String inputString = params.id
            if (sqlService?.isDbSnpIdString(inputString)) {
                // search for the variant by dbSnpId and if found, return; if not found, drop down to below test (just in case for now)
                Variant variant = Variant.findByDbSnpId(inputString)
                if (variant) {
                    redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                    return
                }
            }
        }

        // Is our string a variant?  Build an identifying string and test
        String canonicalVariant = sharedToolsService.createCanonicalVariantName(params.id)
        if (sharedToolsService.getRecognizedStringsOnly()!=0){ // once we have the variant database complete we can use this
            Variant variant = Variant.retrieveVariant(canonicalVariant)
            if (variant) {
                redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                return
            } else {
                redirect(controller: 'home', action: 'portalHome', params: [id: params.id])
                return
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

    def burdenTestExample() {
        String gene="SLC30A8";
        int mostDelScore = 4;
        String sampleGroup = "ExSeq_17k_mdv2";
        log.info("got params: " + params);

        if (params.gene) {
            gene = params.gene;
        }

        if (params.mostDelScore) {
            mostDelScore = Integer.parseInt(params.mostDelScore);
        }

        // call the service
        JSONObject burdenJson = this.burdenService.callBurdenTest(sampleGroup, gene, mostDelScore);

        // send json response back
        render(status: 200, contentType: "application/json") {burdenJson}
    }


    def burdenTestAjax() {
        // log parameters received
        // Here are some example parameters, as they show up in the params variable
        // params.filterNum=="2" // value=id from burdenTestVariantSelectionOptionsAjax, or 0 if no selection was made (which is a legal choice)
        // params.dataSet=="1" // where 1->13k, 2->26k"
        // params.geneName=="SLC30A8" // string representing gene name
        log.info("got parameters: " + params);

        // cast the parameters
        String geneName = params.geneName;
        int variantFilterOptionId = (params.filterNum ? Integer.valueOf(params.filterNum) : 0);     // default to all variants if none given
        int datasetOptionId = (params.dataSet ? Integer.valueOf(params.dataSet) : 1);               // default ot 1 if none given

        // create dummy string for dummy call, for now
        // TODO - DIGP-78: implement call when back end service ready
//        String resultString = "{\"is_error\": false, \"oddsRatio\": \"1.0138318997464533\", \"pValue\": \"0.4437344659074216\"}";
        // create the json object
//        def slurper = new JsonSlurper()
 //       def result = slurper.parseText(resultString)
//        def result = slurper.parseText(this.metaDataService.getSearchablePropertyNameListAsJson(datasetChoice))

        JSONObject result = this.burdenService.callBurdenTest(datasetOptionId, geneName, variantFilterOptionId);

        // send json response back
        render(status: 200, contentType: "application/json") {result}
    }

    def burdenTestVariantSelectionOptionsAjax() {
        JSONObject jsonObject = this.burdenService.getBurdenVariantSelectionOptions()

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

}
