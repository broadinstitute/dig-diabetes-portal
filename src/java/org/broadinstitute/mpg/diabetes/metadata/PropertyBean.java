package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to represent the metadata properties
 *
 */
public class PropertyBean implements Property, Comparable {
    private String name;
    private String description;
    private String variableType;
    private int sortOrder;
    private boolean searchable;
    private DataSet parent;

    /**
     * return a list of all the object's dataset children
     *
     * @return
     */
    public List<DataSet> getAllChildren() {
        // return the resulting list (empty list)
        return new ArrayList<DataSet>();
    }

    public void setParent(DataSet parent) {
        this.parent = parent;
    }

    public String getType() {
        return PortalConstants.TYPE_PROPERTY_KEY;
    }

    public String getPropertyType() {
        String propertyType = PortalConstants.TYPE_COMMON_PROPERTY_KEY;

        if (this.parent != null) {
            if (this.parent.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
                propertyType = PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY;
            } else if (this.getParent().getType() == PortalConstants.TYPE_PHENOTYPE_KEY) {
                propertyType = PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY;
            }
        }

        return propertyType;
    }

    public String getId() {
        return (this.parent == null ? "" : this.parent.getId()) + this.name;
    }

    public DataSet getParent() {
        return this.parent;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setVariableType(String variableType) {
        this.variableType = variableType;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public void setSearchable(boolean searchable) {
        this.searchable = searchable;
    }

    public String getName() {
        return this.name;
    }

    public String getDescription() {
        return this.description;
    }

    public String getVariableType() {
        return this.variableType;
    }

    public boolean isSearchable() {
        return this.searchable;
    }

    public int getSortOrder() {
        return this.sortOrder;
    }

    /**
     * returns the filter string based on what type of property it is (common, dataset or phenotype property)
     *
     * @param operator
     * @param value
     * @return
     */
    public String getWebServiceFilterString(String operator, String value) {
        // local variables
        StringBuilder builder = new StringBuilder();
        String dataset = "blah";
        String phenotype = "blah";

        // based on what type of property you are, add in dataset and phenotype
        if (this.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
            if (this.getParent() != null) {
                SampleGroup parentGroup = (SampleGroup)this.getParent();
                dataset = parentGroup.getSystemId();
            }

        } else if (this.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
            if (this.getParent().getParent() != null) {
                SampleGroup parentGroup = (SampleGroup)this.getParent().getParent();
                dataset = parentGroup.getSystemId();
            }
            phenotype = (this.getParent() != null ? this.getParent().getName() : "blah");
        }

        // build the filter string
        builder.append("{\"dataset_id\": \"");
        builder.append(dataset);
        builder.append("\", \"phenotype\": \"");
        builder.append(phenotype);
        builder.append("\", \"operand\": \"");
        builder.append(this.getName());
        builder.append("\", \"operator\": \"");
        builder.append(operator);
        builder.append("\", \"value\": \"");
        builder.append(value);
        builder.append("\", \"operand_type\": \"");
        builder.append(this.getVariableType());
        builder.append("\"}");

        // return the string
        return builder.toString();
    }

    /**
     * returns the property query string in json format
     *
     * @return
     * @throws PortalException
     */
    public String getWebServiceQueryString() throws PortalException {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();

        // return different property string based on what type of property it is
        if (this.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
            // simply return the name
            stringBuilder.append("\"");
            stringBuilder.append(this.getName());
            stringBuilder.append("\"");

        } else if (this.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
            // TODO - need to implement

        } else if (this.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
            // build data structure based on sample group and phenotype
            stringBuilder.append("\"");
            stringBuilder.append(this.getName());
            stringBuilder.append("\" : { \"");
            stringBuilder.append(this.getParent().getParent().getName());
            stringBuilder.append("\" : [ \"");
            stringBuilder.append(this.getParent().getName());
            stringBuilder.append("\" ] }");

        } else {
            throw new PortalException("got invalid property type: " + this.getPropertyType());
        }

        // return the property query string
        return stringBuilder.toString();
    }

    /**
     * implement the visitor pattern
     *
     * @param visitor
     */
    public void acceptVisitor(DataSetVisitor visitor) {
        visitor.visit(this);
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
            PropertyBean otherBean = (PropertyBean)object;

            if (this.getSortOrder() == otherBean.getSortOrder()) {
                return this.getName().compareTo(otherBean.getName());
            } else {
                return (this.getSortOrder() < otherBean.getSortOrder() ? -1 : 1);
            }
        }
    }
}
