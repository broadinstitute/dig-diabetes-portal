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
    FilterManagementService filterManagementService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService

    private String PROD_LOAD_BALANCED_SERVER = ""
    private String QA_LOAD_BALANCED_SERVER = ""
    private String QA01_BEHIND_LOAD_BALANCER = ""
    private String QA02_BEHIND_LOAD_BALANCER = ""
    private String DEV_LOAD_BALANCED_SERVER = ""
    private String DEV01_BEHIND_LOAD_BALANCER = ""
    private String DEV02_BEHIND_LOAD_BALANCER = ""
    private String AWS01_REST_SERVER = ""
    private String BIGQUERY_REST_SERVER = ""
    private String DEV_REST_SERVER = ""
    private String PROD_REST_SERVER = ""
    private String NEW_DEV_REST_SERVER = ""
    private String BASE_URL = ""
    private String GENE_INFO_URL = "gene-info"
    private String GENE_SEARCH_URL = "gene-search"
    private String DATA_SET_URL = "getDatasets"
    private String VARIANT_INFO_URL = "variant-info"
    private String TRAIT_INFO_URL = "trait-info"
    private String VARIANT_SEARCH_URL = "variant-search"
    private String TRAIT_SEARCH_URL = "trait-search"
    private String METADATA_URL = "getMetadata"
    private String GET_DATA_URL = "getData"
    private String DBT_URL = ""
    private String EXPERIMENTAL_URL = ""
    private String EXOMESEQ_AA = "ExSeq_17k_aa_genes_mdv2"
    private String EXOMESEQ_HS = "ExSeq_17k_hs_mdv2"
    private String EXOMESEQ_EA = "ExSeq_17k_ea_genes_mdv2"
    private String EXOMESEQ_SA = "ExSeq_17k_sa_genes_mdv2"
    private String EXOMESEQ_EU = "ExSeq_17k_eu_mdv2"
    private String EXOMECHIP = "ExChip_82k_mdv2"
    private String EXOMESEQ = "ExSeq_17k_mdv2"
    private String GWASDIAGRAM  = "GWAS_DIAGRAM_mdv2"
    private String ORCHIP  = "ODDS_RATIO"


    static List<String> VARIANT_SEARCH_COLUMNS = [
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

    static List<String> VARIANT_INFO_SEARCH_COLUMNS = [
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


    static List<String> EXSEQ_VARIANT_SEARCH_COLUMNS = [
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


    static List<String> EXCHP_VARIANT_SEARCH_COLUMNS = [
            'IN_EXCHP',
            'EXCHP_T2D_P_value',
            'EXCHP_T2D_MAF',
            'EXCHP_T2D_BETA',
            'EXCHP_T2D_SE'
    ]


    static List<String> GWAS_VARIANT_SEARCH_COLUMNS = [
            'IN_GWAS',
            'GWAS_T2D_PVALUE',
            'GWAS_T2D_OR',
    ]


    static List<String> SIGMA_VARIANT_SEARCH_COLUMNS = [
            'SIGMA_T2D_P',
            'SIGMA_T2D_OR',
            'SIGMA_T2D_MINA',
            'SIGMA_T2D_MINU',
            'SIGMA_T2D_MAF',
            'SIGMA_SOURCE',
            'IN_SIGMA',
    ]


    static List<String> EXSEQ_VARIANT_COLUMNS = EXSEQ_VARIANT_SEARCH_COLUMNS + [
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

    static List<String> SIGMA_VARIANT_COLUMNS = SIGMA_VARIANT_SEARCH_COLUMNS + [
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


    static List<String> GENE_COLUMNS = [
            'ID',
            'CHROM',
            'BEG',
            'END',
            'Function_description',
    ]


    static List<String> EXSEQ_GENE_COLUMNS = [
            '_13k_T2D_VAR_TOTAL',
            '_13k_T2D_ORIGIN_VAR_TOTALS',
            '_17k_T2D_lof_NVAR',
            '_17k_T2D_lof_MINA_MINU_RET',
            '_17k_T2D_lof_P_METABURDEN',
            '_13k_T2D_GWS_TOTAL',
            '_13k_T2D_LWS_TOTAL',
            '_13k_T2D_NOM_TOTAL',
            '_17k_T2D_lof_OBSA',
            '_17k_T2D_lof_OBSU'
    ]


    static List<String> EXCHP_GENE_COLUMNS = [
            'EXCHP_T2D_VAR_TOTALS',
            'EXCHP_T2D_GWS_TOTAL',
            'EXCHP_T2D_LWS_TOTAL',
            'EXCHP_T2D_NOM_TOTAL',
    ]


    static List<String> GWAS_GENE_COLUMNS = [
            'GWS_TRAITS',
            'GWAS_T2D_GWS_TOTAL',
            'GWAS_T2D_LWS_TOTAL',
            'GWAS_T2D_NOM_TOTAL',
            'GWAS_T2D_VAR_TOTAL',
    ]


    static List<String> SIGMA_GENE_COLUMNS = [
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
    static List<String> VARIANT_COLUMNS = VARIANT_SEARCH_COLUMNS
    static List<String> EXCHP_VARIANT_COLUMNS = EXCHP_VARIANT_SEARCH_COLUMNS
    static List<String> GWAS_VARIANT_COLUMNS = GWAS_VARIANT_SEARCH_COLUMNS

    /***
     * plug together the different collections of column specifications we typically use
     */
    public void initialize() {
        // old servers, to be removed
        BIGQUERY_REST_SERVER = grailsApplication.config.server.URL
        //current

        // load balancer with rest server(s) behind it
        PROD_LOAD_BALANCED_SERVER = grailsApplication.config.t2dProdLoadBalancedServer.base + grailsApplication.config.t2dProdLoadBalancedServer.name + grailsApplication.config.t2dProdLoadBalancedServer.path

        // qa load balancer with rest server(s) behind it
        QA_LOAD_BALANCED_SERVER = grailsApplication.config.t2dQaLoadBalancedServer.base + grailsApplication.config.t2dQaLoadBalancedServer.name + grailsApplication.config.t2dQaLoadBalancedServer.path

        // test rest server 01 bypassing load balancer
        QA01_BEHIND_LOAD_BALANCER = grailsApplication.config.t2dQa01BehindLoadBalancer.base + grailsApplication.config.t2dQa01BehindLoadBalancer.name + grailsApplication.config.t2dQa01BehindLoadBalancer.path

        // test rest server 01 bypassing load balancer
        QA02_BEHIND_LOAD_BALANCER = grailsApplication.config.t2dQa02BehindLoadBalancer.base + grailsApplication.config.t2dQa02BehindLoadBalancer.name + grailsApplication.config.t2dQa02BehindLoadBalancer.path

        // test load balancer with rest server(s) behind it
        DEV_LOAD_BALANCED_SERVER = grailsApplication.config.t2dDevLoadBalancedServer.base + grailsApplication.config.t2dDevLoadBalancedServer.name + grailsApplication.config.t2dDevLoadBalancedServer.path

        // test rest server 01 bypassing load balancer
        DEV01_BEHIND_LOAD_BALANCER = grailsApplication.config.t2dDev01BehindLoadBalancer.base + grailsApplication.config.t2dDev01BehindLoadBalancer.name + grailsApplication.config.t2dDev01BehindLoadBalancer.path

        // test rest server 01 bypassing load balancer
        DEV02_BEHIND_LOAD_BALANCER = grailsApplication.config.t2dDev02BehindLoadBalancer.base + grailsApplication.config.t2dDev02BehindLoadBalancer.name + grailsApplication.config.t2dDev02BehindLoadBalancer.path

        // prod rest server, not load balanced
        PROD_REST_SERVER = grailsApplication.config.t2dProdRestServer.base + grailsApplication.config.t2dProdRestServer.name + grailsApplication.config.t2dProdRestServer.path

        // 'dev'
        NEW_DEV_REST_SERVER = grailsApplication.config.t2dNewDevRestServer.base + grailsApplication.config.t2dNewDevRestServer.name + grailsApplication.config.t2dNewDevRestServer.path

        // dev rest server, not load balanced
        DEV_REST_SERVER = grailsApplication.config.t2dDevRestServer.base + grailsApplication.config.t2dDevRestServer.name + grailsApplication.config.t2dDevRestServer.path

        // 'aws01'
        AWS01_REST_SERVER = grailsApplication.config.t2dAws01RestServer.base + grailsApplication.config.t2dAws01RestServer.name + grailsApplication.config.t2dAws01RestServer.path

        //
        //
        BASE_URL = grailsApplication.config.server.URL
        DBT_URL = grailsApplication.config.dbtRestServer.URL
        EXPERIMENTAL_URL = grailsApplication.config.experimentalRestServer.URL
 //       pickADifferentRestServer(NEW_DEV_REST_SERVER)
        pickADifferentRestServer(DEV_LOAD_BALANCED_SERVER)
 //       pickADifferentRestServer(AWS01_REST_SERVER)
  //      pickADifferentRestServer(QA_LOAD_BALANCED_SERVER)

    }


    public String getBigQuery() {
        return BIGQUERY_REST_SERVER;
    }

     public String getDevserver() {
        return DEV_REST_SERVER;
    }



    // current below
    public String getProdLoadBalanced() {
        return PROD_LOAD_BALANCED_SERVER;
    }

    public String getQaLoadBalanced() {
        return QA_LOAD_BALANCED_SERVER;
    }

    public String getQa01BehindLoadBalancer() {
        return QA01_BEHIND_LOAD_BALANCER;
    }

    public String getQa02BehindLoadBalancer() {
        return QA02_BEHIND_LOAD_BALANCER;
    }

    public String getDevLoadBalanced() {
        return DEV_LOAD_BALANCED_SERVER;
    }

    public String getDev01BehindLoadBalancer() {
        return DEV01_BEHIND_LOAD_BALANCER;
    }

    public String getDev02BehindLoadBalancer() {
        return DEV02_BEHIND_LOAD_BALANCER;
    }

    public String getAws01RestServer() {
        return AWS01_REST_SERVER;
    }

    public String getProdserver() {
        return PROD_REST_SERVER;
    }

    public String getNewdevserver() {
        return NEW_DEV_REST_SERVER;
    }


    private List<String> getGeneColumns() {
        List<String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (GENE_COLUMNS + SIGMA_GENE_COLUMNS + GWAS_GENE_COLUMNS)
        } else { // must be t2dGenes
            returnValue = (GENE_COLUMNS + EXSEQ_GENE_COLUMNS + EXCHP_GENE_COLUMNS + GWAS_GENE_COLUMNS)
        }
        return returnValue
    }


    private List<String> getVariantColumns() {
        List<String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (VARIANT_COLUMNS + SIGMA_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS)
        } else {
            returnValue = (VARIANT_COLUMNS + EXSEQ_VARIANT_COLUMNS + EXCHP_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS)
        }
        return returnValue
    }

    private List<String> getVariantInfoColumns() {
        List<String> returnValue
        returnValue = (VARIANT_INFO_SEARCH_COLUMNS)
        return returnValue
    }


    private filterByVariant(String variantName) {
        String returnValue
        String uppercaseVariantName = variantName?.toUpperCase()
        if (uppercaseVariantName?.startsWith("RS")) {
            returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "DBSNP_ID", "operator": "EQ", "value": "${
                uppercaseVariantName
            }", "operand_type": "STRING"}"""
        } else {
//            List<String> variantNamePieces = variantName.tokenize('_')
//            if (variantNamePieces.size() > 2) {
//                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "CHROM", "operator": "EQ", "value": "${
//                    variantNamePieces[0]
//                }", "operand_type": "STRING"},
//                      {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "EQ", "value": ${
//                    variantNamePieces[1]
//                }, "operand_type": "INTEGER"}
//""".toString()
//            }
            returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "VAR_ID", "operator": "EQ", "value": "${
                uppercaseVariantName
            }", "operand_type": "STRING"}"""
        }
        return returnValue
    }


    private String jsonForGeneralApiSearch(String combinedFilterList) {
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

                                            "MAF" : ["${EXOMESEQ_SA}",
                                                      "${EXOMESEQ_HS}",
                                                      "${EXOMESEQ_EA}",
                                                      "${EXOMESEQ_AA}",
                                                      "${EXOMESEQ_EU}",
                                                      "${EXOMECHIP}"
                                                    ]
                                        },
                        "pproperty":    {
                                             "P_VALUE":    {
                                                                       "${GWASDIAGRAM}": ["T2D"],
                                                                    "${EXOMECHIP}": ["T2D"]
                                                                   },
                          "ODDS_RATIO": { "${GWASDIAGRAM}": ["T2D"],
                                          "${EXOMECHIP}": ["T2D"] },
                          "OR_FIRTH_FE_IV":{"${EXOMESEQ}": ["T2D"]},
                          "P_FIRTH_FE_IV":    { "${EXOMESEQ}": ["T2D"]},
                           "OBSA":  { "${EXOMESEQ}": ["T2D"]},
                           "OBSU":  { "${EXOMESEQ}": ["T2D"]},
                          "MINA":    { "${EXOMESEQ}": ["T2D"]},
                          "MINU":    { "${EXOMESEQ}": ["T2D"]}
                        }
                    },
    "filters":    [
                    ${combinedFilterList}
                ]
}""".toString()
        return inputJson

    }

//  "cproperty": ["VAR_ID", "CHROM", "POS","DBSNP_ID","CLOSEST_GENE","GENE","IN_GENE","Protein_change","Consequence"],


    private String jsonForCustomColumnApiSearch(String combinedFilterList, LinkedHashMap requestedProperties) {
        LinkedHashMap resultColumnsToFetch = getColumnsToFetch("[" + combinedFilterList + "]",  requestedProperties)
        String inputJson = """
{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 50,
    "page_size": 100,
    "limit": 1000,
    "count": false,
    "properties":    {
                           "cproperty": [${ resultColumnsToFetch.cproperty.collect({"\"${it}\""}).join(' , ')}],
                          "orderBy":    ["CHROM"],
""".toString()

        inputJson += '"dproperty" : {'
        String curJson = ""
        for (String property in resultColumnsToFetch.dproperty.keySet()) {
            if (curJson) {
                curJson += ","
            }
            if (resultColumnsToFetch.dproperty[property]) {
                curJson += " \"${property}\" : [ " + resultColumnsToFetch.dproperty[property].collect({"\"${it}\""}).join(' , ') + ']'
            }
        }

        inputJson += curJson + ' } , "pproperty" : {'

        curJson = ""
        for (String property in resultColumnsToFetch.pproperty.keySet()) {
            if (resultColumnsToFetch.pproperty[property]) {
                if (curJson) {
                    curJson += ","
                }
                curJson += ' "' + property + '" : { '
                String curJson2 = ""
                for (String dataset in resultColumnsToFetch.pproperty[property].keySet()) {
                    if (resultColumnsToFetch.pproperty[property][dataset]) {
                        if (curJson2) {
                            curJson2 += ","
                        }
                        curJson2 += ' "' + dataset + '" : [ ' + resultColumnsToFetch.pproperty[property][dataset].collect({"\"${it}\""}).join(' , ') + ']'
                    }
                }
                curJson += curJson2 + " } ";
            }
        }
        inputJson += curJson + ' } } ,'

        inputJson += """

    "filters":    [
                    ${combinedFilterList}
                ]
}""".toString()

        return inputJson
    }

    private String regionSearch(String chromosomeNumber, String extentBegin, String extentEnd) {
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

                                            "MAF" : ["${EXOMESEQ_SA}",
                                                      "${EXOMESEQ_HS}",
                                                      "${EXOMESEQ_EA}",
                                                      "${EXOMESEQ_AA}",
                                                      "${EXOMESEQ_EU}",
                                                      "${EXOMECHIP}"
                                                    ]
                                        },
                        "pproperty":    {
                                             "P_VALUE":    {
                                                                       "${GWASDIAGRAM}": ["T2D"],
                                                                    "${EXOMECHIP}": ["T2D"]
                                                                   },
                          "ODDS_RATIO": { "${GWASDIAGRAM}": ["T2D"],
                                                  "${EXOMECHIP}": ["T2D"]},
                          "OR_FIRTH_FE_IV":{"${EXOMESEQ}": ["T2D"]},
                          "P_FIRTH_FE_IV":    { "${EXOMESEQ}": ["T2D"]},
                           "OBSA":  { "${EXOMESEQ}": ["T2D"]},
                           "OBSU":  { "${EXOMESEQ}": ["T2D"]},
                          "MINA":    { "${EXOMESEQ}": ["T2D"]},
                          "MINU":    { "${EXOMESEQ}": ["T2D"]}
                        }
                    },
    "filters":    [
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "CHROM", "operator": "EQ", "value": "${chromosomeNumber}", "operand_type": "STRING"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "LTE", "value": ${extentEnd}, "operand_type": "INTEGER"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "GTE", "value": ${extentBegin}, "operand_type": "INTEGER"}
                ]
}""".toString()
        return inputJson
    }


    private List<String> getVariantSearchColumns() {
        List<String> returnValue
        if (sharedToolsService.applicationName() == 'Sigma') {
            returnValue = (VARIANT_SEARCH_COLUMNS + SIGMA_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS)
        } else {
            returnValue = (VARIANT_SEARCH_COLUMNS + EXSEQ_VARIANT_SEARCH_COLUMNS + EXCHP_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS)
        }
        return returnValue
    }


    private void pickADifferentRestServer(String newRestServer) {
        if (!(newRestServer == BASE_URL)) {
            log.info("NOTE: about to change from the old server = ${BASE_URL} to instead using = ${newRestServer}")
            BASE_URL = newRestServer
            log.info("NOTE: change to server ${BASE_URL} is complete")
        }
    }

    public String getCurrentServer() {
        return (BASE_URL ?: "none")
    }


    public void goWithTheBigQueryServer() {
        pickADifferentRestServer(BIGQUERY_REST_SERVER)
    }

    public void goWithTheProdLoadBalancedServer() {
        pickADifferentRestServer(PROD_LOAD_BALANCED_SERVER)
    }

    public void goWithTheQa01BehindLoadBalancer() {
        pickADifferentRestServer(QA01_BEHIND_LOAD_BALANCER)
    }

    public void goWithTheQa02BehindLoadBalancer() {
        pickADifferentRestServer(QA02_BEHIND_LOAD_BALANCER)
    }

    public void goWithTheQaLoadBalancedServer() {
        pickADifferentRestServer(QA_LOAD_BALANCED_SERVER)
    }

    public void goWithTheDev01BehindLoadBalancer() {
        pickADifferentRestServer(DEV01_BEHIND_LOAD_BALANCER)
    }

    public void goWithTheDev02BehindLoadBalancer() {
        pickADifferentRestServer(DEV02_BEHIND_LOAD_BALANCER)
    }

    public void goWithTheDevLoadBalancedServer() {
        pickADifferentRestServer(DEV_LOAD_BALANCED_SERVER)
    }

    public void goWithTheAws01RestServer() {
        pickADifferentRestServer(AWS01_REST_SERVER)
    }

    public void goWithTheProdServer() {
        pickADifferentRestServer(PROD_REST_SERVER)
    }

    public void goWithTheDevServer() {
        pickADifferentRestServer(DEV_REST_SERVER)
    }

    public void goWithTheNewDevServer() {
        pickADifferentRestServer(NEW_DEV_REST_SERVER)
    }


    public String currentRestServer() {
        return BASE_URL;
    }

    public String whatIsMyCurrentServer() {
        String returnValue
        return currentRestServer()
    }

    /***
     * The point is to extract the relevant numbers from a string that looks something like this:
     *      String s="chr19:21,940,000-22,190,000"
     * @param incoming
     * @return
     */
    public LinkedHashMap<String, String> extractNumbersWeNeed(String incoming) {
        LinkedHashMap<String, String> returnValue = [:]

        String commasRemoved = incoming.replace(/,/, "")
        returnValue["chromosomeNumber"] = sharedToolsService.parseChromosome(commasRemoved)
        java.util.regex.Matcher startExtent = commasRemoved =~ /:\d*/
        if (startExtent.size() > 0) {
            returnValue["startExtent"] = sharedToolsService.parseExtent(startExtent[0])
        }
        java.util.regex.Matcher endExtent = commasRemoved =~ /-\d*/
        if (endExtent.size() > 0) {
            returnValue["endExtent"] = sharedToolsService.parseExtent(endExtent[0])
        }
        return returnValue
    }

    /***
     * This is the underlying routine for every GET request to the REST backend
     * where response is text/plain type.
     * @param drivingJson
     * @param targetUrl
     * @return
     */
    private String  getRestCallBase(String targetUrl, String currentRestServer) {
        String returnValue = null
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response = rest.get(currentRestServer + targetUrl) {
                contentType "text/plain"
            }
        } catch (Exception exception) {
            log.error("NOTE: exception on post to backend. Target=${targetUrl}")
            log.error(exception.toString())
            logStatus << "NOTE: exception on post to backend. Target=${targetUrl}"
        }

        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue = response.text
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
    private JSONObject postRestCallBase(String drivingJson, String targetUrl, currentRestServer) {
        JSONObject returnValue = null
        Date beforeCall = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response = rest.post(currentRestServer + targetUrl) {
                contentType "application/json"
                json drivingJson
            }
            afterCall = new Date()
        } catch (Exception exception) {
            log.error("NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}")
            log.error(exception.toString())
            logStatus << "NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}"
            afterCall = new Date()
        }
        logStatus << """
SERVER POST:
url=${currentRestServer + targetUrl},
parm=${drivingJson},
time required=${(afterCall.time - beforeCall.time) / 1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue = response.json
            logStatus << """status: ok""".toString()
        } else {
            JSONObject tempValue = response.json
            logStatus << """***************************************failed call***************************************************""".toString()
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            logStatus << """***************************************failed call***************************************************""".toString()
            if (tempValue) {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            } else {
                logStatus << "no valid Json returned"
            }
            logStatus << """
