package org.broadinstitute.mpg.diabetes

import dport.MetadataUtilityService
import dport.RestServerService
import dport.SharedToolsService
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.util.PortalException

@Transactional
class MetaDataService {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
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





    public List<PhenotypeBean> getAllPhenotypesWithName(String phenotypicTrait){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName(phenotypicTrait, sharedToolsService.getCurrentDataVersion (), "GWAS")
        return phenotypeList
    }


    public LinkedHashMap<String, List<String>> getHierarchicalPhenotypeTree(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "GWAS")
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.hierarchicalPhenotypeTree(phenotypeList)
        return propertyTree
    }

    public LinkedHashMap<String, LinkedHashMap<String,List<String>>> getFullPropertyTree(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.fullPropertyTree(phenotypeList,true,true)
        return propertyTree
    }


    public LinkedHashMap<String, LinkedHashMap<String,List<String>>> getSampleGroupTree(){
        List<PhenotypeBean> phenotypeList =  this.getJsonParser().getAllPhenotypesWithName("", sharedToolsService.getCurrentDataVersion (), "")
        LinkedHashMap<String, List<String>> propertyTree =  metadataUtilityService.sampleGroupBasedPropertyTree(phenotypeList,true)
        return propertyTree
    }




}

