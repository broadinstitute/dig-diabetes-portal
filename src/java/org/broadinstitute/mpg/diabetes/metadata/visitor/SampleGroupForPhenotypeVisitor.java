package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class to traverse metadata tree and collect sample group names that contain a given phenotype
 *
 */
public class SampleGroupForPhenotypeVisitor implements DataSetVisitor {
    private List<String> sampleGroupNameList;
    private String phenotypeName;
    private List<SampleGroup> sampleGroupList;

    public SampleGroupForPhenotypeVisitor(String phenotypeName) {
        this.sampleGroupNameList = new ArrayList<String>();
        this.sampleGroupList = new ArrayList<SampleGroup>();
        this.phenotypeName = phenotypeName;
    }

    /**
     * method to visit sample group and add it's name to list if it contains the desired phenotype
     *
     * @param dataSet                   the data set to visit
     */
    public void visit(DataSet dataSet) {
        // local variables
        SampleGroup group;

        // if the data set is a sample group
        if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
            group = (SampleGroup)dataSet;

            // go through the phenotypes, if we care about phenotypes, and see if the one being looked for is contained
            if ((this.phenotypeName!=null)&&
                    (this.phenotypeName.length()>0)) {
                for (Phenotype phenotype: group.getPhenotypes()) {
                    // if contained (or else if a blank phenotype match was provided), then add sample group name to list
                    if ((phenotype.getName().equalsIgnoreCase(this.phenotypeName))||
                            (this.phenotypeName.length()==0)){
                        this.sampleGroupNameList.add(group.getSystemId());
                        this.sampleGroupList.add(group);
                        break;
                    }
                }

            } else { // we don't care about phenotypes.  This end through the sample group list anyway
                this.sampleGroupNameList.add(group.getSystemId());
                this.sampleGroupList.add(group);
            }
       }

        for (DataSet child : dataSet.getAllChildren()) {
            child.acceptVisitor(this);
        }
    }

    public List<String> getSampleGroupNameList() {
        return sampleGroupNameList;
    }

    public List<SampleGroup> getSampleGroupList() {
        return sampleGroupList;
    }
}
