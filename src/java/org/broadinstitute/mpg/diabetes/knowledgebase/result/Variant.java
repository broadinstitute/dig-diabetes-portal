package org.broadinstitute.mpg.diabetes.knowledgebase.result;

/**
 * Created by mduby on 9/2/15.
 */
public interface Variant {
    public String getChromosome();

    public String getVariantId();

    public String getPolyphenPredictor();

    public String getSiftPredictor();

    public Integer getMostDelScore();
}
