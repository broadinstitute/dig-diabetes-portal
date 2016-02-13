package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

/**
 * Created by mduby on 9/27/15.
 */
public class PropertyByItsAndParentNamesVisitor implements DataSetVisitor {
    // instance variables
    String propertyName = null;
    String sampleGroupName = null;
    String phenotypeName = null;
    Property property = null;

    /**
     * default constructor, given the 3 property names to search for
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     */
    public PropertyByItsAndParentNamesVisitor(String propertyName, String sampleGroupName, String phenotypeName) {
        this.propertyName = propertyName;
        this.sampleGroupName = sampleGroupName;
        this.phenotypeName = phenotypeName;
    }

    /**
     * visitor method to find single property given property, phenotype and sample group name
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // if property still not found
        if (this.property == null) {
            if (dataSet.getType() == PortalConstants.TYPE_PROPERTY_KEY) {
                Property tempProperty = (Property)dataSet;

                // see if this is the matching property
                if (tempProperty.isTheMatchingProperty(propertyName, sampleGroupName, phenotypeName)) {
                    this.property = tempProperty;
                }

                /* moved to property bean for better reuse
                if ((phenotypeName != null) && (phenotypeName.length() > 0)) {
                    // looking for a phenotype property
                    if (tempProperty.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
                        SampleGroup parent = (SampleGroup)tempProperty.getParent().getParent();
                        if (parent.getSystemId().equals(sampleGroupName) &&
                                tempProperty.getParent().getName().equals(phenotypeName) &&
                                tempProperty.getName().equals(propertyName)) {
                            this.property = tempProperty;
                        }
                    }

                } else if ((sampleGroupName != null) && (sampleGroupName.length() > 0)) {
                    // looking for sample group property
                    if (tempProperty.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
                        SampleGroup parent = (SampleGroup)tempProperty.getParent();
                        if (parent.getSystemId().equals(sampleGroupName) &&
                                tempProperty.getName().equals(propertyName)) {
                            this.property = tempProperty;
                        }
                    }
                } else {
                    // looking for a common property
                    if (tempProperty.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                        if (tempProperty.getName().equals(propertyName)) {
                            this.property = tempProperty;
                        }
                    }
                }
                */

            } else {
                for (DataSet child : dataSet.getAllChildren()) {
                    child.acceptVisitor(this);
                }
            }
        }
    }

    public Property getProperty() {
        return property;
    }
}
