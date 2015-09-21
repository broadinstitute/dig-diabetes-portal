package org.broadinstitute.mpg.diabetes
import dport.MetadataUtilityService
import dport.RestServerService
import dport.SharedToolsService
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryBean
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException

@Transactional
class MetaDataService {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    QueryJsonBuilder queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
    Integer forceProcessedMetadataOverride = -1
    RestServerService restServerService
    SharedToolsService sharedToolsService
    MetadataUtilityService metadataUtilityService
    def grailsApplication

    def serviceMethod() {

    }

    /**
     * returns the data version to use
     *
     * @return
     */
    public String getDataVersion() {
        return this.grailsApplication.config.diabetes.data.version;
    }

    public void setForceProcessedMetadataOverride(Integer forceProcessedMetadataOverride) {
        this.forceProcessedMetadataOverride = forceProcessedMetadataOverride
    }
/**
     * returns th parser after first checking that the metadata hadn't been set to be reloaded
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

    /**
     * return the list of common cproperties in json format
     *
     * @param sortFirst
     * @return
     */
    public String getCommonPropertiesAsJson(Boolean sortFirst) {
        // local variables
        List<Property> propertyList;
        StringBuilder builder = new StringBuilder();

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

        // loop through and create a comma seperated list
        for (Property property : propertyList) {
            builder.append("\"" + property.getName() + "\"" );
            if (propertyList.get(propertyList.size() - 1) != property) {
                builder.append(",");
            }
        }

        // add the wrapping json and return
        GString groovyString = """{"is_error": false,
            "numRecords":${propertyList.size()},
            "dataset":[${builder.toString()}]
        }""";
        return groovyString.toString();
    }



    public List <Property> getCommonProperties() {
        List<Property> propertyList;

        propertyList = this.getJsonParser().getSearchableCommonProperties();

        return propertyList.sort{ a, b -> a.sortOrder <=> b.sortOrder };
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

    public String getSampleGroupNameListForPhenotypeAsJson(String phenotypeName) {
        // local variables
        GString jsonString;
        List<SampleGroup> groupList;
        StringBuilder builder = new StringBuilder();
        List<String> nameList = new ArrayList<String>();

        // get the sample group list for the phenotype
        try {
            groupList = this.getJsonParser().getSamplesGroupsForPhenotype(phenotypeName, this.getDataVersion());

            // sort the group list
            Collections.sort(groupList);

            // add all the names to the name list
            for (SampleGroup group : groupList) {
                StringBuilder depthBuilder = new StringBuilder();
                for (int i = 0; i < group.getNestedLevel(); i++) {
                    depthBuilder.append("-");
                }

                nameList.add(depthBuilder.toString() + group.getSystemId());
            }

        } catch (PortalException exception) {
            log.error("Got exception retrieving sample group name list for selected phenotype: " + phenotypeName + " : " + exception.getMessage());
        }

        //create the json string
        for (String nameString : nameList) {
            builder.append("\"" + nameString + "\"");

            if (!nameList.get(nameList.size() - 1).equalsIgnoreCase(nameString)) {
                builder.append(",");
            }
        }
        jsonString ="{\"is_error\": false, \"numRecords\":${nameList.size()}, \"dataset\":[${builder.toString()}]}";

        // return
        return jsonString;
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
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "GWAS")
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


    /***
     * Build a tree, so that every phenotype points to its sample groups, and every sample group points to its properties (D and P)
     * @return
     */
    public List<String> getEveryPhenotype(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        return phenotypeList.sort{ a, b -> a.sortOrder <=> b.sortOrder }.collect{it.name}.unique()
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
    public List<String> getAllMatchingPropertyList(String sampleGroupName,String  phenotypeName){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        List<String> propertyList =  metadataUtilityService.sampleGroupAndPhenotypeBasedPropertyList(phenotypeList,phenotypeName,sampleGroupName)
        return propertyList
    }

    /***
     * For every sample group/phenotype combination, return a list of all P properties
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

}

