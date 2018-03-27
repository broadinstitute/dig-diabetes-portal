package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.metadata.sort.PropertyListForQueryComparator;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

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
        stringBuilder.append("\", \"page_start\":");
        stringBuilder.append(query.getPageStart());
        stringBuilder.append(", \"page_size\": ");
        stringBuilder.append(query.getPageSize());
        stringBuilder.append(", \"limit\": ");
        stringBuilder.append(query.getLimit());
        stringBuilder.append(", \"count\": ");
        stringBuilder.append(query.isCount());
        stringBuilder.append(", \"result_format\": ");
        stringBuilder.append(query.getResultFormat());

        // add the optional fields
        if (query.getVersion()!=null){
            stringBuilder.append(", \"version\": \"");
            stringBuilder.append(query.getVersion());
            stringBuilder.append("\"");
        }
        if (query.getGene()!=null){
            stringBuilder.append(", \"gene\": \"");
            stringBuilder.append(query.getGene());
            stringBuilder.append("\"");
        }
        if (query.getPhenotype()!=null){
            stringBuilder.append(", \"phenotype\": \"");
            stringBuilder.append(query.getPhenotype());
            stringBuilder.append("\"");
        }
        stringBuilder.append(", ");

        // get the rest of the payload
        finalString = this.getQueryJsonPayloadString(stringBuilder.toString(), query.getQueryPropertyList(), query.getOrderByQueryFilters(), query.getFilterList(), query.getCovariateList());

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
    public String getQueryJsonPayloadString(String headerData, List<Property> requestPropertyList, List<QueryFilter> orderByPropertyList, List<QueryFilter> queryFilterList, List<Covariate> covariateList) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();

        // add in the query header
        stringBuilder.append("{");

        // add in header data
        stringBuilder.append(headerData);

        // add orderBy info
        stringBuilder.append("\"order_by\": [");
        if((orderByPropertyList != null) && (orderByPropertyList.size() > 0)) {
            for (QueryFilter item : orderByPropertyList) {
                String criteria = item.getOrderByString();
                stringBuilder.append(criteria + ",");
            }
            // trim off the last comma
            stringBuilder.setLength(stringBuilder.length() - 1);
        }

        stringBuilder.append("],");

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

        // if have covariates, add in the list
        if ((covariateList != null) && (covariateList.size() > 0)) {
            String covariateString = null;

            try {
                covariateString = this.getHailCovariatesString(covariateList);
                stringBuilder.append(", ");
                stringBuilder.append(covariateString);

            } catch (PortalException exception) {
                // log
            }
        }

        // close out the query
        stringBuilder.append("} ");

        // return the string
        return stringBuilder.toString();
    }


    protected String getHailCovariatesString(List<Covariate> covariateList) throws PortalException {
        // local variables
        StringBuffer buffer = new StringBuffer();
        boolean isFirst = true;

        // start the array
        buffer.append("\"covariates\": [");

        // add in the covariates
        for (Covariate covariate : covariateList) {
            if (covariate.getVariant() != null) {
                if (!isFirst) {
                    buffer.append(", ");
                }
                isFirst = false;
                buffer.append("{\"type\": \"variant\", \"dataset_id\": \"blah\",  \"value\": \"");
                buffer.append(covariate.getVariant().getChromosome());
                buffer.append("_");
                buffer.append(covariate.getVariant().getPosition());
                buffer.append("_");
                buffer.append(covariate.getVariant().getReferenceAllele());
                buffer.append("_");
                buffer.append(covariate.getVariant().getAlternateAllele());
                buffer.append("\"}");
            }
        }

        // end the array
        buffer.append("] ");

        // return
        return buffer.toString();
    }




    protected String getCovariatesString(List<Covariate> covariateList) throws PortalException {
        // local variables
        StringBuffer buffer = new StringBuffer();
        boolean isFirst = true;

        // start the array
        buffer.append("\"covariates\": [");

        // add in the covariates
        for (Covariate covariate : covariateList) {
            if (covariate.getVariant() != null) {
                if (!isFirst) {
                    buffer.append(", ");
                }
                isFirst = false;
                buffer.append("{\"type\": \"variant\", \"chrom\": \"");
                buffer.append(covariate.getVariant().getChromosome());
                buffer.append("\", \"pos\": ");
                buffer.append(covariate.getVariant().getPosition());
                buffer.append(", \"ref\": \"");
                buffer.append(covariate.getVariant().getReferenceAllele());
                buffer.append("\", \"alt\": \"");
                buffer.append(covariate.getVariant().getAlternateAllele());
                buffer.append("\"}");
            }
        }

        // end the array
        buffer.append("] ");

        // return
        return buffer.toString();
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

    protected String getCovariateString(List<Covariate> covariateList) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();
        String queryComma = "";

        if ((covariateList != null) && (covariateList.size() > 0)) {
            // add in the query header
            stringBuilder.append("\"covariates\": [ ");

            // add in the covariates
            for (Covariate covariate: covariateList) {
                // just handle variants for now
                if (covariate.getVariant() != null) {
                    stringBuilder.append(queryComma);
                    stringBuilder.append("{\"type\": \"variant\", \"chrom\": \"");
                    stringBuilder.append(covariate.getVariant().getChromosome());
                    stringBuilder.append("\", \"pos\": ");
                    stringBuilder.append(covariate.getVariant().getPosition());
                    stringBuilder.append(", \"ref\": \"");
                    stringBuilder.append(covariate.getVariant().getReferenceAllele());
                    stringBuilder.append("\", \"alt\": \"");
                    stringBuilder.append(covariate.getVariant().getAlternateAllele());
                    stringBuilder.append("\"}");

                    queryComma = ", ";
                }
            }

            // close out the query header
            stringBuilder.append(" ] ");
        }

        // return
        return stringBuilder.toString();
    }





    /**
     * get the filter string for the getData call
     * @param filterList
     * @return
     */
    public String getFilterStringForListOfFilters(List<QueryFilter> filterList) {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();
        String queryComma = "";

        // add in the query header
        stringBuilder.append(" [ ");

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
     * indicate that we are specifying the filter section of the API call
     * @return
     */
    protected String prependFilterSpecifier() {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();

        // add in the query header
        stringBuilder.append("\"filters\": ");

        // return
        return stringBuilder.toString();
    }








    /**
     * get the filter string for the getData call
     * @param filterList
     * @return
     */
    protected String getFilterString(List<QueryFilter> filterList) {
        // local variables

        return prependFilterSpecifier()+getFilterStringForListOfFilters(filterList);
    }



//    protected String getFilterString(List<QueryFilter> filterList) {
//        // local variables
//        StringBuilder stringBuilder = new StringBuilder();
//        String queryComma = "";
//
//        // add in the query header
//        stringBuilder.append("\"filters\": [ ");
//
//        // add in the filters
//        for (QueryFilter filter: filterList) {
//            stringBuilder.append(queryComma);
//            stringBuilder.append(filter.getFilterString());
//            queryComma = ", ";
//        }
//
//        // close out the query header
//        stringBuilder.append(" ] ");
//
//        // return
//        return stringBuilder.toString();
//    }




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
