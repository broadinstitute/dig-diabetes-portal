package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Visitor to return property list of properties of the same name
 *
 * Created by mduby on 7/10/18.
 */
public class PropertyListByNameFinderVisitor implements DataSetVisitor {
    // instance variables
    List<Property> propertyList = new ArrayList<Property>();
    String propertyDatabaseId;

    /**
     * default constructor with the property id string to find by
     *
     * @param propertyId
     */
    public PropertyListByNameFinderVisitor(String propertyId) {
        this.propertyDatabaseId = propertyId;
    }

    /**
     * traverse dataset tree until find the first property with that value
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        if (dataSet.getType() == PortalConstants.TYPE_PROPERTY_KEY) {
            Property property = (Property)dataSet;

            if (property.getName().equalsIgnoreCase(this.propertyDatabaseId)) {
                this.propertyList.add(property);
            }
        } else {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    /**
     * return the found property
     *
     * @return
     */
    public List<Property> getPropertyList() {
        return this.propertyList;
    }
}
