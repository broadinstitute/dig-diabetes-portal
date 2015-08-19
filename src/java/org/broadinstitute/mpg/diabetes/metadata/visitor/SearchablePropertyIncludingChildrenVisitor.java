package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to search through a data set and all its children for searchable properties
 *
 */
public class SearchablePropertyIncludingChildrenVisitor implements DataSetVisitor {
    // instance variables
    List<Property> propertyList = new ArrayList<Property>();

    /**
     * visit the given data set and all its children for searchable properties
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables
        Property tempProperty;

        // check if data set is a property
        if (dataSet.getType() == PortalConstants.TYPE_PROPERTY_KEY) {
            tempProperty = (Property)dataSet;

            // if a property, add itself if searchable
            if (tempProperty.isSearchable()) {
                this.propertyList.add(tempProperty);
            }

        // if not property, search children
        } else {
            for (DataSet childSet : dataSet.getAllChildren()) {
                childSet.acceptVisitor(this);
            }
        }
    }

    /**
     * return the resulting list
     *
     * @return
     */
    public List<Property> getPropertyList() {
        return this.propertyList;
    }

    /**
     * return a comma delimited string list of the distinct property names
     *
     * @return
     */
    public List<String> getDistinctPropertyNameList() {
        List<String> stringList = new ArrayList<String>();

        // only add non included property names
        for (Property property : this.propertyList) {
            if (!stringList.contains(property.getName())) {
                stringList.add(property.getName());
            }
        }

        // return list as string
        return stringList;
    }
}
