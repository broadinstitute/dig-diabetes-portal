package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantController {
    RestServerService   restServerService
    FilterManagementService filterManagementService

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

//    def variantSearchAjax() {
//       println "variant post received"
//        JSONObject jsonObject = request.JSON
//        if (jsonObject)    {
//            println("received="+jsonObject.toString())
//         }  else {
//            render("<h1> I heard you, but no valid JSON</h1>")
//        }
//
//    }



    def variantSearch() {
        String receivedParameters = request.parameters.toString()
        if (receivedParameters)    {
            LinkedHashMap<String, String> parsedFilterParameters = filterManagementService.parseVariantSearchParameters(request.parameters,false)
            if  (parsedFilterParameters)  {
                render (view: 'variantSearchResults',
                        model:[filter: parsedFilterParameters.filters,
                               filterDescriptions: parsedFilterParameters.filterDescriptions] )
            }  else {
                render("<h1> I heard you, but no valid JSON</h1>")
            }
        }


    }




//    def gwas() {
//        def slurper = new JsonSlurper()
//        String variantToStartWith = params.id
//
//        render (view: 'gwasTable',
//                model:[variantToSearch: geneToStartWith,
//                       show_gwas:1,
//                       show_exchp: 1,
//                       show_exseq: 1,
//                       show_sigma: 0] )
//    }

}
