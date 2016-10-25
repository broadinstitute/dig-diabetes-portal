package org.broadinstitute.mpg.diabetes

import grails.transaction.Transactional
import groovy.json.JsonSlurper
import groovy.json.internal.LazyMap
import org.broadinstitute.mpg.FilterManagementService
import org.broadinstitute.mpg.MetadataUtilityService
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant
import org.broadinstitute.mpg.diabetes.metadata.*
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.CommonGetDataQueryBuilder
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryBean
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseResultParser
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseResultTranslator
import org.broadinstitute.mpg.diabetes.metadata.result.KnowledgeBaseTraitSearchTranslator
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.util.WebUtils

@Transactional
class MetaDataService {
    // handle multiple metadata trees
    public static Integer METADATA_NONE = 0
    public static Integer METADATA_VARIANT = 1
    public static Integer METADATA_SAMPLE = 2

    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    JsonParser jsonSampleParser = JsonParser.getSampleService();
    QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
    Integer forceProcessedMetadataOverride = -1
    Integer forceProcessedSampleMetadataOverride = -1
    RestServerService restServerService
    SharedToolsService sharedToolsService
    MetadataUtilityService metadataUtilityService
    FilterManagementService filterManagementService
    def grailsApplication

    def serviceMethod() {

    }

    /**
     * return the portal type string from the user session
     *
     * @return
     */
    public String getPortalTypeFromSession() {
        // if portal type defined in config, use that
        String portalTypeOverride = this.grailsApplication.config.portal.type.override;
        String portalType = null;

        portalType = WebUtils.retrieveGrailsWebRequest()?.getSession()?.getAttribute('portalType');

        // DIGP-291: adding different metadata versions by portal
        // get the data version based on user session portal type; default to portal override if no session preference set
        if (portalType == null) {
            portalType = portalTypeOverride;

            // if not portal override set in config, set to t2d as last resort
            if (portalType == null) {
                portalType = "t2d";
            }
        }

        // return
        return portalType;
    }

    /**
     * returns the data version to use based on the portal type setting in the user session
     *
     * @return
     */
    public String getDataVersion() {
        // DIGP-291: adding different metadata versions by portal
        String dataVersion;
        String portalType = this.getPortalTypeFromSession();

        // get the data version based on user session portal type; default to t2d
        dataVersion = this.grailsApplication.config.portal.data.version.map[portalType];

        // DIGP-391: quick fix for Marcin testing; for t2d, get the version from the system manager setting
      //  if ("t2d".equals(portalType)) {
            dataVersion = "mdv" + this.sharedToolsService.getDataVersion();
      //  }

        // return
        return dataVersion;
    }

    /**
     * returns the default phenotype based on the portal type setting in the user session
     *
     * @return
     */
    public String getDefaultPhenotype() {
        // DIGP-291: adding different metadata versions by portal
        String phenotype;
        String portalType = this.getPortalTypeFromSession();

        // get the data version based on user session portal type; default to t2d
        phenotype = this.grailsApplication.config.portal.data.default.phenotype.map[portalType];

        // return
        return phenotype;
    }

    public void setForceProcessedMetadataOverride(Integer forceProcessedMetadataOverride) {
        this.forceProcessedMetadataOverride = forceProcessedMetadataOverride
        setForceProcessedSampleMetadataOverride(forceProcessedMetadataOverride)
    }

    /**
     * returns whether a metadada override has been set but not run yet
     *
     * @return
     */
    public Boolean getMetadataOverrideStatus() {
        // DIGP-170: switch looking for the override from the SharedToolService to the new metadata object
        return (this.forceProcessedMetadataOverride == 1)
    }



    public void setForceProcessedSampleMetadataOverride(Integer forceProcessedSampleMetadataOverride) {
        this.forceProcessedSampleMetadataOverride = forceProcessedSampleMetadataOverride
    }

