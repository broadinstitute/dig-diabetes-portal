package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Class to represent the metadata properties
 *
 */
public class PropertyBean implements Property, Comparable {
    private String name;
    private String description;
    private String variableType;
    private String requestedPhenotype;
    private String requestedDataset;
    private int sortOrder;
    private boolean searchable;
    private DataSet parent;
    private  boolean geneTablemdv37;
    private Set<String> meaningSet = new HashSet<String>();     // hashset will take care of accidental duplicate insertions


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

    /**
     * determines if the property has been tagged with a given metadata word
     *
     * @param meaningValue
     * @return
     */
    public boolean hasMeaning(String meaningValue) {
        if (meaningValue == null) {
            return false;
        } else {
            return this.meaningSet.contains(meaningValue);
        }
    }

    public String getRequestedPhenotype() {
        return requestedPhenotype;
    }

    public void setRequestedPhenotype(String requestedPhenotype) {
        this.requestedPhenotype = requestedPhenotype;
    }

    public String getRequestedDataset() {
        return requestedDataset;
    }

    public void setRequestedDataset(String requestedDataset) {
        this.requestedDataset = requestedDataset;
    }

    public boolean isGeneTablemdv37() {
        return geneTablemdv37;
    }

    public void setGeneTablemdv37(boolean geneTablemdv37) {
        this.geneTablemdv37 = geneTablemdv37;
    }

    /**
     * add meaning values when building the property bean
     *
     * @param meaningValue
     */
    public void addMeaning(String meaningValue) {
        this.meaningSet.add(meaningValue);
    }

    /**
     * add all meaning values when building the property bean
     *
     * @param meanings
     */
    public void addAllMeanings(Collection<String> meanings) {
        this.meaningSet.addAll(meanings);
    }

    public List<String> getMeanings() {
        List<String> retstat = new ArrayList<String>();
        retstat.addAll(this.meaningSet);
        return retstat;
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
     * Get the string needed for adding this property as an order_by criteria
     * @param directionOfSort   "" if sorting ascending, "-1" if descending
     * @return
     */
    public String getWebServiceOrderByString(String directionOfSort) {
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
        builder.append(directionOfSort);
        builder.append("\"}");

        // return the string
        return builder.toString();
    }

    /**
     * returns the filter string based on what type of property it is (common, dataset or phenotype property)
     *
     * @param operator
     * @param value
     * @return
     */
    public String getWebServiceFilterString(String operator, String value, String requestedPhenotype) {
        // local variables
        StringBuilder builder = new StringBuilder();
        String dataset = "blah";
        String phenotype = "blah";

        // based on what type of property you are, add in dataset and phenotype
        if (this.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
            if (this.getParent() != null) {
                SampleGroup parentGroup = (SampleGroup)this.getParent();
                dataset = parentGroup.getSystemId();
                if ((requestedPhenotype !=  null ) && (requestedPhenotype.length()>0)){
                    phenotype = requestedPhenotype;
                }
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
        builder.append("\", \"value\": ");

        // no quotes for numbers
        if (this.getVariableType().equals(PortalConstants.OPERATOR_TYPE_FLOAT) ||
                this.getVariableType().equals(PortalConstants.OPERATOR_TYPE_INTEGER) ||
                this.getVariableType().equals(PortalConstants.NAME_COMMON_METAFILTER_OR)  ||
        this.getVariableType().equals(PortalConstants.NAME_COMMON_METAFILTER_AND)
                ) {
            builder.append(value);
            builder.append(", ");

        } else {
            builder.append("\"");
            builder.append(value);
            builder.append("\", ");
        }

        builder.append("\"operand_type\": \"");
        builder.append(this.getVariableType());
        builder.append("\"}");

        // return the string
        return builder.toString();
    }



    /**
     * returns the filter string based on what type of property it is (common, dataset or phenotype property)
     *
     * @param operator
     * @param value
     * @return
     */
    public String getWebServiceFilterString(String operator, String value, String requestedPhenotype, String requestedDataset) {
        // local variables
        StringBuilder builder = new StringBuilder();
        String dataset = "blah";
        String phenotype = "blah";

        // based on what type of property you are, add in dataset and phenotype
        if (this.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
            if (this.getParent() != null) {
                SampleGroup parentGroup = (SampleGroup)this.getParent();
                dataset = parentGroup.getSystemId();
                if ((requestedPhenotype !=  null ) && (requestedPhenotype.length()>0)){
                    phenotype = requestedPhenotype;
                }
            }

        } else if (this.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
            if (this.getParent().getParent() != null) {
                SampleGroup parentGroup = (SampleGroup)this.getParent().getParent();
                dataset = parentGroup.getSystemId();
            }
            phenotype = (this.getParent() != null ? this.getParent().getName() : "blah");
        }

        //HACK ALERT: for adding phenotype and dataset in filter list for getGeneData for mdv37
        //Ideally we should have got this property from the geneMetadata but since we don't have getGeneMetadataRoot implemented
        // I had to do this.
        if(requestedPhenotype != null && requestedDataset != null){
            phenotype = requestedPhenotype;
            dataset = requestedDataset;
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
        builder.append("\", \"value\": ");

        // no quotes for numbers
        if (this.getVariableType().equals(PortalConstants.OPERATOR_TYPE_FLOAT) ||
                this.getVariableType().equals(PortalConstants.OPERATOR_TYPE_INTEGER) ||
                this.getVariableType().equals(PortalConstants.NAME_COMMON_METAFILTER_OR)  ||
                this.getVariableType().equals(PortalConstants.NAME_COMMON_METAFILTER_AND)
                ) {
            builder.append(value);
            builder.append(", ");

        } else {
            builder.append("\"");
            builder.append(value);
            builder.append("\", ");
        }

        builder.append("\"operand_type\": \"");
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

    /**
     * returns true if the property matches the 3 criteria names given
     * <br/>
     * its name, its sample group name and its phenotype name (the latter 2 can be null)
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public boolean isTheMatchingProperty(String propertyName, String sampleGroupName, String phenotypeName) {
        // local variables
        boolean isTheMatchingProperty = false;

        // test to see if the passed in terms match
        if ((phenotypeName != null) && (phenotypeName.length() > 0)) {
            // looking for a phenotype property
            if (this.getPropertyType() == PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY) {
                SampleGroup parent = (SampleGroup)this.getParent().getParent();
                if (parent.getSystemId().equals(sampleGroupName) &&
                        this.getParent().getName().equals(phenotypeName) &&
                        this.getName().equals(propertyName)) {
                    isTheMatchingProperty = true;
                }
            }

        } else if ((sampleGroupName != null) && (sampleGroupName.length() > 0)) {
            // looking for sample group property
            if (this.getPropertyType() == PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY) {
                SampleGroup parent = (SampleGroup)this.getParent();
                if (parent.getSystemId().equals(sampleGroupName) &&
                        this.getName().equals(propertyName)) {
                    isTheMatchingProperty = true;
                }
            }
        } else {
            // looking for a common property
            if (this.getPropertyType() == PortalConstants.TYPE_COMMON_PROPERTY_KEY) {
                if (this.getName().equals(propertyName)) {
                    isTheMatchingProperty = true;
                }
            }
        }

        // return
        return isTheMatchingProperty;
    }
}
