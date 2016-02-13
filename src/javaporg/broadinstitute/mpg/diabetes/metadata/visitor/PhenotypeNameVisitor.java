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
        // if phenotype, then add name
        if (dataSet.getType() == PortalConstants.TYPE_PHENOTYPE_KEY) {
            this.phenotypNameSet.add(dataSet.getName());

        // if not, then only look at children if not property (leaf node)
        } else if (dataSet.getType() != PortalConstants.TYPE_PROPERTY_KEY) {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
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
