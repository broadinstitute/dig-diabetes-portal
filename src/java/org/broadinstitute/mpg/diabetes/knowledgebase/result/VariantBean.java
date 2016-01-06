package org.broadinstitute.mpg.diabetes.knowledgebase.result;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by mduby on 9/2/15.
 */
public class VariantBean implements Variant {
    // instance variables
    private String chromosome;
    private String variantId;
    private String polyphenPredictor;
    private String siftPredictor;
    private Integer mostDelScore;
    List<PropertyValue> propertyValues = new ArrayList<PropertyValue>();

    public void addAllToPropertyValues(Collection<PropertyValue> values) {
        this.propertyValues.addAll(values);
    }

    public void addToPropertyValues(PropertyValue value) {
        this.propertyValues.add(value);
    }

    public List<PropertyValue> getPropertyValues() {
        return this.propertyValues;
    }

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

    public Integer getMostDelScore() {
        return mostDelScore;
    }

    public void setMostDelScore(Integer mostDelScore) {
        this.mostDelScore = mostDelScore;
    }

    /**
     * returns the given property value if the given property search terms find one; null otherwise
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public PropertyValue getPropertyValueFromCollection(String propertyName, String sampleGroupName, String phenotypeName) {
        // local variables
        PropertyValue propertyValue = null;

        // search for the property
        for (PropertyValue tempValue: this.propertyValues) {
            if (tempValue.isTheMatchingPropertyValue(propertyName, sampleGroupName, phenotypeName)) {
                propertyValue = tempValue;
            }
        }

        // return
        return propertyValue;
    }
}
