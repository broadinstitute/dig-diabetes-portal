package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 11/12/2015.
 */
public class RetrieveAllTechnologiesVisitor  implements DataSetVisitor {

    // instance variables
    String metadataVersion = null;
    List<String> technologyList = new ArrayList<String>();

    /**
     * default constructor
     *
     * @param metadataVersion
     */
    public RetrieveAllTechnologiesVisitor(String metadataVersion) {
        this.metadataVersion = metadataVersion;
    }

    /**
     * visiting method to collect all phenotypes of given tech and metadata version
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables
        Experiment experiment = null;
        boolean visitChildren = false;

        if (dataSet.getType().equals(PortalConstants.TYPE_METADATA_ROOT_KEY)) {
            // if metadata root, visit children
            visitChildren = true;

        } else if (dataSet.getType().equals(PortalConstants.TYPE_EXPERIMENT_KEY)) {
            // if experiment, then make sure right tech and metadata version
            experiment = (Experiment)dataSet;
            String technology = experiment.getTechnology();

            if (!technologyList.contains(technology)){
                technologyList.add(technology);
            }

            // if of proper tech and version, visit; if not, skip since phenotype children of no interest

            if (experiment.getVersion().equals(this.metadataVersion)) {
                visitChildren = true;
            }


        }

        // see if need to visit children
        if (visitChildren) {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    public List<String> getTechnologyList() {
        return technologyList;
    }


}



