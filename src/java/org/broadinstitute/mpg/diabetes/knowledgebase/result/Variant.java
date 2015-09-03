package org.broadinstitute.mpg.diabetes.knowledgebase.result;

/**
 * Created by mduby on 9/2/15.
 */
public interface Variant {
    public String getChromosome();

    public void setChromosome(String chromosome);

    public String getVariantId();

    public void setVariantId(String variantId);

    public String getPolyphenPredictor();

    public void setPolyphenPredictor(String polyphenPredictor);

    public String getSiftPredictor();

    public void setSiftPredictor(String siftPredictor);

}
