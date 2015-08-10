package org.broadinstitute.mpg.diabetes.metadata;

import java.util.List;

/**
 * Interface to be implemented by the classes representing the metadata sample groups
 *
 */
public interface SampleGroup extends DataSet {

    public List<SampleGroup> getSampleGroups();

    public List<SampleGroup> getRecursiveChildren();

    public List<SampleGroup> getRecursiveParents();

    public List<SampleGroup> getRecursiveChildrenForPhenotype(Phenotype phenotype);

    public List<SampleGroup> getRecursiveParentsForPhenotype(Phenotype phenotype);

    public List<Phenotype> getPhenotypes();

    public List<Property> getProperties();

    public String getName();

    public String getAncestry();

    public int getSortOrder();

    public String getSystemId();
}
