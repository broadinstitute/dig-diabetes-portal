package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

import java.util.List;

/**
 * Interface to be implemented by objects that will create query strings for the getData calls
 */
public interface QueryFilter {

    /**
     * return a filter string for the getData call
     *
     * @return
     */
    public String getFilterString();

    public String getOrderByString();

    public Property getProperty();

    public String getOperator();

    public String getValue();

    public List<QueryFilter>  getListOfQueryFilter();

    public String getRequestedPhenotype();

    public String getRequestedDataset();

    public boolean isGeneTablemdv37();
}
