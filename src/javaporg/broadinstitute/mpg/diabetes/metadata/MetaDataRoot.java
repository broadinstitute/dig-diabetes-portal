package org.broadinstitute.mpg.diabetes.metadata;

import java.util.List;

/**
 * Interface to be implemented by the class representing the root of the metadata tree
 *
 */
public interface MetaDataRoot extends DataSet {
    public List<Experiment> getExperiments();

    public List<Property> getProperties();
}
