package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

/**
 * Created by mduby on 8/27/15.
 */
public class QueryFilterBean implements QueryFilter {
    // instance variables
    Property property;
    String operator;
    String value;
    String requestedPhenotype;

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

    /**
     * returns the filter string for the property and values given
     *
     * @return
     */
    public String getFilterString() {
        return (this.property == null ? "" : property.getWebServiceFilterString(operator, value,requestedPhenotype));
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
}