    /**
     * returns whether a metadada override has been set but not run yet
     *
     * @return
     */
    public Boolean getSampleMetadataOverrideStatus() {
        // DIGP-170: switch looking for the override from the SharedToolService to the new metadata object
        return (this.forceProcessedSampleMetadataOverride == 1)
    }

    /**
     * returns the json parser after first checking that the metadata hadn't been set to be reloaded
     *
     * @return
     */
    private JsonParser getJsonParser() {
        // reload the metadata if scheduled
        if (this.forceProcessedMetadataOverride != 0) {
            String jsonString = this.restServerService.getMetadata();
            this.jsonParser.forceMetadataReload(jsonString);
        }

        // reset reload indicator
        this.forceProcessedMetadataOverride = 0;

        // return
        return this.jsonParser;
    }



    private JsonParser getJsonSampleParser() {
        // reload the metadata if scheduled
        if (this.forceProcessedSampleMetadataOverride != 0) {

                String jsonString = this.restServerService.getSampleMetadata();
                this.jsonSampleParser.forceMetadataReload(jsonString);

        }

        // reset reload indicator
       this.forceProcessedSampleMetadataOverride = 0;

        // return
        return this.jsonSampleParser;
    }





    /**
     * return the list of common cproperties in json format
     *
     * @param sortFirst
     * @return
     */
    public JSONObject getCommonPropertiesAsJson(Boolean sortFirst) {
        // local variables
        List<Property> propertyList;

        JSONObject toReturn = [
            dataset: new ArrayList<String>()
        ]

        // get the list from the json service parse
        try {
            propertyList = this.getJsonParser().getSearchableCommonProperties();

        } catch (PortalException exception) {
            propertyList = new ArrayList<Property>();
            log.error("Got metadata parsing exception getting common properties json: " + exception.getMessage());
        }

        // if need to sort, sort the list
        if (sortFirst) {
            Collections.sort(propertyList);
        }

        for (Property property : propertyList) {
            toReturn.dataset << property.getName()
        }

        toReturn.is_error = false
        toReturn.numRecords = propertyList.size()

        return toReturn
    }



    public List <Property> getCommonProperties() {
        List<Property> propertyList;

        propertyList = this.getJsonParser().getSearchableCommonProperties();

        return propertyList.sort{ a, b -> a.sortOrder <=> b.sortOrder };
    }




    /**
     * return the root gwas sample group for a given phenotype
     *List<Experiment> getAllExperimentsOfVersionTechnology( String version, String technology )
     * @param phenotypeString
     * @return
     */
    public List<Experiment> getExperimentByVersionAndTechnology( String version, String technology, int metadataTree ) {
        // local variables
        List<Experiment> experimentList = []

        // get the sample group string
        try {
            switch (metadataTree){
                case METADATA_VARIANT:
                    experimentList = this.getJsonParser().getAllExperimentsOfVersionTechnology( version, technology )
                    break;
                case METADATA_SAMPLE:
                    experimentList = this.getJsonSampleParser().getAllExperimentsOfVersionTechnology( version, technology )
                    break;
                case METADATA_NONE:
                default:
                    break;
            }

        } catch (PortalException exception) {
            log.error("Got metadata parsing exception getting getExperimentByVersionAndTechnology: " + exception.getMessage());
        }

        return experimentList
    }





    /**
     * return the root gwas sample group for a given phenotype
     *
     * @param phenotypeString
     * @return
     */
    public String getGwasSampleGroupNameForPhenotype(String phenotypeString) {
        // local variables
        String sampleGroupName = "";

        // get the sample group string
        try {
            sampleGroupName = this.getJsonParser().getGwasSampleGroupNameForPhenotype(phenotypeString);

        } catch (PortalException exception) {
            log.error("Got metadata parsing exception getting gwas sample group name by phenotype: " + exception.getMessage());
        }

        return sampleGroupName;
    }

