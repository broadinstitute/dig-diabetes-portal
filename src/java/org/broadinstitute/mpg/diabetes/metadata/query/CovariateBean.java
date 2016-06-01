package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.Phenotype;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;

/**
 * Concrete class to represent covariates to json queries
 *
 */
public class CovariateBean implements Covariate {
    // instance variables
    Variant variant = null;
    Phenotype phenotype = null;

    public void setVariant(Variant variant) {
        this.variant = variant;
    }

    public void setPhenotype(Phenotype phenotype) {
        this.phenotype = phenotype;
    }

    public Variant getVariant() {

        return variant;
    }

    public Phenotype getPhenotype() {
        return phenotype;
    }
}
