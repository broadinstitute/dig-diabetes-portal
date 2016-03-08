package org.broadinstitute.mpg

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.ServerBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    FilterManagementService filterManagementService
    MetaDataService metaDataService
    MetadataUtilityService metadataUtilityService
    SearchBuilderService searchBuilderService
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
    private String METADATA_URL = "getMetadata"
    private String GET_DATA_URL = "getData"
    private String DBT_URL = ""
    private String EXPERIMENTAL_URL = ""
    public static String TECHNOLOGY_GWAS = "GWAS"
    public static String TECHNOLOGY_EXOME_SEQ = "ExSeq"
    public static String TECHNOLOGY_EXOME_CHIP = "ExChip"
    public static String ANCESTRY_AA = "AA"
    public static String ANCESTRY_HS = "HS"
    public static String ANCESTRY_EA = "EA"
    public static String ANCESTRY_SA = "SA"
    public static String ANCESTRY_EU = "EU"
    public static String ANCESTRY_NONE = "none"
    public static String EXPERIMENT_DIAGRAM = "DIAGRAM"
    public static String EXOMESEQUENCEPVALUE = "P_FIRTH_FE_IV"
    public static String GWASDATAPVALUE = "P_VALUE"
    public static String EXOMECHIPPVALUE = "P_VALUE"
    private String ORCHIP = "ODDS_RATIO"
    private String SIGMADATAPVALUE = "P_VALUE"
    private String DEFAULTPHENOTYPE = "T2D"
    private String MAFPHENOTYPE = "MAF"
    private String GWASDATAOR = "ODDS_RATIO"
    private String EXOMECHIPOR = "ODDS_RATIO"
    private String EXOMESEQUENCEOR = "OR_FIRTH_FE_IV"
    private String HETEROZYGOTE_AFFECTED = "HETA"
    private String HETEROZYGOTE_UNAFFECTED = "HETU"
    private String MINORALLELECOUNTS_AFFECTED = "MINA"
    private String MINORALLELECOUNTS_UNAFFECTED = "MINU"
    private String HOMOZYGOTE_AFFECTED = "HOMA"
    private String HOMOZYGOTE_UNAFFECTED = "HOMU"
    private String OBSERVED_AFFECTED = "OBSA"
    private String OBSERVED_UNAFFECTED = "OBSU"

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
        EXPERIMENTAL_URL = grailsApplication.config.experimentalRestServer.URLburdenRestServer

        this.BURDEN_REST_SERVER = grailsApplication.config.burdenRestServerProd;

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

    private codedfilterByVariant(String variantName) {
        String returnValue
        String uppercaseVariantName = variantName?.toUpperCase()
        if (uppercaseVariantName?.startsWith("RS")) {
            returnValue = """11=DBSNP_ID|${uppercaseVariantName}"""
        } else {
            // be prepared to substitute underscores for dashes, since dashes are an alternate form
            //  for naming variants, but in the database we use only underscores
            List<String> dividedByDashes = uppercaseVariantName?.split("-")
            if ((dividedByDashes) &&
                    (dividedByDashes.size() > 2)) {
                int isThisANumber = 0
                try {
                    isThisANumber = Integer.parseInt(dividedByDashes[0])
                } catch (e) {
                    // his is only a test. An exception here is not a problem
                }
                if (isThisANumber > 0) {// okay -- let's do the substitution
                    uppercaseVariantName = uppercaseVariantName.replaceAll('-', '_')
                }
            }
            returnValue = """11=VAR_ID|${uppercaseVariantName}"""
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

    public String currentRestServer() {
        return BASE_URL;
    }

    public List<ServerBean> getBurdenServerList() {
        if (this.burdenServerList == null) {
            // add in all known servers
            // could do this in config.groovy
            this.burdenServerList = new ArrayList<ServerBean>();
            this.burdenServerList.add(grailsApplication.config.burdenRestServerDev);
            this.burdenServerList.add(grailsApplication.config.burdenRestServerProd);
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


    public String getSampleGroup(String technology, String experiment, String ethnicity) {
        String dataSize = "17k"
        String returnValue = ""
        switch (technology) {
            case TECHNOLOGY_GWAS:
                returnValue = "${TECHNOLOGY_GWAS}_${experiment}_${sharedToolsService.getCurrentDataVersion()}"
                break;
            case TECHNOLOGY_EXOME_SEQ:
                switch (ethnicity) {
                    case ANCESTRY_AA:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_aa_genes_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    case ANCESTRY_HS:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_hs_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    case ANCESTRY_EA:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_ea_genes_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    case ANCESTRY_SA:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_sa_genes_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    case ANCESTRY_EU:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_eu_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    case ANCESTRY_NONE:
                        returnValue = "${TECHNOLOGY_EXOME_SEQ}_${dataSize}_${sharedToolsService.getCurrentDataVersion()}"
                        break;
                    default:
                        log.error("Unexpected ethnicity=${ethnicity}")
                        break
                }
                break;
            case TECHNOLOGY_EXOME_CHIP:
                returnValue = "${TECHNOLOGY_EXOME_CHIP}_82k_${sharedToolsService.getCurrentDataVersion()}"
                break;
            default: // if we don't recognize the data set then assume the reference verbatim
                returnValue = technology
                break

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
    private String getRestCallBase(String targetUrl, String currentRestServer) {
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

    /**
     * burden call to the REST server
     *
     * @param jsonString
     * @return
     */
    public JSONObject postBurdenRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, "", this.getCurrentBurdenServer()?.getRestServiceCallUrl(ServerBean.BURDEN_TEST_CALL_V2));
        return tempObject;
    }

    /**
     * burden call to the REST server
     *
     * @param jsonString
     * @return
     */
    public JSONObject getRestBurdenGetPhenotypesCall() {
        String tempObject = this.getRestCallBase(ServerBean.BURDEN_TEST_CALL_GET_PHENOTYPES_WITH_SLASH, this.getCurrentBurdenServer()?.url);
        JSONObject returnJson = new JSONObject(tempObject)
        return returnJson;
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

    /***
     * retrieve information about a gene specified by name
     *
     * @param geneName
     * @return
     */
    JSONObject retrieveGeneInfoByName(String geneName) {
        JSONObject returnValue = null
        String drivingJson = """{
"gene_symbol": "${geneName}",
"user_group": "ui",
"columns": [${"\"" + getGeneColumns().join("\",\"") + "\""}]
}
""".toString()
        returnValue = postRestCall(drivingJson, GENE_INFO_URL)
        return returnValue
    }

    /***
     * retrieve information about a variant specified by name. Note that the backend routine
     * can support variant name aliases
     *
     * @param variantId
     * @return
     */
    JSONObject retrieveVariantInfoByName(String variantId) {
        String filters = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["CHROM", "POS"])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filters], searchBuilderService, metaDataService)
        JsonSlurper slurper = new JsonSlurper()
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     *   search for a trait on the basis of a region specification
     * @param chromosome
     * @param beginSearch
     * @param endSearch
     * @return
     */
    JSONObject searchForTraitBySpecifiedRegion(String chromosome, String beginSearch, String endSearch) throws PortalException {
        // local variables
        List<org.broadinstitute.mpg.diabetes.metadata.Phenotype> phenotypeList = null;
        int beginSearchNumber, endSearchNumber;

        // get the phenotype list
        // DIGP-291: centralize metadata version
        phenotypeList = this.metaDataService.getPhenotypeListByTechnologyAndVersion("GWAS", this.metaDataService?.getDataVersion());

        try {
            beginSearchNumber = Integer.valueOf(beginSearch).intValue();
            endSearchNumber = Integer.valueOf(endSearch).intValue();
        } catch (NumberFormatException exception) {
            throw new PortalException("searchForTraitBySpecifiedRegion: Got number format exception for start: " + beginSearch + " and end: " + endSearch);
        }

        // submit query
        JSONObject jsonObject = this.metaDataService.getTraitSearchResultForChromosomeAndPositionAndPhenotypes(phenotypeList, chromosome, beginSearchNumber, endSearchNumber);

        // return
        return jsonObject;

    }

    public String convertKnownDataSetsToRealNames(String dataSet) {
        String returnValue = dataSet
        switch (dataSet) {
            case TECHNOLOGY_GWAS:
                returnValue = getSampleGroup(dataSet, EXPERIMENT_DIAGRAM, ANCESTRY_NONE)
                break;
            case TECHNOLOGY_EXOME_SEQ:
                returnValue = getSampleGroup(dataSet, "none", ANCESTRY_NONE)
                break;
            case TECHNOLOGY_EXOME_CHIP:
                returnValue = getSampleGroup(dataSet, "none", ANCESTRY_NONE)
                break;
            default:
                break;
        }
        return returnValue
    }

    /***
     * Generate the numbers for the 'variants and associations' table on the gene info page
     *
     * @param geneName
     * @param significanceIndicator
     * @param dataSet
     * @return
     */
    public JSONObject requestGeneCountByPValue(String geneName, Float significanceIndicator, String dataSet, String phenotype, String technology) {
        String geneRegion
        // known special case data sets
        switch (technology) {
            case RestServerService.TECHNOLOGY_GWAS:
                geneRegion = sharedToolsService.getGeneExpandedRegionSpec(geneName)
                break;
            default:
                break;

        }
        Float significance = significanceIndicator
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["CHROM", "POS"])
        List<String> codedFilters = filterManagementService.retrieveFiltersCodedFilters(geneName, significance, dataSet, geneRegion, technology, phenotype)
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(codedFilters, searchBuilderService, metaDataService)
        Boolean isCount = true;
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        getDataQueryHolder.isCount(isCount);
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Private counterpart for combinedVariantAssociationStatistics, which gets the numbers for the
     * variant and associations boxes across the top of the variant info page
     *
     * @param variantId
     * @return
     */
    private JSONObject variantAssociationStatisticsSection(String variantId, String phenotype, List<LinkedHashMap> linkedHashMapList) {
        // First set up the common elements in the search
        String filterByVariantName = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CLOSEST_GENE", "GENE", "MOST_DEL_SCORE"])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        for (LinkedHashMap linkedHashMap in linkedHashMapList) {
            String dataSet = linkedHashMap.name
            String pValue = linkedHashMap.pvalue
            String orValue = linkedHashMap.orvalue
            String betaValue = linkedHashMap.betavalue
            if ((pValue) && (pValue.length() > 0)) {
                addColumnsForPProperties(resultColumnsToDisplay, phenotype,
                        dataSet,
                        pValue)
            }
            if ((orValue) && (orValue.length() > 0)) {
                addColumnsForPProperties(resultColumnsToDisplay, phenotype,
                        dataSet,
                        orValue)
            }
            if ((betaValue) && (betaValue.length() > 0)) {
                addColumnsForPProperties(resultColumnsToDisplay, phenotype,
                        dataSet,
                        betaValue)
            }
        }
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Numbers for the variant and associations boxes across the top of the variant info page.  we will combine
     * a collection of common properties, along with some number of data sets/properties
     *
     * @param variantName
     * @return
     */
    public JSONObject combinedVariantAssociationStatistics(String variantName, String phenotype, List<LinkedHashMap> linkedHashMapList) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        //  String attribute = "T2D"
        JSONObject returnValue
        List<Integer> dataSeteList = [1]
        List<String> pValueList = [1]
        JSONObject toReturn = [
            results: new ArrayList<JSONObject>()
        ]
        for (int j = 0; j < dataSeteList.size(); j++) {
            JSONObject datasetObject = [
                    dataset: dataSeteList[j],
                    pVals: new ArrayList<JSONObject>()
            ]
            for (int i = 0; i < pValueList.size(); i++) {

                JSONObject apiResults = variantAssociationStatisticsSection(variantName, phenotype, linkedHashMapList)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0]) && (apiResults.variants[0][0])) {
                        def variant = apiResults.variants[0];

                        List<String> commonProperties = ['DBSNP_ID', 'VAR_ID', 'GENE', 'CLOSEST_GENE', 'MOST_DEL_SCORE']
                        for (String commonProperty in commonProperties) {
                            JSONObject newItem = [
                                dataset: "common",
                                level: commonProperty,
                                count: apiResults.variants[0][commonProperty].findAll { it }[0]
                            ]
                            datasetObject.pVals << newItem
                        }

                        List<String> pValueNames = linkedHashMapList.collect { it.pvalue }.unique()
                        LinkedHashMap pValueDataSets = [:]
                        for (String pValueName in pValueNames) {
                            pValueDataSets[pValueName] = linkedHashMapList.findAll { it.pvalue == pValueName }.collect {
                                it.name
                            }
                        }
                        List<String> orValueNames = linkedHashMapList.collect { it.orvalue }.unique()
                        LinkedHashMap orValueDataSets = [:]
                        for (String orValueName in orValueNames) {
                            orValueDataSets[orValueName] = linkedHashMapList.findAll {
                                it.orvalue == orValueName
                            }.collect { it.name }
                        }
                        List<String> betaValueNames = linkedHashMapList.collect { it.betavalue }.unique()
                        LinkedHashMap betaValueDataSets = [:]
                        for (String betaValueName in betaValueNames) {
                            betaValueDataSets[betaValueName] = linkedHashMapList.findAll {
                                it.betavalue == betaValueName
                            }.collect { it.name }
                        }

                        for (def s in pValueDataSets) {
                            String pValueName = s.getKey()
                            List dataSetNames = s.getValue()
                            if ((dataSetNames) &&
                                    (dataSetNames.size() > 0) &&
                                    (dataSetNames[0])) {
                                for (String dataSetName in dataSetNames) {
                                    String dataSetNameTranslated = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                                    JSONObject newItem = [
                                        meaning: "p_value",
                                        dataset: dataSetNameTranslated,
                                        level: pValueName,
                                        count: variant[pValueName][dataSetName][phenotype]
                                    ]
                                    datasetObject.pVals << newItem
                                }
                            }
                        }
                        for (def s in orValueDataSets) {
                            String orValueName = s.getKey()
                            List dataSetNames = s.getValue()
                            if ((dataSetNames) &&
                                    (dataSetNames.size() > 0) &&
                                    (dataSetNames[0])) {
                                for (String dataSetName in dataSetNames) {
                                    String dataSetNameTranslated = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                                    JSONObject newItem = [
                                        meaning: "or_value",
                                        dataset: dataSetNameTranslated,
                                        level: orValueName,
                                        count: variant[orValueName][dataSetName][phenotype]
                                    ]
                                    datasetObject.pVals << newItem
                                }
                            }
                        }
                        for (def s in betaValueDataSets) {
                            String betaValueName = s.getKey()
                            List dataSetNames = s.getValue()
                            if ((dataSetNames) &&
                                    (dataSetNames.size() > 0) &&
                                    (dataSetNames[0])) {
                                for (String dataSetName in dataSetNames) {
                                    String dataSetNameTranslated = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                                    JSONObject newItem = [
                                        meaning: "beta_value",
                                        dataset: dataSetNameTranslated,
                                        level: betaValueName,
                                        count: variant[betaValueName][dataSetName][phenotype]
                                    ]
                                    datasetObject.pVals << newItem
                                }
                            }

                        }
                    }

                }
            }
            toReturn.results << datasetObject
        }
        return toReturn
    }

    /***
     * Private section associated with howCommonIsVariantAcrossEthnicities, used to fill up the "how common is"
     *  section in variant info
     *
     * @param variantId
     * @return
     */
    private JSONObject howCommonIsVariantSection(String variantId) {
        String filterByVariantName = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "CHROM", "POS"])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_SA)}")
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_HS)}")
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_EA)}")
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_AA)}")
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_EU)}")
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_CHIP, "none", ANCESTRY_NONE)}")
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Retrieve all the numbers necessary to fill up the "how common is" section in variant info
     *
     * @param variantName
     * @return
     */
    public JSONObject howCommonIsVariantAcrossEthnicities(String variantName) {
        JSONObject returnValue
        List<Integer> dataSeteList = [1]
        List<String> pValueList = [1]
        StringBuilder sb = new StringBuilder("{\"results\":[")
        def slurper = new JsonSlurper()
        for (int j = 0; j < dataSeteList.size(); j++) {
            sb << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for (int i = 0; i < pValueList.size(); i++) {
                JSONObject apiResults = howCommonIsVariantSection(variantName)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0]) && (apiResults.variants[0][0])) {
                        def variant = apiResults.variants[0];
                        if (variant["MAF"]) {
                            sb << "{\"level\":\"AA\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_AA)]}},"
                            sb << "{\"level\":\"HS\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_HS)]}},"
                            sb << "{\"level\":\"EA\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_EA)]}},"
                            sb << "{\"level\":\"SA\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_SA)]}},"
                            sb << "{\"level\":\"EUseq\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_EU)]}},"
                            sb << "{\"level\":\"Euchip\",\"count\":${variant["MAF"][getSampleGroup(TECHNOLOGY_EXOME_CHIP, "none", ANCESTRY_NONE)]}}"
                        }
                    }

                }
                if (i < pValueList.size() - 1) {
                    sb << ","
                }
            }
            sb << "]}"
            if (j < dataSeteList.size() - 1) {
                sb << ","
            }
        }
        sb << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }

    /***
     * Private counterpart to combinedVariantDiseaseRisk, which is used to fill the "is variant frequency different for patients with the disease" section
     * of the variant info page
     *
     * @param variantId
     * @return
     */
    private JSONObject variantDiseaseRisk(String variantId) {
        String filterByVariantName = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID"])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${HETEROZYGOTE_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${HETEROZYGOTE_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${MINORALLELECOUNTS_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${MINORALLELECOUNTS_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${HOMOZYGOTE_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${HOMOZYGOTE_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${OBSERVED_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${OBSERVED_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${EXOMESEQUENCEPVALUE}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", "${getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)}", "${EXOMESEQUENCEOR}")
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Provide the numbers to fill the "is variant frequency different for patients with the disease" section
     * of the variant info page
     * @param variantName
     * @return
     */
    public JSONObject combinedVariantDiseaseRisk(String variantName) {
        String attribute = "T2D"
        JSONObject returnValue
        List<Integer> dataSeteList = [1]
        List<String> pValueList = [1]
        StringBuilder sb = new StringBuilder("{\"results\":[")
        def slurper = new JsonSlurper()
        for (int j = 0; j < dataSeteList.size(); j++) {
            sb << "{ \"dataset\": ${dataSeteList[j]},\"pVals\": ["
            for (int i = 0; i < pValueList.size(); i++) {
                JSONObject apiResults = variantDiseaseRisk(variantName)
                if (apiResults.is_error == false) {
                    if ((apiResults.variants) && (apiResults.variants[0]) && (apiResults.variants[0][0])) {
                        def variant = apiResults.variants[0];
                        if (variant["HETA"]) {
                            sb << "{\"level\":\"HETA\",\"count\":${variant["HETA"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["HETU"]) {
                            sb << "{\"level\":\"HETU\",\"count\":${variant["HETU"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant[MINORALLELECOUNTS_AFFECTED]) {
                            sb << "{\"level\":\"${MINORALLELECOUNTS_AFFECTED}\",\"count\":${variant[MINORALLELECOUNTS_AFFECTED][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant[MINORALLELECOUNTS_UNAFFECTED]) {
                            sb << "{\"level\":\"${MINORALLELECOUNTS_UNAFFECTED}\",\"count\":${variant[MINORALLELECOUNTS_UNAFFECTED][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["HOMA"]) {
                            sb << "{\"level\":\"HOMA\",\"count\":${variant["HOMA"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["HOMU"]) {
                            sb << "{\"level\":\"HOMU\",\"count\":${variant["HOMU"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["OBSU"]) {
                            sb << "{\"level\":\"OBSU\",\"count\":${variant["OBSU"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["OBSA"]) {
                            sb << "{\"level\":\"OBSA\",\"count\":${variant["OBSA"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["P_FIRTH_FE_IV"]) {
                            sb << "{\"level\":\"P_FIRTH_FE_IV\",\"count\":${variant["P_FIRTH_FE_IV"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}},"
                        }
                        if (variant["OR_FIRTH_FE_IV"]) {
                            sb << "{\"level\":\"OR_FIRTH_FE_IV\",\"count\":${variant["OR_FIRTH_FE_IV"][getSampleGroup(TECHNOLOGY_EXOME_SEQ, "none", ANCESTRY_NONE)][attribute]}}"
                        }
                    }

                }
                if (i < pValueList.size() - 1) {
                    sb << ","
                }
            }
            sb << "]}"
            if (j < dataSeteList.size() - 1) {
                sb << ","
            }
        }
        sb << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }

    /***
     * we don't want the logic in the JavaScript when we already know what calls we need. Just make one call
     * from the browser and then I will cycle through at this level and get all the data
     * @param geneName
     * @return
     */
    public JSONObject combinedVariantCountByGeneNameAndPValue(String geneName,
                                                              List<String> dataSeteList,
                                                              List<Float> significanceList,
                                                              String phenotype) {
        JSONObject returnValue
        // List <Integer> dataSeteList = [3, 2, 1]
        // List <Integer> significanceList = [1,2,  3, 4]
        StringBuilder sb = new StringBuilder("{\"results\":[")
        def slurper = new JsonSlurper()
        for (int j = 0; j < dataSeteList.size(); j++) {
            SampleGroup sampleGroup = metaDataService.getSampleGroupByName(dataSeteList[j])
            String technology = metaDataService.getTechnologyPerSampleGroup(dataSeteList[j])
            sb << "{ \"dataset\": \"${dataSeteList[j]}\",\"subjectsNumber\": ${sampleGroup?.getSubjectsNumber()}, \"technology\": \"${technology}\", \"pVals\": ["
            for (int i = 0; i < significanceList.size(); i++) {
                sb << "{"
                JSONObject apiData = requestGeneCountByPValue(geneName, significanceList[i], dataSeteList[j], phenotype, technology)
                if (apiData.is_error == false) {
                    sb << "\"level\":\"${significanceList[i]}\",\"count\":${apiData.numRecords}"
                }
                sb << "}"
                if (i < significanceList.size() - 1) {
                    sb << ","
                }
            }
            sb << "]}"
            if (j < dataSeteList.size() - 1) {
                sb << ","
            }
        }
        sb << "]}"
        returnValue = slurper.parseText(sb.toString())
        return returnValue
    }

    /***
     * Used to fill the 'variation across continental ancestry' table on the gene info page
     *
     * @param geneName
     * @param ethnicity
     * @param cellNumber
     * @return
     */
    private JSONObject generateJsonVariantCountByGeneAndMaf(String geneName, LinkedHashMap<String, String> dataSetInfo, LinkedHashMap<String, String> numericBound) {
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID"])
        String dataSetName = dataSetInfo.dataset
        String technology = dataSetInfo.technology
        List<String> codedFilters = filterManagementService.generateSampleGroupLevelQueries(geneName, dataSetName, technology,
                numericBound.lowerValue, numericBound.higherValue, "MAF")
        //List<String> codedFilters = filterManagementService.retrieveFiltersCodedFilters(geneName,0f,"","","${codeForMafSlice}-${codeForEthnicity}","T2D")
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(codedFilters, searchBuilderService, metaDataService)

        // DIGP-300: upping default getData limit to 5k for better MAF counts for HDAC9 gene (was getting counts > 1k)
        getDataQueryHolder.getDataQuery.setLimit(5000)
        JsonSlurper slurper = new JsonSlurper()
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Let's make this the common call for metadata which all callers can share
     * @return
     */
    public String getMetadata() {
        String retdat
        retdat = getRestCall(METADATA_URL)
        return retdat
    }

    /***
     * Make multiple calls to fill up the 'variation across continental ancestries' table, then combine all of those
     * numbers into a single JSON structure which we can return to the browser
     *
     * @param geneName
     * @return
     */
    public JSONObject combinedEthnicityTable(String geneName,
                                             List<LinkedHashMap<String, String>> dataSetNames,
                                             List<LinkedHashMap<String, String>> numericBounds) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        JSONObject returnValue
        ArrayList<JSONObject> resultsArray = new ArrayList<JSONObject>()
        for (int j = 0; j < dataSetNames.size(); j++) {
            String datasetDisplayName = g.message(code: "metadata." + dataSetNames[j].dataset, default: dataSetNames[j].dataset)
            JSONObject dataSetObject = [dataset: dataSetNames[j].dataset,
                                        datasetDisplayName: datasetDisplayName,
                                        technology: dataSetNames[j].technology]
            ArrayList<JSONObject> pValsArray = new ArrayList<JSONObject>()
            for (int i = 0; i < numericBounds.size(); i++) {
                JSONObject pValObject
                JSONObject apiResults = generateJsonVariantCountByGeneAndMaf(geneName, dataSetNames[j], numericBounds[i])
                if (apiResults.is_error == false) {
                    if (i == 0) {
                        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(dataSetNames[j].dataset)
                        pValObject = [level: i, count: sampleGroup.getSubjectsNumber()]
                    } else {
                        pValObject = [level: i, count: apiResults.numRecords]
                    }
                    pValsArray << pValObject
                }
            }

            dataSetObject.pVals = pValsArray
            resultsArray << dataSetObject
        }
        ArrayList<JSONObject> colInfo = new ArrayList<JSONObject>()
        for (int i = 0; i < numericBounds.size(); i++) {
            JSONObject col = [lowerValue: numericBounds[i].lowerValue,
                              higherValue: numericBounds[i].higherValue]
            colInfo << col
        }

        return [results: resultsArray, columns: colInfo]
    }

    /***
     * private counterpart to gatherProteinEffect, which gathers protein transcript information
     * @param variantName
     * @return
     */
    private JSONObject gatherProteinEffectResults(String variantName) {
        String filterByVariantName = codedfilterByVariant(variantName)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["TRANSCRIPT_ANNOT", "MOST_DEL_SCORE", "VAR_ID", "DBSNP_ID"])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Provide a variant name and get back a description of the different isoforms
     * @param variantName
     * @return
     */
    public JSONObject gatherProteinEffect(String variantName) {
        return gatherProteinEffectResults(variantName)
    }

