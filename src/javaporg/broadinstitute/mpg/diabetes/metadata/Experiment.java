package org.broadinstitute.mpg.diabetes.metadata;

import java.util.List;

/**
 * Interface to be implemented by the classes representing the experiments in the metadata
 */
public interface Experiment extends DataSet {
    public String getName();

    public String getTechnology();

    public String getVersion();

    public List<SampleGroup> getSampleGroups();
}
