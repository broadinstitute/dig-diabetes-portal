package org.broadinstitute.mpg.diabetes.metadata.query;

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
}