FAILED CALL:
url=${currentRestServer + targetUrl},
parm=${drivingJson},
time required=${(afterCall.time - beforeCall.time) / 1000} seconds
""".toString()
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
    private JSONObject getRestCallBase(String targetUrl, currentRestServer) {
        JSONObject returnValue = null
        Date beforeCall = new Date()
        Date afterCall
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            response = rest.get(currentRestServer + targetUrl) {
                contentType "application/json"
            }
            afterCall = new Date()
        } catch (Exception exception) {
            log.error("NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}")
            log.error(exception.toString())
            logStatus << "NOTE: exception on post to backend. Target=${targetUrl}, driving Json=${drivingJson}"
            afterCall = new Date()
        }
        logStatus << """
SERVER GET:
url=${currentRestServer + targetUrl},
parm=${drivingJson},
time required=${(afterCall.time - beforeCall.time) / 1000} seconds
""".toString()
        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue = response.json
            logStatus << """status: ok""".toString()
        } else {
            JSONObject tempValue = response.json
            logStatus << """status: ${response.responseEntity.statusCode.value}""".toString()
            if (tempValue) {
                logStatus << """is_error: ${response.json["is_error"]}""".toString()
            } else {
                logStatus << "no valid Json returned"
            }
        }
        log.info(logStatus)
        return returnValue
    }


    private JSONObject postRestCallBurden(String drivingJson, String targetUrl) {
        return postRestCallBase(drivingJson, targetUrl, DBT_URL)
    }


    private JSONObject postRestCallExperimental(String drivingJson, String targetUrl) {
        return postRestCallBase(drivingJson, targetUrl, EXPERIMENTAL_URL)
    }

    JSONObject retrieveVariantInfoByName_Experimental(String variantId) {
        JSONObject returnValue = null
        String drivingJson = """{
"variant_id": ${variantId},
"user_group": "ui",
"columns": [${"\"" + getVariantInfoColumns().join("\",\"") + "\""}]
}
""".toString()
        returnValue = postRestCallExperimental(drivingJson, VARIANT_INFO_URL)
        return returnValue
    }


    private JSONObject postRestCall(String drivingJson, String targetUrl) {
        return postRestCallBase(drivingJson, targetUrl, currentRestServer())
    }


    private String getRestCall(String targetUrl) {
        String retdat
        retdat = getRestCallBase(targetUrl, currentRestServer())
        return retdat

    }

    /***
     * used only for testing
     * @param url
     * @param jsonString
     * @return
     */
    JSONObject postServiceJson(String url,
                               String jsonString) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response = rest.post(url) {
            contentType "application/json"
            json jsonString
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue = response.json
        }
        return returnValue
    }


    LinkedHashMap<String, String> convertJsonToMap(JSONObject jsonObject) {
        LinkedHashMap returnValue = [:]
        for (String sequenceKey in jsonObject.keySet()) {
            def intermediateObject = jsonObject[sequenceKey]
            if (intermediateObject) {
                returnValue[sequenceKey] = intermediateObject.toString()
            } else {
                returnValue[sequenceKey] = null
            }

        }
        return returnValue
    }

    /***
     * retrieve everything from the data sets call. Take sample groups or experiments
     * if provided, but if these parameters are empty then get every data set
     *
     * @param geneName
     * @return
     */
    JSONObject retrieveDatasets(List<String> sampleGroupList,
                                List<String> experimentList) {
        JSONObject returnValue = null
        String sampleGroup = (sampleGroupList.size() > 0) ? ("\"" + sampleGroupList.join("\",\"") + "\"") : "";
        String experimentGroup = (experimentList.size() > 0) ? ("\"" + experimentList.join("\",\"") + "\"") : "";
        String drivingJson = """{
"sample_group": [${sampleGroup}],
"experiment": [${experimentGroup}]

}
""".toString()
        returnValue = postRestCall(drivingJson, DATA_SET_URL)
        return returnValue
    }

    // for now let's do a pseudo call
    JSONObject retrieveDatasetsFromMetadata(List<String> sampleGroupList,
                                            List<String> experimentList) {
        JSONObject result
        result = sharedToolsService.getMetadata()
        println 'meta-data retrieved'
    }






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
                case '2hrG': retval = magic; break;
                case '2hrI': retval = magic; break;
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
                case 'CHOL': retval = glgc; break;
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
"columns": [\"GWS_TRAITS\"]
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



    private String requestGeneCountByPValue (String geneName, Integer significanceIndicator, Integer dataSet){
        String dataSetId = ""
        String significance
        String geneRegion
        switch (dataSet){
            case 1:
                dataSetId = "exomeseq"
                break;
            case 2:
                dataSetId = "exomechip"
                break;
            case 3:
                dataSetId = "gwas"
                geneRegion = sharedToolsService.getGeneExpandedRegionSpec(geneName)
                break;
            default:
                log.error("Trouble: user requested data set = ${dataSet} which I don't recognize")
                defaults
        }
        switch (significanceIndicator){
            case 1:
                significance = "everything"
                break;
            case 2:
                significance = "genome-wide"
                break;
            case 3:
                significance = "locus"
                break;
            case 4:
                significance = "nominal"
                break;
            default:
                log.error("Trouble: user requested data set = ${dataSet} which I don't recognize")
                defaults
        }
        List <String> filterList= filterManagementService.retrieveFilters(geneName,significance,dataSetId,geneRegion,"")
        String packagedFilters = sharedToolsService.packageUpEncodedParameters(filterList)
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
                    ${packagedFilters}
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
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "HETU": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "HOMA": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "HOMU": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "OBSU": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "OBSA": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "HETA": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "P_FIRTH_FE_IV": {
                        "${EXOMESEQ}": ["T2D"]
                    },
                       "OR_FIRTH_FE_IV": {
                        "${EXOMESEQ}": ["T2D"]
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
                           "cproperty": ["VAR_ID","DBSNP_ID","CLOSEST_GENE","GENE","MOST_DEL_SCORE"],
                          "orderBy":    [],
                          "dproperty":    {
                                        },
                        "pproperty":    {
                                            "P_FIRTH_FE_IV": {
                                                "${EXOMESEQ}": ["T2D"]
                                            },

                                             "P_VALUE":{
                                                "${GWASDIAGRAM}":["T2D"],
                                                "${EXOMECHIP}":["T2D"]
                                             },
                                             "OR_FIRTH_FE_IV":    {
                                                                   "${EXOMESEQ}": ["T2D"]
                                                                },
                                              "ODDS_RATIO": { "${GWASDIAGRAM}": ["T2D"],
                                                              "${EXOMECHIP}": ["T2D"]}

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
        String gwasSample = "${GWASDIAGRAM}"
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

                        def element = variant["DBSNP_ID"].findAll{it}[0]
                        sb  << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                        element = variant["VAR_ID"].findAll{it}[0]
                        sb  << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                        element = variant["GENE"].findAll{it}[0]
                        sb  << "{\"level\":\"GENE\",\"count\":\"${element}\"},"

                        element = variant["CLOSEST_GENE"].findAll{it}[0]
                        sb  << "{\"level\":\"CLOSEST_GENE\",\"count\":\"${element}\"},"

                        element = variant["MOST_DEL_SCORE"].findAll{it}[0]
                        sb  << "{\"level\":\"MOST_DEL_SCORE\",\"count\":\"${element}\"},"

                        if (variant ["P_FIRTH_FE_IV"]){
                            sb  << "{\"level\":\"P_FIRTH_FE_IV\",\"count\":${variant["P_FIRTH_FE_IV"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["P_VALUE"]){
                            sb  << "{\"level\":\"P_VALUE_GWAS\",\"count\":${variant["P_VALUE"][gwasSample][attribute]}},"
                            sb  << "{\"level\":\"P_VALUE_EXCHIP\",\"count\":${variant["P_VALUE"][EXOMECHIP][attribute]}},"
                        }
                        if (variant ["OR_FIRTH_FE_IV"]){
                            sb  << "{\"level\":\"OR_FIRTH_FE_IV\",\"count\":${variant["OR_FIRTH_FE_IV"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["ODDS_RATIO"]){
                            sb  << "{\"level\":\"ODDS_RATIO\",\"count\":${variant["ODDS_RATIO"][gwasSample][attribute]}},"
                        }
                        if (variant ["${ORCHIP}"]){
                            sb  << "{\"level\":\"${ORCHIP}\",\"count\":${variant["${ORCHIP}"][EXOMECHIP][attribute]}}"
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

                                           "MAF" : ["${EXOMESEQ_SA}",
                                                      "${EXOMESEQ_HS}",
                                                      "${EXOMESEQ_EA}",
                                                      "${EXOMESEQ_AA}",
                                                      "${EXOMESEQ_EU}",
                                                      "${EXOMECHIP}"
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
                            sb  << "{\"level\":\"AA\",\"count\":${variant["MAF"][EXOMESEQ_AA]}},"
                            sb  << "{\"level\":\"HS\",\"count\":${variant["MAF"][EXOMESEQ_HS]}},"
                            sb  << "{\"level\":\"EA\",\"count\":${variant["MAF"][EXOMESEQ_EA]}},"
                            sb  << "{\"level\":\"SA\",\"count\":${variant["MAF"][EXOMESEQ_SA]}},"
                            sb  << "{\"level\":\"EUseq\",\"count\":${variant["MAF"][EXOMESEQ_EU]}},"
                            sb  << "{\"level\":\"Euchip\",\"count\":${variant["MAF"][EXOMECHIP]}}"
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
                            sb  << "{\"level\":\"HETA\",\"count\":${variant["HETA"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["HETU"]){
                            sb  << "{\"level\":\"HETU\",\"count\":${variant["HETU"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["HOMA"]){
                            sb  << "{\"level\":\"HOMA\",\"count\":${variant["HOMA"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["HOMU"]){
                            sb  << "{\"level\":\"HOMU\",\"count\":${variant["HOMU"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["OBSU"]){
                            sb  << "{\"level\":\"OBSU\",\"count\":${variant["OBSU"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["OBSA"]){
                            sb  << "{\"level\":\"OBSA\",\"count\":${variant["OBSA"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["P_FIRTH_FE_IV"]){
                            sb  << "{\"level\":\"P_FIRTH_FE_IV\",\"count\":${variant["P_FIRTH_FE_IV"][EXOMESEQ][attribute]}},"
                        }
                        if (variant ["OR_FIRTH_FE_IV"]){
                            sb  << "{\"level\":\"OR_FIRTH_FE_IV\",\"count\":${variant["OR_FIRTH_FE_IV"][EXOMESEQ][attribute]}}"
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






    public JSONObject variantCountByGeneNameAndPValue(String geneName, Integer significance, Integer dataSet){
        String jsonSpec = requestGeneCountByPValue( geneName,  significance,  dataSet)
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
        List <Integer> significanceList = [1,2,  3, 4]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            sb  << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for ( int  i = 0 ; i < significanceList.size () ; i++ ){
                sb  << "{"
                String jsonSpec = requestGeneCountByPValue(geneName, significanceList[i], dataSeteList[j])
                JSONObject apiData = postRestCall(jsonSpec,GET_DATA_URL)
                if (apiData.is_error == false) {
                    sb  << "\"level\":${significanceList[i]},\"count\":${apiData.numRecords}"
                }
                sb  << "}"
                if (i<significanceList.size ()-1){
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
                                            "P_FIRTH_FE_IV": {
                                                "${EXOMESEQ}": ["T2D"]
                                            },

                                             "P_VALUE":{
                                                "${GWASDIAGRAM}":["T2D"],
                                                "${EXOMECHIP}":["T2D"]
                                             },
                                             "OR_FIRTH_FE_IV":    {
                                                                   "${EXOMESEQ}": ["T2D"]
                                                                },
                                              "ODDS_RATIO": { "${GWASDIAGRAM}": ["T2D"],
                                                              "${EXOMECHIP}": ["T2D"]}
                                        }
                    },
    "filters":    [
                       ${filterByVariant (variantId)}

                ]
}
""".toString()
        return associationStatisticsRequest
    }



    private String ancestryDataSet (String ethnicity){
        String dataSetId = ""
        switch (ethnicity){
            case "HS":
                dataSetId = EXOMESEQ_HS
                break;
            case "AA":
                dataSetId = EXOMESEQ_AA
                break;
            case "EA":
                dataSetId = EXOMESEQ_EA
                break;
            case "SA":
                dataSetId = EXOMESEQ_SA
                break;
            case "EU":
                dataSetId = EXOMESEQ_EU
                break;
            case "chipEu":
                dataSetId = EXOMECHIP
                break;
            default:
                log.error("Trouble: user requested data set = ${ethnicity} which I don't recognize")
                dataSetId = EXOMESEQ_AA
        }
        return dataSetId
    }




    private String generateJsonVariantCountByGeneAndMaf(String geneName, String ethnicity, int cellNumber){
        String dataSetId = ""
        String minimumMaf = 0
        String maximumMaf = 1
        dataSetId = ancestryDataSet ( ethnicity)
        switch (cellNumber){
            case 0:
                minimumMaf = "0"
                maximumMaf = "1"
                break;
            case 1:
                minimumMaf = "0"
                maximumMaf = "1"
                break;
            case 2:
                minimumMaf = "0.05"
                maximumMaf = "1"
                break;
            case 3:
                minimumMaf = "0.0005"
                maximumMaf = "0.05"
                break;
            case 4:
                minimumMaf = "0.00000000000001"
                maximumMaf = "0.0005"
                break;
            default:
                log.error("Trouble: user requested cell number = ${cellNumber} which I don't recognize")
                dataSetId = EXOMESEQ_AA
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
                		"pproperty":	{
                           "OBSA":  { "${EXOMESEQ}": ["T2D"]},
                           "OBSU":  { "${EXOMESEQ}": ["T2D"]}
                         }
                	},
	"filters":	[
        			{"dataset_id": "blah", "phenotype": "blah", "operand": "GENE", "operator": "EQ", "value": "${geneName}", "operand_type": "STRING"},
                	{"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "GT", "value": ${minimumMaf}, "operand_type": "FLOAT"},
                    {"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "LTE", "value": ${maximumMaf}, "operand_type": "FLOAT"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "LT", "value": 4, "operand_type": "FLOAT"}
            	]
}
""".toString()
        String retrieveParticipantCount = ""
        if (ethnicity != "chipEu"){  // there is no participant count in the chip data, so special case it
            retrieveParticipantCount = """
                           "OBSA":  { "${dataSetId}": ["T2D"]},
                           "OBSU":  { "${dataSetId}": ["T2D"]}
""".toString()
        }
        String jsonParticipantCount = """
{
	"passback": "123abc",
	"entity": "variant",
	"page_number": 50,
	"page_size": 100,
	"limit": 1,
	"count": false,
	"properties":	{
           				"cproperty": ["VAR_ID"],
                  		"orderBy":	[],
                  		"dproperty":	{},
                		"pproperty":	{
${retrieveParticipantCount}
                         }
                	},
	"filters":	[
        			{"dataset_id": "blah", "phenotype": "blah", "operand": "GENE", "operator": "EQ", "value": "${geneName}", "operand_type": "STRING"},
                	{"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "GT", "value": ${minimumMaf}, "operand_type": "FLOAT"},
                    {"dataset_id": "${dataSetId}", "phenotype": "blah", "operand": "MAF", "operator": "LTE", "value": ${maximumMaf}, "operand_type": "FLOAT"},
                    {"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "LT", "value": 4, "operand_type": "FLOAT"}
            	]
}
""".toString()
        if (cellNumber==0){
            return jsonParticipantCount
        }else {
            return jsonVariantCountByGeneAndMaf
        }

    }










    public JSONObject findVariantCountByGeneAndMaf(String geneName, String ethnicity, int cellNumber){
        String jsonSpec = generateJsonVariantCountByGeneAndMaf( geneName,  ethnicity,  cellNumber)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }

    /***
     * Let's make this the common call for metadata which all callers can share
     * @return
     */
    public String getMetadata(){
        String retdat
        retdat =  getRestCall(METADATA_URL)
        return retdat
    }






    public JSONObject combinedEthnicityTable(String geneName){
        JSONObject returnValue
        String attribute = "T2D"
        List <String> dataSeteList = ["AA", "HS", "EA", "SA", "EU","chipEu"]
        List <Integer> cellNumberList = [0,1,2,3,4]
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        def slurper = new JsonSlurper()
        for ( int  j = 0 ; j < dataSeteList.size () ; j++ ) {
            String dataSetId =  ancestryDataSet ( dataSeteList[j] )
            sb  << "{ \"dataset\": \"${dataSeteList[j]}\",\"pVals\": ["
            for ( int  i = 0 ; i < cellNumberList.size () ; i++ ){
                sb  << "{"
                String apiData = findVariantCountByGeneAndMaf(geneName,  dataSeteList[j], cellNumberList[i])
                JSONObject apiResults = slurper.parseText(apiData)
                if (apiResults.is_error == false) {
                    if (cellNumberList[i] == 0){
                        // the first cell is different than the others. We need to pull back the number of participants,
                        //  which can be found only by adding the OBSA and OBSU fields
                        int unaffected = 0
                        int affected =  0
                        if (dataSeteList[j]!="chipEu"){
                            def variant = apiResults.variants[0]
                            if ((variant) && (variant != 'null')){
                                def element = variant["OBSU"].findAll{it}[0]
                                if ((element) && (element != 'null')){
                                    if (element[dataSetId][attribute]!=null){
                                        unaffected =  element[dataSetId][attribute]
                                    }

                                }
                                element = variant["OBSA"].findAll{it}[0]
                                if ((element) && (element != 'null')) {
                                    if (element[dataSetId][attribute]!=null) {
                                        affected = element[dataSetId][attribute]
                                    }
                                }
                            }
                            sb  << "\"level\":${cellNumberList[i]},\"count\":${(unaffected +affected)}"

                        } else {
                            sb  << "\"level\":${cellNumberList[i]},\"count\":${(79854)}"// We don't have this number.  Special case it
                        }
                    }else {
                        sb  << "\"level\":${cellNumberList[i]},\"count\":${apiResults.numRecords}"
                    }

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




private String generateProteinEffectJson (String variantName){
    String jsonSpec = """
{
        "passback": "123abc",
        "entity": "variant",
        "page_number": 50,
        "page_size": 100,
        "limit": 1,
        "count": false,
        "properties":   {
                                        "cproperty": ["TRANSCRIPT_ANNOT","MOST_DEL_SCORE","VAR_ID","DBSNP_ID"],
                                "orderBy":      [],
                                "dproperty":    { },
                                "pproperty":    { }
                        },
        "filters":      [
        ${filterByVariant(variantName)}
]
}

""".toString()
    return jsonSpec
}




    private JSONObject gatherProteinEffectResults(String variantName){
        String jsonSpec = generateProteinEffectJson( variantName)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }




    public JSONObject gatherProteinEffect(String variantName){
        def slurper = new JsonSlurper()
        String apiData = gatherProteinEffectResults(variantName)
        JSONObject apiResults = slurper.parseText(apiData)
        return apiResults
    }























    public JSONObject generateVariantTable(String chromosome,
                                           String beginSearch,
                                           String endSearch){//region
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

                        element = variant["P_FIRTH_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"P_FIRTH_FE_IV\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["OR_FIRTH_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"OR_FIRTH_FE_IV\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["OBSU"].findAll{it}[0]

                        sb  << "{\"level\":\"OBSU\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["OBSA"].findAll{it}[0]

                        sb  << "{\"level\":\"OBSA\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MINA"].findAll{it}[0]

                        sb  << "{\"level\":\"MINA\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MINU"].findAll{it}[0]

                        sb  << "{\"level\":\"MINU\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MAF"].findAll{it}[0]

                        sb  << "{\"level\":\"AA\",\"count\":${element[EXOMESEQ_AA]}},"
                        sb  << "{\"level\":\"HS\",\"count\":${element[EXOMESEQ_HS]}},"
                        sb  << "{\"level\":\"EA\",\"count\":${element[EXOMESEQ_EA]}},"
                        sb  << "{\"level\":\"SA\",\"count\":${element[EXOMESEQ_SA]}},"
                        sb  << "{\"level\":\"EUseq\",\"count\":${element[EXOMESEQ_EU]}},"
                        sb  << "{\"level\":\"Euchip\",\"count\":${element[EXOMECHIP]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_P_value\",\"count\":${element[EXOMECHIP][attribute]}},"

                       // element = variant["BETA"].findAll{it}[0]
                        element = variant["${ORCHIP}"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_BETA\",\"count\":${element[EXOMECHIP][attribute]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_PVALUE\",\"count\":${element[GWASDIAGRAM][attribute]}},"

                        element = variant["ODDS_RATIO"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_OR\",\"count\":${element[GWASDIAGRAM][attribute]}}"

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


// Add in the additionally requested properties
    private List<String> expandPropertyList(List<String> propertiesToFetch, LinkedHashMap requestedProperties){
        if (requestedProperties){
            requestedProperties.each{phenotype,LinkedHashMap dataset->
                if (phenotype != 'common'){
                    dataset.each{ String dataSetName,List propertyList->
                        for(String property in propertyList){
                            if (!propertiesToFetch.contains(property)){
                                propertiesToFetch << property
                            }
                        }
                    }
                }
            }
        }
        return propertiesToFetch
    }

    private List<String> expandCommonPropertyList(List<String> propertiesToFetch, LinkedHashMap requestedProperties){
        if (requestedProperties) {
            requestedProperties.each { phenotype, LinkedHashMap dataset ->
                if (phenotype == 'common') {
                    dataset.each { String dataSetName, List propertyList ->
                        if (dataSetName == 'common') {
                            for (String property in propertyList) {
                                if (!propertiesToFetch.contains(property)) {
                                    propertiesToFetch << property
                                }
                            }
                        }
                    }
                }
            }
        }
        return propertiesToFetch
    }






    public LinkedHashMap getColumnsToDisplay(String filterJson,LinkedHashMap requestedProperties) {

        //Get the structure to control the columns we want to display
        LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()

        //Get the sample groups and phenotypes from the filters
        List<String> datasetsToFetch = []
        List<String> phenotypesToFetch = []
        List<String> propertiesToFetch = []
     //   List<String> commonProperties = ["VAR_ID", "CHROM", "POS","DBSNP_ID","CLOSEST_GENE","GENE","IN_GENE","Protein_change","Consequence"]
        List<String> commonProperties = ["CLOSEST_GENE","VAR_ID","DBSNP_ID","Protein_change","Consequence","CHROM", "POS"] // default common properties

        // old logic -- if we filter on it, then we want to display it
        JsonSlurper slurper = new JsonSlurper()
        for (def parsedFilter in slurper.parseText(filterJson)) {
            datasetsToFetch << parsedFilter.dataset_id
            phenotypesToFetch << parsedFilter.phenotype
            propertiesToFetch << parsedFilter.operand
        }

        // if specific data sets are requested then add them to the list
        if (requestedProperties)   {
            requestedProperties?.each{ String phenotype, LinkedHashMap phenotypeProperties ->
                phenotypeProperties?.each { String datasetName, v ->
                    if (datasetName == 'common') {
                        if (v?.size() > 0) {
                            for (String dataset in v) {
                                if (!datasetsToFetch.contains(dataset)) {
                                    datasetsToFetch << dataset
                                }
                            }
                        }
                    }
                }
            }
        }

        //HACK HACK HACK HACK HACK
        for (String pheno in phenotypesToFetch) {
            for (String ds in datasetsToFetch) {
                if (processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[pheno]) {
                    propertiesToFetch += processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[pheno][ds].findAll({it =~ /^MINA/})
                    propertiesToFetch += processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[pheno][ds].findAll({it =~ /^MINU/})
                    propertiesToFetch += processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[pheno][ds].findAll({it =~ /^(OR|ODDS|BETA)/})
                    propertiesToFetch += processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[pheno][ds].findAll({it =~ /^P_(EMMAX|FE|VALUE)/})
                }
            }
        }
        // Adding Phenotype specific properties
        propertiesToFetch = expandPropertyList( propertiesToFetch,  requestedProperties)
        commonProperties = expandCommonPropertyList( commonProperties,  requestedProperties)

        LinkedHashMap columnsToDisplayStructure = sharedToolsService.getColumnsToDisplayStructure(processedMetadata, phenotypesToFetch, datasetsToFetch, propertiesToFetch,commonProperties)
        println(columnsToDisplayStructure)
        return columnsToDisplayStructure
    }

    public LinkedHashMap getColumnsToFetch(String filterJson,LinkedHashMap requestedProperties) {
        LinkedHashMap columnsToDisplay = getColumnsToDisplay(filterJson, requestedProperties)
        LinkedHashMap returnValue = [:]
        returnValue.dproperty = [:]
        returnValue.pproperty = [:]
        returnValue.cproperty = columnsToDisplay.cproperty
        if (columnsToDisplay.pproperty) {
            for (String phenotype in columnsToDisplay.pproperty.keySet()) {
                for (String dataset in columnsToDisplay.pproperty[phenotype].keySet()) {
                    for (String property in columnsToDisplay.pproperty[phenotype][dataset]) {
                        if (!returnValue.pproperty[property]) {
                            returnValue.pproperty[property] = [:]
                        }
                        if (!returnValue.pproperty[property][dataset]) {
                            returnValue.pproperty[property][dataset] = []
                        }
                        returnValue.pproperty[property][dataset] << phenotype
                    }
                }
            }
        }
        if (columnsToDisplay.dproperty) {
            for (String phenotype in columnsToDisplay.dproperty.keySet()) {
                for (String dataset in columnsToDisplay.dproperty[phenotype].keySet()) {
                    for (String property in columnsToDisplay.dproperty[phenotype][dataset]) {
                        if (!returnValue.dproperty[property]) {
                            returnValue.dproperty[property] = []
                        }
                        returnValue.dproperty[property] << dataset
                    }
                }
            }
        }

        return returnValue
    }

    public String postRestCallFromFilters(String filters,LinkedHashMap requestedProperties) {
        String jsonSpec = jsonForCustomColumnApiSearch(filters,  requestedProperties)
        String apiData = postRestCall(jsonSpec,GET_DATA_URL)
        return apiData
    }

    public JSONObject generalizedVariantTable(String filters){//region
        String attribute = "T2D"
        def slurper = new JsonSlurper()
        JSONObject returnValue
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

                        element = variant["P_FIRTH_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"P_FIRTH_FE_IV\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["OR_FIRTH_FE_IV"].findAll{it}[0]

                        sb  << "{\"level\":\"OR_FIRTH_FE_IV\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MINA"].findAll{it}[0]

                        sb  << "{\"level\":\"MINA\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MINU"].findAll{it}[0]

                        sb  << "{\"level\":\"MINU\",\"count\":${element[EXOMESEQ][attribute]}},"

                        element = variant["MAF"].findAll{it}[0]

                        sb  << "{\"level\":\"AA\",\"count\":${element[EXOMESEQ_AA]}},"
                        sb  << "{\"level\":\"HS\",\"count\":${element[EXOMESEQ_HS]}},"
                        sb  << "{\"level\":\"EA\",\"count\":${element[EXOMESEQ_EA]}},"
                        sb  << "{\"level\":\"SA\",\"count\":${element[EXOMESEQ_SA]}},"
                        sb  << "{\"level\":\"EUseq\",\"count\":${element[EXOMESEQ_EU]}},"
                        sb  << "{\"level\":\"Euchip\",\"count\":${element[EXOMECHIP]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_P_value\",\"count\":${element[EXOMECHIP][attribute]}},"

                        // element = variant["BETA"].findAll{it}[0]
                        element = variant["${ORCHIP}"].findAll{it}[0]

                        sb  << "{\"level\":\"EXCHP_T2D_BETA\",\"count\":${element[EXOMECHIP][attribute]}},"

                        element = variant["P_VALUE"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_PVALUE\",\"count\":${element[GWASDIAGRAM][attribute]}},"

                        element = variant["ODDS_RATIO"].findAll{it}[0]

                        sb  << "{\"level\":\"GWAS_T2D_OR\",\"count\":${element[GWASDIAGRAM][attribute]}}"

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


    private String orSubstitute(LinkedHashMap properties){
        String orValue = ""
        if (properties){
            if (properties.containsKey("BETA")){
                orValue = "BETA"
            } else if (properties.containsKey("ODDS_RATIO")){
                orValue = "ODDS_RATIO"
            }
        }
        return orValue
    }


    private String generateTraitSpecificJson (String phenotypeName,String dataSet,LinkedHashMap properties,BigDecimal maximumPValue,BigDecimal minimumPValue=0){
        String orValue = orSubstitute( properties)
        String propertyRequest = ""
        if (orValue.length()>0){
            propertyRequest = """ "${orValue}":   {"${dataSet}": ["${phenotypeName}"]  },"""
        }
         String jsonSpec = """
{
        "passback": "123abc",
        "entity": "variant",
        "page_number": 50,
        "page_size": 100,
        "limit": 3000,
        "count": false,
        "properties":   {
                                        "cproperty": ["VAR_ID", "DBSNP_ID", "CLOSEST_GENE", "CHROM", "POS"],
                                "orderBy":      ["P_VALUE"],
                                "dproperty":    {
                                                    "MAF" : ["${dataSet}"]
                                                },
                                "pproperty":    {
                                                     ${propertyRequest}
                                                     "P_VALUE":      {"${dataSet}": ["${phenotypeName}"]  }

                                }
                        },
        "filters":      [
                                {"dataset_id": "${dataSet}", "phenotype": "${phenotypeName}", "operand": "P_VALUE", "operator": "LTE", "value": ${maximumPValue}, "operand_type": "FLOAT"},
                                {"dataset_id": "${dataSet}", "phenotype": "${phenotypeName}", "operand": "P_VALUE", "operator": "GTE", "value": ${minimumPValue}, "operand_type": "FLOAT"}

        ]
}
""".toString()
        return jsonSpec
    }






    private JSONObject gatherTraitSpecificResults(String phenotypeName,String dataSet,LinkedHashMap properties,BigDecimal maximumPValue,BigDecimal minimumPValue){
        String jsonSpec = generateTraitSpecificJson(phenotypeName,dataSet, properties, maximumPValue, minimumPValue)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }



    public JSONObject getTraitSpecificInformation(String phenotypeName,String dataSet,LinkedHashMap properties, BigDecimal maximumPValue,BigDecimal minimumPValue) {//region
        JSONObject returnValue
        String orValue = orSubstitute( properties)
        def slurper = new JsonSlurper()
        String apiData = gatherTraitSpecificResults(phenotypeName,dataSet, properties, maximumPValue, minimumPValue)
        JSONObject apiResults = slurper.parseText(apiData)
        int numberOfVariants = apiResults.numRecords
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        for ( int  j = 0 ; j < numberOfVariants ; j++ ) {
            sb  << "{ \"dataset\": \"traits\",\"pVals\": ["

                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[j])  && (apiResults.variants[j][0])){
                        def variant = apiResults.variants[j];

                        def element = variant["DBSNP_ID"].findAll{it}[0]
                        sb  << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                        element = variant["CHROM"].findAll{it}[0]
                        sb  << "{\"level\":\"CHROM\",\"count\":\"${element}\"},"

                        element = variant["POS"].findAll{it}[0]
                        sb  << "{\"level\":\"POS\",\"count\":${element}},"

                        element = variant["VAR_ID"].findAll{it}[0]
                        sb  << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                        element = variant["CLOSEST_GENE"].findAll{it}[0]
                        sb  << "{\"level\":\"CLOSEST_GENE\",\"count\":\"${element}\"},"

                        element = variant["P_VALUE"].findAll{it}[0]
                        sb  << "{\"level\":\"P_VALUE\",\"count\":${element[dataSet][phenotypeName]}},"

                        if (orValue.length()>0){
                            element = variant["${orValue}"].findAll{it}[0]
                            sb  << "{\"level\":\"${orValue}\",\"count\":\"${element[dataSet][phenotypeName]}\"},"
                        } else {
                            sb  << "{\"level\":\"BETA\",\"count\":\"--\"},"
                        }

                        element = variant["MAF"].findAll{it}[0]
                        sb  << "{\"level\":\"MAF\",\"count\":${element[dataSet]}}"

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





    private LinkedHashMap <String, String>  generatePhenotypeSpecificReferencesForPropertyMap (String property,LinkedHashMap<String, List<String>> holder) {
        LinkedHashMap <String, String> returnValue = [:]
        if ((property) && (holder) ) {
            holder.each{ String phenotypeName, LinkedHashMap map ->
                LinkedHashMap<String, String>  matchingDescriptor = sharedToolsService.pullBackSampleGroup (phenotypeName, property, holder)
                if ((matchingDescriptor.phenotypeFound)  &&
                        (matchingDescriptor.propertyFound)) {
                    returnValue["${phenotypeName}"] = matchingDescriptor.sampleGroupId
                }
            }
        }
        return returnValue
    }

    /***
     * This is tricky only because the phenotypes have to be grouped by unique sample groups.  So after you get the map
     * phenotype -> sample group (repeated for all phenotypes)
     * you then need to swap it into
     * sample group -> [phenotype1, phenotype2,...], (repeated for all distinct sample groups)
     * @param property
     * @param holder
     * @return
     */
    private String packagePhenotypeSpecificReferencesForProperty (String property,LinkedHashMap<String, List<String>> holder) {
        StringBuilder sb = new StringBuilder()
        LinkedHashMap <String, String>  phenotypeSpecificReferencesForPropertyMap =   generatePhenotypeSpecificReferencesForPropertyMap(property,holder)
        boolean firstTime = true
        LinkedHashMap<String, List<String>> invertedHolder = [:]
        if ((property) && (phenotypeSpecificReferencesForPropertyMap) ) {
            phenotypeSpecificReferencesForPropertyMap.each{ String phenotypeName, String sampleGroupId  ->
                if (!invertedHolder.containsKey(sampleGroupId)){
                    invertedHolder[sampleGroupId] = []
                }
                invertedHolder[sampleGroupId] << phenotypeName
            }
        }
        if (invertedHolder.size()>0 ) {
            invertedHolder.each{ String sampleGroupId, List<String> phenotypeList  ->
                if (firstTime)   {
                    firstTime = false
                }  else {
                    sb << """,
""".toString()
                }
                boolean firstTimeInThisSampleGroup = true
                StringBuilder subsb = new StringBuilder()
                for (String phenotype in phenotypeList){
                    if (firstTimeInThisSampleGroup)   {
                        firstTimeInThisSampleGroup = false
                    }  else {
                        subsb << ",".toString()
                    }
                    subsb << """ "${phenotype}" """.toString()
                }
                sb << """      "${sampleGroupId}": [${subsb.toString()}]"""
            }
        }




        return sb.toString()
    }





//    "cproperty": ["VAR_ID", "DBSNP_ID", "CHROM", "POS"],
//    "orderBy":      ["P_VALUE"],
//    "dproperty":    {
//        "MAF" : ["${magic}",
//                 "${pgc}",
//                 "${giant}",
//                 "${cardiogram}",
//                 "${glgc}",
//                 "${cdkgen}"]
//    },
//    "pproperty":    {
//        "BETA":         {
//            "${magic}": ["2hrG"],
//            "${magic}": ["2hrI"],
//            "${giant}": ["BMI"],
//            "${magic}": ["FG"],
//            "${magic}": ["FI"],
//            "${magic}": ["HBA1C"],
//            "${magic}": ["HOMAB"],
//            "${magic}": ["HOMAIR"],
//            "${magic}": ["PI"]
//        },
//
//        "ODDS_RATIO":   {
//            "${pgc}": ["BIP"],
//            "${cardiogram}": ["CAD"],
//            "${pgc}": ["MDD"],
//            "${pgc}": ["SCZ"]
//        },
//
//        "P_VALUE":      {
//            "${magic}": ["2hrG"],
//            "${magic}": ["2hrI"],
//            "${pgc}": ["BIP"],
//            "${giant}": ["BMI"],
//            "${cardiogram}": ["CAD"],
//            "${glgc}": ["CHOL"],
//            "${cdkgen}": ["CKD"],
//            "${magic}": ["FG"],
//            "${magic}": ["FI"],
//            "${magic}": ["HBA1C"],
//            "${glgc}": ["HDL"],
//            "${giant}": ["HEIGHT"],
//            "${magic}": ["HOMAB"],
//            "${magic}": ["HOMAIR"],
//            "${glgc}": ["LDL"],
//            "${magic}": ["MA"],
//            "${pgc}": ["MDD"],
//            "${magic}": ["PI"],
//            "${pgc}": ["SCZ"],
//            "${glgc}": ["TG"],
//            "${cdkgen}": ["UACR"],
//            "${giant}": ["WHR"],
//            "${cdkgen}": ["eGFRcrea"],
//            "${cdkgen}": ["eGFRcys"]
//        }
//    }




    private List<String> generateSampleGroupsContainingProperty (String propertyOfInterest,LinkedHashMap<String, List<String>> sampleGroupSpecificProperties){
        List<String> returnValue = []
        sampleGroupSpecificProperties.each{ String sampleGroupName, LinkedHashMap map ->
            String sampleGroupId = map.sampleGroupId
            if (map.containsKey(propertyOfInterest)){
                returnValue << sampleGroupId
            }
        }
        return returnValue
    }









    private String packageSampleGroupsContainingProperty (String propertyOfInterest,LinkedHashMap<String, List<String>> sampleGroupSpecificProperties){
       List<String> sampleGroupsContainingPropertyList  =  generateSampleGroupsContainingProperty(propertyOfInterest,sampleGroupSpecificProperties)
       StringBuilder sb  = new StringBuilder()
       Boolean firstTime = true
       for (String sampleGroupsContainingProperty in sampleGroupsContainingPropertyList) {
           if (firstTime)   {
               firstTime = false
           }  else {
               sb << """,
""".toString()
           }
           sb << """      "${sampleGroupsContainingProperty}" """.toString()
       }
       return sb.toString()
   }




    private String generateTraitPerVariantJson (String variantName,LinkedHashMap<String, List<String>> holder,LinkedHashMap<String, List<String>> sampleGroupSpecificProperties){
        String dirMatchers =  packagePhenotypeSpecificReferencesForProperty ("DIR", holder)
        String betaMatchers =  packagePhenotypeSpecificReferencesForProperty ("BETA", holder)
        String orMatchers =  packagePhenotypeSpecificReferencesForProperty ("ODDS_RATIO", holder)
        String pValueMatchers =  packagePhenotypeSpecificReferencesForProperty ("P_VALUE", holder)
        String sampleGroupsWithMaf =  packageSampleGroupsContainingProperty ("MAF",sampleGroupSpecificProperties)
        String filterForParticularVariant = filterByVariant(variantName)
        String jsonSpec = """
{
        "passback": "123abc",
        "entity": "variant",
        "page_number": 50,
        "page_size": 100,
        "limit": 10,
        "count": false,
        "properties":   {
                                        "cproperty": ["VAR_ID", "DBSNP_ID", "CHROM", "POS"],
                                "orderBy":      ["P_VALUE"],
                                "dproperty":    {
                                                    "MAF" : [${sampleGroupsWithMaf}]
                                                },
                                "pproperty":    {
                                                     "BETA":         {
                                                         ${betaMatchers}
                                                     },

                                                     "ODDS_RATIO":   {
                                                          ${orMatchers}
                                                     },

                                                     "P_VALUE":      {
                                                          ${pValueMatchers}
                                                      },

                                                    "DIR":         {
                                                         ${dirMatchers}
                                                     }

                                }
                        },
        "filters":      [
                               ${filterForParticularVariant}
                        ]
}""".toString()
        return jsonSpec
    }






    private JSONObject gatherTraitPerVariantResults(String variantName,
                                                    LinkedHashMap<String, List<String>> holder,
                                                    LinkedHashMap<String, List<String>> sampleGroupSpecificProperties){
        String jsonSpec = generateTraitPerVariantJson( variantName, holder,sampleGroupSpecificProperties)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }



    public JSONObject getTraitPerVariant(String variantName,
                                         LinkedHashMap<String, List<String>> holder,
                                         LinkedHashMap<String, List<String>> sampleGroupSpecificProperties) {//region

        JSONObject returnValue
        def slurper = new JsonSlurper()
        String apiData = gatherTraitPerVariantResults(variantName,holder,sampleGroupSpecificProperties)
        List<String> sampleGroupsContainingMafList = generateSampleGroupsContainingProperty("MAF",sampleGroupSpecificProperties)
        LinkedHashMap <String, String> betaMatchersMap =  generatePhenotypeSpecificReferencesForPropertyMap ("BETA", holder)
        LinkedHashMap <String, String>  orMatchersMap =  generatePhenotypeSpecificReferencesForPropertyMap ("ODDS_RATIO", holder)
        LinkedHashMap <String, String>  pValueMatchersMap =  generatePhenotypeSpecificReferencesForPropertyMap ("P_VALUE", holder)
        JSONObject apiResults = slurper.parseText(apiData)
        int numberOfVariants = apiResults.numRecords
        StringBuilder sb = new StringBuilder ("{\"results\":[")
        for ( int  j = 0 ; j < numberOfVariants ; j++ ) {
            sb  << "{ \"dataset\": \"traits\",\"pVals\": ["

            if (apiResults.is_error == false) {
                if ((apiResults.variants) && (apiResults.variants[j])  && (apiResults.variants[j][0])){
                    def variant = apiResults.variants[j];

                    def element = variant["VAR_ID"].findAll{it}[0]
                    sb  << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                    element = variant["DBSNP_ID"].findAll{it}[0]
                    sb  << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                    element = variant["CHROM"].findAll{it}[0]
                    sb  << "{\"level\":\"CHROM\",\"count\":\"${element}\"},"

                    element = variant["MAF"].findAll{it}[0]

                    for (String sampleGroupsContainingMaf in sampleGroupsContainingMafList){
                        sb  << "{\"level\":\"MAF^${sampleGroupsContainingMaf}\",\"count\":${element[sampleGroupsContainingMaf]}},"
                    }

                    element = variant["P_VALUE"].findAll{it}[0]
                    pValueMatchersMap.each{ String phenotypeName, String sampleGroupId ->
                        sb  << "{\"level\":\"P_VALUE^${phenotypeName}\",\"count\":${element[sampleGroupId][phenotypeName]}},"
                    }

                    element = variant["ODDS_RATIO"].findAll{it}[0]
                    orMatchersMap.each{ String phenotypeName, String sampleGroupId ->
                        sb  << "{\"level\":\"ODDS_RATIO^${phenotypeName}\",\"count\":${element[sampleGroupId][phenotypeName]}},"
                    }

                    element = variant["BETA"].findAll{it}[0]
                    betaMatchersMap.each{ String phenotypeName, String sampleGroupId ->
                        sb  << "{\"level\":\"BETA^${phenotypeName}\",\"count\":${element[sampleGroupId][phenotypeName]}},"
                    }

                    element = variant["DIR"].findAll{it}[0]
                    betaMatchersMap.each{ String phenotypeName, String sampleGroupId ->
                        sb  << "{\"level\":\"DIR^${phenotypeName}\",\"count\":${element[sampleGroupId][phenotypeName]}},"
                    }

                    sampleGroupSpecificProperties.each { String sampleGroupId, LinkedHashMap sgHolder ->
                        if ((sgHolder["phenotypeList"]) && (sgHolder["phenotypeList"].size()>0)){
                            sb << "{\"level\":\"MAPPER^${sampleGroupId}\",\"count\":\"${sgHolder["phenotypeList"].join(",")}\"},"
                        }
                    }

                    element = variant["POS"].findAll{it}[0]
                    sb  << "{\"level\":\"POS\",\"count\":${element}}"

                }
            }
            sb  << "]}"
        }
        sb  << "]}"
        returnValue = slurper.parseText(sb.toString())

        return returnValue
    }





    private JSONObject gatherGenesForChromosomeResults(String chromosomeName){
        String jsonSpec =  """{
    "filters":    [
                    {"operand": "CHROM", "operator": "EQ", "value": "${chromosomeName}", "filter_type": "STRING"},
                      {"operand": "BEG", "operator": "GTE", "value": 1, "filter_type": "INTEGER"},
                    {"operand": "END", "operator": "LTE", "value": 1000000000, "filter_type": "INTEGER"}
                ],
  "columns": ["ID","BEG","END","CHROM"],
      "limit":3000
}
}
""".toString()
        return postRestCall(jsonSpec,GENE_SEARCH_URL)
    }




    public int  refreshGenesForChromosome(String chromosomeName) {//region
        int  returnValue    = 1
        Gene.deleteGenesForChromosome(chromosomeName)
        JSONObject apiResults = gatherGenesForChromosomeResults( chromosomeName)
        if (!apiResults.is_error)  {
            int numberOfGenes = apiResults.numRecords
            def genes =  apiResults.genes
            for ( int  i = 0 ; i < numberOfGenes ; i++ )  {
                String geneName =   genes[i].ID
                Long startPosition =   genes[i].BEG
                Long  endPosition =   genes[i].END
                String  chromosome =   genes[i].CHROM
                Gene.refresh(geneName,chromosome,startPosition,endPosition)
            }
        }

        return returnValue
    }







    private JSONObject gatherVariantsForChromosomeResults(String chromosomeName){
        String jsonSpec =  """{
    "filters":    [
                    {"operand": "CHROM", "operator": "EQ", "value": "${chromosomeName}", "filter_type": "STRING"},
                    {"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": 1},
                    {"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": 3000000000 }                ],
      "columns": ["ID","DBSNP_ID","CHROM","POS"],
      "limit":1000000
}
}
""".toString()
        return postRestCall(jsonSpec,VARIANT_SEARCH_URL)
    }




    public int  refreshVariantsForChromosome(String chromosomeName) {//region
        int  returnValue    = 1
        Variant.deleteVariantsForChromosome(chromosomeName)
        JSONObject apiResults = gatherVariantsForChromosomeResults( chromosomeName)
        if (!apiResults.is_error)  {
            int numberOfVariants = apiResults.numRecords
            def variants =  apiResults.variants
            for ( int  i = 0 ; i < numberOfVariants ; i++ )  {
                String varId =   variants[i].ID
                String dbSnpId =   variants[i].DBSNP_ID
                Long position =   variants[i].POS
                String  chromosome =   variants[i].CHROM
                Variant.refresh(varId,dbSnpId,chromosome,position)
            }
        }

        return returnValue
    }






    private JSONObject gatherVariantsForChromosomeByChunkResults(String chromosomeName,int chunkSize,int startingPosition){
//        String jsonSpec =  """{
//    "filters":    [
//                    {"operand": "CHROM", "operator": "EQ", "value": "${chromosomeName}", "filter_type": "STRING"},
//                    {"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${startingPosition} },
//                    {"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": 3200000000 }                ],
//      "columns": ["ID","DBSNP_ID","CHROM","POS"],
//      "limit":${ chunkSize}
//}
//}
//""".toString()
        String jsonSpec =  """{
    "passback": "123abc",
    "entity": "variant",
    "page_number": 0,
    "page_size": 100,
    "count": false,
    "properties":    {
                           "cproperty": ["VAR_ID","DBSNP_ID","POS", "CHROM"],
                          "orderBy":    ["POS"],
                          "dproperty":    {
                                        },
                        "pproperty":    {
                                        }
                    },
    "filters":    [
                      {"dataset_id": "blah", "phenotype": "blah", "operand": "CHROM", "operator": "EQ", "value": "${chromosomeName}", "operand_type": "STRING"},
                      {"dataset_id": "blah", "phenotype": "blah", "operand": "POS", "operator": "GTE", "value": ${startingPosition}, "operand_type": "INTEGER"}

                ]
}
""".toString()
        return postRestCall(jsonSpec,GET_DATA_URL)
    }






    public LinkedHashMap<String, Integer>  refreshVariantsForChromosomeByChunk(String chromosomeName,int chunkSize,int startingPosition) {//region
        LinkedHashMap<String, Integer>  returnValue    = [numberOfVariants:0,lastPosition:0]
        JSONObject apiResults = gatherVariantsForChromosomeByChunkResults( chromosomeName, chunkSize,  startingPosition)
        if (!apiResults.is_error)  {
            int numberOfVariants = apiResults.numRecords
            returnValue.numberOfVariants =  numberOfVariants
            def variants =  apiResults.variants
            for ( int  i = 0 ; i < numberOfVariants ; i++ )  {
                def variant = apiResults.variants[i];

                String varId =   variant["VAR_ID"].findAll{it}[0]
                String dbSnpId =   variant["DBSNP_ID"].findAll{it}[0]
                Long position =   variant["POS"].findAll{it}[0]
                String  chromosome =   variant["CHROM"].findAll{it}[0]
                returnValue.lastPosition =  position
                Variant.refresh(varId,dbSnpId,chromosome,position)
            }
        }

        return returnValue
    }


    public LinkedHashMap<String, Integer>  refreshVariantsForChromosomeByChunkNew(String chromosomeName,int chunkSize,int startingPosition) {//region
        LinkedHashMap<String, Integer>  returnValue    = [numberOfVariants:0,lastPosition:0]
        JSONObject apiResults = gatherVariantsForChromosomeByChunkResults( chromosomeName, chunkSize,  startingPosition)
        if (!apiResults.is_error)  {
            int numberOfVariants = apiResults.numRecords
            returnValue.numberOfVariants =  numberOfVariants
            def variants =  apiResults.variants
            returnValue.lastPosition =  sqlService.insertArrayOfVariants(variants, numberOfVariants)
        }

        return returnValue
    }













}
