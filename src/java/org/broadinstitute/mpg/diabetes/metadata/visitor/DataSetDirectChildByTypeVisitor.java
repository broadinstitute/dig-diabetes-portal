package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to visit data set and accumulate all its direct children of a certain given type (sample group, phenotype, property)
 *
 */
public class DataSetDirectChildByTypeVisitor implements DataSetVisitor {
    // instance variables
    private List<DataSet> dataSetList = new ArrayList<DataSet>();
    private String childType;

    /**
     * default constructor with the default child type (sample group, phenotype, property, etc) indicated
     *
     * @param childType
     */
    public DataSetDirectChildByTypeVisitor(String childType) {
        this.childType = childType;
    }

    /**
     * visit the node and get the direct children of type of that node
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables

        // for the dataset visiting, only grab the direct sample group children (no grandchildren or other descendants) of this data set
        for (DataSet child: dataSet.getAllChildren()) {
            if (child.getType() == this.childType) {
                this.dataSetList.add(child);
            }
        }
    }

    /**
     * return the list of accumulated children of type
     *
     * @return
     */
    public List<DataSet> getDataSetList() {
        return dataSetList;
    }
}
