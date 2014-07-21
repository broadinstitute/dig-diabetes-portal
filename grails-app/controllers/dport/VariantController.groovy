package dport
import groovy.json.JsonSlurper

class VariantController {

    def index() { }


    def variantInfo() {
        def slurper = new JsonSlurper()
//        String geneToStartWith = params.id
//        JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith)
//        List variationTable = []
//        JSONObject exomeSequencingList =  jsonObject['gene-info']._13k_T2D_ORIGIN_VAR_TOTALS
//        for (String sequenceKey in exomeSequencingList.keySet()){
//            JSONObject exomeSequence = exomeSequencingList.getJSONObject(sequenceKey)
//            LinkedHashMap tableValues = [:]
//            for (exomeKey in exomeSequence.keySet()){
//                tableValues[exomeKey]=exomeSequence.getString(exomeKey)
//            }
//            tableValues["COHORT"] = geneManagementService.cohortDetermination(sequenceKey, "exome sequencing")
//            variationTable << tableValues
//        }
//        JSONObject exomeChipList =  jsonObject['gene-info'].EXCHP_T2D_VAR_TOTALS
//        for (String chipKey in exomeChipList.keySet()){
//            JSONObject exomeChip = exomeChipList.getJSONObject(chipKey)
//            LinkedHashMap tableValues = [:]
//            for (key in exomeChip.keySet()){
//                tableValues[key]=exomeChip.getString(key)
//            }
//            tableValues["COHORT"] = geneManagementService.cohortDetermination(chipKey, "exome chip")
//            variationTable << tableValues
//        }
        render (view: 'variantInfo')
//        , model:[gene_info:jsonObject['gene-info'],
//                                         show_gwas:1,
//                                         show_exchp: 1,
//                                         show_exseq: 1,
//                                         show_sigma: 0,
//                                         variationTable: variationTable] )
    }

}
