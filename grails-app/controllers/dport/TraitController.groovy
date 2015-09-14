package dport

import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.codehaus.groovy.grails.web.json.JSONObject

class TraitController {
    RestServerService restServerService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)
    MetaDataService metaDataService
    MetadataUtilityService metadataUtilityService




    /***
     * create page frame for association statistics across 25 traits for a single variant. The resulting Ajax call is  ajaxTraitsPerVariant
     * @return
     */
     def traitInfo (){
          String variantIdentifier = params.getIdentifier()

         render(view: 'traitsPerVariant',
                 model: [show_gwas        : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                         show_exchp       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                         show_exseq       : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                         show_gene        : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                         variantIdentifier: variantIdentifier])
     }

    /***
     *  search for a single trait from the main page and this will be the page frame.  The resulting Ajax call is  phenotypeAjax
     * @return
     */
    def traitSearch() {
        String phenotypeKey=sharedToolsService.convertOldPhenotypeStringsToNewOnes (params.trait)
        String requestedSignificance=params.significance
        String sampleGroupOwner = this.metaDataService.getGwasSampleGroupNameForPhenotype(phenotypeKey)
        String phenotypeDataSet = ''
        String phenotypeTranslation = sharedToolsService.translator(phenotypeKey)

        render(view: 'phenotype',
                model: [show_gwas            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_gene            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        phenotypeKey         : phenotypeKey,
                        phenotypeName        : phenotypeTranslation,
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
         String dataSetName
         LinkedHashMap properties = [:]
         List<PhenotypeBean> phenotypeList = metaDataService.getAllPhenotypesWithName(phenotypicTrait)
         if (phenotypeList?.size()>0){
             List<Property> propertyList =  metadataUtilityService.retrievePhenotypeProperties(phenotypeList)
             dataSetName = metadataUtilityService.retrievePhenotypeSampleGroupId(phenotypeList)
             for (Property property in propertyList){
                 properties[property.getName()] = property.getPropertyType()
             }
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



    /***
     * Returns association statistics across 25 traits for a single variant.  The launching page is traitInfo
     * @return
     */
    def ajaxTraitsPerVariant()  {
        String variant = params["variantIdentifier"]
        LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()
        JSONObject jsonObject = restServerService.getTraitPerVariant( variant)
        render(status:200, contentType:"application/json") {
            [traitInfo:jsonObject]
        }

    }

    /***
     * Get here from the "Click here to see a GWAS summary of this region" link. Associated Ajax call is traitVariantCrossAjax
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id
        render(view: 'traitVariantCross',
                model: [regionSpecification: regionSpecification,
                        show_gene          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        show_gwas          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)])
    }

    /***
     * called by regionInfo, this provides information across 25 phenotypes. Use it to populate our big region graphic (the one that
     * may one day be supplanted by LocusZoom?)
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



    /***
     * called by regionInfo, this provides information across 25 phenotypes. Use it to populate our big region graphic (the one that
     * may one day be supplanted by LocusZoom?)
     * @return
     */
    def traitVariantCrossByGeneAjax() {
        String geneName = params.geneName
        LinkedHashMap<String, Integer> geneExtents   = sharedToolsService.getGeneExpandedExtent(geneName)
        JSONObject jsonObject =  restServerService.searchForTraitBySpecifiedRegion (geneExtents.chrom as String,
                geneExtents.startExtent as String,
                geneExtents.endExtent as String)
        if (jsonObject) {
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }
        } else {
            render(status:300, contentType:"application/json")
        }

    }









}