    /**
     * returns the searchable properties for a sample group and all it's children
     *
     * TODO - split this into retrieve and then format method so it can be reused somewhere else if need be
     *
     * @param sampleGroupId
     * @return
     * @throws PortalException
     */
    public String getSearchablePropertyNameListAsJson(String sampleGroupId) {
        // local variables
        List<String> propertyNameList;
        StringBuilder propertyBuilder = new StringBuilder();

        // get the list if strings from the json parser
        try {
            propertyNameList = this.getJsonParser().getSearchablePropertiesForSampleGroupAndChildren(sampleGroupId);

        } catch (PortalException exception) {
            log.error("Got exception retrieving property name list for selected sample group: " + sampleGroupId + " : " + exception.getMessage());
            // create empty list
            propertyNameList = new ArrayList<String>();
        }

        // create a json compatible string list
        for (int i = 0; i < propertyNameList.size(); i++) {
            propertyBuilder.append("\"");
            propertyBuilder.append(propertyNameList.get(i));
            propertyBuilder.append("\"");

            if (i < propertyNameList.size() -1) {
                propertyBuilder.append(", ");
            }
        }

        // create a json string
        GString groovyString = "{\"dataset\": [${propertyBuilder.toString()}], \"numRecords\":${propertyNameList.size()}, \"is_error\": false}";

        // return the json string
        return groovyString;
    }




    public SampleGroup  getSampleGroupByName(String sampleGroupId){
        return jsonParser.getSampleGroupByName(sampleGroupId)
    }

    public SampleGroup  getSampleGroupByFromSamplesName(String sampleGroupId){
        return this.getJsonSampleParser().getSampleGroupByName(sampleGroupId)
    }


    public String  getTechnologyPerSampleGroup(String sampleGroupId){
        return jsonParser.getTechnologyPerSampleGroup(sampleGroupId)
    }

    public JSONObject getSampleGroupNameListForPhenotypeAsJson(String phenotypeName) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        // local variables
        JSONObject toReturn = []
        List<SampleGroup> groupList;
        List<JSONObject> nameList = new ArrayList<String>();

        // get the sample group list for the phenotype
        try {
            groupList = this.getJsonParser().getSampleGroupsForPhenotype(phenotypeName, this.getDataVersion());

            // sort the group list
            Collections.sort(groupList);

            // add all the names to the name list
            for (SampleGroup group : groupList) {
                StringBuilder depthBuilder = new StringBuilder();
                for (int i = 0; i < group.getNestedLevel(); i++) {
                    depthBuilder.append("-");
                }
                String sysId = group.getSystemId()
                JSONObject currentGroup = [
                    name: sysId,
                    displayName: depthBuilder.toString() + g.message(code: "metadata." + sysId, default: sysId)
                ]
                nameList.add(currentGroup);
            }

        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list for selected phenotype: " + phenotypeName + " : " + exception.getMessage());
        }

        toReturn.is_error = false
        toReturn.numRecords = nameList.size()
        toReturn.dataset = nameList

