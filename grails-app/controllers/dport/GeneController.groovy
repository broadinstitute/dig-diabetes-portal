package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService

    // return partial matches as Json for the purposes of the twitter typeahead handler
    def index() {
        String partialMatches = geneManagementService.partialGeneMatches(params.query,20)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }

    def geneInfo() {
        def slurper = new JsonSlurper()
        String geneToStartWith = params.id
        JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith)
        List variationTable = []
        JSONObject exomeSequencingList =  jsonObject['gene-info']._13k_T2D_ORIGIN_VAR_TOTALS
        for (String sequenceKey in exomeSequencingList.keySet()){
            JSONObject exomeSequence = exomeSequencingList.getJSONObject(sequenceKey)
            LinkedHashMap tableValues = [:]
            for (exomeKey in exomeSequence.keySet()){
                tableValues[exomeKey]=exomeSequence.getString(exomeKey)
            }
            tableValues["COHORT"] = geneManagementService.cohortDetermination(sequenceKey, "exome sequencing")
            variationTable << tableValues
        }
        if (!(jsonObject['gene-info'].EXCHP_T2D_VAR_TOTALS==JSONObject.NULL)){
            JSONObject exomeChipList =  jsonObject['gene-info'].EXCHP_T2D_VAR_TOTALS
            for (String chipKey in exomeChipList.keySet()){
                JSONObject exomeChip = exomeChipList.getJSONObject(chipKey)
                LinkedHashMap tableValues = [:]
                for (key in exomeChip.keySet()){
                    tableValues[key]=exomeChip.getString(key)
                }
                tableValues["COHORT"] = geneManagementService.cohortDetermination(chipKey, "exome chip")
                variationTable << tableValues
            }
        } else {
            LinkedHashMap tableValues = [:]
            tableValues['EU'] =['COMMON': 0,'LOW_FREQUENCY': 0,'NS': 0,'RARE': 0,'TOTAL': 0]
            variationTable << tableValues
        }
         render (view: 'geneInfo', model:[gene_info:jsonObject['gene-info'],
                                         show_gwas:1,
                                         show_exchp: 1,
                                         show_exseq: 1,
                                         show_sigma: 0,
                                         variationTable: variationTable] )
    }

    def geneAjax() {
        String geneToStartWith = params.id
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject['variant-info']]
            }

        }
    }


//    def geneInfoData() {
//        String geneToStartWith = params.id
//        JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith)
//        response.setContentType("application/json")
//        render ("jsonObject" )
//    }


}
