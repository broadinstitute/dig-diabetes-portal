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

         render(view: 'traitsPerVariant',
                 model: [show_gwas        : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                         show_exchp       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                         show_exseq       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                         show_gene        : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                         variantIdentifier: variantIdentifier,
                         phenotypeList    : encodedString])
     }

    /***
     *  search for a single trait from the main page and this will be the page frame.  The resulting Ajax call is  phenotypeAjax
     * @return
     */
    def traitSearch() {
        String phenotypeKey=sharedToolsService.convertOldPhenotypeStringsToNewOnes (params.trait)
        String requestedSignificance=params.significance
        LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()
        LinkedHashMap phenotypeMap = processedMetadata.gwasSpecificPhenotypes
        String sampleGroupOwner = ""
        if (phenotypeMap.containsKey(phenotypeKey))  {
            sampleGroupOwner  = phenotypeMap[phenotypeKey]?.sampleGroupName
        }
        String phenotypeName = ''
        String phenotypeDataSet = ''
        String phenotypeTranslation = sharedToolsService.translator(phenotypeKey)
        phenotypeName =  phenotypeTranslation
        phenotypeDataSet = ""

        render(view: 'phenotype',
                model: [show_gwas            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_gene            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        phenotypeKey         : phenotypeKey,
                        phenotypeName        : phenotypeName,
                        phenotypeDataSet     : phenotypeDataSet,
                        sampleGroupOwner     : sampleGroupOwner,
                        requestedSignificance: requestedSignificance])

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
         LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()
         LinkedHashMap phenotypeMap = processedMetadata.gwasSpecificPhenotypes
         String dataSetName
         LinkedHashMap properties
         if (phenotypeMap.containsKey(phenotypicTrait)){
             LinkedHashMap traitHolderMap = phenotypeMap[phenotypicTrait]
             dataSetName = traitHolderMap.sampleGroupId
             properties = traitHolderMap.properties
         } else  {
             log.info("Unknown GWAS specific phenotype = '${phenotypicTrait}")
             // nothing we can do with this
             render(status:200, contentType:"application/json") {
                 [variant:[]]
             }
         }
         JSONObject jsonObject = restServerService.getTraitSpecificInformation(phenotypicTrait, dataSetName,properties,significanceValue,0.0)
         render(status:200, contentType:"application/json") {
                [variant:jsonObject]
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
        LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()
        LinkedHashMap phenotypeMap = processedMetadata.gwasSpecificPhenotypes
        LinkedHashMap sampleGroupSpecificProperties = processedMetadata.sampleGroupSpecificProperties
       // JSONObject jsonObject = restServerService.retrieveTraitInfoByVariant(variant)
        JSONObject jsonObject = restServerService.getTraitPerVariant( variant,phenotypeMap,sampleGroupSpecificProperties)
        render(status:200, contentType:"application/json") {
            [traitInfo:jsonObject]
        }

    }

    /***
     * get here from 'SEE P  values and other statistics across 25 traits' on the gene info page. Associated Ajax call is traitVariantCrossAjax
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id
        String encodedString = sharedToolsService.urlEncodedListOfPhenotypes ()
        render(view: 'traitVariantCross',
                model: [regionSpecification: regionSpecification,
                        phenotypeList      : encodedString,
                        show_gene          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        show_gwas          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)])
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
