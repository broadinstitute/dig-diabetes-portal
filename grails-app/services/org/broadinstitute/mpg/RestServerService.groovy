package org.broadinstitute.mpg

import com.google.gson.JsonObject
import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.broadinstitute.mpg.diabetes.bean.ServerBean
import org.broadinstitute.mpg.diabetes.metadata.DataSet
import org.broadinstitute.mpg.diabetes.metadata.Experiment
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryBean
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilterBean
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
    GeneManagementService geneManagementService
    SearchBuilderService searchBuilderService
    BurdenService burdenService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService

    private Boolean TRY_RESTRICTING_ALL_AGGREGATED_CALLS_TO_TOP_VARIANTS = Boolean.TRUE
    private String LOCAL_SERVER = ""
    private String BASE_URL = ""
    private String REMEMBER_BASE_URL = ""
    private String GENE_INFO_URL = "gene-info"
    private String GENE_SEARCH_URL = "gene-search" // TODO: Wipe out, but used for (inefficiently) obtaining gene list.
    private String METADATA_URL = "getMetadata"
    private String GENE_METADATA_URL = "getGeneMetadata"
    private String HAIL_METADATA_URL = "getHailMetadata"
    private String GET_DATA_URL = "getData"
    private String GET_GENE_DATA_URL = "getGeneData"
    private String GET_DATA_AGGREGATION_URL = "getAggregatedData"
    private String GET_DATA_AGGREGATION_BY_RANGE_PHENOTYPES_URL= "getAggregatedData/phenotypes"
    private String GET_DATA_AGGREGATION_BY_RANGE_VARIANTS_URL= "getAggregatedData/variants"
    private String GET_DATA_AGGREGATION_PHEWAS_URL= "getAggregatedData/PheWAS"
    private String GET_BOTTOM_LINE_VARIANTS_URL= "gene/common"
    private String GET_BOTTOM_LINE_VARIANTS_BY_ID_URL= "gene/gtex_by_id"
    private String GET_BOTTOM_LINE_PHENOTYPES_VIA_VARIANTS_URL= "variant/phenotype/array"
    private String GET_TISSUE_ASSOCIATION_BASED_ON_LDSR_URL= "ld_score/by_phenotype/object"
    private String GET_VARIANT_GTEX_EQTL_FROM_URL= "ledge/gtex_eqtl/object"
    private String GET_EFFECTOR_GENE_INFO_URL= "testcalls/genepriority/gene/object"
    private String GET_EQTLS_FOR_A_VARIANT_LIST_URL= "testcalls/ledge/eqtl/object"
    private String GET_VARIANT_ECAVIAR_COLOCALIZATION_FROM_URL= "testcalls/ecaviar/colocalization_max/object"
    private String GET_VARIANT_COLOC_COLOCALIZATION_FROM_URL= "testcalls/ecaviar/colocalization_expanded_max/object"
    private String GET_REGION_FROM_ABC_URL= "testcalls/abc/region/object"
    private String GET_GENE_BASED_RECORDS_FROM_DEPICT_URL= "testcalls/depict/region/object"
    private String GET_TISSUE_BASED_RECORDS_FROM_DEPICT_URL= "testcalls/depict/tissue/object"
    private String GET_GENE_BASED_RECORDS_FROM_MODS_URL= "testcalls/knockout/object"
    private String GET_GENESET_RECORDS_FROM_DEPICT_URL= "testcalls/depict/genepathway/object"
    private String GET_DNASE_RECORDS_URL= "testcalls/region/dnase/object"
    private String GET_H3K27AC_RECORDS_URL= "testcalls/region/h3k27ac/object"
    private String GET_BOTTOM_LINE_RESULTS_URL= "graph/meta/variant/object"
    private String GET_TISSUES_FROM_GREGOR_URL= "graph/gregor/phenotype/object"
    private String GET_TISSUES_FROM_LDSR_URL = "testcalls/ldscore/tissue/object"
    private String GET_HAIL_DATA_URL = "getHailData"
    private String GET_SAMPLE_DATA_URL = "getSampleData"
    private String GET_SAMPLE_METADATA_URL = "getSampleMetadata"
    private String GET_REGION_URL = "getRegion"
    private String GET_VECTOR_URL = "getVectorData"
    private String GET_BIG_WIG_DATA = "getBigWigData"
    private String GET_CLUMP_DATA = "getClumpData"
    private String GET_EPIGENETIC_POSSIBLE_DATA = "getEpigenomicData"
    private String GET_MULTI_ALLELIC_HACK = "getAggregatedData/multiAllelicHack"
    private String DBT_URL = ""
    private String EXPERIMENTAL_URL = ""
    public static String TECHNOLOGY_GWAS = "GWAS"
    public static String TECHNOLOGY_EXOME_SEQ = "ExSeq"
    public static String TECHNOLOGY_EXOME_CHIP = "ExChip"
    public static String TECHNOLOGY_WGS_CHIP = "WGS"
    public static String EXOMESEQUENCEPVALUE = "P_FIRTH_FE_IV"
    public static int  DEFAULT_NUMBER_OF_RESULTS_FROM_TOPVARIANTS = 5000
    public static int  DEFAULT_NUMBER_OF_RESULTS_FROM_GETDATA = 5000

    public static int  EXPAND_ON_EITHER_SIDE_OF_GENE = 100000
    private String DEFAULTPHENOTYPE = "T2D"
    private String MAFPHENOTYPE = "MAF"
    private String EXOMESEQUENCEOR = "OR_FIRTH_FE_IV"
    private String HETEROZYGOTE_AFFECTED = "HETA"
    private String HETEROZYGOTE_UNAFFECTED = "HETU"
    private String MINORALLELECOUNTS_AFFECTED = "MINA"
    private String MINORALLELECOUNTS_UNAFFECTED = "MINU"
    private String HOMOZYGOTE_AFFECTED = "HOMA"
    private String HOMOZYGOTE_UNAFFECTED = "HOMU"
    private String OBSERVED_AFFECTED = "OBSA"
    private String OBSERVED_UNAFFECTED = "OBSU"
    private Integer MAXIMUM_NUMBER_DB_JOINS = 60
    private List<PortalVersionBean> PORTAL_VERSION_BEAN_LIST = []
    private String UCSD_HACK = "http://t2depigenome-test.org:8080/"
    private String UCSD_GET_ANNOTATION = "getAnnotationRegion"


    public static final String HAIL_SERVER_URL_DEV = "http://dig-api-dev.broadinstitute.org/dev/gs/";
    public static final String HAIL_SERVER_URL_QA = "http://dig-api-qa.broadinstitute.org/qa/gs/";
    public static final String SAMPLE_SERVER_URL_QA = "http://dig-api-qa.broadinstitute.org/qa/gs/";

    private static List <String> grsVariants = []

    private ServerBean REST_SERVER = null;

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

        BASE_URL = grailsApplication.config.server.URL
        REMEMBER_BASE_URL = BASE_URL
        DBT_URL = grailsApplication.config.dbtRestServer.URL
        EXPERIMENTAL_URL = grailsApplication.config.experimentalRestServer.URLburdenRestServer

        //default rest server
        this.REST_SERVER = grailsApplication.config.defaultRestServer;
        this.PORTAL_VERSION_BEAN_LIST = grailsApplication.config.portal.data.versionDesignator
    }

    // current below

    public String getLocal() {
        return LOCAL_SERVER;
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
            REMEMBER_BASE_URL = BASE_URL
            log.info("NOTE: change to server ${BASE_URL} is complete")
        }
    }

    public List <String> getGrsVariants(){
        return grsVariants
    }
    public void setGrsVariants(List <String> grsVariants){
        this.grsVariants = grsVariants
    }
