package dport

import grails.transaction.Transactional
import  grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
    GrailsApplication grailsApplication


    private  String BASE_URL = 'http://t2dgenetics.org/dev/rest/server/'
    private  String GENE_INFO_URL = BASE_URL + "gene-info"
    private  String VARIANT_INFO_URL = BASE_URL + "variant-info"
    private  String VARIANT_SEARCH_URL = BASE_URL + "variant-search"

    static List <String> VARIANT_SEARCH_COLUMNS = [
    'ID',
    'CHROM',
    'POS',
    'DBSNP_ID',
    'CLOSEST_GENE',
    'MOST_DEL_SCORE',
    'Consequence',
    'IN_GENE',
    '_13k_T2D_TRANSCRIPT_ANNOT',
    ]


    static List <String> EXSEQ_VARIANT_SEARCH_COLUMNS = [
    'IN_EXSEQ',
    '_13k_T2D_P_EMMAX_FE_IV',
    '_13k_T2D_EU_MAF',
    '_13k_T2D_HS_MAF',
    '_13k_T2D_AA_MAF',
    '_13k_T2D_EA_MAF',
    '_13k_T2D_SA_MAF',
    '_13k_T2D_MINA',
    '_13k_T2D_MINU',
    '_13k_T2D_OR_WALD_DOS_FE_IV',
    ]


    static List <String> EXCHP_VARIANT_SEARCH_COLUMNS = [
    'IN_EXCHP',
    'EXCHP_T2D_P_value',
    'EXCHP_T2D_MAF',
    'EXCHP_T2D_BETA',
    ]


    static List <String> GWAS_VARIANT_SEARCH_COLUMNS = [
    'IN_GWAS',
    'GWAS_T2D_PVALUE',
    'GWAS_T2D_OR',
    ]


    static List <String> SIGMA_VARIANT_SEARCH_COLUMNS = [
    'SIGMA_T2D_P',
    'SIGMA_T2D_OR',
    'SIGMA_T2D_MINA',
    'SIGMA_T2D_MINU',
    'SIGMA_T2D_MAF',
    'SIGMA_SOURCE',
    'IN_SIGMA',
    ]





    static List <String> EXSEQ_VARIANT_COLUMNS = EXSEQ_VARIANT_SEARCH_COLUMNS + [
    '_13k_T2D_HET_ETHNICITIES',
    '_13k_T2D_HET_CARRIERS',
    '_13k_T2D_HETA',
    '_13k_T2D_HETU',
    '_13k_T2D_HOM_ETHNICITIES',
    '_13k_T2D_HOM_CARRIERS',
    '_13k_T2D_HOMA',
    '_13k_T2D_HOMU',
    ]

    static List <String> SIGMA_VARIANT_COLUMNS = SIGMA_VARIANT_SEARCH_COLUMNS + [
    'SIGMA_T2D_N',
    'SIGMA_T2D_MAC',
    'SIGMA_T2D_OBSA',
    'SIGMA_T2D_OBSU',
    'SIGMA_T2D_HETA',
    'SIGMA_T2D_HETU',
    'SIGMA_T2D_HOMA',
    'SIGMA_T2D_HOMU',
    'SIGMA_T2D_SE',
    ]


    static List <String> GENE_COLUMNS = [
    'ID',
    'CHROM',
    'BEG',
    'END',
    'Function_description',
    ]


    static List <String> EXSEQ_GENE_COLUMNS = [
    '_13k_T2D_VAR_TOTAL',
    '_13k_T2D_ORIGIN_VAR_TOTALS',
    '_13k_T2D_lof_NVAR',
    '_13k_T2D_lof_MINA_MINU_RET',
    '_13k_T2D_lof_METABURDEN',
    '_13k_T2D_GWS_TOTAL',
    '_13k_T2D_NOM_TOTAL',
    '_13k_T2D_lof_OBSA',
    '_13k_T2D_lof_OBSU'
    ]


    static List <String> EXCHP_GENE_COLUMNS = [
    'EXCHP_T2D_VAR_TOTALS',
    'EXCHP_T2D_GWS_TOTAL',
    'EXCHP_T2D_NOM_TOTAL',
    ]


    static List <String> GWAS_GENE_COLUMNS = [
    'GWS_TRAITS',
    'GWAS_T2D_GWS_TOTAL',
    'GWAS_T2D_NOM_TOTAL',
    'GWAS_T2D_VAR_TOTAL',
    ]


    static List <String> SIGMA_GENE_COLUMNS = [
    'SIGMA_T2D_VAR_TOTAL',
    'SIGMA_T2D_VAR_TOTALS',
    'SIGMA_T2D_NOM_TOTAL',
    'SIGMA_T2D_GWS_TOTAL',
    'SIGMA_T2D_lof_NVAR',
    'SIGMA_T2D_lof_MAC',
    'SIGMA_T2D_lof_MINA',
    'SIGMA_T2D_lof_MINU',
    'SIGMA_T2D_lof_P',
    'SIGMA_T2D_lof_OBSA',
    'SIGMA_T2D_lof_OBSU',
    ]

    // Did these old lines of Python do anything? Not that I can tell so far
    static List <String> VARIANT_COLUMNS = VARIANT_SEARCH_COLUMNS
    static List <String> EXCHP_VARIANT_COLUMNS = EXCHP_VARIANT_SEARCH_COLUMNS
    static List <String> GWAS_VARIANT_COLUMNS = GWAS_VARIANT_SEARCH_COLUMNS


    public void initialize (){
        if (grailsApplication.config.site.version == 't2dgenes') {
            VARIANT_SEARCH_COLUMNS += EXSEQ_VARIANT_SEARCH_COLUMNS + EXCHP_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS
            VARIANT_COLUMNS += EXSEQ_VARIANT_COLUMNS + EXCHP_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS
            GENE_COLUMNS += EXSEQ_GENE_COLUMNS + EXCHP_GENE_COLUMNS + GWAS_GENE_COLUMNS
        }

        if (grailsApplication.config.site.version ==  'sigma') {
            VARIANT_SEARCH_COLUMNS += SIGMA_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS
            VARIANT_COLUMNS += SIGMA_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS
            GENE_COLUMNS += SIGMA_GENE_COLUMNS + GWAS_GENE_COLUMNS
        }
    }





    def hitService() {
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        def resp = rest.get("http://grails.org/api/v1.0/plugin/acegi/")
       println resp.toString ()
    }

   String getServiceBody (String url) {
       String returnValue = ""
       RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
       RestResponse response = rest.get(url)
       if (response.getStatus () == 200)  {
           returnValue =  response.getBody()
       }
       return returnValue
   }


    JSONObject getServiceJson (String url) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.get(url)
        returnValue =  response.json
        return returnValue
    }


    JSONObject postServiceJson (String url,
                                String jsonString) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.post(url)   {
            contentType "application/json"
            json jsonString
        }
        returnValue =  response.json
        return returnValue
    }


    LinkedHashMap<String, String> convertJsonToMap (JSONObject jsonObject)  {
        LinkedHashMap returnValue = [:]
        for (String sequenceKey in jsonObject.keySet()){
            def intermediateObject = jsonObject[sequenceKey]
            if (intermediateObject) {
                returnValue[sequenceKey] = intermediateObject.toString ()
            } else {
                returnValue[sequenceKey] = null
            }

        }
        return  returnValue
    }

    JSONObject retrieveGeneInfoByName (String geneName) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"gene_symbol": "${geneName}",
"user_group": "ui",
"columns": [${"\""+GENE_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(GENE_INFO_URL)   {
            contentType "application/json"
            json drivingJson
        }
        returnValue =  response.json
        return returnValue
    }



    JSONObject retrieveVariantInfoByName (String variantId) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"variant_id": "${variantId}",
"user_group": "ui",
"columns": [${"\""+VARIANT_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(VARIANT_INFO_URL)   {
            contentType "application/json"
            json drivingJson
        }
        returnValue =  response.json
        return returnValue
    }




    JSONObject searchVariantInfoByName (String variantId) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"variant_id": "${variantId}",
"user_group": "ui",
"filters": []
"columns": [${"\""+VARIANT_SEARCH_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(VARIANT_SEARCH_URL)   {
            contentType "application/json"
            json drivingJson
        }
        returnValue =  response.json
        return returnValue
    }






}
