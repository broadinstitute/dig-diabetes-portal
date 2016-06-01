package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.Phenotype;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;

/**
 * Created by mduby on 5/25/16.
 */
public interface Covariate {

    public void setVariant(Variant variant);

    public void setPhenotype(Phenotype phenotype);

    public Variant getVariant();

    public Phenotype getPhenotype();
}
