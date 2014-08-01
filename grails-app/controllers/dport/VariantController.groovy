package dport
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantController {
    RestServerService   restServerService

    def index() { }


    def variantInfo() {
        String variantToStartWith = params.id
        if (variantToStartWith) {
            render (view: 'variantInfo',
                    model:[variantToSearch: variantToStartWith.trim(),
                           show_gwas:1,
                           show_exchp: 1,
                           show_exseq: 1,
                           show_sigma: 0] )

        }
   }
    def variantAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variant-info']]
            }

        }
    }
    def gwas() {
        def slurper = new JsonSlurper()
        String variantToStartWith = params.id

        render (view: 'gwasTable',
                model:[variantToSearch: geneToStartWith,
                       show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0] )
    }

}
