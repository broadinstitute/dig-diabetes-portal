package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to find all phenotypes given a metadata version and technology
 */
public class PhenotypeByTechAndVersionVisitor implements DataSetVisitor {
    // instance variables
    String technology = null;
    String metadataVersion = null;
    List<Phenotype> phenotypeList = new ArrayList<Phenotype>();

    /**
     * default constructor
     *
     * @param technology
     * @param metadataVersion
     */
    public PhenotypeByTechAndVersionVisitor(String technology, String metadataVersion) {
        this.metadataVersion = metadataVersion;
        this.technology = technology;
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

            // if of proper tech and version, visit; if not, skip since phenotype children of no interest
            if (( this.technology == null )|| (this.technology.length()==0)||
                (experiment.getTechnology().equals(this.technology))) {
                if (experiment.getVersion().equals(this.metadataVersion)) {
                    visitChildren = true;
                }
            }

        } else if (dataSet.getType().equals(PortalConstants.TYPE_PHENOTYPE_KEY)) {
            // if phenotype, then add to list
            this.phenotypeList.add((Phenotype)dataSet);

        } else if (dataSet.getType().equals(PortalConstants.TYPE_SAMPLE_GROUP_KEY)) {
            // if sample group, simply visit
            visitChildren = true;
        }

        // see if need to visit children
        if (visitChildren) {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }
    }

    public List<Phenotype> getPhenotypeList() {
        return phenotypeList;
    }
}
