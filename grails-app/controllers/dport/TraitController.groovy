package dport

import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class TraitController {
    RestServerService restServerService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)


    /***
     * create page frame for association statistics across 25 traits for a single variant. The resulting Ajax call is  ajaxTraitsPerVariant
     * @return
     */
     def traitInfo (){
          String variantIdentifier = params.getIdentifier()
         String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()

         render (view: 'traitsPerVariant',
                 model:[show_gwas:1,
                        show_exchp: 1,
                        show_exseq: 1,
                        show_sigma: 0,
                        show_gene: 1,
                        variantIdentifier:variantIdentifier,
                        phenotypeList:encodedString] )
     }

    /***
     *  search for a single trait from the main page and this will be the page frame.  The resulting Ajax call is  phenotypeAjax
     * @return
     */
    def traitSearch() {
        String phenotypeKey=params.trait
        String requestedSignificance=params.significance
        String phenotypeName = ''
        String phenotypeDataSet = ''
        Phenotype phenotype = Phenotype.findByDatabaseKey(phenotypeKey)
        if (phenotype)  {
            phenotypeName =  phenotype.name
            phenotypeDataSet = phenotype.dataSet
        }
        render (view: 'phenotype',
                model:[show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0,
                       show_gene: 1,
                       phenotypeKey:phenotypeKey,
                       phenotypeName:phenotypeName,
                       phenotypeDataSet:phenotypeDataSet,
                       requestedSignificance:requestedSignificance] )

    }

    /***
     * This Ajax call is launched from the traitSearch page frame
     * @return
     */
     def phenotypeAjax() {
            String significance = params["significance"]
            String phenotypicTrait  = params["trait"]
            BigDecimal significanceValue
            try {
                significanceValue = new BigDecimal(significance)
            } catch (NumberFormatException nfe)  {
                log.info("USER ERROR: User supplied a nonnumeric significance value = '${significance}")
                // TODO: error condition.  Go with GWAS significance
                significanceValue = 0.00000005
            }
            JSONObject jsonObject = restServerService.searchTraitByName(phenotypicTrait,significanceValue)
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variants']]
            }

    }



    def genomeBrowser ()  {
        String geneName = params.id
        render (view: 'genomeBrowser',
                model:[geneName:geneName] )
    }



    /***
     * Returns association statistics across 25 traits for a single variant.  The launching page is traitInfo
     * @return
     */
    def ajaxTraitsPerVariant()  {
        String variant = params["variantIdentifier"]
        JSONObject jsonObject = restServerService.retrieveTraitInfoByVariant(variant)
        render(status:200, contentType:"application/json") {
            [traitInfo:jsonObject['trait-info']]
        }

    }

    /***
     * get here from 'SEE P  values and other statistics across 25 traits' on the gene info page. Associated Ajax call is traitVariantCrossAjax
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id
        String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()
        render (view: 'traitVariantCross',
                model:[regionSpecification: regionSpecification,
                       phenotypeList:encodedString,
                       show_gene:1,
                       show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0] )
    }

    /***
     *
     * @return
     */
    def traitVariantCrossAjax() {
        String regionsSpecification = params.id

        JSONObject jsonObject =  restServerService.searchTraitByUnparsedRegion (regionsSpecification)
        if (jsonObject) {
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }
        } else {
            render(status:300, contentType:"application/json")
        }

     }



}
