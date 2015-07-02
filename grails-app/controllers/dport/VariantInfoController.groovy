package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.transaction.annotation.Transactional

class VariantInfoController {
    RestServerService   restServerService
    FilterManagementService filterManagementService
    SharedToolsService sharedToolsService

    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String variantToStartWith = params.id
        // special case (which really should be handled on the backend, but let's fix it here for now)
        // there is a common way of specifying variants which uses underscores in our database, though in the field it is seen with dashes
        // my algorithm -- split on dashes.  If the first thing we see is a number then do the substitution (underscores for dashes)
        if (variantToStartWith){
            List <String> dividedByDashes = variantToStartWith.split("-")
            if ((dividedByDashes) &&
                    (dividedByDashes.size()>2)){
                int isThisANumber = 0
                try {
                    isThisANumber = Integer.parseInt(dividedByDashes[0])
                }catch(e){
                   // his is only a test. An exception here is not a problem
                }
                if (isThisANumber > 0){// okay -- let's do the substitution
                    variantToStartWith = variantToStartWith.replaceAll('-','_')
                }
            }
        }
        if (variantToStartWith) {
            render(view: 'variantInfo',
                    model: [variantToSearch: variantToStartWith.trim(),
                            show_gwas      : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            show_sigma     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma)])

        }
    }

    /***
     * provide  a nice collection of information about a single variant. This is the Ajax call associated with variantInfo
     * @return
     */
    def variantAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject]
            }

        }
    }



    def proteinEffect (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.gatherProteinEffect ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }




    def variantDiseaseRisk (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }


    def variantDescriptiveStatistics (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantAssociationStatistics ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }


    def howCommonIsVariant(){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.howCommonIsVariantAcrossEthnicities ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }





}
