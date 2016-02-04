package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 2/2/2016.
 */
public class PropertyPerExperimentByMeaningVisitor implements DataSetVisitor {
    private String propertyMeaning;
    private Boolean recursivelyDescendSampleGroups;
    private List<Property> propertyList = new ArrayList<Property>();

    /**
     * default constructor with the property id string to find by
     *
     * @param propertyMeaning
     */
    public PropertyPerExperimentByMeaningVisitor(String propertyMeaning, Boolean recursivelyDescendSampleGroups ){
        this.propertyMeaning = propertyMeaning;
        this.recursivelyDescendSampleGroups = recursivelyDescendSampleGroups;
    }

    /**
     * traverse dataset tree until find the first property with that value
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        if (dataSet.getType().equals(PortalConstants.TYPE_PROPERTY_KEY)) {
            PropertyBean propertyBean = (PropertyBean) dataSet;
            if (propertyBean.hasMeaning(this.propertyMeaning)){
                this.propertyList.add((Property)dataSet);

            }
        } else {
            for (DataSet child:dataSet.getAllChildren()){
                if (this.recursivelyDescendSampleGroups){ // if told to descend then we will always try
                    child.acceptVisitor(this);
                }  else { // if we shouldn't do send, make sure our sample group isn't a child of a sample group
                    if (child.getType().equals(PortalConstants.TYPE_SAMPLE_GROUP_KEY)){
                        if (!child.getParent().getType().equals(PortalConstants.TYPE_SAMPLE_GROUP_KEY)) {
                           child.acceptVisitor(this);
                        }
                    } else {
                        child.acceptVisitor(this);
                    }
                }
            }
        }

    }

    public List<Property> getPropertyList() {
        return propertyList;
    }

}

