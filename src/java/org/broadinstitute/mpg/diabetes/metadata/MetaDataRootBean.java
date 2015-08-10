package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to represent the root of the metadata tree
 *
 */
public class MetaDataRootBean implements MetaDataRoot {
    // instance variables
    private List<Experiment> experimentList;
    private List<Property> propertyList;

    /**
     * return a list of all the object's dataset children
     *
     * @return
     */
    public List<DataSet> getAllChildren() {
        // local variable
        List<DataSet> allChildrenList = new ArrayList<DataSet>();

        // add all children lists
        allChildrenList.addAll(this.getExperiments());
        allChildrenList.addAll(this.getProperties());

        // return the resulting list
        return allChildrenList;
    }

    public List<Experiment> getExperiments() {
        if (this.experimentList == null) {
            this.experimentList = new ArrayList<Experiment>();
        }

        return this.experimentList;
    }

    public List<Property> getProperties() {
        if (this.propertyList == null) {
            this.propertyList = new ArrayList<Property>();
        }

        return this.propertyList;
    }

    public DataSet getParent() {
        return null;
    }

    public String getId() {
        return "metadata_root";
    }

    public String getType() {
        return PortalConstants.TYPE_METADATA_ROOT_KEY;
    }

    public void acceptVisitor(DataSetVisitor visitor) {
        visitor.visit(this);

        /*
        for (Experiment experiment: this.getExperiments()) {
            experiment.acceptVisitor(visitor);
        }

        for (Property property: this.getProperties()) {
            property.acceptVisitor(visitor);
        }
        */
    }

    public String getName() {
        return this.getId();
    }
}
