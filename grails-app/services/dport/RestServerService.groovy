package dport

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import groovy.json.JsonSlurper
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
    private  String TEST_REST_SERVER = ""
    private  String DEV_REST_SERVER = ""
    private  String QA_REST_SERVER = ""
    private  String PROD_REST_SERVER = ""
    private  String NEW_DEV_REST_SERVER = ""
    private  String BASE_URL = ""
    private  String GENE_INFO_URL = "gene-info"
    private  String DATA_SET_URL = "getDatasets"
    private  String VARIANT_INFO_URL = "variant-info"
    private  String TRAIT_INFO_URL = "trait-info"
    private  String VARIANT_SEARCH_URL = "variant-search"
    private  String TRAIT_SEARCH_URL = "trait-search"
    private  String GET_DATA_URL = "getData"
    private  String DBT_URL = ""
    private  String EXPERIMENTAL_URL = ""

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

    static List <String> VARIANT_INFO_SEARCH_COLUMNS = [
            'CLOSEST_GENE',
            'ID',
            'DBSNP_ID',
            'Protein_change',
            'Consequence',
            '_13k_T2D_EU_MAF',
            '_13k_T2D_HS_MAF',
            '_13k_T2D_AA_MAF',
            '_13k_T2D_EA_MAF',
            '_13k_T2D_SA_MAF'
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
    '_13k_T2D_OBSA',
    '_13k_T2D_OBSU',
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
    '_13k_T2D_LWS_TOTAL',
    '_13k_T2D_NOM_TOTAL',
    '_13k_T2D_lof_OBSA',
    '_13k_T2D_lof_OBSU'
    ]


    static List <String> EXCHP_GENE_COLUMNS = [
    'EXCHP_T2D_VAR_TOTALS',
    'EXCHP_T2D_GWS_TOTAL',
    'EXCHP_T2D_LWS_TOTAL',
    'EXCHP_T2D_NOM_TOTAL',
    ]


    static List <String> GWAS_GENE_COLUMNS = [
    'GWS_TRAITS',
    'GWAS_T2D_GWS_TOTAL',
    'GWAS_T2D_LWS_TOTAL',
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
        BIGQUERY_REST_SERVER = grailsApplication.config.server.URL
        TEST_REST_SERVER = grailsApplication.config.t2dTestRestServer.base+grailsApplication.config.t2dTestRestServer.name+grailsApplication.config.t2dTestRestServer.path
        DEV_REST_SERVER = grailsApplication.config.t2dDevRestServer.base+grailsApplication.config.t2dDevRestServer.name+grailsApplication.config.t2dDevRestServer.path
        NEW_DEV_REST_SERVER = grailsApplication.config.t2dNewDevRestServer.base+grailsApplication.config.t2dNewDevRestServer.name+grailsApplication.config.t2dNewDevRestServer.path
        QA_REST_SERVER = grailsApplication.config.t2dQaRestServer.base+grailsApplication.config.t2dQaRestServer.name+grailsApplication.config.t2dQaRestServer.path
        PROD_REST_SERVER = grailsApplication.config.t2dProdRestServer.base+grailsApplication.config.t2dProdRestServer.name+grailsApplication.config.t2dProdRestServer.path
        BASE_URL =  grailsApplication.config.server.URL
        DBT_URL   = grailsApplication.config.dbtRestServer.URL
        EXPERIMENTAL_URL = grailsApplication.config.experimentalRestServer.URL
        pickADifferentRestServer (NEW_DEV_REST_SERVER)
    }


    public  String getBigQuery(){
        return BIGQUERY_REST_SERVER;
    }
    public  String getMysql(){
        return MYSQL_REST_SERVER;
    }
    public  String getDevserver(){
        return DEV_REST_SERVER;
    }
    public  String getTestserver(){
        return TEST_REST_SERVER;
    }
    public  String getQaserver(){
        return QA_REST_SERVER;
    }
    public  String getProdserver(){
        return PROD_REST_SERVER;
    }
    public  String getNewdevserver(){
        return NEW_DEV_REST_SERVER;
    }



    private List <String> getGeneColumns () {
        List <String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (GENE_COLUMNS + SIGMA_GENE_COLUMNS + GWAS_GENE_COLUMNS)
        } else { // must be t2dGenes
            returnValue = (GENE_COLUMNS + EXSEQ_GENE_COLUMNS + EXCHP_GENE_COLUMNS + GWAS_GENE_COLUMNS)
        }
        return  returnValue
    }


    private List <String> getVariantColumns () {
        List <String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (VARIANT_COLUMNS + SIGMA_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS)
        } else {
            returnValue = (VARIANT_COLUMNS + EXSEQ_VARIANT_COLUMNS + EXCHP_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS)
        }
        return  returnValue
    }

    private List <String> getVariantInfoColumns () {
        List <String> returnValue
        returnValue = (VARIANT_INFO_SEARCH_COLUMNS)
        return  returnValue
    }




    private List <String> getVariantSearchColumns () {
        List <String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (VARIANT_SEARCH_COLUMNS + SIGMA_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS)
        } else {
            returnValue = (VARIANT_SEARCH_COLUMNS + EXSEQ_VARIANT_SEARCH_COLUMNS + EXCHP_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS)
        }
        return  returnValue
    }


    private void pickADifferentRestServer (String newRestServer)  {
        if (!(newRestServer  == BASE_URL))  {
            log.info("NOTE: about to change from the old server = ${BASE_URL} to instead using = ${newRestServer}")
            BASE_URL =  newRestServer
            log.info("NOTE: change to server ${BASE_URL} is complete")
        }
    }

    public String  getCurrentServer () {
        return (BASE_URL?:"none")
    }

    public void  goWithTheMysqlServer () {
        pickADifferentRestServer (MYSQL_REST_SERVER)
    }


    public void  goWithTheBigQueryServer () {
        pickADifferentRestServer (BIGQUERY_REST_SERVER)
    }

    public void  goWithTheTestServer () {
        pickADifferentRestServer (TEST_REST_SERVER)
    }

    public void  goWithTheDevServer () {
        pickADifferentRestServer (DEV_REST_SERVER)
    }

    public void  goWithTheNewDevServer () {
        pickADifferentRestServer (NEW_DEV_REST_SERVER)
    }

    public void  goWithTheQaServer () {
        pickADifferentRestServer (QA_REST_SERVER)
    }

    public void  goWithTheProdServer () {
        pickADifferentRestServer (PROD_REST_SERVER)
    }


    public String  currentRestServer()  {
        return   BASE_URL;
    }

    public String  whatIsMyCurrentServer () {
        String returnValue
        String currentBaseUrl =  currentRestServer ()
        if (currentBaseUrl == "") {
            returnValue = 'uninitialized'
        }  else if (MYSQL_REST_SERVER  == currentBaseUrl) {
            returnValue = 'mysql'
        }  else if  (BIGQUERY_REST_SERVER  == currentBaseUrl) {
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
    public LinkedHashMap<String, String> extractNumbersWeNeed (String incoming)  {
        LinkedHashMap<String, String> returnValue = [:]

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
     * This is the underlying routine for every GET request to the REST backend
     * where response is text/plain type.
     * @param drivingJson
     * @param targetUrl
     * @return
     */
    private String getRestCallBase(String targetUrl, String currentRestServer){
        String returnValue = null
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response  = rest.get(currentRestServer+targetUrl) {
                contentType "text/plain"
            }
        } catch (Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}"
        }

        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue =  response.text
            logStatus << """status: ok""".toString()
        } else {
            logStatus << """status: failed""".toString()
        }
        log.info(logStatus)
        return returnValue
    }

    /***
     * This is the underlying routine for every call to the rest backend.
     * @param drivingJson
     * @param targetUrl
     * @return
     */
    private JSONObject postRestCallBase(String drivingJson, String targetUrl, currentRestServer){
        JSONObject returnValue = null
        Date beforeCall  = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response  = rest.post(currentRestServer+targetUrl)   {
                contentType "application/json"
                json drivingJson
            }
            afterCall  = new Date()
        } catch ( Exception exception){
            log.error("NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}")
            log.error(exception.toString())
            logStatus <<  "NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}"
            afterCall  = new Date()
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





    private JSONObject postRestCallBurden(String drivingJson, String targetUrl){
        return postRestCallBase(drivingJson,targetUrl,DBT_URL)
    }


    private JSONObject postRestCallExperimental(String drivingJson, String targetUrl){
        return postRestCallBase(drivingJson,targetUrl,EXPERIMENTAL_URL)
    }
    JSONObject retrieveVariantInfoByName_Experimental (String variantId) {
        JSONObject returnValue = null
        String drivingJson = """{
"variant_id": ${variantId},
"user_group": "ui",
"columns": [${"\""+getVariantInfoColumns () .join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCallExperimental( drivingJson, VARIANT_INFO_URL)
        return returnValue
    }



    private JSONObject postRestCall(String drivingJson, String targetUrl){
        return postRestCallBase(drivingJson,targetUrl,currentRestServer())
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
     * retrieve everything from the data sets call. Take sample groups or experiments
     * if provided, but if these parameters are empty then get every data set
     *
     * @param geneName
     * @return
     */
    JSONObject retrieveDatasets (List <String> sampleGroupList,
                                 List <String> experimentList) {
        JSONObject returnValue = null
        String sampleGroup = (sampleGroupList.size() > 0)?("\""+sampleGroupList.join("\",\"")+"\""):"";
        String experimentGroup = (experimentList.size() > 0)?("\""+experimentList.join("\",\"")+"\""):"";
        String drivingJson = """{
"sample_group": [${sampleGroup}],
"experiment": [${experimentGroup}]

}
""".toString()
        returnValue = postRestCall( drivingJson, DATA_SET_URL)
        return returnValue
    }

    // for now let's do a pseudo call
    JSONObject pseudoRetrieveDatasets (List <String> sampleGroupList,
                                 List <String> experimentList) {
        JSONObject result
        if ((sampleGroupList) &&
            (sampleGroupList.size()>0)){
            String magic = """
{"is_error": false,
 "numRecords":1,
 "dataset":["MAGIC 2014"]
}""".toString()
            String t2d = """
{"is_error": false,
 "numRecords":4,
 "dataset":["exome sequence: 26K","exome sequence: 13K","exome array","DIAGRAM GWAS"]
}""".toString()
            String giant = """
{"is_error": false,
 "numRecords":1,
 "dataset":["GIANT 2014"]
}""".toString()
            String glgc = """
{"is_error": false,
 "numRecords":1,
 "dataset":["GLGC 2011"]
}""".toString()
            String retval = ''
           switch (sampleGroupList[0]) {
               case 'T2D': retval = t2d; break;
               case 'FastGlu': retval = magic; break;
               case 'FastIns': retval = magic; break;
               case 'ProIns': retval = magic; break;
               case '2hrGLU_BMIAdj': retval = magic; break;
               case '2hrIns_BMIAdj': retval = magic; break;
               case 'HOMAIR': retval = magic; break;
               case 'HOMAB': retval = magic; break;
               case 'HbA1c': retval = magic; break;
               case 'BMI': retval = magic; break;
               case 'WHR': retval = giant; break;
               case 'Height': retval = giant; break;
               case 'TC': retval = glgc; break;
               case 'HDL': retval = glgc; break;
               case 'LDL': retval = glgc; break;
               case 'TG': retval = glgc; break;
               case 'CAD': retval = giant; break;
               case 'CKD': retval = giant; break;
               case 'eGFRcrea': retval = giant; break;
               case 'eGFRcys': retval = giant; break;
               case 'UACR': retval = giant; break;
               case 'MA': retval = giant; break;
               case 'BIP': retval = giant; break;
               case 'SCZ': retval = giant; break;
               case 'MDD': retval = giant; break;
               default: retval = magic; break;
           }


            def slurper = new JsonSlurper()
            result = slurper.parseText(retval)
           }
         return result
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
"columns": [${"\""+getGeneColumns ().join("\",\"")+"\""}]
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
"columns": [${"\""+getVariantColumns () .join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( drivingJson, VARIANT_INFO_URL)
        return returnValue
    }




    String generateDataRestrictionFilters (){
        StringBuilder sb = new  StringBuilder ()
        if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_sigma)) {
            sb << """,
{ "filter_type": "STRING", "operand": "IN_SIGMA",  "operator": "EQ","value": "1"  }""".toString()
        }
        if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)) {
            sb << """,
{ "filter_type": "STRING", "operand": "IN_EXSEQ",  "operator": "EQ","value": "1"  }
""".toString()
        }
        return sb.toString()
    }

//    { "filter_type": "STRING", "operand": "IN_EXCHIP",  "operator": "EQ","value": "1"  },
//    { "filter_type": "STRING", "operand": "IN_GWAS",  "operator": "EQ","value": "1"  }



    String generateRangeFilters (String chromosome,
                            String beginSearch,
                            String endSearch,
                            Boolean dataRestriction)    {
           StringBuilder sb = new  StringBuilder ()
           sb << """[
                   { "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "${chromosome}"  },
                   {"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${beginSearch} },
                   {"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": ${endSearch} }""".toString()
        if (dataRestriction) {
            sb <<   generateDataRestrictionFilters ()
        }
        sb << """
]""".toString()
        return sb.toString()
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
"filters": ${generateRangeFilters (chromosome,beginSearch,endSearch,true)},
"columns": [${"\""+getVariantSearchColumns ().join("\",\"")+"\""}]
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
"filters": ${generateRangeFilters (chromosome,beginSearch,endSearch,false)}
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
        StringBuilder sb = new  StringBuilder ()
        sb << """{
"user_group": "ui",
"filters": [
    {"operand": "PVALUE", "operator": "LTE", "value": ${significance.toString ()}, "filter_type": "FLOAT"}""".toString()
        sb << """],
"trait": "${traitName}"
}
""".toString()
        returnValue = postRestCall( sb.toString(), TRAIT_SEARCH_URL)
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
        StringBuilder sb = new  StringBuilder ()
        sb << """{
"user_group": "ui",
"filters": [
${customFilterSet}""".toString()
//        sb <<   generateDataRestrictionFilters ()
        sb << """],
"columns": [${"\""+getVariantSearchColumns ().join("\",\"")+"\""}]
}
""".toString()
        returnValue = postRestCall( sb.toString(), VARIANT_SEARCH_URL)
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



    private String requestGeneCountByPValue (String geneName, BigDecimal pValue, Integer dataSet){
        String dataSetId = ""
        String pFieldName = ""
        switch (dataSet){
            case 1:
                dataSetId = "ExSeq_26k_v2"
                pFieldName = "P_EMMAX_FE_IV"
                break;
            default:
                log.error("Trouble: user requested data set = ${dataSet} which I don't recognize")
                defaults
        }
        String geneCountRequest = """
{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": true,
    "properties":    {
                           "cproperty": ["VAR_ID"],
                          "orderBy":    ["CHROM"],
                          "dproperty":    {},
                        "pproperty":    {}
                    },
    "filters":    [
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "GENE", "operator": "EQ", "value": "${geneName}", "operand_type": "STRING"},
                    {"dataset_id": "${dataSetId}", "phenotype": "T2D", "operand": "${pFieldName}", "operator": "LTE", "value": ${pValue}, "operand_type": "FLOAT"}
                ]
}
""".toString()
        return geneCountRequest
    }





    public JSONObject variantCountByGeneNameAndPValue(String geneName, BigDecimal pValue, Integer dataSet){
        String jsonSpec = requestGeneCountByPValue( geneName,  pValue,  dataSet)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }

    /***
     * we don't want the logic in the JavaScript when we already know what calls we need. Just make one call
     * from the browser and then I will cycle through at this level and get all the data
     * @param geneName
     * @return
     */
    public JSONObject combinedVariantCountByGeneNameAndPValue(String geneName){
        List <BigDecimal> pValueList = [0.00000005, 0.0001, 0.05]
        def slurper = new JsonSlurper()
        for (pValue in pValueList){
            String jsonSpec = requestGeneCountByPValue( geneName,  pValue,  dataSet)
            if (jsonSpec.is_error == false){

            }
        }

        return postRestCall(jsonSpec,GET_DATA_URL)
    }




}
