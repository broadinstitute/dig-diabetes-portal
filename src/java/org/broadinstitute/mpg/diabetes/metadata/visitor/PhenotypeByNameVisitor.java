package org.broadinstitute.mpg.diabetes.metadata.visitor;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by balexand on 8/24/2015.
 */
public class PhenotypeByNameVisitor  implements DataSetVisitor  {
    List<Phenotype> phenotypeList = new ArrayList<Phenotype>();
    private String phenotypeName = "";

    public PhenotypeByNameVisitor(){
    }
    public PhenotypeByNameVisitor(String phenotypeName){
        this.phenotypeName = phenotypeName;
    }

    public List<Phenotype> getPhenotypeList() {
        return phenotypeList;
    }

    /***
     * If we have a phenotype then only pull back phenotypes of that name. Otherwise pull back all phenotypes.
     *
     * @param dataSet
     */
    public void visit(DataSet dataSet) {
        if (dataSet.getType() == PortalConstants.TYPE_PHENOTYPE_KEY) {
            Phenotype tempPhenotype = (Phenotype)dataSet;
            if ((this.phenotypeName!=null)&&
                (this.phenotypeName.length()>0)){
                if (tempPhenotype.getName().equalsIgnoreCase(this.phenotypeName)) {
                    this.phenotypeList.add(tempPhenotype);
                }
            } else {
                this.phenotypeList.add(tempPhenotype);
            }

        } else {
            for (DataSet child : dataSet.getAllChildren()) {
                child.acceptVisitor(this);
            }
        }

    }
}
