package org.broadinstitute.mpg.diabetes.metadata;


import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to represent the metadata phenotypes
 *
 */
public class PhenotypeBean implements Phenotype {
    // instance variables
    private String name;
    private int sortOrder;
    private String group;
    private List<Property> propertyList;
    private DataSet parent;

    /**
     * return a list of all the object's dataset children
     *
     * @return
     */
    public List<DataSet> getAllChildren() {
        // local variable
        List<DataSet> allChildrenList = new ArrayList<DataSet>();

        // add all children lists
        allChildrenList.addAll(this.getProperties());

        // return the resulting list
        return allChildrenList;
    }

    public String getType() {
        return PortalConstants.TYPE_PHENOTYPE_KEY;
    }

    public String getId() {
        return (this.parent == null ? "" : this.parent.getId()) + this.getName();
    }

    public DataSet getParent() {
        return this.parent;
    }

    public void setParent(DataSet parent) {
        this.parent = parent;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }


    public String getName() {
        return this.name;
    }

    public int getSortOrder() {
        return this.sortOrder;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public List<Property> getProperties() {
        if (this.propertyList == null) {
            this.propertyList = new ArrayList<Property>();
        }

        return this.propertyList;
    }

    public int compareTo(Object another) {
        PhenotypeBean otherBean = (PhenotypeBean)another;

        // order based on group, then name
        if (this.getGroup() == null) {
            return -1;
        } else if (otherBean.getGroup() == null) {
            return 1;
        } else {
            if (this.getGroup().equals(otherBean.getGroup())) {
                // should not have to check for nulls here
                return this.getName().compareTo(otherBean.getName());
            } else {
                return this.getGroup().compareTo(otherBean.getGroup());
            }
        }
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
        */
    }
}