// Add in the additionally requested properties
    private List<String> expandPropertyList(List<String> propertiesToFetch, LinkedHashMap requestedProperties) {
        if (requestedProperties) {
            requestedProperties.each { phenotype, LinkedHashMap dataset ->
                if (phenotype != 'common') {
                    dataset.each { String dataSetName, List propertyList ->
                        for (String property in propertyList) {
                            if (!propertiesToFetch.contains(property)) {
                                propertiesToFetch << property
                            }
                        }
                    }
                }
            }
        }
        return propertiesToFetch
    }


    private List<String> expandCommonPropertyList(List<String> propertiesToFetch, LinkedHashMap requestedProperties) {
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

    /***
     * Create a column map and throw in some C properties
     * @param cProperties
     * @return
     */
    public LinkedHashMap getColumnsForCProperties(List<String> cProperties) {
        LinkedHashMap returnValue = [:]
        List<String> commonProperties = []
        returnValue.cproperty = commonProperties
        returnValue.dproperty = [:]
        returnValue.pproperty = [:]

        if (cProperties) {
            for (String cProperty in cProperties) {
                commonProperties << cProperty
            }
        }

        return returnValue
    }


    public LinkedHashMap addColumnsForDProperties(LinkedHashMap existingMap, String property, String dataSet) {
        LinkedHashMap returnValue = [:]
        LinkedHashMap<String> dataSetProperties = [:]
        if (!existingMap) {
            returnValue.cproperty = []
            returnValue.dproperty = [:]
            returnValue.pproperty = [:]
        } else {
            returnValue = existingMap
        }
        dataSetProperties = returnValue.dproperty

        if ((property) &&
                (dataSet)) {
            if (!dataSetProperties.containsKey("T2D")) {
                dataSetProperties["T2D"] = [:]
            }
            if (!dataSetProperties["T2D"].containsKey(dataSet)) {
                dataSetProperties["T2D"][dataSet] = []
            }
            if (!(dataSetProperties["T2D"][dataSet] in property)) {
                dataSetProperties["T2D"][dataSet] << property
            }
        }

        return returnValue
    }

    /***
     * Add an existing p Property to a column map
     * @param existingMap
     * @param phenotype
     * @param dataSet
     * @param property
     * @return
     */
    public LinkedHashMap addColumnsForPProperties(LinkedHashMap existingMap, String phenotype, String dataSet, String property) {
        LinkedHashMap returnValue = [:]
        LinkedHashMap<String, LinkedHashMap> phenotypeProperties = [:]
        if (!existingMap) {
            returnValue.cproperty = []
            returnValue.dproperty = [:]
            returnValue.pproperty = [:]
        } else {
            returnValue = existingMap
        }
        phenotypeProperties = returnValue.pproperty

        if ((phenotype) &&
                (dataSet) &&
                (property)) {
            if (!phenotypeProperties.containsKey(phenotype)) {
                phenotypeProperties[phenotype] = [:]
            }
            if (!phenotypeProperties[phenotype].containsKey(dataSet)) {
                phenotypeProperties[phenotype][dataSet] = []
            }
            if (!(phenotypeProperties[phenotype][dataSet] in property)) {
                phenotypeProperties[phenotype][dataSet] << property
            }
        }

        return returnValue
    }

    /***
     * Given filters, choose which columns to display by default. Alternatively, if requestedProperties
     * is not empty, then choose only those columns that are specifically requested.
     * Note: this method originally written by JF
     *
     * @param filterJson
     * @param requestedProperties
     * @return
     */
    public LinkedHashMap getColumnsToDisplay(String filterJson, LinkedHashMap requestedProperties) {

        //Get the structure to control the columns we want to display
        // DIGP-170: modified method signature for final push to move to dynamic metadata structure
        // LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()

        //Get the sample groups and phenotypes from the filters
        List<String> datasetsToFetch = []
        List<String> phenotypesToFetch = []
        List<String> propertiesToFetch = []
        List<String> commonProperties = [] // default common properties

        if (!requestedProperties) {
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
        if (requestedProperties) {
            requestedProperties?.each { String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype != 'common') {
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
        if (requestedProperties) {
            requestedProperties?.each { String phenotype, LinkedHashMap phenotypeProperties ->
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
        if (requestedProperties) {
            requestedProperties?.each { String phenotype, LinkedHashMap phenotypeProperties ->
                if (phenotype == 'common') {
                    phenotypeProperties?.each { String datasetName, v ->
                        if (datasetName == 'common') {
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



        if (requestedProperties) {
            requestedProperties?.each { String phenotype, LinkedHashMap phenotypeProperties ->
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
                propertiesToFetch += metaDataService.getPhenotypeSpecificSampleGroupPropertyList(pheno, ds, [/^MINA/, /^MINU/, /^(OR|ODDS|BETA)/, /^P_(EMMAX|FIRTH|FE|VALUE)/])
            }
        }
        //  }

        // Adding Phenotype specific properties
        propertiesToFetch = expandPropertyList(propertiesToFetch, requestedProperties)
        if (!requestedProperties) {
            commonProperties = expandCommonPropertyList(commonProperties, requestedProperties)
        }

        LinkedHashMap columnsToDisplayStructure = sharedToolsService.getColumnsToDisplayStructure(phenotypesToFetch, datasetsToFetch, propertiesToFetch, commonProperties)
        println(columnsToDisplayStructure)
        return columnsToDisplayStructure
    }


    private String orSubstitute(LinkedHashMap properties) {
        String orValue = ""
        if (properties) {
            if (properties.containsKey("BETA")) {
                orValue = "BETA"
            } else if (properties.containsKey("ODDS_RATIO")) {
                orValue = "ODDS_RATIO"
            }
        }
        return orValue
    }

    /***
     * private method that generates the REST API call necessary to gather the datafor the Manhattan plot
     * @param phenotypeName
     * @param dataSet
     * @param properties
     * @param maximumPValue
     * @param minimumPValue
     * @return
     */
    private JSONObject gatherTraitSpecificResults(String phenotypeName, String dataSet, LinkedHashMap properties, BigDecimal maximumPValue, BigDecimal minimumPValue) {
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CLOSEST_GENE", "CHROM", "POS"])
        List<String> filters = []
        String orValue = orSubstitute(properties)
        if (orValue.length() > 0) {
            addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSet, orValue)
        }
        String pValueName = filterManagementService.findFavoredMeaningValue ( dataSet, phenotypeName, "P_VALUE" )
        filters << "17=${phenotypeName}[${dataSet}]${pValueName}<${maximumPValue.toString()}"
        filters << "17=${phenotypeName}[${dataSet}]${pValueName}>${minimumPValue.toString()}"
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters, searchBuilderService, metaDataService)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSet, pValueName)
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", dataSet)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Gather up the data that is used in the Manhattan plot
     *
     * @param phenotypeName
     * @param dataSet
     * @param properties
     * @param maximumPValue
     * @param minimumPValue
     * @return
     */
    public JSONObject getTraitSpecificInformation(String phenotypeName, String dataSet, LinkedHashMap properties, BigDecimal maximumPValue, BigDecimal minimumPValue) {
        JSONObject returnValue
        String orValue = orSubstitute(properties)
        def slurper = new JsonSlurper()
        JSONObject apiResults = gatherTraitSpecificResults(phenotypeName, dataSet, properties, maximumPValue, minimumPValue)

        int numberOfVariants = apiResults.numRecords
        StringBuilder sb = new StringBuilder("{\"results\":[")
        for (int j = 0; j < numberOfVariants; j++) {
            sb << "{ \"dataset\": \"traits\",\"pVals\": ["

            if (apiResults.is_error == false) {
                if ((apiResults.variants) && (apiResults.variants[j]) && (apiResults.variants[j][0])) {
                    def variant = apiResults.variants[j];

                    def element = variant["DBSNP_ID"].findAll { it }[0]
                    sb << "{\"level\":\"DBSNP_ID\",\"count\":\"${element}\"},"

                    element = variant["CHROM"].findAll { it }[0]
                    sb << "{\"level\":\"CHROM\",\"count\":\"${element}\"},"

                    element = variant["POS"].findAll { it }[0]
                    sb << "{\"level\":\"POS\",\"count\":${element}},"

                    element = variant["VAR_ID"].findAll { it }[0]
                    sb << "{\"level\":\"VAR_ID\",\"count\":\"${element}\"},"

                    element = variant["CLOSEST_GENE"].findAll { it }[0]
                    sb << "{\"level\":\"CLOSEST_GENE\",\"count\":\"${element}\"},"

                    element = variant["P_VALUE"].findAll { it }[0]
                    sb << "{\"level\":\"P_VALUE\",\"count\":${element[dataSet][phenotypeName]}},"

                    if (orValue.length() > 0) {
                        element = variant["${orValue}"].findAll { it }[0]
                        sb << "{\"level\":\"${orValue}\",\"count\":\"${element[dataSet][phenotypeName]}\"},"
                    } else {
                        sb << "{\"level\":\"BETA\",\"count\":\"--\"},"
                    }

                    element = variant["MAF"].findAll { it }[0]
                    if ((element) &&
                            (element[dataSet])) {
                        sb << "{\"level\":\"MAF\",\"count\":${element[dataSet]}}"
                    } else {
                        sb << "{\"level\":\"MAF\",\"count\":\"0\"}"
                    }


                }
            }
            sb << "]}"
            if (j < numberOfVariants - 1) {
                sb << ","
            }
        }
        sb << "]}"
        returnValue = slurper.parseText(sb.toString())

        return returnValue
    }






    public JSONObject gatherSpecificTraitsPerVariantResults( String variantName, List<LinkedHashMap<String,String>> propsToUse) {
        String filterByVariantName = codedfilterByVariant(variantName)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CHROM", "POS"])
        for(LinkedHashMap oneReference in propsToUse){
            addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, oneReference.prop)
            Property betaProperty = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(oneReference.phenotype,oneReference.ds,"BETA")
            if (betaProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, betaProperty.name)
            }
            Property orProperty = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(oneReference.phenotype,oneReference.ds,"ODDS_RATIO")
            if (orProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, orProperty.name)
            }
            Property dirProperty = metaDataService.getPropertyByNamePhenotypeAndSampleGroup("DIR",oneReference.phenotype,oneReference.ds)
            if (dirProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, dirProperty.name)
            }
            Property mafProperty = metaDataService.getSampleGroupProperty(oneReference.ds,"MAF")
            if (mafProperty){
                addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, oneReference.ds)
            }

        }
//        List<String> sampleGroupsWithMaf =
//                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion( "MAF", sharedToolsService.getCurrentDataVersion(), "", false ).collect {
//                    it.parent.systemId
//                }
//        for (String sampleGroupWithMaf in sampleGroupsWithMaf) {
//            addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, sampleGroupWithMaf)
//        }
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }





    /***
     * starting with a property name OR a meaning, produce a list of triplets mapping the name/meaning to phenotype and sample group name
     * @param propertyOrMeaning
     * @param technology
     * @return
     */
    private List<LinkedHashMap<String, String>> identifyMatchers(String propertyOrMeaning,String technology){
        List<LinkedHashMap<String, String>> matchers
        if ( (propertyOrMeaning == "P_VALUE") ||
                (propertyOrMeaning == "BETA") ||
                (propertyOrMeaning == "ODDS_RATIO") ) {
            List<Property> propertyList = JsonParser.getService().getAllPropertiesWithMeaningForExperimentOfVersion(propertyOrMeaning, sharedToolsService.getCurrentDataVersion(), technology, false)
            matchers = propertyList.collect { ['pname':it.name,'pheno': it.parent.name, 'ds': it.parent.parent.systemId, 'meaning':propertyOrMeaning] }
        } else {
            matchers = JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion(propertyOrMeaning, sharedToolsService.getCurrentDataVersion(), technology, false).
                    collect { ['pname':it.name,'pheno': it.parent.name, 'ds': it.parent.parent.systemId, 'meaning':propertyOrMeaning] }
        }
        return matchers
    }

    /***
     * given a particular property or meaning, along with the technology, retrieve the P properties we need to use on our request
     * @param resultColumnsToDisplay
     * @param propertyOrMeaning
     * @param technology
     * @return
     */
    private LinkedHashMap buildColumnsRequestForPProperties(LinkedHashMap resultColumnsToDisplay, String propertyOrMeaning, String technology ) {

        List<LinkedHashMap<String, String>> matchers = identifyMatchers( propertyOrMeaning, technology )

        for (LinkedHashMap dirMatcher in matchers) {
            addColumnsForPProperties(resultColumnsToDisplay, dirMatcher.pheno, dirMatcher.ds, dirMatcher.pname)
        }
        return resultColumnsToDisplay
    }

    /***
     * private method that does REST API generation for 'Association statistics across 25 traits'
     * @param variantName
     * @return
     */
    private JSONObject gatherTraitPerVariantResults(String variantName, String technology ) {
        String filterByVariantName = codedfilterByVariant(variantName)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CHROM", "POS"])
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "DIR", technology )
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "BETA", technology )
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "ODDS_RATIO", technology )
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "P_VALUE", technology )
        List<String> sampleGroupsWithMaf =
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion( "MAF", sharedToolsService.getCurrentDataVersion(), technology, false ).collect {
                    it.parent.systemId
                }
        for (String sampleGroupWithMaf in sampleGroupsWithMaf) {
            addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, sampleGroupWithMaf)
        }
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }


    LinkedHashMap<String, String> extractPhenotypeToSampleGroupMapping(String propertyName,JSONObject apiResults, String technology){
        LinkedHashMap<String, String> returnValue = [:]
        if (apiResults.variants.collect{it[propertyName]}[0].findAll { it }.size()>0){
            Set sampleGroups = apiResults.variants.collect{it[propertyName]}[0].findAll { it }[0].keySet()
            for ( String sampleGroupName in sampleGroups ){
                Set phenotypes = apiResults.variants.collect{it[propertyName]}[0]?.collect { it }[sampleGroupName].collect { it }[0].keySet()
                for ( String phenotypeName in phenotypes ){
                    returnValue[phenotypeName] = sampleGroupName
                }
            }
        }
        return returnValue
    }


    List<String> extractSampleGroupListForProperty(String propertyName,JSONObject apiResults){
        log.info(["propertyName": propertyName, "apiResults": apiResults])
        List<String> returnValue = []
        Set sampleGroups = apiResults.variants.collect{it[propertyName]}[0].findAll { it }[0].keySet()
        for ( String sampleGroupName in sampleGroups ){
            returnValue << sampleGroupName
        }
        // need to work out how to do this extraction…
        return returnValue
    }


    public JSONObject getSpecifiedTraitPerVariant( String variantName, List<LinkedHashMap<String,String>> propsToUse, List<String> openPhenotypes) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        JSONObject returnValue = []
        JSONObject apiResults = gatherSpecificTraitsPerVariantResults(variantName, propsToUse)
        int numberOfVariants = apiResults.numRecords

        returnValue.results = new ArrayList<JSONObject>()

        List<String> jsonComponentList = []
        JSONObject variantObject
        if (!apiResults["is_error"]){
            for (int j = 0; j < numberOfVariants; j++) {
                variantObject = [
                        dataset: "traits",
                        openPhenotypes: openPhenotypes,
                        pVals: new ArrayList<JSONObject>()
                ]
                // TODO: finish refactoring this JSON
                List<String> keys = []
                for (int i = 0; i < apiResults.variants[j].size(); i++) {
                    keys << (new JSONObject(apiResults.variants[j][i]).keys()).next()
                }
                for (String key in keys) {
                    ArrayList valueArray = apiResults.variants[j][key]
                    def value = valueArray.findAll { it }[0]
                    if (value instanceof String) {
                        String stringValue = value as String
                        variantObject.pVals << [level: key, count: stringValue]
                    } else if (value instanceof Integer) {
                        Integer integerValue = value as Integer
                        variantObject.pVals << [level: key, count: integerValue]
                    } else if (value instanceof BigDecimal) {
                        BigDecimal bigDecimalValue = value as BigDecimal
                        variantObject.pVals << [level: key, count: bigDecimalValue]
                    } else if (value instanceof Map) {
                        Map mapValue = value as Map
                        List<String> subKeys = mapValue.keySet() as List
                        for (String subKey in subKeys) {
                            def particularMapValue = mapValue[subKey]
                            if (particularMapValue instanceof BigDecimal) {// data set particular values
                                BigDecimal particularMapBigDecimalValue = particularMapValue as BigDecimal
                                variantObject.pVals << [level: "${key}^NONE^${key}^${subKey}", count:particularMapBigDecimalValue]
                            } else if (particularMapValue instanceof Integer) {// data set particular values
                                Integer particularMapIntegerValue = particularMapValue as Integer
                                variantObject.pVals << [level: "${key}^NONE^${key}^${subKey}", count: particularMapIntegerValue]
                            } else if (particularMapValue instanceof Map) {
                                Map particularSubMap = particularMapValue as Map
                                List<String> particularSubKeys = particularSubMap.keySet() as List
                                for (String particularSubKey in particularSubKeys) {
                                    def particularSubMapValue = particularSubMap[particularSubKey]
                                    BigDecimal phenoValue = particularSubMapValue.findAll { it }[0] as BigDecimal
                                    String meaning = metaDataService.getMeaningForPhenotypeAndSampleGroup(key, particularSubKey, subKey)
                                    String translatedName = g.message(code: "metadata." + particularSubKey, default: particularSubKey)
                                    variantObject.pVals << [
                                            level: "${key}^${particularSubKey}^${translatedName}^${meaning}^${subKey}",
                                            count: phenoValue
                                    ]
                                    log.debug("Hey ${phenoValue}")
                                }

                            }
                        }

                    } else if (value instanceof ArrayList) {
                        ArrayList arrayListValue = value as ArrayList
                        log.debug("Hey, ArrayList")
                    }
                }
            }

        }
        returnValue.results << variantObject
        return returnValue
    }




        /***
     * Generate the numbers for the 'Association statistics across 25 traits', which is displayed on the variant info page (elsewhere as well)
     * @param variantName
     * @return
     */
    public JSONObject getTraitPerVariant( String variantName, String technology ) {//region
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        JSONObject apiResults = gatherTraitPerVariantResults( variantName, technology )
        List <String> meaningFieldNames = ["BETA","ODDS_RATIO","P_VALUE","DIR"]
        List<List<LinkedHashMap<String, String>>> meaningBasedMapper = []
        for (String meaningFieldName in meaningFieldNames){
            meaningBasedMapper << identifyMatchers(meaningFieldName, technology)
        }
        List <String> dataSetSpecificProperties = ["MAF"]
        List <List<String>>  dataSetSpecificMapper = []
        for (String dataSetSpecificProperty in dataSetSpecificProperties){
            dataSetSpecificMapper <<  extractSampleGroupListForProperty(dataSetSpecificProperty, apiResults)
        }
       // List<String> sampleGroupsContainingMafList =extractSampleGroupListForProperty("MAF", apiResults)
        int numberOfVariants = apiResults.numRecords
        JSONObject toReturn = []
        toReturn.results = new ArrayList<JSONObject>()
        for (int j = 0; j < numberOfVariants; j++) {
            JSONObject variantObject = [dataset: "traits"]
            variantObject.pVals = new ArrayList<JSONObject>()

            if (apiResults.is_error == false) {
                if ((apiResults.variants) && (apiResults.variants[j]) && (apiResults.variants[j][0])) {
                    def variant = apiResults.variants[j];

                    def element = variant["VAR_ID"].findAll { it }[0]
                    variantObject.pVals << [level: "VAR_ID", count: element]

                    element = variant["DBSNP_ID"].findAll { it }[0]
                    variantObject.pVals << [level: "DBSNP_ID", count: element]

                    element = variant["CHROM"].findAll { it }[0]
                    variantObject.pVals << [level: "CHROM", count: element]

                    for( List<List<String>> dataSetMapper in dataSetSpecificMapper) {
                        element = variant["MAF"].findAll { it }[0]
                        for (String sampleGroupsContainingMaf in dataSetMapper) {
                            JSONObject mafObject = [
                                    level: "MAF^NONE^MAF^${sampleGroupsContainingMaf}",
                                    count: element[sampleGroupsContainingMaf]
                            ]
                            variantObject.pVals << mafObject
                        }
                    }

                    for( List<LinkedHashMap<String, String>> meaningMapper in meaningBasedMapper){
                        for( String valueName in meaningMapper?.collect{it.pname}.unique()){
                            for (LinkedHashMap valueMap in meaningMapper.findAll{it.pname==valueName}){
                                String val = variant["${valueMap.pname}"].findAll{it}[0].findAll{it}["${valueMap.ds}"].findAll{it}["${valueMap.pheno}"] as String
                                String translatedName = g.message(code: "metadata." + valueMap.pheno, default: valueMap.pheno);
                                // not sure of the best description for this object
                                JSONObject thisObject = [
                                        level: "${valueMap.pname}^${valueMap.pheno}^${translatedName}^${valueMap.meaning}^${valueMap.ds}",
                                        count: val
                                ]
                                variantObject.pVals << thisObject
                            }
                        }
                    }


                    element = variant["POS"].findAll { it }[0]
                    variantObject.pVals << [level: "POS", count: element]

                }
            }
            toReturn.results << variantObject
        }
        return toReturn
    }

    /***
     * Note: this call is not used interactively, but used instead to fill the grails domain object that holds
     * all of our genes and extents.
     *
     * Note also: This is the only instance in the portal that calls the gene_search API.  We should find a way to update
     * this call to a regular, maintained API call
     *
     * @param chromosomeName
     * @return
     */
    private JSONObject gatherGenesForChromosomeResults(String chromosomeName) {
        String jsonSpec = """{
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
        return postRestCall(jsonSpec, GENE_SEARCH_URL) // This is an old API call, but we don't have an analogous
        //  : the new API
    }

    /***
     * Note: this call is not used interactively, but used instead to fill the grails domain object that holds
     * all of our genes and extents.
     *
     * @param chromosomeName
     * @return
     */
    public int refreshGenesForChromosome(String chromosomeName) {//region
        int returnValue = 1
        Gene.deleteGenesForChromosome(chromosomeName)
        JSONObject apiResults = gatherGenesForChromosomeResults(chromosomeName)
        if (!apiResults.is_error) {
            int numberOfGenes = apiResults.numRecords
            def genes = apiResults.genes
            for (int i = 0; i < numberOfGenes; i++) {
                String geneName = genes[i].ID
                Long startPosition = genes[i].BEG
                Long endPosition = genes[i].END
                String chromosome = genes[i].CHROM
                Gene.refresh(geneName, chromosome, startPosition, endPosition)
            }
        }

        return returnValue
    }

    /***
     * Note: this call is not used interactively, but used instead to fill the grails domain object that holds
     * all of our genes and extents.
     *
     * @param chromosomeName
     * @param chunkSize
     * @param startingPosition
     * @return
     */
    private JSONObject gatherVariantsForChromosomeByChunkResults(String chromosomeName, int chunkSize, int startingPosition) {
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "POS", "CHROM"])
        List<String> codedFilters = ["8=${chromosomeName}", "9=${startingPosition}"]
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(codedFilters, searchBuilderService, metaDataService)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }


    public LinkedHashMap<String, Integer> refreshVariantsForChromosomeByChunkNew(String chromosomeName, int chunkSize, int startingPosition) {
//region
        LinkedHashMap<String, Integer> returnValue = [numberOfVariants: 0, lastPosition: 0]
        JSONObject apiResults = gatherVariantsForChromosomeByChunkResults(chromosomeName, chunkSize, startingPosition)
        if (!apiResults.is_error) {
            int numberOfVariants = apiResults.numRecords
            returnValue.numberOfVariants = numberOfVariants
            JSONArray variants = apiResults.variants as JSONArray
            returnValue.lastPosition = sqlService.insertArrayOfVariants(variants, numberOfVariants)
        }

        return returnValue
    }


}
