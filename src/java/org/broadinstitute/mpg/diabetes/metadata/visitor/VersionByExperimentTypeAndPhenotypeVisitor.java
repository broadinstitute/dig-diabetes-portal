package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Visitor class to find mdv versions that have a particular experiment type and a particular phenotype
 *
 * Created by mduby on 10/12/16.
 */
public class VersionByExperimentTypeAndPhenotypeVisitor implements DataSetVisitor {
    // instance variables
    private String phenotypeString = null;
    private String experimentTypeString = null;
    private List<String> versionList = new ArrayList<String>();

    /**
     * default constructor
     *
     * @param phenotype
     * @param experimentType
     */
    public VersionByExperimentTypeAndPhenotypeVisitor(String phenotype, String experimentType) {
        this.experimentTypeString = experimentType;
        this.phenotypeString = phenotype;
    }

    /**
     * visit the tree
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        // local variables
        Experiment experiment = null;

        // only use this method for the top level experiment
        if (dataSet.getType().equalsIgnoreCase(PortalConstants.TYPE_EXPERIMENT_KEY)) {
            experiment = (Experiment)dataSet;

            // visit all the children to find matching phenotypes
            for (DataSet child : dataSet.getAllChildren()) {
                this.visitExperimentTypeMatchedExperiment(child, experiment.getVersion());
            }
        } else {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    /**
     * method to look through the experiment
     *
     * @param dataSet
     * @param version
     */
    private void visitExperimentTypeMatchedExperiment(DataSet dataSet, String version) {
        // local variables
        Phenotype phenotype = null;

        // if phenotype, see if string matches
        if (dataSet.getType().equalsIgnoreCase(PortalConstants.TYPE_PHENOTYPE_KEY)) {
            phenotype = (Phenotype)dataSet;

            // check the phenotype name
            if ((phenotype.getName() != null) && (phenotype.getName().equalsIgnoreCase(this.phenotypeString))) {
                this.versionList.add(version);
            }

        } else {
            // visit all children
            for (DataSet child : dataSet.getAllChildren()) {
                this.visitExperimentTypeMatchedExperiment(child, version);
            }
        }

    }

    public List<String> getVersionList() {
        return versionList;
    }
}
