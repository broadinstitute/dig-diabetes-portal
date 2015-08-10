package org.broadinstitute.mpg.diabetes.metadata;

import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetVisitor;

/**
 * Interface to be implemented by the metadata tree classes
 */
public interface DataSet {
    public DataSet getParent();

    public String getId();

    public String getType();

    public void acceptVisitor(DataSetVisitor visitor);

    public String getName();
}
