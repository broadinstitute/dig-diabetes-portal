package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

/**
 * Class to represent the metadata sample groups
 *
 */
public class SampleGroupBean implements SampleGroup, Comparable {
    // instance variables
    private String name;
    private String ancestry;
    private List<SampleGroup> sampleGroupList;
    private List<Property> propertyList;
    private List<Phenotype> phenotypeList;
    private int sortOrder;
    private DataSet parent;
    private String systemId;

    // DIGP-196: adding subjects/cases/controls per data set
    private Integer subjectsNumber;
    private Integer casesNumber;
    private Integer controlsNumber;

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
        allChildrenList.addAll(this.getPhenotypes());
        allChildrenList.addAll(this.getProperties());

        // return the resulting list
        return allChildrenList;
    }

    /**
     * return the subjects number for the sample group
     *
     * @return
     */
    public Integer getSubjectsNumber() {
        return this.subjectsNumber;
    }

    /**
     * return the cases number for the sample group
     *
     * @return
     */
    public Integer getCasesNumber() {
        return this.casesNumber;
    }

    /**
     * return the controls number for the sample group
     *
     * @return
     */
    public Integer getControlsNumber() {
        return this.controlsNumber;
    }

    public void setControlsNumber(Integer controlsNumber) {
        this.controlsNumber = controlsNumber;
    }

    public void setSubjectsNumber(Integer subjectsNumber) {
        this.subjectsNumber = subjectsNumber;
    }

    public void setCasesNumber(Integer casesNumber) {
        this.casesNumber = casesNumber;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAncestry(String ancestry) {
        this.ancestry = ancestry;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getType() {
        return PortalConstants.TYPE_SAMPLE_GROUP_KEY;
    }

    public String getId() {
        return (this.parent == null ? "" : this.parent.getId() + "_") + this.getName();
    }

    public DataSet getParent() {
        return this.parent;
    }

    public List<SampleGroup> getSampleGroups() {
        if (this.sampleGroupList == null) {
            this.sampleGroupList = new ArrayList<SampleGroup>();
        }

        return this.sampleGroupList;
    }

    public void setParent(DataSet parent) {
        this.parent = parent;
    }

    public List<SampleGroup> getRecursiveChildren() {
        // create a new list from the direct children
        List<SampleGroup> tempList = new ArrayList<SampleGroup>();
        tempList.addAll(this.getSampleGroups());

        // add in the children's children
        for (SampleGroup sampleGroup : this.sampleGroupList) {
            tempList.addAll(sampleGroup.getRecursiveChildren());
        }

        return tempList;
    }

    /**
     * Returns an array of ancestor sample groups, from most distant to least distant. Does not include
     * the parent experiment.
     * @return
     */
    public List<SampleGroup> getRecursiveParents() {
        SampleGroup current = this;
        List<SampleGroup> toReturn = new ArrayList<SampleGroup>();
        toReturn.add(current);
        while( current.getParent() != null && ! current.getParent().getType().equals(PortalConstants.TYPE_EXPERIMENT_KEY)) {
            current = (SampleGroup) current.getParent();
            toReturn.add(current);
        }
        Collections.reverse(toReturn);
        return toReturn;
    }

    public List<SampleGroup> getRecursiveChildrenForPhenotype(Phenotype phenotype) {
        return null;
    }

    public List<SampleGroup> getRecursiveParentsForPhenotype(Phenotype phenotype) {
        return null;
    }

    public List<Phenotype> getPhenotypes() {
        if (this.phenotypeList == null) {
            this.phenotypeList = new ArrayList<Phenotype>();
        }

        return this.phenotypeList;
    }

    public List<Property> getProperties() {
        if (this.propertyList == null) {
            this.propertyList = new ArrayList<Property>();
        }

        return this.propertyList;
    }

    public String getName() {
        return this.name;
    }

    public String getAncestry() {
        return this.ancestry;
    }

    public int getSortOrder() {
        return this.sortOrder;
    }

    /**
     * implement the visitor pattern
     *
     * @param visitor
     */
    public void acceptVisitor(DataSetVisitor visitor) {
        visitor.visit(this);

        /*
        for (Property property: this.getProperties()) {
            property.acceptVisitor(visitor);
        }

        for (Phenotype phenotype : this.getPhenotypes()) {
            phenotype.acceptVisitor(visitor);
        }

        for (SampleGroup group: this.getSampleGroups()) {
            group.acceptVisitor(visitor);
        }
        */
    }

    /**
     * returns how many levels down this sample group is nested in other sample groups
     *
     * @return
     */
    public Integer getNestedLevel() {
       if (this.getParent() == null || this.getParent().getType() != PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
           return 0;
       } else {
           // the parent is a sample group, so cast
           SampleGroup groupParent = (SampleGroup)this.getParent();
           return (1 + groupParent.getNestedLevel());
       }
    }

    public String getSystemId() {
        return systemId;
    }

    public void setSystemId(String systemId) {
        this.systemId = systemId;
    }

    /**
     * returns sort int of objects; compares first on sort order, then name
     *
     * @param object
     * @return
     */
    public int compareTo(Object object) {
        if (object == null) {
            return 1;
        } else {
            SampleGroup otherBean = (SampleGroup)object;

            if (this.getSortOrder() == otherBean.getSortOrder()) {
                if (this.getNestedLevel().equals(otherBean.getNestedLevel())) {
                    return this.getName().compareTo(otherBean.getName());

                } else {
                    return this.getNestedLevel().compareTo(otherBean.getNestedLevel());
                }
            } else {
                return (this.getSortOrder() < otherBean.getSortOrder() ? -1 : 1);
            }
        }
    }

    /**
     * Returns a nested structure of datasets and child datasets
     * @param phenotype
     * @return
     */
    public HashMap<String, HashMap> getHierarchy(String phenotype) {
        HashMap<String, HashMap> map = new HashMap<String, HashMap>();
        List<SampleGroup> children = this.getSampleGroups();
        // base case
        if (children.size() == 0) {
            return map;
        } else {
            for(SampleGroup child : children) {
                // we don't want to be doing this on anything that's not a sample group
                if( ! child.getType().equalsIgnoreCase(PortalConstants.TYPE_SAMPLE_GROUP_KEY) ) {
                    break;
                }

                String id = child.getSystemId();
                HashMap<String, HashMap> childMap = child.getHierarchy(phenotype);
                map.put(id, childMap);
            }
        }

        return map;
    }

}
