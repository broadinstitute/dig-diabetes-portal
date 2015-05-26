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


   private filterByVariant(String variantName){
       String returnValue
       String uppercaseVariantName = variantName?.toUpperCase()
       if (uppercaseVariantName?.startsWith("RS")){
           returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "DBSNP_ID", "operator": "EQ", "value": "${uppercaseVariantName}", "operand_type": "STRING"}"""
       }else {
           returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "VAR_ID", "operator": "EQ", "value": "${uppercaseVariantName}", "operand_type": "STRING"}"""
       }
       return returnValue
   }




    private String jsonForGeneralApiSearch(String combinedFilterList){
        String inputJson = """
{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID", "CHROM", "POS","DBSNP_ID","CLOSEST_GENE","GENE","IN_GENE","Protein_change","Consequence"],
                          "orderBy":    ["CHROM"],
                          "dproperty":    {

                                            "MAF" : ["ExSeq_13k_sa_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExSeq_13k_ea_genes_dv1",
                                                      "ExSeq_13k_aa_genes_dv1",
                                                      "ExSeq_13k_eu_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExChip_82k_dv2"
                                                    ]
                                        },
                        "pproperty":    {
                                             "P_VALUE":    {
                                                                       "GWAS_DIAGRAM_dv1": ["T2D"],
                                                                    "ExChip_82k_dv2": ["T2D"]
                                                                   },
                          "ODDS_RATIO": { "GWAS_DIAGRAM_dv1": ["T2D"] },
                          "OR_WALD_FE_IV":{"ExSeq_26k_dv2": ["T2D"]},
                          "P_EMMAX_FE_IV":    { "ExSeq_26k_dv2": ["T2D"]},
                           "OBSA":  { "ExSeq_26k_dv2": ["T2D"]},
                           "OBSU":  { "ExSeq_26k_dv2": ["T2D"]},
                          "MINA":    { "ExSeq_26k_dv2": ["T2D"]},
                          "MINU":    { "ExSeq_26k_dv2": ["T2D"]},
                          "BETA":    { "ExChip_82k_dv2": ["T2D"]}
                        }
                    },
    "filters":    [
                    ${combinedFilterList}
                ]
}""".toString()
        return inputJson
    }





   private String regionSearch (String chromosomeNumber,String extentBegin,String extentEnd){
       String inputJson = """
{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID", "CHROM", "POS","DBSNP_ID","CLOSEST_GENE","GENE","IN_GENE","Protein_change","Consequence"],
                          "orderBy":    ["CHROM"],
                          "dproperty":    {
        
                                            "MAF" : ["ExSeq_13k_sa_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExSeq_13k_ea_genes_dv1",
                                                      "ExSeq_13k_aa_genes_dv1",
                                                      "ExSeq_13k_eu_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExChip_82k_dv2"
                                                    ]
                                        },
                        "pproperty":    {
                                             "P_VALUE":    {                                                                   
                                                                       "GWAS_DIAGRAM_dv1": ["T2D"],
                                                                    "ExChip_82k_dv2": ["T2D"]
                                                                   },
                          "ODDS_RATIO": { "GWAS_DIAGRAM_dv1": ["T2D"] },
                          "OR_WALD_FE_IV":{"ExSeq_26k_dv2": ["T2D"]},
                          "P_EMMAX_FE_IV":    { "ExSeq_26k_dv2": ["T2D"]},
                           "OBSA":  { "ExSeq_26k_dv2": ["T2D"]},
                           "OBSU":  { "ExSeq_26k_dv2": ["T2D"]},
                          "MINA":    { "ExSeq_26k_dv2": ["T2D"]},
                          "MINU":    { "ExSeq_26k_dv2": ["T2D"]},
                          "BETA":    { "ExChip_82k_dv2": ["T2D"]}
                        }
                    },
    "filters":    [ 
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "CHROM", "operator": "LTE", "value": ${chromosomeNumber}, "operand_type": "INTEGER"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "LTE", "value": ${extentEnd}, "operand_type": "INTEGER"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "GTE", "value": ${extentBegin}, "operand_type": "INTEGER"}
                ]
}""".toString()
       return inputJson
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







    String generateRangeFiltersPValueRestriction (String chromosome,
                                 String beginSearch,
                                 String endSearch,
                                 Boolean dataRestriction,
                                 BigDecimal pValue)    {
        StringBuilder sb = new  StringBuilder ()
        sb << """[
                   { "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "${chromosome}"  },
                   {"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${beginSearch} },
                   {"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": ${endSearch} }""".toString()
        if (dataRestriction) {
            sb <<   generateDataRestrictionFilters ()
        }
        if (pValue) {
            sb <<   """,
{"operand": "PVALUE", "operator": "LTE", "value": ${pValue.toString()}, "filter_type": "FLOAT"}"""
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
        if (sharedToolsService.getNewApi()){
            returnValue = generateVariantTable( chromosome,beginSearch,endSearch)
        } else {
            String drivingJson = """{
"user_group": "ui",
"filters": ${generateRangeFilters (chromosome,beginSearch,endSearch,true)},
"columns": [${"\""+getVariantSearchColumns ().join("\",\"")+"\""}]
}
""".toString()
            returnValue = postRestCall( drivingJson, VARIANT_SEARCH_URL)
        }
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
"filters": ${generateRangeFiltersPValueRestriction (chromosome,beginSearch,endSearch,false,0.05)}
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
                dataSetId = "ExSeq_26k_dv2"
                pFieldName = "P_EMMAX_FE_IV"
                break;
            case 2:
                dataSetId = "ExChip_82k_dv1"
                pFieldName = "P_VALUE"
                break;
            case 3:
                dataSetId = "GWAS_DIAGRAM_dv1"
                pFieldName = "P_VALUE"
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




    private String diseaseRiskValue (String variantId){
        String diseaseRiskRequest = """
{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": false,
"properties": {
"dproperty": {
},
"pproperty": {
                   
                       "HETA": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "HETU": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "HOMA": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "HOMU": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "OBSU": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "OBSA": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "HETA": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "P_EMMAX_FE_IV": {
                        "ExSeq_26k_dv2": ["T2D"]
                    },
                       "OR_WALD_FE_IV": {
                        "ExSeq_26k_dv2": ["T2D"]
                    }

                     }

                    },
    "filters":    [
                         ${filterByVariant (variantId)}

                ]
}
""".toString()
        return diseaseRiskRequest
    }


    public JSONObject variantDiseaseRisk(String variantId){
        String jsonSpec = diseaseRiskValue( variantId)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }


    private String variantAssociationStatisticsRequest (String variantId) {
        String associationStatisticsRequest = """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 0,
    "page_size": 100,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID"],
                          "orderBy":    [],
                          "dproperty":    {
                                        },
                        "pproperty":    {
                                            "P_EMMAX_FE_IV": {
                                                "ExSeq_26k_dv2": ["T2D"]
                                            },

                                             "P_VALUE":{
                                                "GWAS_DIAGRAM_dv1":["T2D"],
                                                "ExChip_82k_dv1":["T2D"]
                                             },
                                             "OR_WALD_FE_IV":    {
                                                                   "ExSeq_26k_dv2": ["T2D"]
                                                                },
                                             "ODDS_RATIO":{
                                                "GWAS_DIAGRAM_dv1":["T2D"]
                                             },

                                              "BETA":{
                                                "ExChip_82k_dv1":["T2D"]
                                              }

                                        }
                    },
    "filters":    [ 
                      ${filterByVariant (variantId)}

                ]
}
""".toString()
        return associationStatisticsRequest
    }


    public JSONObject variantAssociationStatisticsSection(String variantId){
        String jsonSpec = variantAssociationStatisticsRequest( variantId)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }





    public JSONObject combinedVariantAssociationStatistics(String variantName){
        String exSeq2Sample = "ExSeq_26k_dv2"
        String exChipSample = "ExChip_82k_dv1"
        String gwasSample = "GWAS_DIAGRAM_dv1"
        String attribute = "T2D"
        JSONObject returnValue
        List <Integer> dataSeteList = [1]
        List <String> pValueList = [1]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                String apiData = variantAssociationStatisticsSection(variantName)
                JSONObject apiResults = slurper.parseText(apiData)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0])  && (apiResults.variants[0][0])){
                        def variant = apiResults.variants[0];
                        if (variant ["P_EMMAX_FE_IV"]){
                            sb  << "{\"level\":\"P_EMMAX_FE_IV\",\"count\":${variant["P_EMMAX_FE_IV"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["P_VALUE"]){
                            sb  << "{\"level\":\"P_VALUE_GWAS\",\"count\":${variant["P_VALUE"][gwasSample][attribute]}},"
                            sb  << "{\"level\":\"P_VALUE_EXCHIP\",\"count\":${variant["P_VALUE"][exChipSample][attribute]}},"
                        }
                        if (variant ["OR_WALD_FE_IV"]){
                            sb  << "{\"level\":\"OR_WALD_FE_IV\",\"count\":${variant["OR_WALD_FE_IV"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["ODDS_RATIO"]){
                            sb  << "{\"level\":\"ODDS_RATIO\",\"count\":${variant["ODDS_RATIO"][gwasSample][attribute]}},"
                        }
                        if (variant ["BETA"]){
                            sb  << "{\"level\":\"BETA\",\"count\":${variant["BETA"][exChipSample][attribute]}}"
                        }

                    }

                }
                if (i<pValueList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<dataSeteList.size ()-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }




    private String howCommonIsVariantRequest (String variantId) {
        String associationStatisticsRequest = """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID", "CHROM", "POS"],
                          "orderBy":    ["CHROM"],
                          "dproperty":    {
                                            "MAF" : ["ExSeq_13k_sa_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExSeq_13k_ea_genes_dv1",
                                                      "ExSeq_13k_aa_genes_dv1",
                                                      "ExSeq_13k_eu_genes_dv1",
                                                      "ExSeq_13k_hs_genes_dv1",
                                                      "ExChip_82k_dv2"
                                                    ]
                                        },
                        "pproperty":    {
                                                                                     }
                    },
    "filters":    [
                      ${filterByVariant (variantId)}

                ]
}
""".toString()
        return associationStatisticsRequest
    }






    public JSONObject howCommonIsVariantSection(String variantId){
        String jsonSpec = howCommonIsVariantRequest( variantId)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }



    public JSONObject howCommonIsVariantAcrossEthnicities(String variantName){
        String exSeqAASample = "ExSeq_13k_aa_genes_dv1"
        String exSeqHSSample = "ExSeq_13k_hs_genes_dv1"
        String exSeqEASample = "ExSeq_13k_ea_genes_dv1"
        String exSeqSASample = "ExSeq_13k_sa_genes_dv1"
        String exSeqEUSample = "ExSeq_13k_eu_genes_dv1"
        String exChipSample = "ExChip_82k_dv2"
        JSONObject returnValue
        List <Integer> dataSeteList = [1]
        List <String> pValueList = [1]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                String apiData = howCommonIsVariantSection(variantName)
                JSONObject apiResults = slurper.parseText(apiData)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0])  && (apiResults.variants[0][0])){
                        def variant = apiResults.variants[0];
                        if (variant ["MAF"]){
                            sb  << "{\"level\":\"AA\",\"count\":${variant["MAF"][exSeqAASample]}},"
                            sb  << "{\"level\":\"HS\",\"count\":${variant["MAF"][exSeqHSSample]}},"
                            sb  << "{\"level\":\"EA\",\"count\":${variant["MAF"][exSeqEASample]}},"
                            sb  << "{\"level\":\"SA\",\"count\":${variant["MAF"][exSeqSASample]}},"
                            sb  << "{\"level\":\"EUseq\",\"count\":${variant["MAF"][exSeqEUSample]}},"
                            sb  << "{\"level\":\"Euchip\",\"count\":${variant["MAF"][exChipSample]}}"
                        }
                    }

                }
                if (i<pValueList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<dataSeteList.size ()-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }





    public JSONObject combinedVariantDiseaseRisk(String variantName){
        String exSeq2Sample = "ExSeq_26k_dv2"
        String attribute = "T2D"
        JSONObject returnValue
        List <Integer> dataSeteList = [1]
        List <String> pValueList = [1]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                String apiData = variantDiseaseRisk(variantName)
                JSONObject apiResults = slurper.parseText(apiData)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0])  && (apiResults.variants[0][0])){
                        def variant = apiResults.variants[0];
                        if (variant ["HETA"]){
                            sb  << "{\"level\":\"HETA\",\"count\":${variant["HETA"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["HETU"]){
                            sb  << "{\"level\":\"HETU\",\"count\":${variant["HETU"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["HOMA"]){
                            sb  << "{\"level\":\"HOMA\",\"count\":${variant["HOMA"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["HOMU"]){
                            sb  << "{\"level\":\"HOMU\",\"count\":${variant["HOMU"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["OBSU"]){
                            sb  << "{\"level\":\"OBSU\",\"count\":${variant["OBSU"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["OBSA"]){
                            sb  << "{\"level\":\"OBSA\",\"count\":${variant["OBSA"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["P_EMMAX_FE_IV"]){
                            sb  << "{\"level\":\"P_EMMAX_FE_IV\",\"count\":${variant["P_EMMAX_FE_IV"][exSeq2Sample][attribute]}},"
                        }
                        if (variant ["OR_WALD_FE_IV"]){
                            sb  << "{\"level\":\"OR_WALD_FE_IV\",\"count\":${variant["OR_WALD_FE_IV"][exSeq2Sample][attribute]}}"
                        }
                    }

                }
                if (i<pValueList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<dataSeteList.size ()-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
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
        JSONObject returnValue
        List <Integer> dataSeteList = [3, 2, 1]
        List <BigDecimal> pValueList = [1,0.00000005, 0.0001, 0.05]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                sb  << "{"
                 String jsonSpec = requestGeneCountByPValue(geneName, pValueList[i], dataSeteList[j])
                JSONObject apiData = postRestCall(jsonSpec,GET_DATA_URL)
                if (apiData.is_error == false) {
                    sb  << "\"level\":${pValueList[i]},\"count\":${apiData.numRecords}"
                }
                sb  << "}"
                if (i<pValueList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<dataSeteList.size ()-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }







    private String generateJsonVariantCountByGeneAndMaf (String variantId) {
        String associationStatisticsRequest = """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 0,
    "page_size": 100,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID"],
                          "orderBy":    [],
                          "dproperty":    {
                                        },
                        "pproperty":    {
                                            "P_EMMAX_FE_IV": {
                                                "ExSeq_26k_dv2": ["T2D"]
                                            },

                                             "P_VALUE":{
                                                "GWAS_DIAGRAM_dv1":["T2D"],
                                                "ExChip_82k_dv1":["T2D"]
                                             },
                                             "OR_WALD_FE_IV":    {
                                                                   "ExSeq_26k_dv2": ["T2D"]
                                                                },
                                             "ODDS_RATIO":{
                                                "GWAS_DIAGRAM_dv1":["T2D"]
                                             },

                                              "BETA":{
                                                "ExChip_82k_dv1":["T2D"]
                                              }

                                        }
                    },
    "filters":    [
                       ${filterByVariant (variantId)}

                ]
}
""".toString()
        return associationStatisticsRequest
    }







    private String generateJsonVariantCountByGeneAndMaf(String geneName, String ethnicity, int cellNumber){
        String dataSetId = ""
        String minimumMaf = 0
        String maximumMaf = 1
        switch (ethnicity){
            case "HS":
                dataSetId = "ExSeq_13k_hs_genes_dv1"
                break;
            case "AA":
                dataSetId = "ExSeq_13k_aa_genes_dv1"
                break;
            case "EA":
                dataSetId = "ExSeq_13k_ea_genes_dv1"
                break;
            case "SA":
                dataSetId = "ExSeq_13k_sa_genes_dv1"
                break;
            case "EU":
                dataSetId = "ExSeq_13k_eu_genes_dv1"
                break;
            case "chipEu":
                dataSetId = "ExChip_82k_dv2"
                break;
            default:
                log.error("Trouble: user requested data set = ${ethnicity} which I don't recognize")
                dataSetId = "ExSeq_13k_aa_genes_dv1"
        }
        switch (cellNumber){
            case 0:
                minimumMaf = "0"
                maximumMaf = "1"
                break;
            case 1:
                minimumMaf = "0.05"
                maximumMaf = "1"
                break;
            case 2:
                minimumMaf = "0.0005"
                maximumMaf = "0.05"
                break;
            case 3:
                minimumMaf = "0.00000000000001"
                maximumMaf = "0.0005"
                break;
            default:
                log.error("Trouble: user requested cell number = ${cellNumber} which I don't recognize")
                dataSetId = "ExSeq_13k_aa_genes_dv1"
        }
        String jsonVariantCountByGeneAndMaf = """
{
	"passback": "123abc",
	"entity": "variant",
	"page_number": 50,
	"page_size": 100,
	"limit": 1000,
	"count": true,
	"properties":	{
           				"cproperty": ["VAR_ID"],
                  		"orderBy":	[],
                  		"dproperty":	{},
                		"pproperty":	{}
                	},
	"filters":	[
        			{"dataset_id": "blah", "phenotype": "blah", "operand": "GENE", "operator": "EQ", "value": "${geneName}", "operand_type": "STRING"},
                	{"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "GT", "value": ${minimumMaf}, "operand_type": "FLOAT"},
                    {"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "LTE", "value": ${maximumMaf}, "operand_type": "FLOAT"}
            	]
}
""".toString()
        return jsonVariantCountByGeneAndMaf
    }










    public JSONObject findVariantCountByGeneAndMaf(String geneName, String ethnicity, int cellNumber){
        String jsonSpec = generateJsonVariantCountByGeneAndMaf( geneName,  ethnicity,  cellNumber)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }






    public JSONObject combinedEthnicityTable(String geneName){
        JSONObject returnValue
        List <String> dataSeteList = ["HS", "AA", "EA", "SA", "EU","chipEu"]
        List <Integer> cellNumberList = [0,1,2,3]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": \"${dataSeteList[j]}\",\"pVals\": ["
            for ( int  i = 0 ; i < cellNumberList.size () ; i++ ){
                sb  << "{"
                String apiData = findVariantCountByGeneAndMaf(geneName,  dataSeteList[j], cellNumberList[i])
                JSONObject apiResults = slurper.parseText(apiData)
                if (apiResults.is_error == false) {
                    sb  << "\"level\":${cellNumberList[i]},\"count\":${apiResults.numRecords}"
                }
                sb  << "}"
                if (i<cellNumberList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<dataSeteList.size ()-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }



    public JSONObject generateVariantTable(String chromosome,
                                           String beginSearch,
                                           String endSearch){//region
            String exSeq2Sample = "ExSeq_26k_dv2"
            String exSeqAASample = "ExSeq_13k_aa_genes_dv1"
            String exSeqHSSample = "ExSeq_13k_hs_genes_dv1"
            String exSeqEASample = "ExSeq_13k_ea_genes_dv1"
            String exSeqSASample = "ExSeq_13k_sa_genes_dv1"
            String exSeqEUSample = "ExSeq_13k_eu_genes_dv1"
            String exChipSample = "ExChip_82k_dv2"
            String exGwasDiagram = "GWAS_DIAGRAM_dv1"
            String attribute = "T2D"
            def slurper = new JsonSlurper()
            JSONObject returnValue
            String jsonSpec = regionSearch(chromosome,beginSearch,endSearch)
            String apiData = postRestCall(jsonSpec,GET_DATA_URL)
            JSONObject apiResults = slurper.parseText(apiData)
            List <Integer> dataSeteList = [1]
            List <String> pValueList = [1]
            int numberOfVariants = apiResults.numRecords
            StringBuilder sb = new StringBuilder ("{\"results\":[")
            for ( int  j = 0 ; j < numberOfVariants ; j++ ) {
                sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
                for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                    if (apiResults.is_error == false) {
                        if ((apiResults.variants) && (apiResults.variants[j])  && (apiResults.variants[j][0])){
                            def variant = apiResults.variants[j];
                            def element = variant["DBSNP_ID"].findAll{it}[0]

                                sb  << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                            element = variant["VAR_ID"].findAll{it}[0]

                                sb  << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                            element = variant["CHROM"].findAll{it}[0]

                                sb  << "{\"level\":\"CHROM\",\"count\":\"${element}\"},"

                            element = variant["POS"].findAll{it}[0]

                                sb  << "{\"level\":\"POS\",\"count\":${element}},"

                            element = variant["CLOSEST_GENE"].findAll{it}[0]

                                sb  << "{\"level\":\"CLOSEST_GENE\",\"count\":\"${element}\"},"

                            element = variant["Protein_change"].findAll{it}[0]

                                sb  << "{\"level\":\"Protein_change\",\"count\":\"${element}\"},"

                            element = variant["Consequence"].findAll{it}[0]

                                sb  << "{\"level\":\"Consequence\",\"count\":\"${element}\"},"

                            element = variant["P_EMMAX_FE_IV"].findAll{it}[0]

                                sb  << "{\"level\":\"P_EMMAX_FE_IV\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["OR_WALD_FE_IV"].findAll{it}[0]

                                sb  << "{\"level\":\"OR_WALD_FE_IV\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["OBSU"].findAll{it}[0]

                                sb  << "{\"level\":\"OBSU\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["OBSA"].findAll{it}[0]

                                sb  << "{\"level\":\"OBSA\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["MINA"].findAll{it}[0]

                                sb  << "{\"level\":\"MINA\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["MINU"].findAll{it}[0]

                                sb  << "{\"level\":\"MINU\",\"count\":${element[exSeq2Sample][attribute]}},"

                            element = variant["MAF"].findAll{it}[0]

                                sb  << "{\"level\":\"AA\",\"count\":${element[exSeqAASample]}},"
                                sb  << "{\"level\":\"HS\",\"count\":${element[exSeqHSSample]}},"
                                sb  << "{\"level\":\"EA\",\"count\":${element[exSeqEASample]}},"
                                sb  << "{\"level\":\"SA\",\"count\":${element[exSeqSASample]}},"
                                sb  << "{\"level\":\"EUseq\",\"count\":${element[exSeqEUSample]}},"
                                sb  << "{\"level\":\"Euchip\",\"count\":${element[exChipSample]}},"

                            element = variant["P_VALUE"].findAll{it}[0]

                                sb  << "{\"level\":\"EXCHP_T2D_P_value\",\"count\":${element[exChipSample][attribute]}},"

                            element = variant["BETA"].findAll{it}[0]

                                sb  << "{\"level\":\"EXCHP_T2D_BETA\",\"count\":${element[exChipSample][attribute]}},"

                            element = variant["P_VALUE"].findAll{it}[0]

                                sb  << "{\"level\":\"GWAS_T2D_PVALUE\",\"count\":${element[exGwasDiagram][attribute]}},"

                            element = variant["ODDS_RATIO"].findAll{it}[0]

                                sb  << "{\"level\":\"GWAS_T2D_OR\",\"count\":${element[exGwasDiagram][attribute]}}"

                        }
                    }
                    if (i<pValueList.size ()-1){
                        sb  << ","
                    }
                }
                sb  << "]}"
                if (j<numberOfVariants-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            returnValue = slurper.parseText(sb.toString())
            return returnValue
        }





    public JSONObject generalizedVariantTable(String filters){//region
        String exSeq2Sample = "ExSeq_26k_dv2"
        String exSeqAASample = "ExSeq_13k_aa_genes_dv1"
        String exSeqHSSample = "ExSeq_13k_hs_genes_dv1"
        String exSeqEASample = "ExSeq_13k_ea_genes_dv1"
        String exSeqSASample = "ExSeq_13k_sa_genes_dv1"
        String exSeqEUSample = "ExSeq_13k_eu_genes_dv1"
        String exChipSample = "ExChip_82k_dv2"
        String exGwasDiagram = "GWAS_DIAGRAM_dv1"
        String attribute = "T2D"
        def slurper = new JsonSlurper()
        JSONObject returnValue
       // String jsonSpec = regionSearch(chromosome,beginSearch,endSearch)
        String jsonSpec = jsonForGeneralApiSearch(filters)
        String apiData = postRestCall(jsonSpec,GET_DATA_URL)
        JSONObject apiResults = slurper.parseText(apiData)
        List <Integer> dataSeteList = [1]
        List <String> pValueList = [1]
        int numberOfVariants = apiResults.numRecords
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        for ( int  j = 0 ; j < numberOfVariants ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < pValueList.size () ; i++ ){
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[j])  && (apiResults.variants[j][0])){
                        def variant = apiResults.variants[j];
                        def element = variant["DBSNP_ID"].findAll{it}[0]

                        sb  << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                        element = variant["VAR_ID"].findAll{it}[0]

                        sb  << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                        element = variant["CHROM"].findAll{it}[0]

                        sb  << "{\"level\":\"CHROM\",\"count\":\"${element}\"},"

                        element = variant["POS"].findAll{it}[0]

                        sb  << "{\"level\":\"POS\",\"count\":${element}},"

                        element = variant["CLOSEST_GENE"].findAll{it}[0]

                        sb  << "{\"level\":\"CLOSEST_GENE\",\"count\":\"${element}\"},"

                        element = variant["Protein_change"].findAll{it}[0]

                        sb  << "{\"level\":\"Protein_change\",\"count\":\"${element}\"},"

                        element = variant["Consequence"].findAll{it}[0]

                        sb  << "{\"level\":\"Consequence\",\"count\":\"${element}\"},"

                        element = variant["P_EMMAX_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"P_EMMAX_FE_IV\",\"count\":${element[exSeq2Sample][attribute]}},"

                        element = variant["OR_WALD_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"OR_WALD_FE_IV\",\"count\":${element[exSeq2Sample][attribute]}},"

                        //element = variant["OBSU"].findAll{it}[0]

                       // sb  << "{\"level\":\"OBSU\",\"count\":${element[exSeq2Sample][attribute]}},"

                       // element = variant["OBSA"].findAll{it}[0]

                       // sb  << "{\"level\":\"OBSA\",\"count\":${element[exSeq2Sample][attribute]}},"

                        element = variant["MINA"].findAll{it}[0]

                        sb  << "{\"level\":\"MINA\",\"count\":${element[exSeq2Sample][attribute]}},"

                        element = variant["MINU"].findAll{it}[0]

                        sb  << "{\"level\":\"MINU\",\"count\":${element[exSeq2Sample][attribute]}},"

                        element = variant["MAF"].findAll{it}[0]

                        sb  << "{\"level\":\"AA\",\"count\":${element[exSeqAASample]}},"
                        sb  << "{\"level\":\"HS\",\"count\":${element[exSeqHSSample]}},"
                        sb  << "{\"level\":\"EA\",\"count\":${element[exSeqEASample]}},"
                        sb  << "{\"level\":\"SA\",\"count\":${element[exSeqSASample]}},"
                        sb  << "{\"level\":\"EUseq\",\"count\":${element[exSeqEUSample]}},"
                        sb  << "{\"level\":\"Euchip\",\"count\":${element[exChipSample]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_P_value\",\"count\":${element[exChipSample][attribute]}},"

                        element = variant["BETA"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_BETA\",\"count\":${element[exChipSample][attribute]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_PVALUE\",\"count\":${element[exGwasDiagram][attribute]}},"

                        element = variant["ODDS_RATIO"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_OR\",\"count\":${element[exGwasDiagram][attribute]}}"

                    }
                }
                if (i<pValueList.size ()-1){
                    sb  << ","
                }
            }
            sb  << "]}"
            if (j<numberOfVariants-1){
                sb  << ","
            }
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }



}
