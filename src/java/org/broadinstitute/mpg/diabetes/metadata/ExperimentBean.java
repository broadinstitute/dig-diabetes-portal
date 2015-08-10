package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to represent the metadata experiments
 *
 */
public class ExperimentBean implements Experiment {
    private String name;
    private String technology;
    private String version;
    private List<SampleGroup> sampleGroupList;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTechnology() {
        return technology;
    }

    public void setTechnology(String technology) {
        this.technology = technology;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getType() {
        return PortalConstants.TYPE_EXPERIMENT_KEY;
    }

    public String getId() {
        return this.getName();
    }

    public DataSet getParent() {
        return null;
    }

    public List<SampleGroup> getSampleGroups() {
        if (this.sampleGroupList == null) {
            this.sampleGroupList = new ArrayList<SampleGroup>();
        }

        return sampleGroupList;
    }

    /**
     * implement the visitor pattern
     *
     * @param visitor
     */
    public void acceptVisitor(DataSetVisitor visitor) {
        visitor.visit(this);

        for (SampleGroup sampleGroup: this.getSampleGroups()) {
            sampleGroup.acceptVisitor(visitor);
        }
    }
}
