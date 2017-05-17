package org.broadinstitute.mpg.diabetes.metadata;

import java.util.List;

/**
 * Interface to be implemented by the classes representing the experiments in the metadata
 */
public interface Experiment extends DataSet {
    public String getName();

    public String getTechnology();

    public String getVersion();

    public String getInstitution();

    public List<SampleGroup> getSampleGroups();

    /**
     * determines if the property has been tagged with a given metadata word
     *
     * @param meaningValue
     * @return
     */
    public boolean hasMeaning(String meaningValue);
}
