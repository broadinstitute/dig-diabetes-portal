package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;

/**
 * Interface to be implemented by classes that traverse metadata tree
 *
 */
public interface DataSetVisitor {
    public void visit(DataSet dataSet);

}
