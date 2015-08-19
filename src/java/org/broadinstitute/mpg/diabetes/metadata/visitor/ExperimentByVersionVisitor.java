package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 8/19/2015.
 */
public class ExperimentByVersionVisitor implements DataSetVisitor {
    List<Experiment> experimentList = new ArrayList<Experiment>();
    String versionToSearchFor;

    public ExperimentByVersionVisitor(String version) {
        this.versionToSearchFor =version;
    }

    public void visit(DataSet dataSet) {
        if (dataSet.getType() == PortalConstants.TYPE_EXPERIMENT_KEY) {
            Experiment tempExperiment = (Experiment)dataSet;
            if (tempExperiment.getVersion().equalsIgnoreCase(this.versionToSearchFor)) {
                this.experimentList.add(tempExperiment);
            }
        } else {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    public List<Experiment> getExperimentList() {
        return experimentList;
    }
}
