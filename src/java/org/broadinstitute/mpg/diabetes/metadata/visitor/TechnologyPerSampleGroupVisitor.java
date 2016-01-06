package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

/**
 * Created by balexand on 12/9/2015.
 */
public class TechnologyPerSampleGroupVisitor implements DataSetVisitor {
    // instance variables
    private String sampleGroupId;
    private SampleGroup sampleGroup;
    private String currentlyAssessingTechnology;
    private String technology;

    public TechnologyPerSampleGroupVisitor(String sampleGroupId) {
        this.sampleGroupId = sampleGroupId;
    }

    public void visit(DataSet dataSet) {
        // local variables
        SampleGroup sampleGroup;
        boolean visitChildren = false;

        if (dataSet.getType().equals(PortalConstants.TYPE_METADATA_ROOT_KEY)) {
            // if metadata root, visit children
            visitChildren = true;

        } else if (dataSet.getType().equals(PortalConstants.TYPE_EXPERIMENT_KEY)) {
            // if experiment, then make sure right tech and metadata version
            Experiment experiment = (Experiment)dataSet;
            this.currentlyAssessingTechnology = experiment.getTechnology();
            visitChildren = true;

        } if (this.sampleGroup == null) {
            if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
                sampleGroup = (SampleGroup)dataSet;
                visitChildren = true;

                if (sampleGroup.getSystemId().equalsIgnoreCase(this.sampleGroupId)) {
                    this.sampleGroup = sampleGroup;
                    this.technology = this.currentlyAssessingTechnology;
                    visitChildren = false;
                }
            }
        }

        // if still children
        if (visitChildren) {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }

    }

    public String getTechnology() {
        return this.technology;
    }
}



