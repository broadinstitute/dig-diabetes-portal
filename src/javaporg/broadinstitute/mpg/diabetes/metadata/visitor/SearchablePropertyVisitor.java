package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to travel the data set tree and collect the search properties based on the given data set
 *
 */
public class SearchablePropertyVisitor implements DataSetVisitor {
    // instance variables
    List<Property> propertyList;

    public SearchablePropertyVisitor() {
        this.propertyList = new ArrayList<Property>();
    }

    /**
     * visit the data set object and collect the searchable properties from it and it's parents'
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables
        SampleGroup sampleGroup;

        if (dataSet != null) {
            // add any properties that this sample group has that are searchable
            if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
                sampleGroup = (SampleGroup)dataSet;
                for (Property property : sampleGroup.getProperties()) {
                    if (property.isSearchable()) {
                        this.propertyList.add(property);
                    }
                }
            }

            // travel up the tree from the sample group parents collecting all the searchable properties
            if (dataSet.getParent() != null) {
                dataSet.getParent().acceptVisitor(this);
            }
        }
    }

    /**
     * return the list of searchable properties
     *
     * @return
     */
    public List<Property> getPropertyList() {
        // TODO - could sort properties here with custom sorter if needed

        // return
        return this.propertyList;
    }
}
