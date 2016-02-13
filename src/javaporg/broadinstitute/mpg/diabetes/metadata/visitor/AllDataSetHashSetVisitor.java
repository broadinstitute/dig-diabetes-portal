package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;

import java.util.HashMap;
import java.util.Map;

/**
 * Data set visitor to aggregate all data sets into a central hashmap
 *
 */
public class AllDataSetHashSetVisitor implements DataSetVisitor {
    // instance variables
    Map<String, DataSet> dataSetMap;
    String error;

    public AllDataSetHashSetVisitor() {
        this.dataSetMap = new HashMap<String, DataSet>();
    }

    /**
     * visit all nodes and add them to the hash map
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        if (this.dataSetMap.containsKey(dataSet.getId())) {
            this.error = "The id: " + dataSet.getId() + " is a duplicate key";
        } else {
            this.dataSetMap.put(dataSet.getId(), dataSet);
        }

        // visit all children
        for (DataSet child: dataSet.getAllChildren()) {
            child.acceptVisitor(this);
        }
    }

    /**
     * return the map
     *
     * @return
     */
    public Map<String, DataSet> getDataSetMap() {
        return dataSetMap;
    }

    public String getError() {
        return error;
    }
}
