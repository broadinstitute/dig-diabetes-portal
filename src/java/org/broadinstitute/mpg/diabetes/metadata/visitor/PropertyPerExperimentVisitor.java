package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.MetaDataRoot;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 8/19/2015.
 */
public class PropertyPerExperimentVisitor implements DataSetVisitor {
    private String propertyName;
    private List<Property> propertyList = new ArrayList<Property>();

    public PropertyPerExperimentVisitor(String propertyName){
        this.propertyName = propertyName;
    }

    public List<Property> getPropertyList() {
        return propertyList;
    }

    public void visit(DataSet dataSet) {
        if (dataSet.getType().equals(PortalConstants.TYPE_PROPERTY_KEY)) {
            if (dataSet.getName().equalsIgnoreCase(this.propertyName)){
                this.propertyList.add((Property)dataSet);

            }
        } else {
            for (DataSet child:dataSet.getAllChildren()){
                child.acceptVisitor(this);
            }
        }

    }

}
