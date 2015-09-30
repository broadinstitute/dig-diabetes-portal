package org.broadinstitute.mpg.diabetes.knowledgebase.result;

import org.broadinstitute.mpg.diabetes.metadata.Property;

/**
 * Interface to be implemented by a class representing a property query value
 *
 */
public interface PropertyValue {
    public Property getProperty();

    public String getValue();

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
    public boolean isTheMatchingPropertyValue(String propertyName, String sampleGroupName, String phenotypeName);

}
