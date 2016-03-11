package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 3/9/2016.
 */
public class SampleGroupForNonMixedAncestry  implements DataSetVisitor {
    private List<SampleGroup> sampleGroupList;
    private String metadataVersion;
    private String ancestryName="";


    public SampleGroupForNonMixedAncestry( String metadataVersion, String ancestryName) {
        this.sampleGroupList = new ArrayList<SampleGroup>();
        this.metadataVersion = metadataVersion;
        this.ancestryName = ancestryName;
    }

    public void visit(DataSet dataSet) {
        // local variables
        Experiment experiment;
        SampleGroup group;
        Phenotype phenotype;
        boolean visitChildren = false;

        if (dataSet.getType().equals(PortalConstants.TYPE_METADATA_ROOT_KEY)) {
            // if metadata root, visit children
            visitChildren = true;

        } else if (dataSet.getType().equals(PortalConstants.TYPE_EXPERIMENT_KEY)) {
            // if experiment, then make sure right tech and metadata version
            experiment = (Experiment)dataSet;

            // if of proper version, visit; if not, skip since children of this experiment are of no interest
            if (experiment.getVersion().equals(this.metadataVersion)) {
                visitChildren = true;
            }


        } else if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
            group = (SampleGroup)dataSet;

            if (this.ancestryName.equals("")) { // If ancestry string is blank then don't filter by it
                visitChildren = true;
                this.sampleGroupList.add(group);
            } else if (group.getAncestry().equals(this.ancestryName)) { // a 'mixed' group may contain other sample groups, so we must descend
                    visitChildren = true;
            } else {
                visitChildren = true;
                this.sampleGroupList.add(group);
            }


        }
        if (visitChildren) {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    public List<SampleGroup> getSampleGroupList() {
        return sampleGroupList;
    }



}

