package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mduby on 8/27/15.
 */
public class QueryFilterBean implements QueryFilter {
    // instance variables
    Property property;
    String operator;
    String value;
    String requestedPhenotype;
    String requestedDataset;
    Boolean geneTablemdv37;
    List<QueryFilter> queryFilterList = new ArrayList<QueryFilter>();

    /**
     * default constructor
     *
     * @param property
     * @param operator
     * @param value
     */
    public QueryFilterBean(Property property, String operator, String value) {
        this.property = property;
        this.operator = operator;
        this.value = value;
    }

    public QueryFilterBean(Property property, String operator, String value,  String requestedPhenotype) {
        this.property = property;
        this.operator = operator;
        this.value = value;
        this.requestedPhenotype = requestedPhenotype;
    }

    public QueryFilterBean(Property property, String operator, List<QueryFilter> queryFilterList) {
        this.property = property;
        this.operator = operator;
        this.value = null;
        this.requestedPhenotype = null;
        this.queryFilterList = queryFilterList;
    }

    public QueryFilterBean(Property property, String operator, String value, String requestedPhenotype,String requestedDataset,boolean geneTablemdv37) {
        this.property = property;
        this.operator = operator;
        this.value = value;
        this.requestedPhenotype = requestedPhenotype;
        this.requestedDataset = requestedDataset;
        this.geneTablemdv37 = geneTablemdv37;
    }

    /**
     * returns the filter string for the property and values given
     *
     * @return
     */
    public String getFilterString() {
        if (this.property == null){
            return "";
        } else if (queryFilterList.size()>0){
            String compoundValue = QueryJsonBuilder.getQueryJsonBuilder().getFilterStringForListOfFilters(queryFilterList);
            return   (property.getWebServiceFilterString(operator, compoundValue,requestedPhenotype));
        }
        //HACK ALERT - to provide phenotype and dataset for gene table of 52K
        else if(this.geneTablemdv37 != null && this.geneTablemdv37==true) {
            return (property.getWebServiceFilterString(operator, value,requestedPhenotype,requestedDataset));
        }
        else {
            return (property.getWebServiceFilterString(operator, value,requestedPhenotype));
        }
    }

    public String getOrderByString() {
        return property.getWebServiceOrderByString(operator);
    }

    public Property getProperty() {
        return property;
    }

    public String getOperator() {
        return operator;
    }

    public String getValue() {
        return value;
    }

    public String getRequestedPhenotype() { return requestedPhenotype; }

    public String getRequestedDataset() { return requestedDataset; }

    public boolean isGeneTablemdv37() {
        return geneTablemdv37;
    }

    public List<QueryFilter> getListOfQueryFilter() { return queryFilterList; }

}