        return toReturn;
    }

    /**
     * For the given phenotype, return a tree of sample groups, with cohorts inside of their
     * parent sample groups
     * @param phenotypeName
     * @return
     */
    public HashMap<String, HashMap> getSampleGroupStructureForPhenotypeAsJson(String phenotypeName) {
        HashMap<String, HashMap> toReturn;
        try {
            toReturn = this.getJsonParser().getSampleGroupStructureForPhenotype(phenotypeName, this.getDataVersion());
        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list for selected phenotype: " + phenotypeName + " : " + exception.getMessage());
        }

        return toReturn;
    }

    public Property getPropertyForPhenotypeAndSampleGroupAndMeaning(String phenotypeName,String sampleGroupName,String  meaning) {
        // local variables
        List<SampleGroup> groupList;
        List<SampleGroup> filteredSampleGroupList = [];
        Property returnValue;


        // get the sample group list for the phenotype
        try {
            groupList = this.getJsonParser().getSampleGroupsForPhenotype(phenotypeName, this.getDataVersion());

            // sort the group list
            Collections.sort(groupList);

            // filter sample groups by name
            for (SampleGroup group : groupList) {
                if (group.systemId == sampleGroupName)  {
                    filteredSampleGroupList.add(group) ;
                }
            }

            for (SampleGroup filteredSampleGroup : filteredSampleGroupList) {
                List<Phenotype> phenotypeList = filteredSampleGroup.getPhenotypes();
                for (Phenotype phenotype : phenotypeList) {
                    List<Property> propertyList =  phenotype.getProperties();
                    for (Property property : propertyList) {
                        if (property.hasMeaning(meaning))  {
                            returnValue =   property;
                        }
                    }
                }

            }
        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list for selected phenotype: " + phenotypeName + " : " + exception.getMessage());
        }

        //create the json string

        // return
        return returnValue;
    }





    public List<SampleGroup>  getSampleGroupListForPhenotypeAndVersion(String phenotype, String version, int metadataTree) {
        List<SampleGroup> groupList = [];

        if ((!version) ||
                (version.length()==0)){
            version = this.getDataVersion()
        }

        // get the sample group list for a particular phenotype
        try {
            switch (metadataTree) {
                case METADATA_VARIANT:
                    groupList = this.getJsonParser().getSampleGroupsForPhenotype(phenotype, version)
                    break;
                case METADATA_SAMPLE:
                    groupList = this.getJsonSampleParser().getSampleGroupsForPhenotype(phenotype, version)
                    break;
                case METADATA_NONE:
                default:
                    break;
            }
        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list : " + exception.getMessage());
        }

        // return
        return groupList;
    }

    /**
     * Get a JSON object listing every phenotype and the top-level datasets containing data for that phenotype
     * @return
     */
    public JSONObject getPhenotypeDatasetMapping() {
        List<String> everyPhenotype = getEveryPhenotype()
        JSONObject mapping = []

        List<String> technologies = ["GWAS", "ExChip", "ExSeq", "WGS"]

        everyPhenotype.each {  String phenoName ->
            if (phenoName != 'none'){
                List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups(phenoName ,"",  technologies)
                JSONObject jsonList = filterManagementService.convertSampleGroupListToJson(fullListOfSampleGroups, phenoName)
                mapping[phenoName] = jsonList
            }
        }

        return mapping
    }

    public List<SampleGroup>  getSampleGroupList() {
        List<SampleGroup> groupList;

        // get the sample group list independent of phenotype
        try {

            groupList = this.getJsonParser().getSampleGroupsForPhenotype("", this.getDataVersion());

        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list : " + exception.getMessage());
        }

        // return
        return groupList;
    }

    /***
     * Retrieve a list of PhenotypeBeans on the basis of phenotype name. Restrict the results by technology==GWAS
     * @param phenotypicTrait
     * @return
     */
    public List<PhenotypeBean> getAllPhenotypesWithName(String phenotypicTrait){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName(phenotypicTrait, sharedToolsService.getCurrentDataVersion (), "GWAS")
        return phenotypeList
    }

    /***
     * Return a tree in which every phenotype name points to a list of sample groups, restricted by technology==GWAS
     * @return
     */
    public LinkedHashMap<String, List<String>> getHierarchicalPhenotypeTree(){
        // DIGP-291: looking to see if phenotypes for list only gets GWAS related phenotypes
        // TODO: find better way to start filtering out phenotypes we want to show to people (rank by portal type)
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), null)
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.hierarchicalPhenotypeTree(phenotypeList)
        return propertyTree
    }

    /***
     * Build a tree, so that every phenotype points to its sample groups, and every sample group points to its properties (D and P)
     * @return
     */
    public LinkedHashMap<String, LinkedHashMap<String,List<String>>> getFullPropertyTree(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.fullPropertyTree(phenotypeList,true,true)
        return propertyTree
    }


    public List<String> getEveryPhenotype(Boolean includeNone){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        return phenotypeList.sort{ a, b -> a.sortOrder <=> b.sortOrder }.findAll{
            // if includeNone is true, then return true regardless; otherwise, return whether
            // the phenotype.name == "none"
            (! it.name.equals("none") || includeNone)
        }.collect{it.name}.unique()
    }

    /**
     * for trait server use, GWAS
     *
     * @return
     */
    public String urlEncodedListOfPhenotypes() {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')

        List<String> phenotypeList =  this.getJsonParser().getAllDistinctPhenotypeNames();
        StringBuilder sb   = new StringBuilder ("")
        for (int i = 0; i < phenotypeList.size(); i++){
            String phenotypeCode = phenotypeList.get(i)
            sb<< (phenotypeCode + ":" + g.message(code: "metadata." + phenotypeCode, default: phenotypeCode))
            sb<< ","

            // also add old keys from trait-search call if exists
            String oldCode = this.sharedToolsService?.convertNewPhenotypeStringsToOldOnes(phenotypeCode)
            if (!oldCode?.equals(phenotypeCode)) {
                sb<< (oldCode + ":" + g.message(code: "metadata." + phenotypeCode, default: phenotypeCode))
                sb<< ","
            }
        }

        // remove the last comma
        sb.deleteCharAt(sb.length() - 1);

        // return
        return java.net.URLEncoder.encode( sb.toString())
    }

    /***
     * Create a tree, so that every sample group contains a list of every D property that belongs to it
     * @return
     */
    public LinkedHashMap<String, List<String>> getSampleGroupTree(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.sampleGroupBasedPropertyTree(phenotypeList,true)
        return propertyTree
    }


    /***
     * For every sample group/phenotype combination, return a list of all D and P properties
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public List<String> getAllMatchingPropertyList(String sampleGroupName, String phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.sampleGroupAndPhenotypeBasedPropertyList(phenotypeList,phenotypeName,sampleGroupName)
        return propertyList
    }

    /***
     * For every sample group/phenotype combination, return a list of all P property names
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public List<String> getSpecificPhenotypePropertyList(String sampleGroupName,String  phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.phenotypeBasedPropertyList(phenotypeList,phenotypeName,sampleGroupName)
        return propertyList
    }

    /***
     * For every sample group/phenotype combination, return a list of all P properties
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public List<Property> getSpecificPhenotypeProperties(String sampleGroupName,String  phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<Property> propertyList =  metadataUtilityService.phenotypeBasedProperties(phenotypeList,phenotypeName,sampleGroupName)
        return propertyList
    }


    /***
     * For every sample group, return a list of all D properties
     * @param sampleGroupName
     * @return
     */
    public List<String> getSampleGroupPropertyList(String sampleGroupName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.sampleGroupBasedPropertyList(phenotypeList,sampleGroupName)
        return propertyList
    }


    /***
     * For every sample group/phenotype combination, return a list of all D properties
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public List<String> getPhenotypeSpecificSampleGroupPropertyList(String sampleGroupName,String  phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.phenotypeSpecificSampleGroupBasedPropertyList(phenotypeList,phenotypeName,sampleGroupName)
        return propertyList
    }

    /***
     * For every sample group/phenotype combination, return a list of all D and P properties that map to any of the array of RegEx's
     * in the propertyTemplates array.  Currently we are using the stove pull back defaults properties, but this is a stopgap until the
     * metadata can tell us which properties should show up by default
     *
     * @param phenotypeName
     * @param sampleGroupName
     * @param propertyTemplates
     * @return
     */
    public List<String> getPhenotypeSpecificSampleGroupPropertyList(String phenotypeName,String sampleGroupName, List <String> propertyTemplates){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName(phenotypeName, sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.phenotypeSpecificSampleGroupBasedPropertyList(phenotypeList,sampleGroupName,propertyTemplates)
        return propertyList
    }

    public List<Property> getPhenotypeSpecificSampleGroupPropertyCollection(String phenotypeName,String sampleGroupName, List <String> propertyTemplates){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName(phenotypeName, sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.phenotypeSpecificSampleGroupBasedPropertyCollection(phenotypeList,sampleGroupName,propertyTemplates)
        return propertyList
    }


    public List<String> getSampleGroupPerPhenotype(String phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName(phenotypeName, sharedToolsService.getCurrentDataVersion (), "")
        List<String> sampleGroupList =  metadataUtilityService.sampleGroupsPerPhenotypeList(phenotypeList)
        return sampleGroupList
    }



    public Property getSampleGroupProperty(String sampleGroupName,String propertyName){
        Property returnValue
        List<Property> propertyList =  this.getJsonParser().getSearchablePropertiesForSampleGroupId( sampleGroupName )
        if (propertyList){
            for (Property property in propertyList){
                if (property.name == propertyName){
                    returnValue = property
                    break
                }
            }
        }
        return returnValue
    }



    public Property getCommonPropertyByName (String commonPropertyName){
        Property returnValue
        List<Property> commonProperties =  this.getJsonParser().getAllCommonProperties()
        if (commonProperties){
            for (Property property in commonProperties){
                if (property.name == commonPropertyName){
                    returnValue = property
                    break
                }
            }
        }
        return returnValue
    }




    /**
     * demo method to return properties based on types, as well as a max number input
     *
     * @param propertyTypeId
     * @param numberReturn
     * @return
     */
    public List<Property> getPropertyListByPropertyType(String propertyTypeId, int numberReturn) {
        // local variables
        List<Property> propertyList = new ArrayList<Property>();

        // get the metadata hash map
        propertyList = this.jsonParser.getPropertyListOfPropertyType(this.jsonParser.getMetaDataRoot(), propertyTypeId);

        if (propertyList.size() > numberReturn) {
            propertyList = new ArrayList<>(propertyList.subList(0, numberReturn))
        }

        // return the list
        return propertyList
    }

    /**
     * demo method to show how to build getData json payload string based on a few inputs
     *
     * @param queryList
     * @param filterList
     * @return
     */
    public String getGetDataPayloadString(List<String> queryList, List<String> filterList) {
        // local variables
        String payloadString = "";
        GetDataQuery queryBean = new GetDataQueryBean();

        // build the filter
        for (String propertyId: filterList) {
            Property property = this.jsonParser.getMapOfAllDataSetNodes().get(propertyId);

            // TODO - defaults to EQ for strings for demo purposes
            if (property?.getVariableType() == PortalConstants.OPERATOR_TYPE_STRING) {
                queryBean.addFilterProperty(property, PortalConstants.OPERATOR_EQUALS, "1");
            } else {
                queryBean.addFilterProperty(property, PortalConstants.OPERATOR_LESS_THAN_EQUALS, "1");
            }
        }

        // add in the query properties
        for (String propertyId: queryList) {
            Property property = this.jsonParser.getMapOfAllDataSetNodes().get(propertyId);
            queryBean.addQueryProperty(property);
        }

        // return the built string
        payloadString = this.queryJsonBuilder.getQueryJsonPayloadString(queryBean);
        return payloadString;
    }

    /**
     * returns translated trait search query call
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     */
    public JSONObject getTraitSearchResultForChromosomeAndPosition(String chromosome, int startPosition, int endPosition) {
        // local variables
        JSONObject jsonObject = null;

//        try {
            // get the 25 traits
        // DIGP-291: centralize metadata version
            List<Phenotype> phenotypeList = this.jsonParser.getPhenotypeListByTechnologyAndVersion("GWAS", this.getDataVersion());

            // get the json object
            jsonObject = this.getTraitSearchResultForChromosomeAndPositionAndPhenotypes(phenotypeList, chromosome, startPosition, endPosition);

//        } catch (PortalException exception) {
            // got error
//            log.error("Got error for trait-search wrapper query: " + exception.getMessage());
//        }

        // return
        return jsonObject;
    }

    /***
     * retrieve a trait starting with the  raw region specification string we get from users
     * @param userSpecifiedString
     * @return
     */
    public JSONObject searchTraitByUnparsedRegion(String userSpecifiedString, List<Phenotype> phenotypeList) {
        JSONObject returnValue = null
        LinkedHashMap<String, Integer> ourNumbers = extractTraitSearchNumbersWeNeed(userSpecifiedString)
        if (ourNumbers.containsKey("chromosomeNumber") &&
                ourNumbers.containsKey("startExtent") &&
                ourNumbers.containsKey("endExtent")) {
            returnValue = getTraitSearchResultForChromosomeAndPositionAndPhenotypes(phenotypeList, ourNumbers["chromosomeNumber"], Integer.valueOf(ourNumbers["startExtent"]).intValue(),
                    Integer.valueOf(ourNumbers["endExtent"]).intValue());
        }
        return returnValue
    }

    /***
     * The point is to extract the relevant numbers from a string that looks something like this:
     *      String s="chr19:21,940,000-22,190,000"
     * @param incoming
     * @return
     */
    public LinkedHashMap<String, String> extractTraitSearchNumbersWeNeed(String incoming) {
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

    /**
     * method accessible from the controllers to retrieve a keyed map of phenotypes
     *
     * @param technology
     * @param dataVersion
     * @return
     */
    public Map<String, Phenotype> getPhenotypeMapByTechnologyAndVersion(String technology, String dataVersion) {
        return this.jsonParser.getPhenotypeMapByTechnologyAndVersion(technology, dataVersion);
    }

    /**
     * method accessible from the controllers to retrieve a list of phenotypes
     *
     * @param technology
     * @param dataVersion
     * @return
     */
    public List<Phenotype> getPhenotypeListByTechnologyAndVersion(String technology, String dataVersion) {
        return this.jsonParser.getPhenotypeListByTechnologyAndVersion(technology, dataVersion);
    }


    public List<SampleGroup> getSampleGroupForPhenotypeTechnologyAncestry(String phenotypeName, String technologyName, String metadataVersion, String ancestryName){
        return this.jsonParser.getSampleGroupForPhenotypeTechnologyAncestry ( phenotypeName,  technologyName,  metadataVersion,  ancestryName)
    }


    public List<SampleGroup> getSampleGroupForNonMixedAncestry( String metadataVersion, String ancestryName ){
        return this.jsonParser.getSampleGroupForNonMixedAncestry (   metadataVersion,  ancestryName)
    }

    public List<SampleGroup> getSampleGroupForPhenotypeDatasetTechnologyAncestry(String phenotypeName,  String datasetName, String technologyName, String metadataVersion, String ancestryName){
        return this.jsonParser.getSampleGroupForPhenotypeDatasetTechnologyAncestry ( phenotypeName, datasetName, technologyName,  metadataVersion,  ancestryName)
    }

    public List<String> getTechnologyListByVersion(String dataVersion) {
        if(dataVersion == null) {
            dataVersion = getDataVersion()
        }
        List<String> technologyList = this.jsonParser.getTechnologyListByVersion(dataVersion);
        return technologyList
    }


    public List<String> getTechnologyListByPhenotypeAndVersion(String phenotypeName,String dataVersion) {
        List<String> technologyList = this.jsonParser.getTechnologyListByVersion(dataVersion);
        LinkedHashMap<String,List<Phenotype>> technologyToPhenotype = [:]
        List<String> returnValue = []
        // we have all the technologies.  Let's loop through them and create a map from technologies to phenotypes
        for (String technology in technologyList){
            technologyToPhenotype[technology] = this.jsonParser.getPhenotypeListByTechnologyAndVersion(technology, dataVersion);
        }
        // now pull back the information we need for a single phenotype
        technologyToPhenotype.each{ String technologyName, List<Phenotype> phenotypeList ->
            if (phenotypeList){
                List<Phenotype> discretePhenotypes = phenotypeList.unique{ a,b-> a.name <=> b.name }
                if (discretePhenotypes.findIndexOf { Phenotype phenotype -> phenotype.getName() == phenotypeName } > -1){
                    returnValue << technologyName
                }

            }

        }
        return returnValue
    }

    public Property getPropertyByNamePhenotypeAndSampleGroup(String propertyName, String phenotypeName, String sampleGroupName){
        Property property =  this.getJsonParser().getPropertyGivenItsAndPhenotypeAndSampleGroupNames( propertyName,  phenotypeName,  sampleGroupName)
        return property
    }

    public String getMeaningForPhenotypeAndSampleGroup(String propertyName, String phenotypeName, String sampleGroupName){
        String returnValue = ""
        PropertyBean propertyBean =  this.getJsonParser().getPropertyGivenItsAndPhenotypeAndSampleGroupNames( propertyName,  phenotypeName,  sampleGroupName)
        List<String> listOfStrings = propertyBean.getMeanings()

        if (( listOfStrings.size() == 0 )||
                (listOfStrings[0] == "NULL")){
            returnValue = propertyName
        } else {
            returnValue = listOfStrings[0]
        }

    }




    /**
     * return the json object emulating a trait-search call given a phenotype list
     *
     * @param phenotypeList
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    public JSONObject getTraitSearchResultForChromosomeAndPositionAndPhenotypes(List<Phenotype> phenotypeList, String chromosome, int startPosition, int endPosition) throws PortalException {
        // local variables
        JSONObject jsonObject = null;
        GetDataQuery getDataQuery = null;
        CommonGetDataQueryBuilder commonGetDataQueryBuilder = new CommonGetDataQueryBuilder();
        List<Variant> variantList = new ArrayList<Variant>();
        KnowledgeBaseResultTranslator knowledgeBaseResultTranslator = new KnowledgeBaseTraitSearchTranslator();

        // for each trait, get the getData query
        for (Phenotype phenotype : phenotypeList) {
            getDataQuery = commonGetDataQueryBuilder.getDataQueryForPhenotype(phenotype, chromosome, startPosition, endPosition, "0.05");



            // call the rest server
            if (((GetDataQueryBean) getDataQuery).queryPropertyMap.size()==3){
                jsonObject = this.restServerService.postGetDataCall(this.queryJsonBuilder.getQueryJsonPayloadString(getDataQuery));

                if (jsonObject["is_error"]) {
                    println("error from KB: ${jsonObject["error_msg"]}")
                } else {
                    // for the result, translate into a variant and add to the list
                    KnowledgeBaseResultParser knowledgeBaseResultParser = new KnowledgeBaseResultParser(jsonObject.toString());
                    List<Variant> tempList = knowledgeBaseResultParser.parseResult();
                    variantList.addAll(tempList);
                }

            }


        }

        // for all the variants found, translate into trait-search format
        jsonObject = knowledgeBaseResultTranslator.translate(variantList);

        // return
        return jsonObject
    }

    // returns a set of the metadata names in database form (i.e. not translated)
    // used for translation support--though should be used sparingly
    public Set<String> parseMetadataNames() {
        String metadata = restServerService.getMetadata()
        // TODO - DIGP-320: move this call to use the JsonParser class to access the cached metadata, avoiding differences in cached vs real time call data
        def jsonSlurper = new JsonSlurper()

        JSONObject metadataParsed = jsonSlurper.parseText(metadata)

        return pullOutMetadataNames(metadataParsed)
    }

    /*
    Given the metadata, recursively go through it looking for
    any "name" key, returning a set (i.e. unique values only) containing
    the value for each "name" key. Built for use with parseMetadataNames()
    function.
     */
    private Set<String> pullOutMetadataNames(Object metadata) {
        Set<String> toReturn = new HashSet<String>()

        if( metadata instanceof JSONObject ) {
            def keys = metadata.keySet()

            for (String key in keys) {
                if (key == "name" && (metadata[key] instanceof String)) {
                    toReturn << metadata[key]
                }
                toReturn.addAll(pullOutMetadataNames(metadata[key]))
            }
        } else if( metadata instanceof ArrayList ) {
            metadata.each { item ->

                if (item instanceof JSONObject || item instanceof LazyMap) {

                    toReturn.addAll(pullOutMetadataNames(item as JSONObject))
                }
            }
        }

        return toReturn
    }

    public String translateMetadata(String metadata) {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        return g.message(code: "metadata." + metadata, default: metadata)
    }
}