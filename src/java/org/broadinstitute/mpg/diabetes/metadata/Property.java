package org.broadinstitute.mpg.diabetes.metadata;

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
}
