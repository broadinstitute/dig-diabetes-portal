package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class TraitController {
    RestServerService restServerService

    def index() {}
    def traitSearch() {
        String phenotypeKey=params.trait
        String requestedSignificance=params.significance
        render (view: 'phenotype',
                model:[show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0,
                       phenotypeKey:phenotypeKey,
                       requestedSignificance:requestedSignificance] )

    }
     def phenotypeAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variant-info']]
            }

        }
    }

}
