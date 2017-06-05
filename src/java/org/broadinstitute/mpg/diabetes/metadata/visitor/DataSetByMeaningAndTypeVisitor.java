package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 2/2/2016.
 */
public class DataSetByMeaningAndTypeVisitor implements DataSetVisitor {
    private String propertyMeaning;
    private String dataSetType;
    private String version;
    private List<DataSet> dataSetList = new ArrayList<DataSet>();

    /**
     * default constructor with the property id string to find by
     *
     * @param propertyMeaning
     */
    public DataSetByMeaningAndTypeVisitor(String propertyMeaning, String dataSetType, String version) {
        this.propertyMeaning = propertyMeaning;
        this.dataSetType = dataSetType;
        this.version = version;
    }

    public DataSetByMeaningAndTypeVisitor(String propertyMeaning, String dataSetType) {
        this.propertyMeaning = propertyMeaning;
        this.dataSetType = dataSetType;
    }

    /**
     * traverse dataset tree until find the first property with that value
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables
        boolean addToList = false;

        // test the given data set to see if it matches given parameters
        if (dataSet.getType().equals(this.dataSetType)) {
            if (dataSet.getType().equals(PortalConstants.TYPE_PROPERTY_KEY)) {
                PropertyBean propertyBean = (PropertyBean) dataSet;
                if (propertyBean.hasMeaning(this.propertyMeaning)) {
                    addToList = true;
                }
            } else if (dataSet.getType().equals(PortalConstants.TYPE_SAMPLE_GROUP_KEY)) {
                SampleGroupBean sampleGroupBean = (SampleGroupBean) dataSet;
                if (sampleGroupBean.hasMeaning(this.propertyMeaning)) {
                    addToList = true;
                }
            }

            // now see if it meets the version criteria
            if (addToList && (this.version != null)) {
                addToList = false;
                DataSet parent = dataSet.getParent();

                while ((parent != null) && (!parent.getType().equals(PortalConstants.TYPE_EXPERIMENT_KEY))) {
                    parent = parent.getParent();
                }

                // if parent not null, check version
                if (parent != null) {
                    if (this.version.equals(((Experiment)parent).getVersion())) {
                        addToList = true;
                    }
                }
            }

            // if add to list is true, then add it
            if (addToList) {
                this.dataSetList.add(dataSet);
            }
        }

        for (DataSet child:dataSet.getAllChildren()){
            child.acceptVisitor(this);
        }

    }

    public List<DataSet> getDataSetList() {
        return this.dataSetList;
    }

}

