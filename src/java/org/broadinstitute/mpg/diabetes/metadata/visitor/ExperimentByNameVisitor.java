package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

/**
 * Created by balexand on 8/19/2015.
 */
public class ExperimentByNameVisitor implements DataSetVisitor {
    Experiment experiment;
    String experimentName;

    public ExperimentByNameVisitor(String experimentName) {
        this.experimentName = experimentName;
    }

    public void visit(DataSet dataSet) {
        if (dataSet.getType() == PortalConstants.TYPE_EXPERIMENT_KEY) {
            if (dataSet.getName().equalsIgnoreCase(this.experimentName)) {
                this.experiment = (Experiment)dataSet;
            }
        } else {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    public Experiment getExperiment() {
        return experiment;
    }
}
