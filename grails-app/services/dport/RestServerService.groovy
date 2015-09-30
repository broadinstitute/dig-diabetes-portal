package dport
import dport.meta.UserQueryContext
import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.ServerBean
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    FilterManagementService filterManagementService
    MetaDataService metaDataService
    MetadataUtilityService metadataUtilityService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService

    private String PROD_LOAD_BALANCED_SERVER = ""
    private String QA_LOAD_BALANCED_SERVER = ""
    private String DEV_LOAD_BALANCED_SERVER = ""
    private String AWS01_REST_SERVER = ""
    private String DEV_REST_SERVER = ""
    private String BASE_URL = ""
    private String GENE_INFO_URL = "gene-info"
    private String GENE_SEARCH_URL = "gene-search" // TODO: Wipe out, but used for (inefficiently) obtaining gene list.
    private String TRAIT_SEARCH_URL = "trait-search" // TODO: Wipe out
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
    private List<ServerBean> burdenServerList;

    private ServerBean BURDEN_REST_SERVER = null;

   // okay
    static List<String> GENE_COLUMNS = [
            'ID',
            'CHROM',
            'BEG',
            'END',
            'Function_description',
    ]

    //okay
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

    //okay
    static List<String> EXCHP_GENE_COLUMNS = [
            'EXCHP_T2D_VAR_TOTALS',
            'EXCHP_T2D_GWS_TOTAL',
            'EXCHP_T2D_LWS_TOTAL',
            'EXCHP_T2D_NOM_TOTAL',
    ]

    // okay
    static List<String> GWAS_GENE_COLUMNS = [
            'GWS_TRAITS',
            'GWAS_T2D_GWS_TOTAL',
            'GWAS_T2D_LWS_TOTAL',
            'GWAS_T2D_NOM_TOTAL',
            'GWAS_T2D_VAR_TOTAL',
    ]


    /***
     * plug together the different collections of column specifications we typically use
     */
    public void initialize() {
        //current

        // load balancer with rest server(s) behind it
        PROD_LOAD_BALANCED_SERVER = grailsApplication.config.t2dProdLoadBalancedServer.base + grailsApplication.config.t2dProdLoadBalancedServer.name + grailsApplication.config.t2dProdLoadBalancedServer.path

        // qa load balancer with rest server(s) behind it
        QA_LOAD_BALANCED_SERVER = grailsApplication.config.t2dQaLoadBalancedServer.base + grailsApplication.config.t2dQaLoadBalancedServer.name + grailsApplication.config.t2dQaLoadBalancedServer.path

        // test load balancer with rest server(s) behind it
        DEV_LOAD_BALANCED_SERVER = grailsApplication.config.t2dDevLoadBalancedServer.base + grailsApplication.config.t2dDevLoadBalancedServer.name + grailsApplication.config.t2dDevLoadBalancedServer.path

        // dev rest server, not load balanced
        DEV_REST_SERVER = grailsApplication.config.t2dDevRestServer.base + grailsApplication.config.t2dDevRestServer.name + grailsApplication.config.t2dDevRestServer.path

        // 'aws01'
        AWS01_REST_SERVER = grailsApplication.config.t2dAws01RestServer.base + grailsApplication.config.t2dAws01RestServer.name + grailsApplication.config.t2dAws01RestServer.path

        //
        //
        BASE_URL = grailsApplication.config.server.URL
        DBT_URL = grailsApplication.config.dbtRestServer.URL
        EXPERIMENTAL_URL = grailsApplication.config.experimentalRestServer.URL

        this.BURDEN_REST_SERVER = grailsApplication.config.burdenRestServer;

       // pickADifferentRestServer(QA_LOAD_BALANCED_SERVER)

    }


    // current below

    public String getDevLoadBalanced() {
        return DEV_LOAD_BALANCED_SERVER;
    }

    public String getAws01RestServer() {
        return AWS01_REST_SERVER;
    }

    public String getProdLoadBalanced() {
        return PROD_LOAD_BALANCED_SERVER;
    }

    public String getQaLoadBalanced() {
        return QA_LOAD_BALANCED_SERVER;
    }
    private List<String> getGeneColumns() {
        return GENE_COLUMNS + EXSEQ_GENE_COLUMNS + EXCHP_GENE_COLUMNS + GWAS_GENE_COLUMNS
    }


    private String getDataHeader (Integer pageNumber,
                                  Integer pageSize,
                                  Integer limit,
                                  Boolean count){
        return """    "passback": "123abc",
    "entity": "variant",
    "page_number": ${pageNumber.toString()},
    "page_size": ${pageSize.toString()},
    "limit": ${limit.toString()},
    "count": ${(count)?"true": "false"},""".toString()
    }




    private filterByVariant(String variantName) {
        String returnValue
        String uppercaseVariantName = variantName?.toUpperCase()
        if (uppercaseVariantName?.startsWith("RS")) {
            returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "DBSNP_ID", "operator": "EQ", "value": "${
                uppercaseVariantName
            }", "operand_type": "STRING"}"""
        } else {
            // be prepared to substitute underscores for dashes, since dashes are an alternate form
            //  for naming variants, but in the database we use only underscores
            List <String> dividedByDashes = uppercaseVariantName?.split("-")
            if ((dividedByDashes) &&
                    (dividedByDashes.size()>2)){
                int isThisANumber = 0
                try {
                    isThisANumber = Integer.parseInt(dividedByDashes[0])
                }catch(e){
                    // his is only a test. An exception here is not a problem
                }
                if (isThisANumber > 0){// okay -- let's do the substitution
                    uppercaseVariantName = uppercaseVariantName.replaceAll('-','_')
                }
            }
            returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "VAR_ID", "operator": "EQ", "value": "${
                uppercaseVariantName
            }", "operand_type": "STRING"}"""
        }
        return returnValue
    }


    private String jsonForGeneralApiSearch(String combinedFilterList) {
        String inputJson = """
{
${getDataHeader (0, 100, 1000, false)}
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


    private String jsonForCustomColumnApiSearch(String combinedFilterList, LinkedHashMap requestedProperties) {
        LinkedHashMap resultColumnsToFetch = getColumnsToFetch("[" + combinedFilterList + "]",  requestedProperties)
        String inputJson = """
{
${getDataHeader (0, 100, 1000, false)}
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

    public void goWithTheProdLoadBalancedServer() {
        pickADifferentRestServer(PROD_LOAD_BALANCED_SERVER)
    }

    public void goWithTheQaLoadBalancedServer() {
        pickADifferentRestServer(QA_LOAD_BALANCED_SERVER)
    }


    public void goWithTheDevLoadBalancedServer() {
        pickADifferentRestServer(DEV_LOAD_BALANCED_SERVER)
    }

    public void goWithTheAws01RestServer() {
        pickADifferentRestServer(AWS01_REST_SERVER)
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

    public List<ServerBean> getBurdenServerList() {
        if (this.burdenServerList == null) {
            // add in all known servers
            // could do this in config.groovy
            this.burdenServerList = new ArrayList<ServerBean>();
            this.burdenServerList.add(this.BURDEN_REST_SERVER);
            this.burdenServerList.add(new ServerBean("dummy server", this.BURDEN_REST_SERVER?.getUrl()));
        }

        return this.burdenServerList;
    }

    public void changeBurdenServer(String serverName) {
        for (ServerBean serverBean : this.burdenServerList) {
            if (serverBean.getName().equals(serverName)) {
                log.info("changing burden rest server from: " + this.BURDEN_REST_SERVER.getUrl() + " to: " + serverBean.getUrl());
                this.BURDEN_REST_SERVER = serverBean;
                break;
            }
        }
    }

    /**
     * get the current burden rest server
     *
     * @return
     */
    public ServerBean getCurrentBurdenServer() {
        return this.BURDEN_REST_SERVER
    }

    public String whatIsMyCurrentServer() {
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

    /**
     * burden call to the REST server
     *
     * @param jsonString
     * @return
     */
    public JSONObject postBurdenRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, "", this.getCurrentBurdenServer()?.getUrl());
        return tempObject;
    }

    /**
     * post a getData call with the given json string
     *
     * @param jsonString
     * @return
     */
    public JSONObject postGetDataCall(String jsonString) {
        return this.postRestCall(jsonString, this.GET_DATA_URL);
    }

    private JSONObject postRestCall(String drivingJson, String targetUrl) {
        return postRestCallBase(drivingJson, targetUrl, currentRestServer())
    }

    public JSONObject postDataQueryRestCall(GetDataQueryHolder getDataQueryHolder) {
        QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder()
        String drivingJson = queryJsonBuilder.getQueryJsonPayloadString(getDataQueryHolder.getGetDataQuery())
        return postRestCallBase(drivingJson, this.GET_DATA_URL, currentRestServer())
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

    // for now let's do a pseudo call
    JSONObject retrieveDatasetsFromMetadata(List<String> sampleGroupList,
                                            List<String> experimentList) {
        JSONObject result
        result = sharedToolsService.getMetadata()
        println 'meta-data retrieved'
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
        String drivingJson =
                """
{
${getDataHeader (0, 100, 1, false)}
  "properties" : {
    "cproperty" : ["CHROM", "POS"],
    "orderBy" : ["CHROM"],
    "dproperty" : {},
    "pproperty" : {}
  },
  "filters" : [
    ${filterByVariant(variantId)}
  ]
}""".toString()
        returnValue = postRestCall( drivingJson, GET_DATA_URL)
        return returnValue
    }


    String generateDataRestrictionFilters (){
        StringBuilder sb = new  StringBuilder ()
        if (sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)) {
            sb << """,
{ "filter_type": "STRING", "operand": "IN_EXSEQ",  "operator": "EQ","value": "1"  }
""".toString()
        }
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
//        List <String> filterList= filterManagementService.retrieveFilters(geneName,significance,dataSetId,geneRegion,"")
//        String packagedFilters = sharedToolsService.packageUpEncodedParameters(filterList)

        String packagedFilters = filterManagementService.retrieveFilters(geneName,significance,dataSetId,geneRegion,"")
        String geneCountRequest = """
{
${getDataHeader (0, 100, 1000, true)}
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
${getDataHeader (0, 100, 1000, false)}
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
${getDataHeader (0, 100, 1000, false)}
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
${getDataHeader (0, 100, 1000, false)}
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
    private String generalizedAncestryDataSet (String ethnicity){
        String dataSetId = ""
        switch (ethnicity){
            case "HS":
                dataSetId = "hs"
                break;
            case "AA":
                dataSetId = "aa"
                break;
            case "EA":
                dataSetId = "ea"
                break;
            case "SA":
                dataSetId = "sa"
                break;
            case "EU":
                dataSetId = "eu"
                break;
            case "chipEu":
                dataSetId = "exchp"
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
        String codeForMafSlice = ""
        String codeForEthnicity = generalizedAncestryDataSet ( ethnicity)
        dataSetId = ancestryDataSet ( ethnicity)
        switch (cellNumber){
            case 0:
                codeForMafSlice = "total"
                break;
            case 1:
                codeForMafSlice = "total"
                break;
            case 2:
                codeForMafSlice = "common"
                break;
            case 3:
                codeForMafSlice = "lowfreq"
                break;
            case 4:
                codeForMafSlice = "rare"
                break;
            default:
                log.error("Trouble: user requested cell number = ${cellNumber} which I don't recognize")
                dataSetId = EXOMESEQ_AA
        }
//        List <String> filterList= filterManagementService.retrieveFilters(geneName,"","","","${codeForMafSlice}-${codeForEthnicity}")
//        String packagedFilters = sharedToolsService.packageUpEncodedParameters(filterList)
        String packagedFilters = filterManagementService.retrieveFilters(geneName,"","","","${codeForMafSlice}-${codeForEthnicity}")
        String jsonVariantCountByGeneAndMaf = """
{
${getDataHeader (0, 100, 1000, true)}
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
	              ${packagedFilters}
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
${getDataHeader (0, 100, 1, false)}
	"properties":	{
           				"cproperty": ["VAR_ID"],
                  		"orderBy":	[],
                  		"dproperty":	{},
                		"pproperty":	{
${retrieveParticipantCount}
                         }
                	},
	"filters":	[
                ${packagedFilters}
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
${getDataHeader (0, 100, 1, false)}
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
        List<String> commonProperties = [] // default common properties

        if (!requestedProperties){
            commonProperties << "CLOSEST_GENE"
            commonProperties << "VAR_ID"
            commonProperties << "DBSNP_ID"
            commonProperties << "Protein_change"
            commonProperties << "Consequence"
            commonProperties << "CHROM"
            commonProperties << "POS"
        }

        //  if we don't have a better idea then launch the search based on the filters.  Otherwise used our stored criteria
        if (!requestedProperties) {
            JsonSlurper slurper = new JsonSlurper()
            for (def parsedFilter in slurper.parseText(filterJson)) {
                datasetsToFetch << parsedFilter.dataset_id
                phenotypesToFetch << parsedFilter.phenotype
                propertiesToFetch << parsedFilter.operand
            }
       }

        // if specific data sets are requested then add them to the list
        if (requestedProperties)   {
            requestedProperties?.each{ String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype!='common'){
                    phenotypeProperties?.each { String datasetName, v ->
                        if (datasetName != 'common') {
                            datasetsToFetch << datasetName
                        } else {
                            if (v?.size() > 0) {
                                for (String dataset in v) {
                                    if (dataset != 'common') {
                                        datasetsToFetch << dataset
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Add properties specific to a data set
        if (requestedProperties)   {
            requestedProperties?.each{ String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype == 'common') {
                    phenotypeProperties?.each { String datasetName, v ->
                        if (v?.size() > 0) {
                            for (String property in v) {
                                if (!propertiesToFetch.contains(property)) {
                                    propertiesToFetch << property
                                }
                            }
                        }
                    }
                }
            }
        }
        if (requestedProperties)   {
            requestedProperties?.each{ String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype == 'common') {
                    phenotypeProperties?.each { String datasetName, v ->
                        if (datasetName == 'common'){
                            commonProperties = []
                            if (v?.size() > 0) {
                                for (String property in v) {
                                         commonProperties << property
                                }
                            }

                        }
                    }
                }
            }
        }



        if (requestedProperties)   {
            requestedProperties?.each{ String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype != 'common') {
                    if (!phenotypesToFetch.contains(phenotype)) {
                        phenotypesToFetch << phenotype
                    }
                }
            }
        }

 // If you include the below conditional on (!requestedProperties) then you have the ability to remove properties, but
 //  it can be difficult to add new sample groups.
 //       if (!requestedProperties)   {
            for (String pheno in phenotypesToFetch) {
                for (String ds in datasetsToFetch) {
                    propertiesToFetch += metaDataService.getPhenotypeSpecificSampleGroupPropertyList(pheno,ds,[/^MINA/,/^MINU/,/^(OR|ODDS|BETA)/,/^P_(EMMAX|FIRTH|FE|VALUE)/])
                }
            }
      //  }

        // Adding Phenotype specific properties
        propertiesToFetch = expandPropertyList( propertiesToFetch,  requestedProperties)
        if (!requestedProperties) {
            commonProperties = expandCommonPropertyList(commonProperties, requestedProperties)
        }

        LinkedHashMap columnsToDisplayStructure = sharedToolsService.getColumnsToDisplayStructure(processedMetadata, phenotypesToFetch, datasetsToFetch, propertiesToFetch,commonProperties)
        println(columnsToDisplayStructure)
        return columnsToDisplayStructure
    }

    public LinkedHashMap getColumnsToFetch(String filterJson,LinkedHashMap requestedProperties) {
        LinkedHashMap columnsToDisplay = getColumnsToDisplay(filterJson, requestedProperties)
        LinkedHashMap returnValue = [:]
        returnValue.dproperty = [:]
        returnValue.pproperty = [:]
        // var id is required
        returnValue.cproperty = columnsToDisplay.cproperty+"VAR_ID"


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
        List <UserQueryContext> userQueryContextList = []
        userQueryContextList << new UserQueryContext([propertyCategory:"PVALUE_LTE", phenotype:phenotypeName,sampleGroup: "custom",customSampleGroup:dataSet, value:maximumPValue.toString()])
        userQueryContextList << new UserQueryContext([propertyCategory:"PVALUE_GTE", phenotype:phenotypeName,sampleGroup: "custom",customSampleGroup:dataSet, value:minimumPValue.toString()])
        String filters = filterManagementService.generateMultipleFilters(userQueryContextList)
        String jsonSpec = """
{
${getDataHeader (0, 100, 3000, false)}
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
                  ${filters}
        ]
}
""".toString()
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






    private String generateTraitPerVariantJson (String variantName){
        String dirMatchers =   metadataUtilityService.createPhenotypePropertyFieldRequester(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("DIR", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        String betaMatchers =  metadataUtilityService.createPhenotypePropertyFieldRequester(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("BETA", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        String orMatchers = metadataUtilityService.createPhenotypePropertyFieldRequester(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("ODDS_RATIO", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        String pValueMatchers =  metadataUtilityService.createPhenotypePropertyFieldRequester(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("P_VALUE", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        String sampleGroupsWithMaf =  metadataUtilityService.createSampleGroupPropertyFieldRequester(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("MAF", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        String filterForParticularVariant = filterByVariant(variantName)
        String jsonSpec = """
{
${getDataHeader (0, 100, 10, false)}
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






    private JSONObject gatherTraitPerVariantResults(String variantName){
        String jsonSpec = generateTraitPerVariantJson( variantName)
        return postRestCall(jsonSpec,GET_DATA_URL)
    }



    public JSONObject getTraitPerVariant(String variantName ) {//region

        JSONObject returnValue
        def slurper = new JsonSlurper()
        String apiData = gatherTraitPerVariantResults(variantName)
        LinkedHashMap <String, String> betaMatchersMap =   metadataUtilityService.createPhenotypeSampleGroupMap(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("BETA", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        LinkedHashMap <String, String> orMatchersMap =   metadataUtilityService.createPhenotypeSampleGroupMap(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("ODDS_RATIO", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        LinkedHashMap <String, String> pValueMatchersMap =   metadataUtilityService.createPhenotypeSampleGroupMap(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("P_VALUE", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        List<String> sampleGroupsContainingMafList =   metadataUtilityService.createSampleGroupPropertyList(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("MAF", sharedToolsService.getCurrentDataVersion (), "GWAS"))
        LinkedHashMap<String,List<String>> phenotypeSampleGroupNameMap =   metadataUtilityService.createPhenotypeSampleNameMapper(
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("P_VALUE", sharedToolsService.getCurrentDataVersion (), "GWAS"))
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
                    if (element) {
                        betaMatchersMap.each{ String phenotypeName, String sampleGroupId ->
                            sb  << "{\"level\":\"DIR^${phenotypeName}\",\"count\":${element[sampleGroupId][phenotypeName]}},"
                        }
                    }

                    phenotypeSampleGroupNameMap.each { String sampleGroupId, List sgHolder ->
                        if ((sgHolder) && (sgHolder.size()>0)){
                            sb << "{\"level\":\"MAPPER^${sampleGroupId}\",\"count\":\"${sgHolder.join(",")}\"},"
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
        return postRestCall(jsonSpec,GENE_SEARCH_URL) // TODO: change to new API
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


    private JSONObject gatherVariantsForChromosomeByChunkResults(String chromosomeName,int chunkSize,int startingPosition){
        String jsonSpec =  """{
${getDataHeader (0, 100, 1000, false)}
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
