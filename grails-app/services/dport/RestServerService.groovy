package dport

import grails.transaction.Transactional
import  grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
   // static String GENE_INFO_URL = "http://t2dgenetics.org/mysql/rest/server/gene-info"
    static String GENE_INFO_URL = "http://t2dgenetics.org/dev/rest/server/gene-info"

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



    JSONObject retrieveGeneInfoByName (String geneName) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"gene_symbol": "${geneName}",
"columns": ["ID", "CHROM", "BEG", "END", "Function_description", "_13k_T2D_VAR_TOTAL", "_13k_T2D_ORIGIN_VAR_TOTALS", "_13k_T2D_lof_NVAR", "_13k_T2D_lof_MINA_MINU_RET",
"_13k_T2D_lof_METABURDEN", "_13k_T2D_GWS_TOTAL", "_13k_T2D_NOM_TOTAL","_13k_T2D_lof_OBSA", "_13k_T2D_lof_OBSU", "EXCHP_T2D_VAR_TOTALS", "EXCHP_T2D_GWS_TOTAL", "EXCHP_T2D_NOM_TOTAL", "GWS_TRAITS",
"GWAS_T2D_GWS_TOTAL", "GWAS_T2D_NOM_TOTAL", "GWAS_T2D_VAR_TOTAL"],
"user_group": "ui"
}
""".toString()
        RestResponse response  = rest.post(GENE_INFO_URL)   {
            contentType "application/json"
            json drivingJson
        }
        returnValue =  response.json
        return returnValue
    }




}
