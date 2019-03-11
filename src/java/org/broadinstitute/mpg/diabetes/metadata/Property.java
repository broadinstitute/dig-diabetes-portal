package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.util.PortalException;

/**
 * Interface to be implemented by the classes representing the metadata properties
 *
 */
public interface Property extends DataSet {
    public String getName();

    public String getDescription();

    public String getVariableType();

    public String getPropertyType();

    public boolean isSearchable();

    public String getRequestedPhenotype();

    public String getRequestedDataset();

    public boolean isGeneTablemdv37();


    public int getSortOrder();

    public String getWebServiceOrderByString(String directionOfSort);

    public String getWebServiceFilterString(String operand, String value,String requestedPhenotype);

    public String getWebServiceFilterString(String operand, String value,String requestedPhenotype, String requestedDataset);

    /**
     * determines if the property has been tagged with a given metadata word
     *
     * @param meaningValue
     * @return
     */
    public boolean hasMeaning(String meaningValue);

    /**
     * returns the property query string in json format
     *
     * @return
     * @throws org.broadinstitute.mpg.diabetes.util.PortalException
     */
    public String getWebServiceQueryString() throws PortalException;

    /**
     * returns true if the property matches the 3 criteria names given
     * <br/>
     * its name, its sample group name and its phenotype name (the latter 2 can be null)
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public boolean isTheMatchingProperty(String propertyName, String sampleGroupName, String phenotypeName);
}
