package org.broadinstitute.mpg.diabetes.metadata.visitor;

        import org.broadinstitute.mpg.diabetes.metadata.*;
        import org.broadinstitute.mpg.diabetes.util.PortalConstants;

        import java.util.ArrayList;
        import java.util.List;

/**
 * Created by balexand on 11/12/2015.
 */
public class SampleGroupForPhenotypeDatasetTechnologyAncestryVisitor implements DataSetVisitor  {
    private List<SampleGroup> sampleGroupList;
    private String phenotypeName;
    private String datasetName;
    private String technologyName;
    private String metadataVersion;
    private String ancestryName="";


    public SampleGroupForPhenotypeDatasetTechnologyAncestryVisitor(String phenotypeName,  String datasetName, String technologyName, String metadataVersion, String ancestryName) {
        this.sampleGroupList = new ArrayList<SampleGroup>();
        this.phenotypeName = phenotypeName;
        this.datasetName = datasetName;
        this.technologyName = technologyName;
        this.metadataVersion = metadataVersion;
        this.ancestryName = ancestryName;
    }

    private Boolean isAnAncestryMatch(SampleGroup group,String ancestryName,List<SampleGroup> sampleGroupList){
        Boolean visitChildren = false;
        if (ancestryName.equals("")) { // If ancestry string is blank then don't filter by it
            visitChildren = true;
            sampleGroupList.add(group);
        } else if (group.getAncestry().equals("Mixed")) { // a 'mixed' group may contain other sample groups, so we need special handling
            if (ancestryName.equals(group.getAncestry())){
                visitChildren = true;
                sampleGroupList.add(group);
            } else {
                visitChildren = true;
            }
        } else if (ancestryName.equals(group.getAncestry())) {
            visitChildren = true;
            sampleGroupList.add(group);
        }
        return visitChildren;
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

        } else if (dataSet.getType() == PortalConstants.TYPE_SAMPLE_GROUP_KEY) {
            group = (SampleGroup)dataSet;

            // we might choose to return a sample group due to a matching phenotype property...
            List<Phenotype> phenotypes =  group.getPhenotypes();
            List<String> phenotypeNames = new ArrayList<String>();
            for ( int  i = 0 ; i < phenotypes.size() ; i++ ){
                phenotypeNames.add(phenotypes.get(i).getName());
            }
            if (!(this.phenotypeName.equals(""))){ // // If phenotype string is blank then don't filter by it
                  if  (phenotypeNames.contains(this.phenotypeName)) {
                      visitChildren = isAnAncestryMatch(group, this.ancestryName, this.sampleGroupList);
                  }
            }


            // ...or else we might choose to return a sample group due to a matching data set property.
            List<Property> properties =  group.getProperties();
            List<String> propertyNames = new ArrayList<String>();
            for ( int  i = 0 ; i < properties.size() ; i++ ){
                propertyNames.add(properties.get(i).getName());
            }
            if (!(this.datasetName.equals(""))){ // // If dataset string is blank then ignore it
                 if (propertyNames.contains(this.datasetName)){
                    visitChildren = isAnAncestryMatch(group, this.ancestryName, this.sampleGroupList);
                }
            }

            // Note that matching on data set OR phenotype is fine

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