//
//    public String getCurrentServer() {
//        return (BASE_URL ?: "none")
//    }
//
//
//    public void resetCurrentRestServer(){
//        BASE_URL = REMEMBER_BASE_URL
//    }
//
//    public void explicitlySetRestServer(String newRestServer){
//        BASE_URL = newRestServer
//    }
//
//
//    public void goWithTheProdLoadBalancedServer() {
//        pickADifferentRestServer(PROD_LOAD_BALANCED_SERVER)
//    }
//
//    public void goWithTheQaLoadBalancedServer() {
//        pickADifferentRestServer(QA_LOAD_BALANCED_SERVER)
//    }
//
//
//        public void goWithTheDev01Server() {
//            pickADifferentRestServer(DEV_01_SERVER )
//        }
//
//        public void goWithTheDev02Server() {
//            pickADifferentRestServer(DEV_02_SERVER)
//        }
//
//        public void goWithTheProd01Server() {
//            pickADifferentRestServer(PROD_01_SERVER )
//        }
//
//        public void goWithTheProd02Server() {
//            pickADifferentRestServer(PROD_02_SERVER)
//        }
//
//    public void goWithTheDevLoadBalancedServer() {
//        pickADifferentRestServer(DEV_LOAD_BALANCED_SERVER)
//    }
//
//    public void goWithTheAws01RestServer() {
//        pickADifferentRestServer(AWS01_REST_SERVER)
//    }
//
//    public void goWithTheAws02RestServer() {
//        pickADifferentRestServer(AWS02_REST_SERVER)
//    }
//
//    public void goWithTheAws01NewCodeRestServer() {
//        pickADifferentRestServer(AWS01_NEW_CODE_REST_SERVER)
//    }
//    public void goWithTheAws02NewCodeRestServer() {
//        pickADifferentRestServer(AWS02_NEW_CODE_REST_SERVER)
//    }
//
//    public void goWithProdLoadBalancedBroadServer() {
//        pickADifferentRestServer(PROD_LOAD_BALANCED_BROAD_SERVER)
//    }
//    public void goWithLocalServer() {
//        pickADifferentRestServer(LOCAL_SERVER)
//    }
//
//
//    public void goWithTheDevServer() {
//        pickADifferentRestServer(DEV_REST_SERVER)
//    }

    public String currentRestServer() {
        return this.REST_SERVER.url;
    }


    public void changeRestServer(String serverName) {
        for (ServerBean serverBean : grailsApplication.config.getRestServerList) {
            if (serverBean!= null && serverBean.getName().equals(serverName)) {
                //log.info("changing rest server from: " + this.REST_SERVER.getUrl() + " to: " + serverBean.getUrl());
                this.REST_SERVER = serverBean;
                break;
            }
        }
    }


    public void removePortalVersion(String portalType){
        PORTAL_VERSION_BEAN_LIST.removeAll{it.portalType==portalType}
        log.info("removed")
    }


    /***
     * Update the current list of portal versions.  If this record has the same name as an existing record then update
     * that existing record, otherwise add a new record
     *
     * @param portalType
     * @param portalDescription
     * @param mdvName
     * @return
     */
    public PortalVersionBean modifyPortalVersion(String portalType, String mdvName){
        PortalVersionBean existingPortalVersionBean = PORTAL_VERSION_BEAN_LIST.find{it.portalType==portalType}
        PortalVersionBean newPortalVersionBean
        if (existingPortalVersionBean){
            newPortalVersionBean = new PortalVersionBean( portalType,
                    existingPortalVersionBean.getPortalDescription(),
                    mdvName,
                    existingPortalVersionBean.getKnowledgeBaseName(),
                    existingPortalVersionBean.getPhenotype(),
                    existingPortalVersionBean.getDataSet(),
                    existingPortalVersionBean.getTissueRegionOverlapMatcher(),
                    existingPortalVersionBean.getTissueRegionOverlapDisplayMatcher(),
                    existingPortalVersionBean.getTissues(),
                    existingPortalVersionBean.getOrderedPhenotypeGroupNames(),
                    existingPortalVersionBean.getExcludeFromLZ(),
                    existingPortalVersionBean.getEpigeneticAssays(),
                    existingPortalVersionBean.getLzDataset(),
                    existingPortalVersionBean.getFrontLogo(),
                    existingPortalVersionBean.getTagline(),
                    existingPortalVersionBean.getTabLabel(),
                    existingPortalVersionBean.getAlternateLanguages(),
                    existingPortalVersionBean.getGeneExamples(),
                    existingPortalVersionBean.getVariantExamples(),
                    existingPortalVersionBean.getRangeExamples(),
                    existingPortalVersionBean.getBackgroundGraphic(),
                    existingPortalVersionBean.getPhenotypeLookupMessage(),
                    existingPortalVersionBean.getLogoCode(),
                    existingPortalVersionBean.getMenuHeader(),
                    existingPortalVersionBean.getSampleLevelSequencingDataExists(),
                    existingPortalVersionBean.getGenePageWarning(),
                    existingPortalVersionBean.getCredibleSetInfoCode(),
                    existingPortalVersionBean.getBlogId(),
                    existingPortalVersionBean.getAggregationCovarianceUrl(),
                    existingPortalVersionBean.getAggregationMetadataUrl(),
                    existingPortalVersionBean.getExposeCommonVariantTab(),
                    existingPortalVersionBean.getExposeRareVariantTab(),
                    existingPortalVersionBean.getVariantAssociationsExists(),
                    existingPortalVersionBean.getGeneLevelDataExists(),
                    existingPortalVersionBean.getExposeGrsModule(),
                    existingPortalVersionBean.getHighSpeedGetAggregatedDataCall(),
                    existingPortalVersionBean.getRegionSpecificVersion(),
                    existingPortalVersionBean.getExposePhewasModule(),
                    existingPortalVersionBean.getExposeForestPlot(),
                    existingPortalVersionBean.getExposeTraitDataSetAssociationView(),
                    existingPortalVersionBean.getExposeGreenBoxes(),
                    existingPortalVersionBean.getExposeGeneComparisonTable(),
                    existingPortalVersionBean.getVariantTakesYouToGenePage(),
                    existingPortalVersionBean.getUtilizeBiallelicGait(),
                    existingPortalVersionBean.getUtilizeUcsdData(),
                    existingPortalVersionBean.getExposePredictedGeneAssociations(),
                    existingPortalVersionBean.getExposeHiCData(),
                    existingPortalVersionBean.getExposeDynamicUi(),
                    existingPortalVersionBean.getExposeDatasetHierarchy(),
                    existingPortalVersionBean.getExposeVariantAndAssociationTable(),
                    existingPortalVersionBean.getExposeIgvDisplay(),
                    existingPortalVersionBean.getExposeIndependentBurdenTest(),
                    existingPortalVersionBean.getExposeGenesInRegionTab(),
                    existingPortalVersionBean.getExposeRegionAdjustmentOnGenePage(),
                    existingPortalVersionBean.getExposeGeneTableOnDynamicUi(),
                    existingPortalVersionBean.getExposeVariantTableOfDynamicUi(),
                    existingPortalVersionBean.getExposeEffectorGeneTableUi()
            )

            removePortalVersion(portalType)
        } else {
            newPortalVersionBean = new PortalVersionBean( portalType,  "",  mdvName )
        }
        PORTAL_VERSION_BEAN_LIST << newPortalVersionBean
        return newPortalVersionBean
    }


    public PortalVersionBean retrieveBeanForCurrentPortal(){
        PortalVersionBean existingPortalVersionBean = PORTAL_VERSION_BEAN_LIST.find{it.portalType==metaDataService?.getPortalTypeFromSession()}
        PortalVersionBean returnValue
        if (existingPortalVersionBean){
            returnValue = existingPortalVersionBean
        } else {
            log.error("ERROR: code requested portal ${metaDataService?.getPortalTypeFromSession()}, but we don't have anything by that name")
        }
        return returnValue
    }


    public List <PortalVersionBean> retrieveBeanForAllPortals(){
        return PORTAL_VERSION_BEAN_LIST
    }



    /***
     * Retrieve the MDV version for a portal type
     *
     * @param portalType
     * @return
     */
    public PortalVersionBean retrieveBeanForPortalType(String portalType){
        PortalVersionBean existingPortalVersionBean = PORTAL_VERSION_BEAN_LIST.find{it.portalType==portalType}
        PortalVersionBean returnValue
        if (existingPortalVersionBean){
            returnValue = existingPortalVersionBean
        } else {
            log.error("ERROR: code requested portal ${portalType}, but we don't have anything by that name")
        }
        return returnValue
    }


    public String retrieveMdvForPortalType(String portalType){
        String returnValue
        PortalVersionBean existingPortalVersionBean = retrieveBeanForPortalType(portalType)
        returnValue = existingPortalVersionBean.getMdvName()
        return returnValue
    }



    public String getPortalVersionBeanListAsJson(){
        List<PortalVersionBean> listPortalVersionBean = PORTAL_VERSION_BEAN_LIST
        return "[${listPortalVersionBean.collect{it.toJsonString(retrieveBeanForCurrentPortal())}.join(",")}]"
    }



    /**
     * get the current burden rest server
     *
     * @return
     */
    public ServerBean getCurrentBurdenServer() {
        // the IAT always runs through the current KB (originally it was possible to set it separately)
        ServerBean currentKb = getCurrentRestServer()
        return new ServerBean(currentKb.url,"${currentKb.url}burden")
    }

    public ServerBean getCurrentRestServer() {
        return this.REST_SERVER
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




    public LinkedHashMap parseARange(String regionSpecification){
        boolean encounteredErrors = false
        LinkedHashMap returnValue = [:]
        LinkedHashMap extractedNumbers =  extractNumbersWeNeed(regionSpecification)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ) {
            Long startExtent = sharedToolsService.convertRegionString(extractedNumbers["startExtent"])
            Long endExtent = sharedToolsService.convertRegionString(extractedNumbers["endExtent"])
            if ((startExtent < 0) || (endExtent < 0) || (startExtent > endExtent)) {
                encounteredErrors = true
            }
            String chromosome = sharedToolsService.parseChromosome(extractedNumbers["chromosomeNumber"])
            if (chromosome != 'X' && chromosome != 'x' && chromosome != 'Y' && chromosome != 'y'){
                Integer chromosomeNumber
                try {
                    chromosomeNumber = Integer.parseInt(chromosome)
                } catch(e){
                    encounteredErrors = true
                }
                if ((chromosomeNumber < 1) || (chromosomeNumber > 22)){
                    encounteredErrors = true
                }
            }
            if (!encounteredErrors){
                returnValue["start"] = startExtent
                returnValue["end"] = endExtent
                returnValue["chromosome"] = chromosome
                returnValue["error"] = false
            }
        } else {
            returnValue["error"] = true
        }
        return returnValue
    }







    /***
     * Need to to send through metadata sample groups recursively in order to generate a JSON structure
     * that can create the recursive Sunburst graphic
     *
     * @param sb
     * @param sampleGroup
     * @param description
     * @return
     */
    StringBuilder extendDataSetJsonRecursively (StringBuilder sb,SampleGroup sampleGroup,String description){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        // start the sample group definition
        if ((sampleGroup)&&(sampleGroup.getSystemId())){
            String dataSetName  = sampleGroup.getSystemId()
            String dataSetNameTranslated = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
            String technologyTranslated = g.message(code: 'metadata.' + "${metaDataService.getTechnologyPerSampleGroup(sampleGroup.systemId)}");
            String technologyUntranslated = metaDataService.getTechnologyPerSampleGroup(sampleGroup.systemId);
            //List <Phenotype> phenotypeListUntranslated
            List <Phenotype> phenotypeList = sampleGroup.getPhenotypes();
           // String fullName =  "g.message(code: 'metadata.' + $it.name)";
            //, "fullName": "g.message(code: 'metadata.' + $it.name)"
            ArrayList <String> phenotypeArrayList = phenotypeList.collect{return """{"name":"$it.name","group":"$it.group", "fullName": "${g.message(code: 'metadata.' + "$it.name")}"}"""};

            
            sb << """{"name":"${dataSetName}","sortOrder": ${sampleGroup.sortOrder},"phenotypes":${phenotypeArrayList.toString()},"ancestry":"${sampleGroup.getAncestry()}", "label": "${dataSetNameTranslated}", "descr":"${dataSetNameTranslated}<br/>Total samples: ${sampleGroup.getSubjectsNumber()}","size": ${sampleGroup.getSubjectsNumber()},"technology":"${technologyTranslated}","technologyUntranslated":"${technologyUntranslated}","col": 1""".toString()
        }

        // recurse, if necessary
        if (sampleGroup.getSampleGroups().size()>0){
            List <String> recursiveSampleGroups = []

            // need to compare against last, NOT start in array then join with ","

            SampleGroup lastSampleGroup = sampleGroup.getSampleGroups().last()

            sb <<  ""","children": [""".toString()
            for (SampleGroup recursiveSampleGroup in sampleGroup.getSampleGroups()){
                extendDataSetJsonRecursively ( sb,recursiveSampleGroup, description+sampleGroup.getSystemId() )
                if (recursiveSampleGroup.getSystemId()==lastSampleGroup.getSystemId()){
                    sb << """,
{"name":"zzull${description+sampleGroup.getSystemId()}", "descr":"null","col": 1,"size":1}
""".toString()
                } else {
                    sb <<  """,
"""
                }
            }
            sb <<  """]
}""".toString()
        } else {
            sb <<  """}
""".toString()
        }

        return sb
    }

    /***
     * Build the top-level holder consumed by the Sunburst visualization. Most of the databases returned not by this
     * routine itself, but instead by extendDataSetJsonRecursively
     *
     * @param version
     * @param technology
     * @return
     */
    public JSONObject extractDataSetHierarchy(String version,String technology) {
        JSONObject returnValue
        StringBuilder sb = new StringBuilder("""[
                {"name":"/", "descr":"click to zoom out", "label":"null", "size": 1,"col": 1,"children": [""".toString())


        if ( (!version)||
                (version.length()<1) ) {
            version = this.metaDataService?.getDataVersion() // use current default version
        }
        if ( (!technology)||
                (technology.length()<1)||
                (technology=='none')) {
            technology = ''
        }
        List<Experiment> experimentList = this.metaDataService.getExperimentByVersionAndTechnology(version, technology, MetaDataService.METADATA_VARIANT);
        if (experimentList.size()>0){
            Experiment lastExperiment = experimentList.last()
            for (Experiment experiment in experimentList){
                List<SampleGroup> sampleGroups = experiment.getSampleGroups()
                for (SampleGroup sampleGroup in sampleGroups){
                    extendDataSetJsonRecursively (sb,sampleGroup,sampleGroup.getSystemId())
                    if (experiment.name != lastExperiment.name){
                        sb << """,
""".toString()
                    }

                }

            }
        }

        sb << """]}
    ]""".toString()

        JsonSlurper slurper = new JsonSlurper()
        returnValue = slurper.parseText(sb.toString())

       return returnValue
    }




    /***
     * This is the underlying routine for every GET request to the REST backend
     * where response is text/plain type.
     * @param drivingJson
     * @param targetUrl
     * @return
     */
    public String getRestCallBase(String targetUrl, String currentRestServer) {
        String returnValue = null
        RestResponse response
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        String completeUrl = currentRestServer + targetUrl
        try {
            log.info("About to attempt call to ${completeUrl}")
            response = rest.get(completeUrl) {
                contentType "text/plain"
            }
        } catch (Exception exception) {
            log.error("NOTE: exception on post to backend. Target=${completeUrl}")
            log.error(exception.toString())
            logStatus << "NOTE: exception on post to backend. Target=${completeUrl}"
        }

        if (response?.responseEntity?.statusCode?.value == 200) {
            returnValue = response.text
            logStatus << """status: ok""".toString()
        } else {
            logStatus << """status: failed (${response?.responseEntity?.statusCode?.value}) on ${completeUrl}""".toString()
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
    public JSONObject postRestCallBase(String drivingJson, String targetUrl, currentRestServer) {
        JSONObject returnValue = null
        Date beforeCall = new Date()
        Date afterCall
        RestResponse response
        String completeUrl = currentRestServer + targetUrl
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        StringBuilder logStatus = new StringBuilder()
        try {
            log.info("About to attempt call to ${completeUrl}")
            response = rest.post(completeUrl) {
                contentType "application/json"
                json drivingJson
            }
            afterCall = new Date()
        } catch (Exception exception) {
            log.error("NOTE: exception on post to backend. Target=${completeUrl}, driving Json=${drivingJson}")
            log.error(exception.toString())
            logStatus << "NOTE: exception on post to backend. Target=${completeUrl}, driving Json=${drivingJson}"
            afterCall = new Date()
        }
        logStatus << """
SERVER POST:
url=${completeUrl},
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
url=${completeUrl},
parm=${drivingJson},
time required=${(afterCall.time - beforeCall.time) / 1000} seconds
""".toString()
        }
        log.info(logStatus)
        return returnValue
    }


    /**
     * get the bigwig data (api call) to the REST server
     *
     * @param jsonString {"chr":"chr1", "start":17370,"stop":91447}
     * @return
     */
    public JSONObject postVectorDataRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, GET_VECTOR_URL, currentRestServer() );
        return tempObject;
    }

    public JSONObject postBigWigDataRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, GET_BIG_WIG_DATA, currentRestServer() );
        return tempObject;
    }

    public JSONObject postClumpDataRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, GET_CLUMP_DATA, currentRestServer() );
        return tempObject;
    }

    public JSONObject postEpigeneticBigwigFileQueryRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, GET_EPIGENETIC_POSSIBLE_DATA, currentRestServer() );
        return tempObject;
    }

    public JSONObject postMultiAllelicHackRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, GET_MULTI_ALLELIC_HACK, currentRestServer() );
        return tempObject;
    }



    /**
     * burden call to the REST server
     *
     * @param jsonString
     * @return
     */
    public JSONObject postBurdenRestCall(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, "", this.getCurrentBurdenServer()?.getRestServiceCallUrl(ServerBean.BURDEN_TEST_CALL_V1));
        return tempObject;
    }


    /***
     * perform a meta-analysis api call
     *
     * @param jsonString
     * @return
     */
    public JSONObject postRestBurdenMetaData(String jsonString) {
        JSONObject tempObject = this.postRestCallBase(jsonString, "", this.getCurrentBurdenServer()?.getRestServiceCallUrl(ServerBean.BURDEN_TEST_CALL_META_ANALYSIS));
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
    public JSONObject postGetHailDataCall(String jsonString) {
        return this.postRestCall(jsonString, this.GET_HAIL_DATA_URL);
    }


    public JSONObject postGetHailDataCall(String jsonString, String URL) {
        // TODO - hard code to QA server for now
//        return postRestCallBase(drivingJson, this.GET_HAIL_DATA_URL, currentRestServer())
//        return postRestCallBase(jsonString, this.GET_HAIL_DATA_URL, "http://dig-api-dev.broadinstitute.org/dev/gs/")
        return postRestCallBase(jsonString, this.GET_HAIL_DATA_URL, URL)
    }


    public JSONObject postGetSampleDataCall(String jsonString, String URL) {
         return postRestCallBase(jsonString, this.GET_SAMPLE_DATA_URL, currentRestServer())
    }

    private JSONObject postRestCall(String drivingJson, String targetUrl) {
        return postRestCallBase(drivingJson, targetUrl, currentRestServer())
    }

    public JSONObject postDataQueryRestCall(GetDataQueryHolder getDataQueryHolder) {
        QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder()
        String drivingJson = queryJsonBuilder.getQueryJsonPayloadString(getDataQueryHolder.getGetDataQuery())
        return postRestCallBase(drivingJson, this.GET_DATA_URL, currentRestServer())
    }

    public JSONObject postGeneDataQueryRestCall(GetDataQueryHolder getDataQueryHolder) {
        QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder()
        String drivingJson = queryJsonBuilder.getQueryJsonPayloadString(getDataQueryHolder.getGetDataQuery())
        return postRestCallBase(drivingJson, this.GET_GENE_DATA_URL, currentRestServer())
    }

    public JSONObject postMultiJoinProtectedDataQueryRestCall(GetDataQueryHolder getDataQueryHolder) {
        QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder()
        GetDataQueryBean getDataQueryBean = getDataQueryHolder.getGetDataQuery()
        List<HashMap> listOfPropertyMaps = []
        JSONObject retValue = null
        //if (getDataQueryBean.queryPropertyList.size()>this.MAXIMUM_NUMBER_DB_JOINS){
            int loopCounter = 0
            listOfPropertyMaps << [:]
            List <String> propertyListKeys = getDataQueryBean.queryPropertyMap.keySet() as List<String>
            for (int i = 0; i < propertyListKeys.size(); i++){
                String keyName = propertyListKeys[i]
                listOfPropertyMaps[loopCounter][keyName] = getDataQueryBean.queryPropertyMap[keyName]
                if (i == (this.MAXIMUM_NUMBER_DB_JOINS*(loopCounter+1))-1){ // end of batch
                    loopCounter++
                    listOfPropertyMaps << [:]
                }
            }
            List<JSONObject> returnJSONObjectList = []
            def slurper = new JsonSlurper()
            for (Map propertyMap in listOfPropertyMaps){
                getDataQueryBean.queryPropertyMap = propertyMap
                String drivingJson = queryJsonBuilder.getQueryJsonPayloadString(getDataQueryBean)
                String returnString = postRestCallBase(drivingJson, this.GET_DATA_URL, currentRestServer())
                returnJSONObjectList << slurper.parseText(returnString)
            }
            for (Map returnJSONObject in returnJSONObjectList){
                if (retValue == null){
                    retValue = returnJSONObject
                } else {
                    List newResults = returnJSONObject['variants']
                    if (newResults!=null){
                        for (def resultCategories in newResults){
                            for (def resultCategory in resultCategories){
                                Map result = resultCategory as Map
                                List keys = result.keySet() as List
                                String key  = keys.first() as String
                                int existingIndex = -1
                                int existingIndexCounter = 0
                                if (retValue['variants'] == null){
                                    continue;
                                }
                                for (def existingResult in retValue['variants'][0]){
                                    Map resultExisting = existingResult as Map
                                    List keysExisting = resultExisting.keySet() as List
                                    String keyExisting  = keysExisting.first() as String
                                    if (key==keyExisting){
                                        existingIndex = existingIndexCounter
                                    }
                                    existingIndexCounter++
                                }
                                if (existingIndex==-1){
                                    HashMap newEntry = [:]
                                    newEntry[key] = resultCategory[key]
                                    retValue['variants'][0] << newEntry
                                } else { // must merge
                                    if (result[key].getClass().simpleName!="String"){
                                        Map everythingToAdd = result[key] as Map
                                        try {
                                            List keysToAdd = everythingToAdd?.keySet() as List
                                            for (def keyToAdd in keysToAdd) {
                                                if (retValue['variants'][0][existingIndex][key].containsKey(keyToAdd)) {
                                                    if (result[key][keyToAdd] == null) {
                                                        log.error("Map name matching problem in postMultiJoinProtectedDataQueryRestCall")
                                                    } else {
                                                        List keysToAppend = result[key][keyToAdd].keySet() as List
                                                        for (String keyToAppend in keysToAppend) {
                                                            retValue['variants'][0][existingIndex][key][keyToAdd][keyToAppend] = result[key][keyToAdd][keyToAppend]
                                                        }

                                                    }
                                                } else {
                                                    HashMap newEntryToAdd = [:]
                                                    newEntryToAdd[keyToAdd] = result[key][keyToAdd]
                                                    retValue['variants'][0][existingIndex][key] << newEntryToAdd
                                                }
                                            }

                                        } catch (Exception e) {
                                            log.error("List casting problem in postMultiJoinProtectedDataQueryRestCall")
                                        }

                                    }

                                }
                            }

                        }
                    }
                 }
            }
        return retValue
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
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["CHROM",
                                                                         "POS",
                                                                         "VAR_ID",
                                                                         "DBSNP_ID",
                                                                         "GENE",
                                                                         "CLOSEST_GENE",
                                                                         "TRANSCRIPT_ANNOT",
                                                                         "Reference_Allele",
                                                                         "Effect_Allele",
                                                                         "Consequence",
                                                                         "PolyPhen_PRED",
                                                                         "SIFT_PRED",
                                                                         "Protein_change"
        ])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filters], searchBuilderService, metaDataService)
        JsonSlurper slurper = new JsonSlurper()
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }


    JSONObject retrieveVariantInfoByNameAndDs(String variantId,String dataSet) {
        String filters = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["CHROM",
                                                                         "POS",
                                                                         "VAR_ID",
                                                                         "DBSNP_ID",
                                                                         "GENE",
                                                                         "CLOSEST_GENE",
                                                                         "TRANSCRIPT_ANNOT",
                                                                         "Reference_Allele",
                                                                         "Effect_Allele",
                                                                         "Consequence",
                                                                         "PolyPhen_PRED",
                                                                         "SIFT_PRED",
                                                                         "Protein_change"
        ])
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filters], searchBuilderService, metaDataService)
        Property macProperty = metaDataService.getSampleGroupProperty(dataSet,"MAC",MetaDataService.METADATA_VARIANT)
        JsonSlurper slurper = new JsonSlurper()
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        if (macProperty != null){
            getDataQueryHolder.addSpecificProperty(macProperty)
        }
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
        phenotypeList = this.metaDataService.getPhenotypeListByTechnologyAndVersion("GWAS", this.metaDataService?.getDataVersion(),MetaDataService.METADATA_VARIANT);

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
            case RestServerService.TECHNOLOGY_WGS_CHIP:
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
            String mafValue = linkedHashMap.maf
            String macValue = linkedHashMap.mac
            String pValue = linkedHashMap.pvalue
            String orValue = linkedHashMap.orvalue
            String betaValue = linkedHashMap.betavalue
            String minaValue = linkedHashMap.mina
            String minuValue = linkedHashMap.minu
            String obsValue = linkedHashMap.obs
            String obsaValue = linkedHashMap.obsa
            String obsuValue = linkedHashMap.obsu
            String mafaValue = linkedHashMap.mafa
            String mafuValue = linkedHashMap.mafu

            ArrayList<String> pproperties = [pValue, orValue, betaValue, minaValue, minuValue, obsValue,
                                             obsaValue, obsuValue, mafaValue, mafuValue]

            if(mafValue && mafValue.length() > 0) {
                addColumnsForDProperties(resultColumnsToDisplay, mafValue, dataSet)
            }
            if(macValue && macValue.length() > 0) {
                addColumnsForDProperties(resultColumnsToDisplay, macValue, dataSet)
            }

            pproperties.each {
                if ((it) && (it.length() > 0)) {
                    addColumnsForPProperties(resultColumnsToDisplay, phenotype,
                            dataSet,
                            it)
                }
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
        JSONObject datasetObject = [
            pVals: new ArrayList<JSONObject>()
        ]

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

                def mafObject = variant.MAF.findAll { it }[0]
                for( def s in mafObject ) {
                    String dataSetName = s.getKey()
                    Number value = s.getValue()
                    String dataSetNameTranslated = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                    JSONObject newItem = [
                        meaning: 'MAF',
                        dataset: dataSetNameTranslated,
                        datasetCode: dataSetName,
                        level: 'MAF',
                        count: value
                    ]
                    datasetObject.pVals << newItem
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
                                // datasetCode is here to support a lookup on the client
                                datasetCode: dataSetName,
                                level: pValueName,
                                count: variant[pValueName][dataSetName][phenotype][0]
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
                                datasetCode: dataSetName,
                                level: orValueName,
                                count: variant[orValueName][dataSetName][phenotype][0]
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
                                datasetCode: dataSetName,
                                level: betaValueName,
                                count: variant[betaValueName][dataSetName][phenotype][0]
                            ]
                            datasetObject.pVals << newItem
                        }
                    }
                }

                // it would probably be better to not hardcode OBSA/OBSU, but right now
                // there's not an obviously better way to do it
                String obsaKey = "OBSA"
                def obsaObjectList = variant[obsaKey].findAll { it }
                if(obsaObjectList.size() > 0) {
                    def obsaObject = obsaObjectList[0] as JSONObject
                    for (def dataset in obsaObject.keys()) {
                        String dataSetNameTranslated = g.message(code: 'metadata.' + dataset, default: dataset);
                        JSONObject newItem = [
                                meaning: "OBSA",
                                dataset: dataSetNameTranslated,
                                datasetCode: dataset,
                                level  : obsaKey,
                                count  : variant[obsaKey][dataset][phenotype][0]
                        ]
                        datasetObject.pVals << newItem
                    }
                }

                String obsuKey = "OBSU"
                def obsuObjectList = variant[obsuKey].findAll { it }
                if(obsuObjectList.size() > 0) {
                    def obsuObject = obsuObjectList[0] as JSONObject
                    for (def dataset in obsuObject.keys()) {
                        String dataSetNameTranslated = g.message(code: 'metadata.' + dataset, default: dataset);
                        JSONObject newItem = [
                                meaning: "OBSU",
                                dataset: dataSetNameTranslated,
                                datasetCode: dataset,
                                level  : obsuKey,
                                count  : variant[obsuKey][dataset][phenotype][0]
                        ]
                        datasetObject.pVals << newItem
                    }
                }
            }

        }
        return datasetObject
    }



    private LinkedHashMap<String,List<SampleGroup>> generateSampleGroupByAncestry(String variantId){
        List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupForNonMixedAncestry( sharedToolsService.getCurrentDataVersion(), "Mixed" )
        // start by collecting all of the sample groups that share a common ancestry
        LinkedHashMap<String,List<SampleGroup>> sampleGroupByAncestry = [:]
        for ( int  i = 0 ; i < sampleGroupList.size() ; i++ ){
            SampleGroup sampleGroup = sampleGroupList[i]
            List<Property>  propertyList = sampleGroup.getProperties()
            for (Property property in propertyList){
                if ((property.hasMeaning("MAF"))||
                        (property.name==MAFPHENOTYPE)||
                        (property.name=="EAF")){
                    String ancestry = sampleGroup.getAncestry()
                    if (!sampleGroupByAncestry.containsKey(ancestry)){
                        sampleGroupByAncestry[ancestry] = [sampleGroup]
                    } else {
                        sampleGroupByAncestry[ancestry] << sampleGroup
                    }
                }
            }
        }
        return sampleGroupByAncestry

    }



    /***
     * Private section associated with howCommonIsVariantAcrossEthnicities, used to fill up the "how common is"
     *  section in variant info
     *
     * @param variantId
     * @return
     */
    private JSONObject howCommonIsVariantSection(String variantId, LinkedHashMap<String,List<SampleGroup>> sampleGroupByAncestry ) {
        String filterByVariantName = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID"])

        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        // start by collecting all of the sample groups that share a common ancestry

        // We will only chart the ancestry record with the larger sample group.
        LinkedHashMap<String,SampleGroup> chosenSampleGroupByAncestry = [:]
        for (Map.Entry<String, List<SampleGroup>> entry : sampleGroupByAncestry.entrySet()) {
            String ancestry = entry.getKey()
            List<SampleGroup> sampleGroups = entry.getValue()
            for (SampleGroup oneSampleGroup in sampleGroups){
                chosenSampleGroupByAncestry["${ancestry}+${oneSampleGroup.getSystemId()}"] = oneSampleGroup
            }
        }
        // Add all of our chosen ancestries
        List<String> ancestryList = chosenSampleGroupByAncestry.keySet()?.sort{a, b -> a <=> b }
        for (String ancestry in ancestryList) {
            SampleGroup sampleGroup = chosenSampleGroupByAncestry[ancestry]
            addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", sampleGroup.systemId)
        }

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
    public JSONObject howCommonIsVariantAcrossEthnicities(String variantName, String showAll) {
        JSONObject returnValue
        LinkedHashMap<String,List<SampleGroup>> sampleGroupByAncestry =  generateSampleGroupByAncestry(variantName)
        JSONObject apiResults = howCommonIsVariantSection(variantName,sampleGroupByAncestry)
        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults, "", "", MetaDataService.METADATA_VARIANT)
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)
        if (showAll=="0"){// refine list based on sample size
            LinkedHashMap variantIdentifier = [:]
            LinkedHashMap<String,List<SampleGroup>> refiningAncestryList = [:]
            List unrefinedList = returnValue ["results"]["pVals"]
            if ((unrefinedList) &&
                    (unrefinedList.size()>0)){
                for (Map map in unrefinedList[0]){
                    String fieldName = map["level"]
                    String fieldValue = map["count"]
                    if (fieldName.startsWith("MAF")){
                        List<String> listOfFieldElements = fieldName.tokenize("^")
                        if (listOfFieldElements.size()>5){
                            List<SampleGroup> ancestrySpecificSampleGroups = sampleGroupByAncestry[listOfFieldElements[4]]
                            List<SampleGroup> sortedAncestrySpecificSampleGroups = ancestrySpecificSampleGroups.sort{a,b->a.subjectsNumber<=>b.subjectsNumber}
                            for ( int  i = 0 ; i < sortedAncestrySpecificSampleGroups.size() ; i++ ){
                                if (sortedAncestrySpecificSampleGroups[i].systemId == listOfFieldElements[3]){
                                    if (refiningAncestryList.containsKey(listOfFieldElements[4])){
                                        refiningAncestryList[listOfFieldElements[4]]<<["count":fieldValue,"value":fieldName,"sortOrder":i]
                                    }else{
                                        refiningAncestryList[listOfFieldElements[4]]=[]
                                        refiningAncestryList[listOfFieldElements[4]]<<["count":fieldValue,"value":fieldName,"sortOrder":i]
                                    }
                                }
                            }
                        }
                    } else {
                        variantIdentifier["count"] = fieldValue
                    }
                }
            }
            List<LinkedHashMap> chosenMafs = []
            for (String ancestry in refiningAncestryList.keySet()){
                List<SampleGroup> recordsPerAncestry = refiningAncestryList[ancestry]
                List<SampleGroup> sortedRecordsPerAncestry = recordsPerAncestry.sort{a,b->return b.sortOrder<=>a.sortOrder}
                if (sortedRecordsPerAncestry?.first()){
                    LinkedHashMap map = sortedRecordsPerAncestry.first()
                    chosenMafs << """{"level":"${map.value}","count":${map.count}}""".toString()
                }
            }
            StringBuilder sb = new StringBuilder("""{"results":[{ "dataset": 1, "pVals": [{"level":"VAR_ID","count":"${variantIdentifier["count"]}"}""".toString())
            if (chosenMafs.size()>0){
                sb << ","
                sb << chosenMafs.join(",")
            }
            sb << "]}]}"
            returnValue = slurper.parseText(sb.toString())
        }

        return returnValue




    }



    /***
     * Private counterpart to combinedVariantDiseaseRisk, which is used to fill the "is variant frequency different for patients with the disease" section
     * of the variant info page
     *
     * @param variantId
     * @return
     */
    private JSONObject variantDiseaseRisk( String variantId,String sampleGroup ) {
        String filterByVariantName = codedfilterByVariant(variantId)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID"])
        List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupForPhenotypeTechnologyAncestry(DEFAULTPHENOTYPE, TECHNOLOGY_EXOME_SEQ, metaDataService.getDataVersion(), "Mixed",MetaDataService.METADATA_VARIANT)
        String sampleGroupName = sampleGroupList[0]?.systemId
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${HETEROZYGOTE_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${HETEROZYGOTE_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${MINORALLELECOUNTS_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${MINORALLELECOUNTS_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${HOMOZYGOTE_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${HOMOZYGOTE_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${OBSERVED_AFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${OBSERVED_UNAFFECTED}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${EXOMESEQUENCEPVALUE}")
        addColumnsForPProperties(resultColumnsToDisplay, "${DEFAULTPHENOTYPE}", sampleGroupName, "${EXOMESEQUENCEOR}")
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }

    /***
     * Provide the numbers to fill the "is variant frequency different for patients with the disease" section
     * of the variant info page  processInfoFromGetDataCall
     * @param variantName
     * @return
     */
    public JSONObject combinedVariantDiseaseRisk(String variantName, String sampleGroup) {
        String attribute = "T2D"
        JSONObject returnValue
        JSONObject apiResults = variantDiseaseRisk(variantName,sampleGroup)
        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults,"", "", MetaDataService.METADATA_VARIANT )
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)
        return returnValue
    }

    /***
     * we don't want the logic in the JavaScript when we already know what calls we need. Just make one call
     * from the browser and then I will cycle through at this level and get all the data
     * @param geneName
     * @return
     */
    public JSONObject combinedVariantCountByGeneNameAndPValue(String geneName,
                                                              String dataset,
                                                              List<Float> significanceList,
                                                              String phenotype) {

        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(dataset, MetaDataService.METADATA_VARIANT)
        String technology = metaDataService.getTechnologyPerSampleGroup(dataset)
        JSONObject returnValue = [
            dataset: dataset,
            subjectsNumber: sampleGroup?.getSubjectsNumber(),
            technology: technology,
        ]

        ArrayList<JSONObject> values = new ArrayList<>();

        int i = 0
        while(i < significanceList.size()) {
            JSONObject apiData = requestGeneCountByPValue(geneName, significanceList[i], dataset, phenotype, technology)
            if (apiData.is_error == false) {
                values.add([
                    level: significanceList[i],
                    count: apiData.numRecords
                ] as JSONObject)
            } else {
                log.error("error in requestGeneCountByPValue = '${apiData.error_msg}', code = ${apiData.error_code}")
            }
            // in the case that numRecords < 1000, then just get the whole variant list and process on that
            // otherwise proceed to the next significance value
            if(apiData.numRecords < 1000) {
                // all of the following is just building up the query to get the variant list
                String geneRegion
                switch (technology) {
                    case RestServerService.TECHNOLOGY_GWAS:
                    case RestServerService.TECHNOLOGY_WGS_CHIP:
                        geneRegion = sharedToolsService.getGeneExpandedRegionSpec(geneName)
                        break;
                    default:
                        break;

                }
                Float significance = significanceList[i]
                List<String> codedFilters = filterManagementService.retrieveFiltersCodedFilters(geneName, significance, dataset, geneRegion, technology, phenotype)
                String pValueText = filterManagementService.findFavoredMeaningValue(dataset, phenotype, "P_VALUE")
                LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["CHROM", "POS"])
                resultColumnsToDisplay = addColumnsForPProperties(resultColumnsToDisplay, phenotype, dataset, pValueText)
                GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(codedFilters, searchBuilderService, metaDataService)
                // we need this so we can order the variants, which makes the counting simpler
                Property pvalProperty = metaDataService.getPropertyByNamePhenotypeAndSampleGroup(pValueText, phenotype, dataset,MetaDataService.METADATA_VARIANT)

                getDataQueryHolder.addOrderByProperty(pvalProperty, '1')
                getDataQueryHolder.getDataQuery.setPageSize(-1)
                getDataQueryHolder.getDataQuery.setPageStart(-1)
                getDataQueryHolder.addProperties(resultColumnsToDisplay)

                String dataString = postDataQueryRestCall(getDataQueryHolder)
                JSONObject data = (new JsonSlurper()).parseText(dataString)

                int counter = 0
                int significanceLevelTracker = significanceList.size() - 1
                ArrayList<JSONArray> variants = data.variants
                // note: this works because the variants are returned in an ascending order--if
                // this invariant is not true, then good luck
                if (variants.size()==0){
                    for (float oneSignificance in significanceList) {
                        // if so, save the current value of counter for the current significance level, and decrement the significane tracker
                        values.add([
                                level: oneSignificance,
                                count: 0
                        ] as JSONObject)
                    }
                } else {
                    variants.each { variant ->
                        // check the current significance boundary--if it's equal to the
                        // significance that we fetched with, then we don't need to iterate
                        // any more. We can't break out of the each closure, but we can
                        // skip the computations in the closure
                        if(significanceList[significanceLevelTracker] == significance) {
                            return true
                        }

                        // find the p-value object
                        JSONObject pvalObject = variant.find { variantData ->
                            return (variantData as JSONObject).keySet()[0].indexOf('P_') == 0
                        } as JSONObject
                        // pull out the p-value
                        float pVal = pvalObject[pValueText][dataset][phenotype]
                        // check if it's > the next significance boundary
                        if(pVal > significanceList[significanceLevelTracker]) {
                            // I feel like this while loop could use an explanation, but I don't know of a good
                            // way to explain
                            while(pVal > significanceList[significanceLevelTracker]) {
                                // if so, save the current value of counter for the current significance level, and decrement the significane tracker
                                values.add([
                                        level: significanceList[significanceLevelTracker],
                                        count: counter
                                ] as JSONObject)
                                significanceLevelTracker--
                            }
                        }
                        counter++
                    }
                }


                // get out of the while loop, because we've now got all the data we need
                break
            }
            i++
        }

        returnValue.values = values

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
        //getDataQueryHolder.getDataQuery.setLimit(5000)
        // DIGP-300: upping default getData limit to 5k for better MAF counts for HDAC9 gene (was getting counts > 1k)
        Boolean isCount = true;
        getDataQueryHolder.isCount(isCount);
       // getDataQueryHolder.getDataQuery.setLimit(1000)
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
        String retdat;
        retdat = getRestCallBase("${METADATA_URL}?mdv=${this.metaDataService?.getDataVersion()}", currentRestServer());
        return retdat;
    }

    public String getSampleMetadata() {
        String retdat
        retdat = getRestCallBase("${GET_SAMPLE_METADATA_URL}?mdv=${this.metaDataService?.getDataVersion()}", currentRestServer())
        return retdat
    }


    public String getGeneMetadata() {
        String retdat
        retdat = getRestCallBase("${GENE_METADATA_URL}?mdv=${this.metaDataService?.getDataVersion()}", currentRestServer())
        return retdat
    }

    public String getHailMetadata() {
        String retdat
        retdat = getRestCallBase(HAIL_METADATA_URL, currentRestServer())
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
                        SampleGroup sampleGroup = metaDataService.getSampleGroupByName(dataSetNames[j].dataset, MetaDataService.METADATA_VARIANT)
                        pValObject = [level: i, count: sampleGroup.getSubjectsNumber()]
                    } else {
                        pValObject = [level: i, count: apiResults.numRecords]
                    }
                    pValsArray << pValObject
                } else {
                    log.error("error in combinedEthnicityTable = '${apiData.error_msg}', code = ${apiData.error_code}")
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
    public LinkedHashMap getColumnsToDisplay(String filterJson, LinkedHashMap<String, LinkedHashMap> requestedProperties) {
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
//        if (!requestedProperties) {
            JsonSlurper slurper = new JsonSlurper()
            for (def parsedFilter in slurper.parseText(filterJson)) {
                datasetsToFetch << parsedFilter.dataset_id
                phenotypesToFetch << parsedFilter.phenotype
                propertiesToFetch << parsedFilter.operand
            }
//        }

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
                if (phenotype != 'common') { // has this bug always been here? Is it a bug?
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
//                            commonProperties = []
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
//        if (!requestedProperties) {
            commonProperties = expandCommonPropertyList(commonProperties, requestedProperties)
//        }

        LinkedHashMap columnsToDisplayStructure = sharedToolsService.getColumnsToDisplayStructure(phenotypesToFetch, datasetsToFetch, propertiesToFetch, commonProperties)
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
    private JSONObject gatherTraitSpecificResults(String phenotypeName, String dataset, LinkedHashMap properties, BigDecimal maximumPValue, BigDecimal minimumPValue) {
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CLOSEST_GENE", "CHROM", "POS"])
        List<String> filters = []
        String orValue = orSubstitute(properties)
        if (orValue.length() > 0) {
            addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataset, orValue)
        }
        String pValueName = filterManagementService.findFavoredMeaningValue ( dataset, phenotypeName, "P_VALUE" )
        filters << "17=${phenotypeName}[${dataset}]${pValueName}<${maximumPValue.toString()}"
        filters << "17=${phenotypeName}[${dataset}]${pValueName}>${minimumPValue.toString()}"
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters, searchBuilderService, metaDataService)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataset, pValueName)
        addColumnsForDProperties(resultColumnsToDisplay, "${MAFPHENOTYPE}", dataset)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        getDataQueryHolder.addOrderByProperty(metaDataService.getPropertyByNamePhenotypeAndSampleGroup(pValueName, phenotypeName, dataset,MetaDataService.METADATA_VARIANT), '1')
        getDataQueryHolder.getDataQuery.setLimit(500)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }





    private JSONObject gatherGenePrioritizationInformation (String phenotypeName, String dataSetName, String propertyName) {
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties([ "GENE", "START" , "END", "GEN_ID", "CHROM"])
        List<String> filters = []
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filters, searchBuilderService, metaDataService,MetaDataService.METADATA_GENE)

        // for now let's make the assumption that we always want to look at case and control counts for this phenotype.  We can manufacture those if we cut some corners
      //List <String> piecesOfThePropertyName = propertyName.split("_")
        List<String> nameOfColumnsString = []

        String filter1 = ""
        String filter2 = ""
        //HACK EXPERIMENT - checking if given property for Exeq shows data or not.

       if(propertyName.startsWith("OR_FIRTH")){
           List<String> splitsOfPropertyName = propertyName.split("OR_FIRTH_")
           nameOfColumnsString.add(splitsOfPropertyName[0])
           nameOfColumnsString.add(splitsOfPropertyName[1])
           nameOfColumnsString.add("OR")
           nameOfColumnsString.add("P")
           filter1 = "AC_" + nameOfColumnsString[1]
           filter2 = "P_FIRTH_" + nameOfColumnsString[1]

       }
        else{
           List<String> splitsOfPropertyName1 = propertyName.split("OR_")
           List<String> splitsOfPropertyName2 = splitsOfPropertyName1[1].split("_FIRTH_")
           nameOfColumnsString.add(splitsOfPropertyName2[0])
           nameOfColumnsString.add(splitsOfPropertyName2[1])
           filter1 = "AC_" + nameOfColumnsString[1]
           filter2 = "P_FIRTH_" + nameOfColumnsString[1]
           if((splitsOfPropertyName2[0] == "WEIGHTED") || (splitsOfPropertyName2[0] == "MIN_P")){
               nameOfColumnsString.add("OR_")
               nameOfColumnsString.add("P_")
               filter2 = nameOfColumnsString[3] + nameOfColumnsString[0] + "_FIRTH_" + nameOfColumnsString[1]
           }

       }

        String propertyNameForMINARatio   = "MINA_" + nameOfColumnsString[1]
        String propertyNameForMINURatio   = "MINU_"+ nameOfColumnsString[1]
        String propertyNameForNumberOfVariants = "NUM_PASS_VARS_" + nameOfColumnsString[1]
        String propertyNameForOddsRatio   = nameOfColumnsString[2]+ nameOfColumnsString[0] + "_FIRTH_" + nameOfColumnsString[1]
        String propertyNameForPFirthvalue = nameOfColumnsString[3] + nameOfColumnsString[0] + "_FIRTH_" + nameOfColumnsString[1]
        String propertyNameForSkatValue   = nameOfColumnsString[3] + nameOfColumnsString[0] + "_SKAT_" + nameOfColumnsString[1]

        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyName)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForOddsRatio)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForPFirthvalue)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForSkatValue)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForMINARatio)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForMINURatio)
        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, dataSetName, propertyNameForNumberOfVariants)

        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        getDataQueryHolder.addOrderByProperty(metaDataService.getPropertyByNamePhenotypeAndSampleGroup(propertyNameForPFirthvalue, phenotypeName, dataSetName,MetaDataService.METADATA_GENE), '1')

        PropertyBean pb = new PropertyBean()
        pb.setName(filter1)
        pb.setVariableType("INTEGER")
        pb.addMeaning(filter1)
        pb.searchable = "true"
        pb.setRequestedPhenotype(phenotypeName)
        pb.setRequestedDataset(dataSetName)
        pb.setGeneTablemdv37(true)

        String propertyFilter2 = ""
        PropertyBean pb2 = new PropertyBean()
        pb2.setName(filter2)
        pb2.setVariableType("INTEGER")
        pb2.addMeaning(filter2)
        pb2.searchable = "true"
        pb2.setRequestedPhenotype(phenotypeName)
        pb2.setRequestedDataset(dataSetName)
        pb2.setGeneTablemdv37(true)

       // pb.setParent(DataSet)

        QueryFilterBean qb = new QueryFilterBean(pb, "GT","0",phenotypeName,dataSetName,true)

        QueryFilterBean qb2 = new QueryFilterBean(pb2, "GT","0",phenotypeName,dataSetName,true)

        if(filters.isEmpty()){
            getDataQueryHolder.getDataQuery.addQueryFilter(qb)
            getDataQueryHolder.getDataQuery.addQueryFilter(qb2)
        }

        getDataQueryHolder.getDataQuery.setLimit(1000)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postGeneDataQueryRestCall(getDataQueryHolder)
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

        JSONObject apiResults = gatherTraitSpecificResults(phenotypeName, dataSet, properties, maximumPValue, minimumPValue)
        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults, "", ",\n\"dataset\":\"${dataSet}\"", MetaDataService.METADATA_VARIANT )
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)
        return returnValue
    }
    
    public JSONObject getGenePrioritizationInformation(String phenotypeName, String dataSetName, String propertyName) {
        JSONObject returnValue

        JSONObject apiResults = gatherGenePrioritizationInformation (phenotypeName, dataSetName, propertyName)
        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults, "", ",\n\"dataset\":\"${dataSetName}\"", MetaDataService.METADATA_GENE )
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)
        return returnValue
    }



    /***
     * Gather up the data that is used in the Manhattan plot
     *
     * @param phenotype
     * @param dataSetName

     */
    public JSONObject getClumpSpecificInformation(String phenotype, String dataSetName,String r2) {
        JSONObject returnValue
        JsonSlurper slurper = new JsonSlurper()

        JSONObject apiResults = this.getClumpDataRestCall(phenotype, dataSetName,r2)


        String jsonParsedFromApi = processInfoFromGetClumpDataCall( apiResults, "", ",\n\"dataset\":\"${dataSetName}\"" )

        JSONObject dataJsonObject = slurper.parseText(jsonParsedFromApi)

        return dataJsonObject
    }



    public JSONObject gatherSpecificTraitsPerVariantResults( String variantName, List<LinkedHashMap<String,String>> propsToUse) {
        String filterByVariantName = codedfilterByVariant(variantName)
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CHROM", "POS"])
        for(LinkedHashMap oneReference in propsToUse){
            addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, oneReference.prop)
            Property betaProperty = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(oneReference.phenotype,oneReference.ds,
                                                                                            "BETA",MetaDataService.METADATA_VARIANT)
            if (betaProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, betaProperty.name)
            }
            Property orProperty = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(oneReference.phenotype,oneReference.ds,
                                                                                        "ODDS_RATIO",MetaDataService.METADATA_VARIANT)
            if (orProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, orProperty.name)
            }
            Property dirProperty = metaDataService.getPropertyByNamePhenotypeAndSampleGroup("DIR",oneReference.phenotype,oneReference.ds,MetaDataService.METADATA_VARIANT)
            if (dirProperty){
                addColumnsForPProperties(resultColumnsToDisplay, oneReference.phenotype, oneReference.ds, dirProperty.name)
            }
            Property mafProperty = metaDataService.getSampleGroupProperty(oneReference.ds,"MAF",MetaDataService.METADATA_VARIANT)
            if (mafProperty){
                addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, oneReference.ds)
            }

        }
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([filterByVariantName], searchBuilderService, metaDataService)
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }




    public JSONObject gatherTopVariantsPerSg(  String phenotype, String geneName, float pValueSignificance, SampleGroup  sampleGroup  ) {
        List<String> queryFilterStrings = []
        String sampleGroupName = sampleGroup.systemId
        Experiment experiment = sampleGroup.parent
        String pValueName = filterManagementService.findFavoredMeaningValue ( sampleGroupName, phenotype, "P_VALUE" )
        String betaName = filterManagementService.findFavoredMeaningValue ( sampleGroupName, phenotype, "BETA" )
        String orName = filterManagementService.findFavoredMeaningValue ( sampleGroupName, phenotype, "ODDS_RATIO" )
        queryFilterStrings << "17=${phenotype}[${sampleGroupName}]${pValueName}<${pValueSignificance.toString()}"
        if ((experiment?.technology == 'ExSeq')||(experiment?.technology == 'WGS')){
            queryFilterStrings << "7=${geneName}"
        } else {
            LinkedHashMap  regionSpecification = sharedToolsService.getGeneExpandedExtent(geneName,EXPAND_ON_EITHER_SIDE_OF_GENE)
            queryFilterStrings << "8=${regionSpecification.chrom}"
            queryFilterStrings << "9=${regionSpecification.startExtent}"
            queryFilterStrings << "10=${regionSpecification.endExtent}"
        }



        String technology = ""
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CHROM", "POS",
                                                                         "MOST_DEL_SCORE",
                                                                         "Consequence",
                                                                         "Reference_Allele",
                                                                         "Effect_Allele",
                                                                         "Protein_change"])
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "DIR", technology, sampleGroupName )
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "BETA", technology, sampleGroupName)
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "ODDS_RATIO", technology, sampleGroupName)
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "P_VALUE", technology, sampleGroupName)
        List<String> sampleGroupsWithMaf =
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("MAF", sharedToolsService.getCurrentDataVersion(), technology, false).collect {
                    it.parent.systemId
                }
        for (String sampleGroupWithMaf in sampleGroupsWithMaf) {
            if (sampleGroupWithMaf == sampleGroupName){
                addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, sampleGroupWithMaf)
            }
        }
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(queryFilterStrings, searchBuilderService, metaDataService )
        getDataQueryHolder.addProperties(resultColumnsToDisplay)
        JsonSlurper slurper = new JsonSlurper()
        String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        // need to figure out data set and property names
        List<LinkedHashMap<String, String>> matchers = identifyMatchers( 'P_VALUE', '' )
        // would be handy to replace all of the assorted P values with just 1 string
      //  if (pValueName != 'P_VALUE'){
            for (List variant in dataJsonObject.variants) {
                Map holder = variant.find{p->p.keySet().contains(pValueName)}
                List<LinkedHashMap> recDescriptor = matchers.findAll{it.ds==holder[pValueName].keySet()[0]
                   // &&it.pname==pValueName
                }
                if (recDescriptor.size()>=1){
                    LinkedHashMap currentRecDescriptor = recDescriptor.first()
                    variant << ['pname':currentRecDescriptor['pname']]
                    variant << ['pheno':currentRecDescriptor['pheno']]
                    variant << ['datasetname':currentRecDescriptor['ds']]
                } else {
                    println("strange.  ${recDescriptor.size()} results")
                }
//                holder['P_VALUE'] = holder[pValueName]
//                holder.remove(pValueName)

            }
      //  }

        return dataJsonObject
    }



    public JSONObject gatherTopVariantsFromAggregatedTables( String phenotype,String geneName,
                                                            int  startHere, int pageSize,
                                                            String version )  {
        List<String> specifyRequestList = []
        //specifyRequestList << "\"version\":\"${sharedToolsService.getCurrentDataVersion()}\""
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "\"phenotype\":\"${phenotype}\""
        }
        if (startHere != -1) {
            specifyRequestList << "\"page_start\":${startHere}"
        }
        if (pageSize != -1) {
            specifyRequestList << "\"page_size\":${pageSize}"
        }
        if ((geneName) && (geneName.length() > 0)) {
            specifyRequestList << "\"gene\":\"${geneName}\""
        }
        if ((version) && (version.length() > 0)) {
            specifyRequestList << "\"version\":\"${version}\""
        }
        return postRestCall("{${specifyRequestList.join(",")}}", GET_DATA_AGGREGATION_URL)
    }



    public JSONArray gatherEqtlDataForVariantList( String gene,List<String> variants,
                                     String tissue ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((variants) && (variants.length() > 0)) {
            specifyRequestList << "var_id=${variants.join(",").replace("\"","")}"
        }
        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }
        String rawReturnFromApi =  getRestCallBase("${GET_EQTLS_FOR_A_VARIANT_LIST_URL}?${specifyRequestList.join("&")}", currentRestServer())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(rawReturnFromApi) as JSONArray
        return jsonArray
    }



    public JSONArray gatherEqtlData( String gene,String variant,
    String tissue ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((variant) && (variant.length() > 0)) {
            specifyRequestList << "variant=${variant}"
        }
        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }
        String rawReturnFromApi =  getRestCall("${GET_VARIANT_GTEX_EQTL_FROM_URL}?${specifyRequestList.join("&")}")
        //String rawReturnFromApi =  getRestCallBase("ledge/gtex_eqtl/object?${specifyRequestList.join("&")}", GET_TEMPORARY_EQTL_URL)
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(rawReturnFromApi) as JSONArray
        return jsonArray
    }


    public JSONArray gatherAbcData( String gene, String tissue,
                                     int  startPosition, int  endPosition, String chromosome, List <String> variantList ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }
        if ((chromosome) && (chromosome.length() > 0)) {
            specifyRequestList << "chrom=${chromosome}"
        }
        if (startPosition > -1) {
            specifyRequestList << "start_pos=${startPosition}"
        }
        if (endPosition > -1) {
            specifyRequestList << "end_pos=${endPosition}"
        }
        if ((variantList) && (variantList.length() > 0)) {
            specifyRequestList << "var_id=${variantList.join(",").replace("\"","")}"
        }


        String rawReturnFromApi =  getRestCall("${GET_REGION_FROM_ABC_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(rawReturnFromApi) as JSONArray
        return jsonArray
    }




    public JSONArray gatherDepictData( String gene, String phenotype,
                                    int  startPosition, int  endPosition, String chromosome ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }
        if ((chromosome) && (chromosome.length() > 0)) {
            specifyRequestList << "chrom=${chromosome}"
        }
        if (startPosition > -1) {
            specifyRequestList << "start_pos=${startPosition}"
        }
        if (endPosition > -1) {
            specifyRequestList << "end_pos=${endPosition}"
        }


        String rawReturnFromApi =  getRestCall("${GET_GENE_BASED_RECORDS_FROM_DEPICT_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray
        try{
            jsonArray = slurper.parseText(rawReturnFromApi) as List
        } catch(Exception e){
            jsonArray = [slurper.parseText(rawReturnFromApi)] as List
        }
        return jsonArray
    }






    public JSONArray gatherDepictTissues(  String phenotype ) {
        List<String> specifyRequestList = []
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }

        String rawReturnFromApi =  getRestCall("${GET_TISSUE_BASED_RECORDS_FROM_DEPICT_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray
        try{
            jsonArray = slurper.parseText(rawReturnFromApi) as List
        } catch(Exception e){
            jsonArray = [slurper.parseText(rawReturnFromApi)] as List
        }
        return jsonArray
    }





    public JSONObject gatherGregorData(  String phenotype ) {
        List<String> specifyRequestList = []
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }

        String rawReturnFromApi =  getRestCall("${GET_TISSUES_FROM_GREGOR_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject
        try{
            jsonObject = slurper.parseText(rawReturnFromApi)
        } catch(Exception e){
            log.error("ERROR: gatherGregorData. problem parsing the data we received from the KB")
        }
        return jsonObject
    }


    public JSONObject gatherLdsrData(  String phenotype ) {
        List<String> specifyRequestList = []
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }

        String rawReturnFromApi =  getRestCall("${GET_TISSUES_FROM_LDSR_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject
        try{
            jsonObject = slurper.parseText(rawReturnFromApi)
        } catch(Exception e){
            log.error("ERROR: gatherGregorData. problem parsing the data we received from the KB")
        }
        return jsonObject
    }




    public JSONObject gatherDepictGeneSetData( String gene, String phenotype, float pValueThreshold ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }
        if ((pValueThreshold) ) {
            specifyRequestList << "lt_value=${pValueThreshold}"
        }

        String rawReturnFromApi =  getRestCall("${GET_GENESET_RECORDS_FROM_DEPICT_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject
        try{
            jsonObject = slurper.parseText(rawReturnFromApi) as List
        } catch(Exception e){
            // are you telling me this stupid library interprets a list of one as not a list at all, but an object?  eat me, Java
            jsonObject = [slurper.parseText(rawReturnFromApi)] as List
        }
        return jsonObject
    }






    public JSONArray gatherDnaseData(  String tissue, List <String> variantList ) {
        List<String> specifyRequestList = []

        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }

        if ((variantList) && (variantList.length() > 0)) {
            specifyRequestList << "var_id=${variantList.join(",").replace("\"","")}"
        }

        String rawReturnFromApi =  getRestCall("${GET_DNASE_RECORDS_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(rawReturnFromApi) as JSONArray
        return jsonArray
    }





    public JSONArray gatherH3k27acData( String tissue, List <String> variantList ) {
        List<String> specifyRequestList = []

        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }

        if ((variantList) && (variantList.length() > 0)) {
            specifyRequestList << "var_id=${variantList.join(",").replace("\"","")}"
        }

        String rawReturnFromApi =  getRestCall("${GET_H3K27AC_RECORDS_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(rawReturnFromApi) as JSONArray
        return jsonArray
    }



    public JSONObject gatherEffectorGeneData(  List <String> geneList ) {
        List<String> specifyRequestList = []

        if ((geneList) && (geneList.length() > 0)) {
            specifyRequestList << "gene=${geneList.join(",").replace("\"","")}"
        }

        String rawReturnFromApi =  getRestCall("${GET_EFFECTOR_GENE_INFO_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject = slurper.parseText(rawReturnFromApi) as JSONObject
        return jsonObject
    }




    public JSONArray gatherECaviarData( String gene, String tissue,
                                         String variant, String phenotype,
                                         int  startPosition, int  endPosition,
                                        String chromosome) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }
        if ((variant) && (variant.length() > 0)) {
            specifyRequestList << "variant=${variant}"
        }

        if ((chromosome) && (chromosome.length() > 0)) {
            specifyRequestList << "chrom=${chromosome}"
        }
        if (startPosition > -1) {
            specifyRequestList << "start_pos=${startPosition}"
        }
        if (endPosition > -1) {
            specifyRequestList << "end_pos=${endPosition}"
        }

        String rawReturnFromApi =  getRestCall("${GET_VARIANT_ECAVIAR_COLOCALIZATION_FROM_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray
        try{
            jsonArray = slurper.parseText(rawReturnFromApi) as List
        } catch(Exception e){
            // are you telling me this stupid library interprets a list of one as not a list at all, but an object?  eat me, Java
            jsonArray = [slurper.parseText(rawReturnFromApi)] as List
        }
        return jsonArray
    }


    public JSONObject gatherModsData( String gene ) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }

        String rawReturnFromApi =  getRestCall("${GET_GENE_BASED_RECORDS_FROM_MODS_URL}?${specifyRequestList.join("&")}")
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray
        JSONObject jsonObject
        try {
            try{
                jsonArray = slurper.parseText(rawReturnFromApi) as List
            } catch(Exception e){
                // are you telling me this stupid library interprets a list of one as not a list at all, but an object?  eat me, Java
                jsonArray = [slurper.parseText(rawReturnFromApi)] as List
            }
            jsonObject = new JSONObject()
            jsonObject['gene']=gene
            jsonObject['records']=jsonArray
        } catch (Exception e){
            e.printStackTrace()
        }

        return jsonObject
    }







    public JSONArray gatherEColocData( String gene, String tissue,
                                        String variant, String phenotype,
                                        int  startPosition, int  endPosition,
                                        String chromosome) {
        List<String> specifyRequestList = []
        if ((gene) && (gene.length() > 0)) {
            specifyRequestList << "gene=${gene}"
        }
        if ((tissue) && (tissue.length() > 0)) {
            specifyRequestList << "tissue=${tissue}"
        }
        if ((phenotype) && (phenotype.length() > 0)) {
            specifyRequestList << "phenotype=${phenotype}"
        }
        if ((variant) && (variant.length() > 0)) {
            specifyRequestList << "variant=${variant}"
        }

        if ((chromosome) && (chromosome.length() > 0)) {
            specifyRequestList << "chrom=${chromosome}"
        }
        if (startPosition > -1) {
            specifyRequestList << "start_pos=${startPosition}"
        }
        if (endPosition > -1) {
            specifyRequestList << "end_pos=${endPosition}"
        }

        String rawReturnFromApi =  getRestCall("${GET_VARIANT_COLOC_COLOCALIZATION_FROM_URL}?${specifyRequestList.join("&")}".toString())
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray
        try{
            jsonArray = slurper.parseText(rawReturnFromApi) as List
        } catch(Exception e){
            jsonArray = [slurper.parseText(rawReturnFromApi)] as List
        }
        return jsonArray
    }





    public JSONObject gatherTopVariantsFromAggregatedTablesByRange( String phenotype,
                                                                    Long startExtent,
                                                                    Long endExtent,
                                                                    String chromosomeNumber,
                                                                     int  startHere, int pageSize,
                                                                     String version ) {
        List<String> specifyRequestList = []
        Boolean phenotypeQuery = false
        if (retrieveBeanForCurrentPortal().highSpeedGetAggregatedDataCall){

            if ((version) && (version.length() > 0)) {
                specifyRequestList << "\"version\":\"${version}\""
            } else {
                log.error("ERROR: gatherTopVariantsFromAggregatedTablesByRange. version parameter required")
            }

            // the following parameter is required byt the API she. Provide some defaults
            if (pageSize == -1){
                pageSize = DEFAULT_NUMBER_OF_RESULTS_FROM_TOPVARIANTS
            }
            if (startHere == -1){
                startHere = 0
            }

            specifyRequestList << "\"pagination\":{\"size\": ${pageSize},\"offset\":${startHere}}"

            List<String> filterList = []
            if ((phenotype) && (phenotype.length() > 0)) {
                phenotypeQuery = true
                filterList <<  "{\"parameter\": \"phenotype\", \"operator\": \"eq\", \"value\": \"${phenotype}\"}"
            }
            if ((chromosomeNumber) && (chromosomeNumber.length() > 0)) {
                filterList <<  "{\"parameter\": \"chrom\", \"operator\": \"eq\", \"value\": \"${chromosomeNumber}\"}"
            }
            if (startExtent != -1) {
                filterList <<  "{\"parameter\": \"pos\", \"operator\": \"ge\", \"value\": ${startExtent}}"
            }
            if (endExtent != -1) {
                filterList <<  "{\"parameter\": \"pos\", \"operator\": \"le\", \"value\": ${endExtent}}"
            }
            specifyRequestList << "\"filters\":[\n${filterList.join(",")}\n]"

            if (TRY_RESTRICTING_ALL_AGGREGATED_CALLS_TO_TOP_VARIANTS){
                specifyRequestList << "\"topVariants\": true"
            } else {
                specifyRequestList << "\"topVariants\": false"
            }


            specifyRequestList << "\"sort\": [{ \"parameter\": \"P_VALUE\" }]"

        } else {
            if ((phenotype) && (phenotype.length() > 0)) {
                specifyRequestList << "\"phenotype\":\"${phenotype}\""
            }
            if (startHere != -1) {
                specifyRequestList << "\"pageStart\":${startHere}"
            }
            if (pageSize != -1) {
                specifyRequestList << "\"pageSize\":${pageSize}"
            }
            if ((chromosomeNumber) && (chromosomeNumber.length() > 0)) {
                specifyRequestList << "\"chrom\":\"${chromosomeNumber}\""
            }
            if (startExtent != -1) {
                specifyRequestList << "\"start\":${startExtent}"
            }
            if (endExtent != -1) {
                specifyRequestList << "\"end\":${endExtent}"
            }
            if ((version) && (version.length() > 0)) {
                specifyRequestList << "\"version\":\"${version}\""
            }
        }

        String restApiGetAggregationAndPoint = GET_DATA_AGGREGATION_BY_RANGE_PHENOTYPES_URL
        if (phenotypeQuery){
            restApiGetAggregationAndPoint = GET_DATA_AGGREGATION_BY_RANGE_VARIANTS_URL
        }
        return postRestCall("{${specifyRequestList.join(",")}}", restApiGetAggregationAndPoint)
    }


    public JSONObject getUcsdRangeData( List <String> biosampleTermNameList,
                                        List <String> labTitleList,
                                        List <String> organSlimList,
                                        List <String> biosampleTypeList,
                                        String annotationType,
                                        String region,
                                        int  startHere,
                                        int pageSize,
                                        String version ) {
        List<String> specifyRequestList = []
        String objectJoiner = "\",\""
        if ((biosampleTermNameList)&&(biosampleTermNameList.size()>0)) {
            specifyRequestList << "\"biosample_term_name\":[\"${biosampleTermNameList.join(objectJoiner)}\"]"
        }
        if ((labTitleList)&&(labTitleList.size()>0)) {
            specifyRequestList << "\"lab.title\":[\"${labTitleList.join(objectJoiner)}\"]"
        }
        if ((organSlimList)&&(organSlimList.size()>0)) {
            specifyRequestList << "\"organ_slims\":[\"${organSlimList.join(objectJoiner)}\"]"
        }
        if ((biosampleTypeList)&&(biosampleTypeList.size()>0)) {
            specifyRequestList << "\"biosample_type\":[\"${biosampleTypeList.join(objectJoiner)}\"]"
        }
        if ((region) && (region.length() > 0)) {
            specifyRequestList << "\"region\":\"${region}\""
        }
        if ((annotationType) && (annotationType.length() > 0)) {
            specifyRequestList << "\"annotation_type\":\"${annotationType}\""
        }
        specifyRequestList << "\"genome\":\"GRCh37\""
//        if (startHere != -1) {
//            specifyRequestList << "\"pageStart\":${startHere}"
//        }
//        if (pageSize != -1) {
//            specifyRequestList << "\"pageSize\":${pageSize}"
//        }
//        if ((version) && (version.length() > 0)) {
//            specifyRequestList << "\"version\":\"${version}\""
//        }
        return postRestCallBase("{${specifyRequestList.join(",")}}", UCSD_GET_ANNOTATION, UCSD_HACK )
    }





    public JSONObject gatherRegionInformation( String chromosome,int startPosition,int endPosition, int pageStart, int pageEnd,
                                               String source, String assayIdListInStringForm) {
        int revisedPageStart = 0;
        int revisedPageEnd = 1000;
        if (pageStart > 0){revisedPageStart = pageStart}
        if (pageEnd > 0){revisedPageEnd = pageEnd}
        List <String> restApiParameterList = []
        restApiParameterList << "\"passback\":\"abc123\""
        restApiParameterList << "\"page_start\": ${revisedPageStart}"
        restApiParameterList << "\"page_size\": ${revisedPageEnd}"
        restApiParameterList << "\"chrom\": \"${chromosome}\""
        restApiParameterList << "\"start_pos\": ${startPosition}"
        restApiParameterList << "\"end_pos\": ${endPosition}"
        if (retrieveBeanForCurrentPortal().getUtilizeUcsdData()){
            restApiParameterList << "\"host\": \"ucsd\""
        }
        if (source){
            restApiParameterList << "\"source\": \"${source}\""
        }
        if ((assayIdListInStringForm) ){
            restApiParameterList << "\"annotation\": ${assayIdListInStringForm}"
        }
        String specifyRequest = "{${restApiParameterList.join(",")}}"
        return postRestCall(specifyRequest, GET_REGION_URL)
    }


    public JSONObject gatherBottomLineResultsByVarId( String variantId ) {
        PortalVersionBean portalVersionBean = retrieveBeanForCurrentPortal();
        String rawReturnFromApi =  getRestCall(
                "${GET_BOTTOM_LINE_RESULTS_URL}?var_id=${variantId}&disease_focus=${portalVersionBean.getKnowledgeBaseName()}")
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject = slurper.parseText(rawReturnFromApi) as JSONObject
        return jsonObject
    }



    public JSONObject gatherTopVariantsFromAggregatedTablesByVarId( String phenotype,
                                                                    String varId,
                                                                    int  startHere, int pageSize,
                                                                    String version,
                                                                    Boolean includeAllAssociations ) {
        List<String> specifyRequestList = []

        if ((version) && (version.length() > 0)) {
            specifyRequestList << "\"version\":\"${version}\""
        } else {
            specifyRequestList << "\"version\":\"${metaDataService.getDataVersion()}\""
        }

        // the following parameter is required byt the API she. Provide some defaults
        if (pageSize == -1){
            pageSize = DEFAULT_NUMBER_OF_RESULTS_FROM_TOPVARIANTS
        }
        if (startHere == -1){
            startHere = 0
        }

        specifyRequestList << "\"pagination\":{\"size\": ${pageSize},\"offset\":${startHere}}"

        List<String> filterList = []
        if ((phenotype) && (phenotype.length() > 0)) {
            filterList <<  "{\"parameter\": \"phenotype\", \"operator\": \"eq\", \"value\": \"${phenotype}\"}"
        }
        if ((varId) && (varId.length() > 0)) {
            filterList <<  "{\"parameter\": \"VAR_ID\", \"operator\": \"eq\", \"value\": \"${varId}\"}"
        }

        specifyRequestList << "\"filters\":[\n${filterList.join(",")}\n]"

        if (includeAllAssociations){
            specifyRequestList << "\"topVariants\": false"
        } else {
            specifyRequestList << "\"topVariants\": true"
        }


        specifyRequestList << "\"sort\": [{ \"parameter\": \"P_VALUE\" }]"



        return postRestCall("{${specifyRequestList.join(",")}}", GET_DATA_AGGREGATION_PHEWAS_URL)
    }




    /***
     * We want to be able to pull back all of the gene level associations for a given phenotype/gene/desiredMeaning.  We will accept
     * all of the properties that have their meaning matching the desiredMeaning parameter, which should give us back all of the different
     * variant groupings used for burden testing, or alternatively all of the different tissues if we are pulling back
     * metaXcan data.
     *
     * @param phenotypeName
     * @return
     */
    public JSONObject gatherGenePhenotypeAssociations (String phenotypeName,String geneName,
                                                       List<String> desiredMeanings, String preferredSampleGroup) {

        // Now we need to find the data sets that contain the phenotype we are interested in.  If I end up with more than one data set than
        // I'll ignore every one other than the one with the largest sample size.
        List<SampleGroup> listOfSampleGroupsToWorkWith = []
        if (desiredMeanings?.size()>0){
            for (String desiredMeaning in desiredMeanings){
                List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupsBasedOnPhenotypeAndMeaning(phenotypeName,desiredMeaning,
                        MetaDataService.METADATA_GENE)
                boolean sampleGroupChosen = false
                if (preferredSampleGroup) { // if a specific sample group was requested then try to get it
                    SampleGroup requestedSampleGroup =  sampleGroupList?.find{it.getSystemId().contains(preferredSampleGroup)}
                    if (requestedSampleGroup){
                        listOfSampleGroupsToWorkWith << sampleGroupList?.first()
                        sampleGroupChosen = true
                    }
                }
                if (!sampleGroupChosen){ // either a specific sample group wasn't requested, or else we couldn't find it
                    sampleGroupList = sampleGroupList?.sort{SampleGroup a,SampleGroup b->b.subjectsNumber<=>a.subjectsNumber}
                    if ((sampleGroupList)&&(sampleGroupList.size()>0)){
                        listOfSampleGroupsToWorkWith << sampleGroupList?.first()
                    }

                }
            }
        }

        listOfSampleGroupsToWorkWith = listOfSampleGroupsToWorkWith.unique()
        // we might legitimately have no Gene level data for this phenotype
        String dataJsonObjectString
        if (listOfSampleGroupsToWorkWith.size()==0){
            dataJsonObjectString = """{
            "is_error": true,
            "error_message": "No gene level data for phenotype ${phenotypeName}"
        }""".toString()
        } else { // we have a sample group to work with
            // Let's start putting together the query. We can use existing machinery for this work
            LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["GENE" ])
            List<String> codedFilters = ["7=${geneName}".toString()]
            GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(codedFilters, searchBuilderService, metaDataService,MetaDataService.METADATA_GENE)

            // now let's find our chosen phenotype in the sample group, and then stroll through that phenotypes properties and pull back every name
            // which has our chosen meaning
            for (SampleGroup sampleGroup in listOfSampleGroupsToWorkWith){
                PhenotypeBean phenotype = sampleGroup.getPhenotypes().find{PhenotypeBean p->p.getName() == phenotypeName}
                for (String desiredMeaning in desiredMeanings) {
                    for(Property property in phenotype.getProperties().findAll{ PropertyBean p->p.hasMeaning(desiredMeaning)}){
                        addColumnsForPProperties(resultColumnsToDisplay, phenotypeName, sampleGroup.getSystemId(), property.getName())
                    }
                }


            }
            getDataQueryHolder.addProperties(resultColumnsToDisplay)
            getDataQueryHolder.getDataQuery.setLimit(5000)
            // go and get the data from the KB
            dataJsonObjectString = postGeneDataQueryRestCall(getDataQueryHolder)
        }
        JsonSlurper slurper = new JsonSlurper()
        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }















    public Map convertGeneCommonNameToEnsemblId( String gene, boolean removeTrailingDot ) {
        Map returnValue = [:]

        JsonSlurper slurper = new JsonSlurper()

        String combinedCommonNameUrl = GET_BOTTOM_LINE_VARIANTS_URL +"?id=" +gene

        String  retrieveGeneIdJsonAsString = getRestCall(combinedCommonNameUrl)

        List retrieveGeneIdArray =   slurper.parseText(retrieveGeneIdJsonAsString) as List
        if (retrieveGeneIdArray.size()>0){

            String ensemblId = ""
            String unmodifiedReturn = (retrieveGeneIdArray[0]["GEN_ID"] as String)
            if (removeTrailingDot){
                ensemblId = unmodifiedReturn - ~/\.([^\.]+)$/
            } else {
                ensemblId = unmodifiedReturn
            }
            returnValue ["GEN_ID"] = ensemblId
            returnValue ["CHROM"] = retrieveGeneIdArray[0]["CHROM"]
            returnValue ["START"] = retrieveGeneIdArray[0]["START"]
            returnValue ["END"] = retrieveGeneIdArray[0]["END"]
            returnValue ["GENE"] = retrieveGeneIdArray[0]["GENE"]

        } else {
            log.error("Problem:  we have an unrecognized gene common name == '${gene}'")
        }
        return returnValue
    }




    public Map gatherBottomLineVariantsPerGene( String gene ) {
        JsonSlurper slurper = new JsonSlurper()

        Map retval = [:]

        Map ensemblMapper = convertGeneCommonNameToEnsemblId(gene,false)
        String ensemblId = ensemblMapper.GEN_ID

        if (ensemblId){
            String combinedEnsemblNameUrl = GET_BOTTOM_LINE_VARIANTS_BY_ID_URL +"?id=" + ensemblId

            String  retrieveTissueExpressionInformationJsonAsString = getRestCall(combinedEnsemblNameUrl)

            List retrieveTissueExpressionArray =   slurper.parseText(retrieveTissueExpressionInformationJsonAsString)  as List

            retval =  retrieveTissueExpressionArray[0]
        }
        return retval



    }






    public Map gatherBottomLinePhenotypesVariantsPerRange( String chromosome, Integer startPosition, Integer endPosition ) {
        JsonSlurper slurper = new JsonSlurper()

        String combinedRangeAndUrl = "${GET_BOTTOM_LINE_PHENOTYPES_VIA_VARIANTS_URL}?chrom=${chromosome}&start=${startPosition}&end=${endPosition}"

        String  retrieveTissueExpressionInformationJsonAsString = getRestCall(combinedRangeAndUrl)

        Map bottomLinePhenotypes =   slurper.parseText(retrieveTissueExpressionInformationJsonAsString)  as Map

        return bottomLinePhenotypes

    }




    public List determineTissueAssociationPerPhenotype( String phenotype ) {
        JsonSlurper slurper = new JsonSlurper()

        String combinedPhenotypeAndUrl = "${GET_TISSUE_ASSOCIATION_BASED_ON_LDSR_URL}?id=${phenotype}"

        String  rawTissueWeightPerPhenotype = getRestCall(combinedPhenotypeAndUrl)

        List tissueWeightPerPhenotype =   slurper.parseText(rawTissueWeightPerPhenotype)  as List

        return tissueWeightPerPhenotype

    }










    public JSONObject gatherTopVariantsAcrossSgs( List<SampleGroup> fullListOfSampleGroups, String phenotype,String geneName, float pValueSignificance) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        JSONObject dataJsonObject
        List variants = []
        for (SampleGroup  sampleGroup in fullListOfSampleGroups){
            dataJsonObject =  gatherTopVariantsPerSg(  phenotype,  geneName, pValueSignificance, sampleGroup )
            for (List variant in dataJsonObject.variants) {
                variant << ['ds':g.message(code: "metadata." + sampleGroup.systemId, default: phenotype)]
                variant << ['dsr':"${ sampleGroup.systemId}".toString() ]
            }
            variants.addAll( dataJsonObject.variants )
        }
        Map<String,List> allVariants = [:]
        // first get a list of all variants indexed by var ID
        for (List variant in variants) {
            Map varId = variant.find{p->p.keySet().contains('VAR_ID')}
            String varIdVal = varId["VAR_ID"]
            if (!allVariants.containsKey(varIdVal)){
                allVariants[varIdVal] = []
            }
            allVariants[varIdVal] << variant
        }
        List uniqueVariants = []
        // Now go through the map and select the variants that have the lowest P value to keep
        for (String varId in allVariants.keySet()){
            List instancesOfVariant = allVariants[varId]
            if (instancesOfVariant.size()==1) {
                uniqueVariants << instancesOfVariant[0]
            } else {
                List<String> pValueString = []
                Map<Float,Map> sortHelper = [:]
                for (List instanceOfVariant in instancesOfVariant ){
                    String propName
                    Map pnameMaps = instanceOfVariant.find{p->p.keySet().contains('pname')}
                    if (pnameMaps) {
                        propName = pnameMaps["pname"]
                    } else {
                        println('really? -- no pname')
                    }
                    Map pMaps = instanceOfVariant.find{p->p.keySet().contains(propName)}
                    if (pMaps){
                        Map dsMap = pMaps[propName]
                        for (Map phenoMaps in dsMap.values()){
                            for (String value in phenoMaps.values()){
                                if (!sortHelper.containsKey()){
                                    sortHelper[value as Float] = instanceOfVariant
                                }
                                pValueString << value
                            }
                        }

                    } else {
                        println('strange -- no pvalue')
                    }

                }
                uniqueVariants << sortHelper.sort{ it.key }.values().first()
            }
        }
        dataJsonObject.variants = uniqueVariants

        return dataJsonObject
    }




    public JSONObject gatherTopVariantsAcrossSgsWhenORsWork( List<SampleGroup> fullListOfSampleGroups, String phenotype, float pValueSignificance) {
        List<QueryFilter> queryFilterList = []
        for (SampleGroup  sampleGroup in fullListOfSampleGroups){
            String pValueName = filterManagementService.findFavoredMeaningValue ( sampleGroup.systemId, phenotype, "P_VALUE" )
            queryFilterList.addAll( burdenService.getBurdenJsonBuilder().getPValueFilters(sampleGroup.systemId,pValueSignificance,phenotype,pValueName))
        }

        String technology = ""
        LinkedHashMap resultColumnsToDisplay = getColumnsForCProperties(["VAR_ID", "DBSNP_ID", "CHROM", "POS"])
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "DIR", technology)
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "BETA", technology)
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "ODDS_RATIO", technology)
        resultColumnsToDisplay = buildColumnsRequestForPProperties(resultColumnsToDisplay, "P_VALUE", technology)
        List<String> sampleGroupsWithMaf =
                JsonParser.getService().getAllPropertiesWithNameForExperimentOfVersion("MAF", sharedToolsService.getCurrentDataVersion(), technology, false).collect {
                    it.parent.systemId
                }
        for (String sampleGroupWithMaf in sampleGroupsWithMaf) {
            addColumnsForDProperties(resultColumnsToDisplay, MAFPHENOTYPE, sampleGroupWithMaf)
        }
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolderFromFilters(queryFilterList, searchBuilderService, metaDataService,true)
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
            LinkedHashMap tempPropertyList = [:]
            for (Property property in propertyList){
                String identifier = property.parent.name+"_"+property.parent.parent.systemId
                if (!tempPropertyList.containsKey(identifier)){
                    tempPropertyList[identifier] = property
                } else if (tempPropertyList[identifier].sortOrder>property.sortOrder){
                        tempPropertyList[identifier] = property
                }
            }
            matchers = tempPropertyList.values().collect { ['pname':it.name,'pheno': it.parent.name, 'ds': it.parent.parent.systemId, 'meaning':propertyOrMeaning] }
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
    private LinkedHashMap buildColumnsRequestForPProperties(LinkedHashMap resultColumnsToDisplay, String propertyOrMeaning, String technology, String datasetName ) {

        List<LinkedHashMap<String, String>> matchers = identifyMatchers( propertyOrMeaning, technology )

        for (LinkedHashMap dirMatcher in matchers) {
            if (dirMatcher.ds == datasetName){
                addColumnsForPProperties(resultColumnsToDisplay, dirMatcher.pheno, dirMatcher.ds, dirMatcher.pname)
            }
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
        //JsonSlurper slurper = new JsonSlurper()
        JSONObject dataJsonObject = postMultiJoinProtectedDataQueryRestCall(getDataQueryHolder)
        //String dataJsonObjectString = postDataQueryRestCall(getDataQueryHolder)
//        JSONObject dataJsonObject = slurper.parseText(dataJsonObjectString)
        return dataJsonObject
    }



    /***
     * This is the universal API return value reader.
     * @param apiResults
     * @return
     */
    public String processInfoFromGetDataCall ( JSONObject apiResults, String additionalDataSetInformation, String topLevelInformation, int metadataTree ){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        List<String> crossVariantData = []
        if (!apiResults["is_error"]){
            int numberOfVariants = apiResults.numRecords
            for (int j = 0; j < numberOfVariants; j++) {
                List<String> keys = []
                def valueToLoopOver
                if (apiResults.variants[j] instanceof JSONObject) {
                    valueToLoopOver = (apiResults.variants[j] as Map).keySet()
                } else {
                    for (int i = 0; i < apiResults.variants[j]?.size(); i++) {
                        keys << (new JSONObject(apiResults.variants[j][i]).keys()).next()
                    }
                    valueToLoopOver = keys
                }
                List<String> variantSpecificList = []
                for (def key in valueToLoopOver) {
                    def value
                    if (apiResults.variants[j][key] instanceof ArrayList){
                        value = apiResults.variants[j][key].findAll { it }[0]
                    } else {
                        value = apiResults.variants[j][key]
                    }
                    if (value instanceof String) {
                        String stringValue = value as String
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${stringValue}\"}"
                    } else if (value instanceof Integer) {
                        Integer integerValue = value as Integer
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${integerValue}\"}"
                    } else if (value instanceof BigDecimal) {
                        BigDecimal bigDecimalValue = value as BigDecimal
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${bigDecimalValue}\"}"
                    } else if (value instanceof Map) {
                        Map mapValue = value as Map
                        List<String> subKeys = mapValue.keySet() as List
                        for (String subKey in subKeys) {
                            // maybe subKey is always a group ID
                            SampleGroup sampleGroup = metaDataService.getSampleGroupByName(subKey,metadataTree)
                            String dataSetName = sampleGroup.systemId
                            String translatedDatasetName = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                            String ancestry = "unknown"
                            if (sampleGroup) {
                                ancestry = sampleGroup.getAncestry()
                            }
                            def particularMapValue = mapValue[subKey]
                            if (particularMapValue instanceof BigDecimal) {// data set particular values
                                BigDecimal particularMapBigDecimalValue = particularMapValue as BigDecimal
                                variantSpecificList << "{\"level\":\"${key}^NONE^${key}^${subKey}^${ancestry}^${translatedDatasetName}\",\"count\":${particularMapBigDecimalValue}}"
                            } else if (particularMapValue instanceof Integer) {// data set particular values
                                Integer particularMapIntegerValue = particularMapValue as Integer
                                variantSpecificList << "{\"level\":\"${key}^NONE^${key}^${subKey}^${ancestry}^${translatedDatasetName}\",\"count\":${particularMapIntegerValue}}"
                            } else if (particularMapValue instanceof Map) {
                                Map particularSubMap = particularMapValue as Map
                                List<String> particularSubKeys = particularSubMap.keySet() as List
                                for (String particularSubKey in particularSubKeys) {
                                    def particularSubMapValue = particularSubMap[particularSubKey]
                                    BigDecimal phenoValue = particularSubMapValue.findAll { it }[0] as BigDecimal
                                    String translatedPhenotypeName = g.message(code: 'metadata.' + particularSubKey, default: particularSubKey);
                                    String meaning = metaDataService.getMeaningForPhenotypeAndSampleGroup(key, particularSubKey, subKey, metadataTree)
                                    variantSpecificList << "{\"level\":\"${key}^${particularSubKey}^${meaning}^${subKey}^${ancestry}^${translatedDatasetName}^${translatedPhenotypeName}\",\"count\":${phenoValue}}"
                                }

                            }
                        }

                    } else if (value instanceof ArrayList) {
                        ArrayList arrayListValue = value as ArrayList
                        log.error("An ArrayList is not an expected result.  Did the return data format change?")
                    }
                }
                crossVariantData << "{ \"dataset\": 1, ${additionalDataSetInformation}, \"pVals\": [".toString() + variantSpecificList.join(",") + "]}"
            }
        }
        return  "{\"results\":[" +  crossVariantData.join(",") + "]"+topLevelInformation+"}"
    }



    public String processInfoFromGetClumpDataCall ( JSONObject apiResults, String additionalDataSetInformation, String topLevelInformation ){
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        List<String> crossVariantData = []
        if (!apiResults["is_error"]){
            int numberOfVariants = apiResults.numRecords
            boolean isClumped = apiResults.isClump

            if(!isClumped){
                List<String> variantSpecificList = []
                crossVariantData << "{\"isClump\": ${isClumped}, \"dataset\": 1, ${additionalDataSetInformation}, \"pVals\": [".toString() + variantSpecificList.join(",") + "]}"
                return  "{\"results\":[" +  crossVariantData.join(",") + "]"+topLevelInformation+"}"
            }

            for (int j = 0; j < numberOfVariants; j++) {
                List<String> keys = []
                List<String> keys2 = []


                keys = ["P_VALUE","MAF","ODDS_RATIO", "BETA",  "DBSNP_ID", "VAR_ID", "R2", "POS", "CHROM", "CLOSEST_GENE"];


                // keys = ["P_VALUE","MAF","ODDS_RATIO^T2D^ODDS_RATIO^ExChip_ExTexT2D_mdv34^Mixed^ExTexT2D exome chip analysis^Type 2 diabetes",  "DBSNP_ID", "VAR_ID", "R2", "POS", "CHROM", "CLOSEST_GENE"];
                List<String> variantSpecificList = []
                for (String key in keys) {
                    ArrayList valueArray = []
                  //String Chrom =   apiResults.variants[0].VAR_ID.split("_")[0]
                   // Integer Chrom = Integer.parseInt(apiResults.variants[j].VAR_ID.split("_")[0])
                    apiResults.variants[j].CHROM = apiResults.variants[j].VAR_ID.split("_")[0].toString()
                    apiResults.variants[j].POS = Integer.parseInt(apiResults.variants[j].VAR_ID.split("_")[1])

//                    valueArray.add(apiResults.variants[j][key]);
//                    def value = valueArray.findAll { it }[0]

                    JSONObject jObj = apiResults.variants[j]
                    HashMap map = jObj as HashMap
                    def value = map[key]

                    if (value instanceof String) {
                        String stringValue = value as String
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${stringValue}\"}"
                    } else if (value instanceof Integer) {
                        Integer integerValue = value as Integer
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${integerValue}\"}"
                    } else if (value instanceof Double) {
                        Double doubleValue = value as Double
                        variantSpecificList << "{\"level\":\"${key}\",\"count\":\"${doubleValue}\"}"
                    } else if (value instanceof Map) {
                        Map mapValue = value as Map
                        List<String> subKeys = mapValue.keySet() as List
                        for (String subKey in subKeys) {
                            // maybe subKey is always a group ID
                            SampleGroup sampleGroup = metaDataService.getSampleGroupByName(subKey, MetaDataService.METADATA_VARIANT)
                            String dataSetName = sampleGroup.systemId
                            String translatedDatasetName = g.message(code: 'metadata.' + dataSetName, default: dataSetName);
                            String ancestry = "unknown"
                            if (sampleGroup) {
                                ancestry = sampleGroup.getAncestry()
                            }
                            def particularMapValue = mapValue[subKey]
                            if (particularMapValue instanceof BigDecimal) {// data set particular values
                                BigDecimal particularMapBigDecimalValue = particularMapValue as BigDecimal
                                variantSpecificList << "{\"level\":\"${key}^NONE^${key}^${subKey}^${ancestry}^${translatedDatasetName}\",\"count\":${particularMapBigDecimalValue}}"
                            } else if (particularMapValue instanceof Integer) {// data set particular values
                                Integer particularMapIntegerValue = particularMapValue as Integer
                                variantSpecificList << "{\"level\":\"${key}^NONE^${key}^${subKey}^${ancestry}^${translatedDatasetName}\",\"count\":${particularMapIntegerValue}}"
                            } else if (particularMapValue instanceof Map) {
                                Map particularSubMap = particularMapValue as Map
                                List<String> particularSubKeys = particularSubMap.keySet() as List
                                for (String particularSubKey in particularSubKeys) {
                                    def particularSubMapValue = particularSubMap[particularSubKey]
                                    BigDecimal phenoValue = particularSubMapValue.findAll { it }[0] as BigDecimal
                                    String translatedPhenotypeName = g.message(code: 'metadata.' + particularSubKey, default: particularSubKey);
                                    String meaning = metaDataService.getMeaningForPhenotypeAndSampleGroup(key, particularSubKey, subKey, MetaDataService.METADATA_VARIANT)
                                    variantSpecificList << "{\"level\":\"${key}^${particularSubKey}^${meaning}^${subKey}^${ancestry}^${translatedDatasetName}^${translatedPhenotypeName}\",\"count\":${phenoValue}}"
                                }

                            }
                        }

                    } else if (value instanceof ArrayList) {
                        ArrayList arrayListValue = value as ArrayList
                        log.error("An ArrayList is not an expected result.  Did the return data format change?")
                    }
                }
                crossVariantData << "{\"isClump\": ${isClumped}, \"dataset\": 1, ${additionalDataSetInformation}, \"pVals\": [".toString() + variantSpecificList.join(",") + "]}"
            }
        }
        return  "{\"results\":[" +  crossVariantData.join(",") + "]"+topLevelInformation+"}"
    }





    public JSONObject getSpecifiedTraitPerVariant( String variantName, List<LinkedHashMap<String,String>> propsToUse, List<String> openPhenotypes) {

        JSONObject returnValue
        JSONObject apiResults = gatherSpecificTraitsPerVariantResults(variantName, propsToUse)
        List<String> openPhenotypesWithQuotes = []
        for (String openPhenotype in openPhenotypes){
            if (openPhenotypes[0].indexOf("\"")== -1){
                openPhenotypesWithQuotes << "\"${openPhenotype}\""
            }
        }
        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults,"\"openPhenotypes\": ["+openPhenotypesWithQuotes.join(',')+"]", "", MetaDataService.METADATA_VARIANT )
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)

        return returnValue
    }




        /***
     * Generate the numbers for the 'Association statistics across 25 traits', which is displayed on the variant info page (elsewhere as well)
     * @param variantName
     * @return
     */
    public JSONObject getTraitPerVariant( String variantName, String technology ) {//region
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        JSONObject returnValue
        JSONObject apiResults = gatherTraitPerVariantResults( variantName, technology )
        if (apiResults.is_error){
            log.error("error in getTraitPerVariant = '${apiResults.error_msg}'")
        }

        String jsonParsedFromApi = processInfoFromGetDataCall( apiResults, "\"openPhenotypes\": []", "", MetaDataService.METADATA_VARIANT )
        def slurper = new JsonSlurper()
        returnValue = slurper.parseText(jsonParsedFromApi)


        return returnValue


    }

    public JSONObject getClumpDataRestCall(String phenotype, String datasetName, String r2) {

/*

{
    "dataset":"GWAS_AGEN_mdv30",
    "phenotype":"t2d",
    "r2":"0.4",
    "pagination": {"size":5000, "offset":0},
    "p_valueThreshold":1.0
}
 */
       String clumpDataJsonPayloadString = """ {"phenotype": "${phenotype}","dataset": "${datasetName}", "r2": "${r2}",
                                                    "pagination":{"size":5000,"offset":0},"p_valueThreshold":1.0 } """.toString()

        JSONObject VectorDataJson = this.postClumpDataRestCall(clumpDataJsonPayloadString);


        return VectorDataJson;
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


    public List<String> retrieveGenesInExtents(LinkedHashMap<String,String> positioningInformation){
        List<String> identifiedGenes = []
        String regionSpecifier = "chr${positioningInformation?.chromosomeSpecified}:${positioningInformation?.beginningExtentSpecified}-${positioningInformation?.endingExtentSpecified}"
        String chromosomeSpecifier = (positioningInformation?.chromosomeSpecified?.startsWith('chr'))?
                positioningInformation?.chromosomeSpecified:
                ("chr" + positioningInformation?.chromosomeSpecified)
        List<Gene> geneList = Gene.findAllByChromosome(chromosomeSpecifier)
        for (Gene gene in geneList) {
            try {
                int startExtent = positioningInformation?.beginningExtentSpecified as Long
                int endExtent = positioningInformation?.endingExtentSpecified as Long
                if (((gene?.addrStart > startExtent) && (gene?.addrStart < endExtent)) ||
                        ((gene?.addrEnd > startExtent) && (gene?.addrEnd < endExtent))) {
                    identifiedGenes << gene?.name2 as String
                }
            } catch (e) {
                log.error("problem translating extent start=${} to end=${}")
            }

        }
        return identifiedGenes
    }



}
