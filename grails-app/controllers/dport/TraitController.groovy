package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class TraitController {
    RestServerService restServerService
    SharedToolsService sharedToolsService

    def index() {}


     def traitInfo (){
          String variantIdentifier = params.getIdentifier()
         render (view: 'traitsPerVariant',
                 model:[show_gwas:1,
                        show_exchp: 1,
                        show_exseq: 1,
                        show_sigma: 0,
                        show_gene: 1,
                        variantIdentifier:variantIdentifier] )
     }

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




     def phenotypeAjax() {
            String significance = params["significance"]
            String phenotypicTrait  = params["trait"]
            BigDecimal significanceValue
            try {
                significanceValue = new BigDecimal(significance)
            } catch (NumberFormatException nfe)  {
                println "User supplied a nonnumeric significance value = '${significance}'"
                // TODO: error condition.  Go with GWAS significance
                significantValue = 0.00000005
            }
            JSONObject jsonObject = restServerService.searchTraitByName(phenotypicTrait,significanceValue)
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variants']]
            }

    }



    def ajaxTraitsPerVariant()  {
        String variant = params["variantIdentifier"]
        JSONObject jsonObject = restServerService.retrieveTraitInfoByVariant(variant)
        render(status:200, contentType:"application/json") {
            [traitInfo:jsonObject['trait-info']]
        }

    }


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


    def traitVariantCrossAjax() {
        String regionsSpecification = params.id

        JSONObject jsonObject =  restServerService.searchTraitByUnparsedRegion (regionsSpecification)
        render(status:200, contentType:"application/json") {
            [variants:jsonObject['variants']]
        }
    }



}
