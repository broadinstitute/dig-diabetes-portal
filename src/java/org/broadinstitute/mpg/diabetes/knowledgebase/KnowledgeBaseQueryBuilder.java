package org.broadinstitute.mpg.diabetes.knowledgebase;

import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.List;

/**
 * LOOKS LIKE THIS IS DEPRECATED; WILL KEEP AROUND FOR NOW JUST IN CASE
 */
public class KnowledgeBaseQueryBuilder {
    // static variables
    private static KnowledgeBaseQueryBuilder knowledgeBaseQueryBuilder;

    /**
     * singleton method to return the json builder object
     *
     * @return
     */
    public static KnowledgeBaseQueryBuilder getKnowledgeBaseQueryBuilder() {
        if (knowledgeBaseQueryBuilder == null) {
            knowledgeBaseQueryBuilder = new KnowledgeBaseQueryBuilder();
        }

        return knowledgeBaseQueryBuilder;
    }

    /**
     * return a filter string based on needed format
     *
     * @param dataSet
     * @param phenotype
     * @param operand
     * @param operator
     * @param value
     * @param operandType
     * @return
     */
    public String getFilterJsonString(String dataSet, String phenotype, String operand, String operator, String value, String operandType) {
        // local variables
        StringBuilder builder = new StringBuilder();

        // add in default values if some variables are null
        if (dataSet == null) {
            dataSet = "blah";
        }
        if (phenotype == null) {
            phenotype="blah";
        }

        // build the filter string
        builder.append("{\"dataset_id\": \"");
        builder.append(dataSet);
        builder.append("\", \"phenotype\": \"");
        builder.append(phenotype);
        builder.append("\", \"operand\": \"");
        builder.append(operand);
        builder.append("\", \"operator\": \"");
        builder.append(operator);
        builder.append("\", \"value\": \"");
        builder.append(value);
        builder.append("\", \"operand_type\": \"");
        builder.append(operandType);
        builder.append("\"}");

        // return the string
        return builder.toString();
    }

    /**
     * return the getData json payload string
     *
     * @param returnPropertyList
     * @param filterPropertyList
     * @return
     * @throws PortalException
     */
    public String getSearchBuilderString(List<Property> returnPropertyList, List<Property> filterPropertyList) throws PortalException {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();
        String commaString = "";

        // build the header of the search query
        stringBuilder.append("{\"passback\": \"123abc\", \"entity\": \"variant\", \"page_number\": 0, \"page_size\": 100, \"limit\": 1000, \"count\": true,");


        // add in the properties to retrieve
        // add in the cproperties
        stringBuilder.append("\"properties\": { \"cproperty\": [");
        for (Property property : returnPropertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                stringBuilder.append(commaString);
                stringBuilder.append(property.getWebServiceQueryString());
                commaString = ", ";
            }
        }
        // delete the last ,
        stringBuilder.deleteCharAt(stringBuilder.length() - 1);
        commaString = "";

        // add in the dproperties
        // TODO - this won't work
        stringBuilder.append("\"properties\": { \"dproperty\": {");
        for (Property property : returnPropertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                stringBuilder.append(commaString);
                stringBuilder.append(property.getWebServiceQueryString());
                commaString = ", ";
            }
        }
        stringBuilder.append("}, ");
        commaString = "";

        // add in the pproperties
        stringBuilder.append("\"properties\": { \"pproperty\": {");
        for (Property property : returnPropertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
                stringBuilder.append(commaString);
                stringBuilder.append(property.getWebServiceQueryString());
                commaString = ", ";
            }
        }
        stringBuilder.append("}}, ");
        commaString = "";

        // add in the filters
        stringBuilder.append("\"filters\": [");
        for (Property property: filterPropertyList) {
            stringBuilder.append(commaString);
            // TODO - error here - scrap this method for now, make it prettier and useful later
            stringBuilder.append(property.getWebServiceFilterString(null, null,null));
            commaString = ",";
        }
        stringBuilder.append("]}");

        // return the string
        return stringBuilder.toString();
    }
}
