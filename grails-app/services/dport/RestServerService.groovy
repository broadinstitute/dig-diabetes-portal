package dport

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)


    private  String MYSQL_REST_SERVER = ""
    private  String BIGQUERY_REST_SERVER = ""
    private  String BASE_URL = ""
    private  String GENE_INFO_URL = "gene-info"
    private  String VARIANT_INFO_URL = "variant-info"
    private  String TRAIT_INFO_URL = "trait-info"
    private  String VARIANT_SEARCH_URL = "variant-search"
    private  String TRAIT_SEARCH_URL = "trait-search"

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
    "Protein_change"
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
    '_13k_T2D_SE'
    ]


    static List <String> EXCHP_VARIANT_SEARCH_COLUMNS = [
    'IN_EXCHP',
    'EXCHP_T2D_P_value',
    'EXCHP_T2D_MAF',
    'EXCHP_T2D_BETA',
    'EXCHP_T2D_SE'
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

    /***
     * plug together the different collections of column specifications we typically use
     */
    public void initialize (){
        MYSQL_REST_SERVER = grailsApplication.config.t2dRestServer.base+grailsApplication.config.t2dRestServer.mysql+grailsApplication.config.t2dRestServer.path
        BIGQUERY_REST_SERVER = grailsApplication.config.t2dRestServer.base+grailsApplication.config.t2dRestServer.bigquery+grailsApplication.config.t2dRestServer.path
        BASE_URL =  MYSQL_REST_SERVER
        log.info ">>>Initializing rest server=${BASE_URL}"
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


    private void pickADifferentRestServer (String newRestServer)  {
        if (!(newRestServer  == BASE_URL))  {
            log.info("NOTE: about to change from the old server = ${BASE_URL} to instead using = ${newRestServer}")
            BASE_URL =  newRestServer
            log.info("NOTE: change to server ${BASE_URL} is complete")
        }
    }

    public void  goWithTheMysqlServer () {
        pickADifferentRestServer (MYSQL_REST_SERVER)
    }


    public void  goWithTheBigQueryServer () {
        pickADifferentRestServer (BIGQUERY_REST_SERVER)
    }

    public String  whatIsMyCurrentServer () {
        String returnValue
        if (BASE_URL == "") {
            returnValue = 'uninitialized'
        }  else if (MYSQL_REST_SERVER  == BASE_URL) {
            returnValue = 'mysql'
        }  else if  (BIGQUERY_REST_SERVER  == BASE_URL) {
            returnValue = 'bigquery'
        }  else {
            returnValue = 'unknown'
        }
        return returnValue
    }



    /***
     * The point is to extract the relevant numbers from a string that looks something like this:
     *      String s="chr19:21,940,000-22,190,000"
     * @param incoming
     * @return
     */
    public LinkedHashMap<String, Integer> extractNumbersWeNeed (String incoming)  {
        LinkedHashMap<String, Integer> returnValue = [:]

        String commasRemoved=incoming.replace(/,/,"")
        returnValue["chromosomeNumber"] =  sharedToolsService.parseChromosome(commasRemoved)
        java.util.regex.Matcher  startExtent = commasRemoved =~ /:\d*/
        if (startExtent.size() >  0){
            returnValue ["startExtent"]  = sharedToolsService.parseExtent(startExtent[0])
         }
        java.util.regex.Matcher  endExtent = commasRemoved =~ /-\d*/
        if (endExtent.size() >  0){
            returnValue ["endExtent"]  = sharedToolsService.parseExtent(endExtent[0])
        }
        return  returnValue
    }

    /***
     * This is the underlying routine for every call to the rest backend.
     * @param drivingJson
     * @param targetUrl
     * @return
     */
  private JSONObject postRestCall(String drivingJson, String targetUrl){
      JSONObject returnValue = null
      Date beforeCall  = new Date()
      Date afterCall
      RestResponse response
      RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
      StringBuilder logStatus = new StringBuilder()
      try {
          response  = rest.post(BASE_URL+targetUrl)   {
              contentType "application/json"
              json drivingJson
          }
          afterCall  = new Date()
      } catch ( Exception exception){
          log.error("NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}")
          log.error(exception.toString())
          logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}"
          exception.printStackTrace()
      }
      logStatus << """
SERVER CALL:
url=${targetUrl},
parm=${drivingJson},
time required=${(afterCall.time-beforeCall.time)/1000} seconds
""".toString()
      if (response?.responseEntity?.statusCode?.value == 200) {
          returnValue =  response.json
          logStatus << """status: ok""".toString()
      }  else {
          JSONObject tempValue =  response.json
          logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
          if  (tempValue)  {
              logStatus << """is_error: ${response.json["is_error"]}""".toString()
          }  else {
              logStatus << "no valid Json returned"
          }
      }
      log.info(logStatus)
      return returnValue
  }



    /***
     * used only for testing
     * @param url
     * @param jsonString
     * @return
     */
    JSONObject postServiceJson (String url,
                                String jsonString) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.post(url)   {
            contentType "application/json"
            json jsonString
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
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

    /***
     * retrieve information about a gene specified by name
     *
     * @param geneName
     * @return
     */
    JSONObject retrieveGeneInfoByName (String geneName) {
        JSONObject returnValue = null
        String drivingJson = """{
"gene_symbol": "${geneName}",
"user_group": "ui",
"columns": [${"\""+GENE_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( drivingJson, GENE_INFO_URL)
        return returnValue
    }

    /***
     * retrieve information about a variant specified by name. Note that the backend routine
     * can support variant name aliases
     *
     * @param variantId
     * @return
     */
    JSONObject retrieveVariantInfoByName (String variantId) {
        JSONObject returnValue = null
        String drivingJson = """{
"variant_id": "${variantId}",
"user_group": "ui",
"columns": [${"\""+VARIANT_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( drivingJson, VARIANT_INFO_URL)
        return returnValue
    }

    /***
     * Variant search on the basis of chromosome, start position, and end position.
     *
     * @param chromosome
     * @param beginSearch
     * @param endSearch
     * @return
     */
    JSONObject searchGenomicRegionBySpecifiedRegion (String chromosome,
                                                     String beginSearch,
                                                     String endSearch) {
        JSONObject returnValue = null
        String drivingJson = """{
"user_group": "ui",
"filters": [
{ "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "${chromosome}"  },
{"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${beginSearch} },
{"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": ${endSearch} }
],
"columns": [${"\""+VARIANT_SEARCH_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( drivingJson, VARIANT_SEARCH_URL)
        return returnValue
    }


    /***
     *   search for a trait on the basis of a region specification
     * @param chromosome
     * @param beginSearch
     * @param endSearch
     * @return
     */
    JSONObject searchForTraitBySpecifiedRegion (String chromosome,
                                                String beginSearch,
                                                String endSearch) {
        JSONObject returnValue = null
        String drivingJson = """{
"user_group": "ui",
"filters": [
{ "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "${chromosome}"  },
{"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${beginSearch} },
{"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": ${endSearch} }
]
}
""".toString()
        returnValue = postRestCall( drivingJson, TRAIT_SEARCH_URL)
        return returnValue
    }

    /***
     * search for a treat specified by name
     * @param traitName
     * @param significance
     * @return
     */
    JSONObject searchTraitByName (String traitName,
                                  BigDecimal significance) {
        JSONObject returnValue = null
        String drivingJson = """{
"user_group": "ui",
"filters": [
    {"operand": "PVALUE", "operator": "LTE", "value": ${significance.toString ()}, "filter_type": "FLOAT"}
],
"trait": "${traitName}"
}
""".toString()
        returnValue = postRestCall( drivingJson, TRAIT_SEARCH_URL)
        return returnValue
    }

    /***
     * retrieved trait information based on a variant name
     * @param variantName
     * @return
     */
    JSONObject retrieveTraitInfoByVariant (String variantName) {
        JSONObject returnValue = null
        String drivingJson = """{
"user_group": "ui",
"variant_id": "${variantName}"
}
""".toString()
        returnValue = postRestCall( drivingJson, TRAIT_INFO_URL)
        return returnValue
    }


    /***
     * Employ a set of filters to perform a variant search. In practice  I'm using this
     * when I compose the filter set on the client ( browser), and thereby allow user-specified
     * filtering on the basis of form.
     *
     * @param customFilterSet
     * @return
     */
    JSONObject searchGenomicRegionByCustomFilters (String customFilterSet) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"user_group": "ui",
"filters": [
${customFilterSet}
],
"columns": [${"\""+VARIANT_SEARCH_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( drivingJson, VARIANT_SEARCH_URL)
        return returnValue
    }

    /***
     * Take a string specifying a region in the form ->  "chr9:21,940,000-22,190,000"
     * Purse this string and then perform a variant search using these three parameters
     *
     * @param userSpecifiedString
     * @return
     */
    JSONObject searchGenomicRegionAsSpecifiedByUsers(String userSpecifiedString) {
        JSONObject returnValue = null
        LinkedHashMap<String, Integer> ourNumbers = extractNumbersWeNeed(userSpecifiedString)
        if (ourNumbers.containsKey("chromosomeNumber") &&
                ourNumbers.containsKey("startExtent") &&
                ourNumbers.containsKey("endExtent")) {
            returnValue = searchGenomicRegionBySpecifiedRegion(ourNumbers["chromosomeNumber"],
                    ourNumbers["startExtent"],
                    ourNumbers["endExtent"])
        }
        return returnValue
    }

    /***
     * retrieve a trait starting with the  raw region specification string we get from users
     * @param userSpecifiedString
     * @return
     */
    public JSONObject searchTraitByUnparsedRegion(String userSpecifiedString) {
        JSONObject returnValue = null
        LinkedHashMap<String, Integer> ourNumbers = extractNumbersWeNeed(userSpecifiedString)
        if (ourNumbers.containsKey("chromosomeNumber") &&
                ourNumbers.containsKey("startExtent") &&
                ourNumbers.containsKey("endExtent")) {
            returnValue = searchForTraitBySpecifiedRegion(ourNumbers["chromosomeNumber"],
                    ourNumbers["startExtent"],
                    ourNumbers["endExtent"])
        }
        return returnValue
    }





}
