package org.broadinstitute.mpg.diabetes.knowledgebase.result;

/**
 * Created by mduby on 9/2/15.
 */
public class VariantBean implements Variant {
    // instance variables
    private String chromosome;
    private String variantId;
    private String polyphenPredictor;
    private String siftPredictor;


    public String getChromosome() {
        return chromosome;
    }

    public void setChromosome(String chromosome) {
        this.chromosome = chromosome;
    }

    public String getVariantId() {
        return variantId;
    }

    public void setVariantId(String variantId) {
        this.variantId = variantId;
    }

    public String getPolyphenPredictor() {
        return polyphenPredictor;
    }

    public void setPolyphenPredictor(String polyphenPredictor) {
        this.polyphenPredictor = polyphenPredictor;
    }

    public String getSiftPredictor() {
        return siftPredictor;
    }

    public void setSiftPredictor(String siftPredictor) {
        this.siftPredictor = siftPredictor;
    }

    public String toString() {return this.variantId;}
}
