package org.broadinstitute.mpg

import dport.RestServerService
import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * Controller class to control the /variantInfo section of the T2D site
 */
class VariantInfoController {
    RestServerService   restServerService
    SharedToolsService sharedToolsService

    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String variantToStartWith = params.id
        if (variantToStartWith) {
            render(view: 'variantInfo',
                    model: [variantToSearch: variantToStartWith.trim(),
                            show_gwas      : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)])

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

    /**
     * method to service ajax call for the 'What effect on the encoded protein' section/accordion
     *
     * @return
     */
    def proteinEffect (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.gatherProteinEffect ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service ajax call for the 'Variant frequency difference for patients with disease' section/accordion
     *
     * @return
     */
    def variantDiseaseRisk (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service the ajax call for the 'variant association statistics (pvalue/OR)' section/accordion
     *
     * @return
     */
    def variantDescriptiveStatistics (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantAssociationStatistics ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service the ajax call for the 'How common is' section/accordion
     *
     * @return
     */
    def howCommonIsVariant(){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.howCommonIsVariantAcrossEthnicities ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }
}
