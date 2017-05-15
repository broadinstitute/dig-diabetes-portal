package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Class to represent the metadata experiments
 *
 */
public class ExperimentBean implements Experiment {
    private String name;
    private String technology;
    private String institution;
    private String version;
    private List<SampleGroup> sampleGroupList;
    private DataSet parent;
    private Set<String> meaningSet = new HashSet<String>();     // hashset will take care of accidental duplicate insertions

    /**
     * return a list of all the object's dataset children
     *
     * @return
     */
    public List<DataSet> getAllChildren() {
        // local variable
        List<DataSet> allChildrenList = new ArrayList<DataSet>();

        // add all children lists
        allChildrenList.addAll(this.getSampleGroups());

        // return the resulting list
        return allChildrenList;
    }

    /**
     * add meaning values when building the property bean
     *
     * @param meaningValue
     */
    public void addMeaning(String meaningValue) {
        this.meaningSet.add(meaningValue);
    }

    /**
     * add all meaning values when building the property bean
     *
     * @param meanings
     */
    public void addAllMeanings(Collection<String> meanings) {
        this.meaningSet.addAll(meanings);
    }

    /**
     * determines if the property has been tagged with a given metadata word
     *
     * @param meaningValue
     * @return
     */
    public boolean hasMeaning(String meaningValue) {
        if (meaningValue == null) {
            return false;
        } else {
            return this.meaningSet.contains(meaningValue);
        }
    }

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

    public String getInstitution() {
        return institution;
    }

    public void setInstitution(String institution) {
        this.institution = institution;
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
        return (this.getParent() == null ? "" : this.getParent().getId() + "_") + this.getName() + "_" + this.getVersion();
    }

    public DataSet getParent() {
        return this.parent;
    }

    public void setParent(DataSet parent) {this.parent = parent;}

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

        /*
        for (SampleGroup sampleGroup: this.getSampleGroups()) {
            sampleGroup.acceptVisitor(visitor);
        }
        */
    }
}
