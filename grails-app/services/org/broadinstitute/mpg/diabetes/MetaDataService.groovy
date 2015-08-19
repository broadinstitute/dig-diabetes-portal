package org.broadinstitute.mpg.diabetes

import dport.RestServerService
import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.util.PortalException

@Transactional
class MetaDataService {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    Integer forceProcessedMetadataOverride = -1
    RestServerService restServerService;

    def serviceMethod() {

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

    public String getSearchablePropertyNameListAsJson(String sampleGroupId) throws PortalException {
        // local variables
        List<String> propertyNameList;
        StringBuilder propertyBuilder = new StringBuilder();

        // get the list if strings from the json parser
        propertyNameList = this.getJsonParser().getSearchablePropertiesForSampleGroupAndChildren(sampleGroupId);

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
}