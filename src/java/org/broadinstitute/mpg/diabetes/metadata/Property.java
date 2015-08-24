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

    public int getSortOrder();

    public String getWebServiceFilterString(String operand, String value);

    /**
     * returns the property query string in json format
     *
     * @return
     * @throws org.broadinstitute.mpg.diabetes.util.PortalException
     */
    public String getWebServiceQueryString() throws PortalException;

}
