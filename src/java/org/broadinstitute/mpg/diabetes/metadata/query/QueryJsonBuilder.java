package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.metadata.sort.PropertyListForQueryComparator;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.Collections;
import java.util.List;

/**
 * Created by mduby on 8/27/15.
 */
public class QueryJsonBuilder {
    // singleton instance
    private static QueryJsonBuilder queryJsonBuilder;

    /**
     * singleton method to return query builder
     *
     * @return
     */
    public static QueryJsonBuilder getQueryJsonBuilder() {
        if (queryJsonBuilder == null) {
            queryJsonBuilder = new QueryJsonBuilder();
        }

        return queryJsonBuilder;
    }

    /**
     * return the json payload for the getData call using the query bean
     *
     * @param query
     * @return
     */
    public String getQueryJsonPayloadString(GetDataQuery query) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();
        String finalString;

        // get the header data
        stringBuilder.append("\"passback\": \"");
        stringBuilder.append(query.getPassback());
        stringBuilder.append("\", \"entity\": \"");
        stringBuilder.append(query.getEntity());
        stringBuilder.append("\", \"page_number\":");
        stringBuilder.append(query.getPageNumber());
        stringBuilder.append(", \"page_size\": ");
        stringBuilder.append(query.getPageSize());
        stringBuilder.append(", \"limit\": ");
        stringBuilder.append(query.getLimit());
        stringBuilder.append(", \"count\": ");
        stringBuilder.append(query.isCount());
        stringBuilder.append(", ");

        // get the rest of the payload
        finalString = this.getQueryJsonPayloadString(stringBuilder.toString(), query.getQueryPropertyList(), null, query.getFilterList());

        // return
        return finalString;
    }

    /**
     * return the json payload string for the getData call, according to the format needed
     *
     * @param requestPropertyList
     * @param orderByPropertyList
     * @param queryFilterList
     * @return
     */
    public String getQueryJsonPayloadString(String headerData, List<Property> requestPropertyList, List<Property> orderByPropertyList, List<QueryFilter> queryFilterList) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();

        // add in the query header
        stringBuilder.append("{");

        // add in header data
        stringBuilder.append(headerData);

        // add in properties header
        stringBuilder.append("\"properties\": {");

        // first sort the properties based on the query comparator logic
        Collections.sort(requestPropertyList, new PropertyListForQueryComparator());

        // add in the cproperties string
        stringBuilder.append(this.getCpropertiesString(requestPropertyList));

        // add in the dproperties string
        stringBuilder.append(this.getDpropertiesString(requestPropertyList));

        // add in the pproperties string
        stringBuilder.append(this.getPpropertiesString(requestPropertyList));

        // add in the filter string
        stringBuilder.append(this.getFilterString(queryFilterList));

        // close out the query
        stringBuilder.append("} ");

        // return the string
        return stringBuilder.toString();
    }

    /**
     * return the pproperties string in the format needed for the getData call
     *
     * @param propertyList
     * @return
     */
    protected String getPpropertiesString(List<Property> propertyList) {
        // local instances
        StringBuilder builder = new StringBuilder();
        String oldPropertyName = " ";
        String oldSampleGroupName = " ";
        String propertyComma = "";
        String sampleGroupComma = "";
        String phenotypeComma = "";
        String propertyClosureClose = "";

        // start the dproperty header
        builder.append("\"pproperty\" : {");

        // properties are grouped by property name
        // so loop through properties, pick the dproperties out, then build json based on new property parents
        for (Property property: propertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
                if (!property.getName().equals(oldPropertyName)) {
                    // if different property name, start new property closure
                    builder.append(propertyComma);
                    builder.append("\"");
                    builder.append(property.getName());
                    builder.append("\" : { ");

                    // set the comma values
                    propertyComma = "]}, ";
                    propertyClosureClose = "] } ";

                    // reset the temp compare values
                    sampleGroupComma = "";
                    phenotypeComma = "";
                    oldPropertyName = property.getName();
                    oldSampleGroupName = "";
                }

                if (!property.getParent().getParent().getId().equals(oldSampleGroupName)) {
                    // if different property name, start new sample closure
                    builder.append(sampleGroupComma);
                    builder.append("\"");
                    builder.append(((SampleGroup)property.getParent().getParent()).getSystemId());
                    builder.append("\" : [ ");

                    // set the comma values
                    sampleGroupComma = " ], ";
                    phenotypeComma = "";

                    // reset the temp compare values
                    oldSampleGroupName = property.getParent().getParent().getId();

                }

                builder.append(phenotypeComma);
                builder.append("\"");
                builder.append(property.getParent().getName());
                builder.append("\"");
                phenotypeComma = " , ";
            }
        }

        // close the property closure
        builder.append(propertyClosureClose);

        // close the dproperty header
        builder.append("} }, ");

        // return
        return builder.toString();
    }

    /**
     * get the filter string for the getData call
     * @param filterList
     * @return
     */
    protected String getFilterString(List<QueryFilter> filterList) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();
        String queryComma = "";

        // add in the query header
        stringBuilder.append("\"filters\": [ ");

        // add in the filters
        for (QueryFilter filter: filterList) {
            stringBuilder.append(queryComma);
            stringBuilder.append(filter.getFilterString());
            queryComma = ", ";
        }

        // close out the query header
        stringBuilder.append(" ] ");

        // return
        return stringBuilder.toString();
    }


    /**
     * returns the dproperty json
     *
     * @param propertyList
     * @return
     */
    protected String getDpropertiesString(List<Property> propertyList) {
        // local instances
        StringBuilder builder = new StringBuilder();
        String oldPropertyName = " ";
        String propertyComma = "";
        String sampleGroupComma = "";
        String propertyClosureClose = "";

        // start the dproperty header
        builder.append("\"dproperty\" : {");

        // properties are grouped by property name
        // so loop through properties, pick the dproperties out, then build json based on new property parents
        for (Property property: propertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
               if (!property.getName().equals(oldPropertyName)) {
                   // if different property name, start new property closure
                   builder.append(propertyComma);
                   builder.append("\"");
                   builder.append(property.getName());
                   builder.append("\" : [ ");
                   propertyComma = "], ";
                   propertyClosureClose = "] ";
                   sampleGroupComma = "";
                   oldPropertyName = property.getName();
               }

               builder.append(sampleGroupComma);
               builder.append("\"");
               builder.append(((SampleGroup)property.getParent()).getSystemId());
               builder.append("\"");
               sampleGroupComma = " , ";
            }
        }

        // close the property closure
        builder.append(propertyClosureClose);

        // close the dproperty header
        builder.append("} , ");

        // return
        return builder.toString();
    }

    /**
     * build out the cproperty query string
     *
     * @param propertyList
     * @return
     */
    protected String getCpropertiesString(List<Property> propertyList) {
        // local variables
        StringBuilder builder = new StringBuilder();
        String commaString = "";

        // add in the cproperty header
        builder.append("\"cproperty\": [ ");

        // loop through the properties, pick out the cproperties, and add them to the string
        for (Property property: propertyList) {
            if (property.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                builder.append(commaString);
                builder.append("\"");
                builder.append(property.getName());
                builder.append("\"");
                commaString = " , ";
            }
        }

        // close out the cproperty header
        builder.append("], ");

        // return the string
        return builder.toString();
    }


}
