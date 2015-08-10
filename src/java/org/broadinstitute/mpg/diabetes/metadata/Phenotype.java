package org.broadinstitute.mpg.diabetes.metadata;

import java.util.List;

/**
 * Interface to be implemented by classes representing the metadata phenotypes
 *
 */
public interface Phenotype extends DataSet {
    public String getName();

    public int getSortOrder();

    public String getGroup();

    public List<Property> getProperties();
}
