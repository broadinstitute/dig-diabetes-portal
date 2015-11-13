package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 11/12/2015.
 */
public class SampleGroupForPhenotypeTechnologyAncestryVisitor implements DataSetVisitor  {
    private List<SampleGroup> sampleGroupList;
    private String phenotypeName;
    private String technologyName;
    private String metadataVersion;
    private String ancestryName="";


    public SampleGroupForPhenotypeTechnologyAncestryVisitor(String phenotypeName, String technologyName, String metadataVersion, String ancestryName) {
        this.sampleGroupList = new ArrayList<SampleGroup>();
        this.phenotypeName = phenotypeName;
        this.technologyName = technologyName;
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

            // if of proper tech and version, visit; if not, skip since phenotype children of no interest
            if (experiment.getTechnology().equals(this.technologyName)) {
                if (experiment.getVersion().equals(this.metadataVersion)) {
                    visitChildren = true;
                }
            }

//        } else if (dataSet.getType().equals(PortalConstants.TYPE_PHENOTYPE_KEY)) {
//            phenotype = (Phenotype) dataSet;
//
//            if (phenotype.getName().equals(this.phenotypeName)) {
//               visitChildren = true;
//            }
        } else if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
            group = (SampleGroup)dataSet;

            List<Phenotype> phenotypes =  group.getPhenotypes();
            List<String> phenotypeName = new ArrayList<String>();
            for ( int  i = 0 ; i < phenotypes.size() ; i++ ){
                phenotypeName.add(phenotypes.get(i).getName());
            }
            if (phenotypeName.contains(this.phenotypeName)){
                if (this.ancestryName.equals("")) { // If ancestry string is blank then don't filter by it
                    visitChildren = true;
                    this.sampleGroupList.add(group);
                } else if (group.getAncestry().equals("Mixed")) { // a 'mixed' group may contain other sample groups, so we need special handling
                    if (this.ancestryName.equals(group.getAncestry())){
                        visitChildren = true;
                        this.sampleGroupList.add(group);
                    } else {
                        visitChildren = true;
                    }
                } else if (this.ancestryName.equals(group.getAncestry())) {
                    visitChildren = true;
                    this.sampleGroupList.add(group);
                }

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
