package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.HashSet;

/**
 * Class to traverse the metadata tree and collect all the distinct phenotype names in a set
 *
 */
public class PhenotypeNameVisitor implements DataSetVisitor {
    HashSet<String> phenotypNameSet = new HashSet<String>();

    /**
     * visis the data set and captures the phenotype names within it
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        if (dataSet.getType() == PortalConstants.TYPE_PHENOTYPE_KEY) {
            this.phenotypNameSet.add(dataSet.getName());
        }
    }

    /**
     * return the phenotype name set
     *
     * @return
     */
    public HashSet<String> getResultSet() {
        return phenotypNameSet;
    }
}
