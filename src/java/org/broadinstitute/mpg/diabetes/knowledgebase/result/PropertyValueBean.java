package org.broadinstitute.mpg.diabetes.knowledgebase.result;

import org.broadinstitute.mpg.diabetes.metadata.Property;

/**
 * Class to represent a getData query property value result
 *
 */
public class PropertyValueBean implements PropertyValue {
    // instance variables
    private Property property;
    private String value;

    /**
     * default constructor
     *
     * @param property
     * @param value
     */
    public PropertyValueBean(Property property, String value) {
        this.property = property;
        this.value = value;
    }

    public Property getProperty() {
        return this.property;
    }

    public String getValue() {
        return this.value;
    }

    /**
     * returns true if the property contained matches the 3 criteria names given
     * <br/>
     * its name, its sample group name and its phenotype name (the latter 2 can be null)
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public boolean isTheMatchingPropertyValue(String propertyName, String sampleGroupName, String phenotypeName) {
        // local variables
        boolean isMatching = false;

        if (this.property != null) {
            isMatching = this.property.isTheMatchingProperty(propertyName, sampleGroupName, phenotypeName);
        }

        // return
        return isMatching;
    }
}