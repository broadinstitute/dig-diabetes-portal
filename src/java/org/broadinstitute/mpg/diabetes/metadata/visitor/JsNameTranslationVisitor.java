package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mduby on 9/4/15.
 */
public class JsNameTranslationVisitor implements DataSetVisitor {
    // instance variables
    // use a list to track when there are more than one properties for troubleshooting purposes
    List<Property> propertyList = new ArrayList<Property>();
    String inputJsName;
    String sampleGroupName, phenotypeName, propertyName;

    public JsNameTranslationVisitor(String jsNameToParse) {
        this.inputJsName = jsNameToParse;

        // split the input string
        this.parseInputString();
    }

    /**
     * parse the input search string
     *
     */
    protected void parseInputString() {
        String tempString;
        String[] stringArray;

        // split the string into it's 3 parts
        if (this.inputJsName != null) {
            // get the property name
            stringArray = this.inputJsName.split("]");
            if (stringArray.length == 2) {
                tempString = stringArray[0];
                this.propertyName = stringArray[1];

                // split on start of sample group delimiter
                stringArray = tempString.split("\\[");
                if (stringArray.length == 2) {
                    this.phenotypeName = stringArray[0];
                    this.sampleGroupName = stringArray[1];
                }
            }
        }
    }

    /**
     * visit the given tree node and find all the matching properties
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // check if the object is a property
        if (dataSet.getType() == PortalConstants.TYPE_PROPERTY_KEY) {
            // if so, match on name
            if (dataSet.getName().equals(this.propertyName)) {
                Property property = (Property)dataSet;

                // if match on name, then see if match on phenotype or sample group parent
                if (property.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                    // if common property, then add it
                    this.propertyList.add(property);

                } else if (property.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
                    // if phenotype property, make sure both the phenotype and phenotype parent sample group match
                    if ((property.getParent() != null) && property.getParent().getName().equals(this.phenotypeName)) {
                        SampleGroup sampleGroup = (SampleGroup)property.getParent().getParent();
                        if (sampleGroup.getSystemId().equals(this.sampleGroupName)) {
                            this.propertyList.add(property);
                        }
                    }

                } else if (property.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
                    // if sample group property, then only match on the sample group parent
                    if (property.getParent() != null) {
                        SampleGroup sampleGroup = (SampleGroup)property.getParent();
                        if (sampleGroup.getSystemId().equals(this.sampleGroupName)) {
                            this.propertyList.add(property);
                        }
                    }
                }
            }

        } else {
            for (DataSet child: dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    /**
     * return the property found; throw an exception if more than one or none found
     *
     * @return
     * @throws PortalException
     */
    public Property getProperty() throws PortalException{
        Property property;

        // if more than one property, throw an exception
        if (this.propertyList.size() > 1) {
            throw new PortalException("Found multiple properties for input string: " + this.inputJsName + ": " + this.propertyList.toString());

        } else if (this.propertyList.size() == 1) {
            property = this.propertyList.get(0);

        } else {
            throw new PortalException("Found no properties for input string: " + this.inputJsName);
        }

        // return
        return property;
    }

    public String getSampleGroupName() {
        return sampleGroupName;
    }

    public String getPhenotypeName() {
        return phenotypeName;
    }

    public String getPropertyName() {
        return propertyName;
    }
}
