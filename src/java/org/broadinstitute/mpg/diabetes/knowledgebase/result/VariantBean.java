package org.broadinstitute.mpg.diabetes.knowledgebase.result;

import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by mduby on 9/2/15.
 */
public class VariantBean implements Variant {
    // constants
    public static final String FORMAT_VAR_ID_BROAD = "broadFormat";         // chrom_position_refAllele_altAllele
    public static final String FORMAT_VAR_ID_UMICH = "uMichFormat";         // chrom:position_refAllele/altAllele

    // instance variables
    private String chromosome;
    private int position;
    private String referenceAllele;
    private String alternateAllele;
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
        // if the variant id is null, try to see if we can find it in the property values
        if (this.variantId == null) {
            PropertyValue tempPropertyValue = this.getPropertyValueFromCollection(PortalConstants.PROPERTY_NAME_VAR_ID, null, null);

            // if not null, get varId
            if (tempPropertyValue != null) {
                this.variantId = tempPropertyValue.getValue();
            }
        }

        // return
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

    /**
     * return the varId in given format
     *
     * @param formatKey
     * @return
     */
    public String getVariantIdWithFormat(String formatKey) throws PortalException {
        // local variables
        String returnVarId = this.getVariantId();

        if (formatKey != null) {
            if (formatKey.equals(FORMAT_VAR_ID_UMICH)) {
                // change to UMich format
                returnVarId = this.formatVarIdForUMichiganFormat(variantId);
            }
        }

        // return
        return returnVarId;
    }

    /**
     * return new formatted varId in UMich expected format
     *
     * @param originalVarId
     * @return
     * @throws PortalException
     */
    protected String formatVarIdForUMichiganFormat(String originalVarId) throws PortalException {
        // local variables
        StringBuffer formattedVarIdBuffer = new StringBuffer();
        String[] splitStringArray = null;

        // check string not null
        if (originalVarId == null) {
            throw new PortalException("Got null varId string to reformat");
        }

        // split the string into the 4 parts
        splitStringArray = originalVarId.split("_");

        // check array is 4 parts long
        if (splitStringArray == null) {
            throw new PortalException("Got null varId array split for reformat");
        } else if (splitStringArray.length < 4) {
            throw new PortalException("Got varId array split for reformat of size: " + splitStringArray.length);
        }

        // rebuild the string into the chrom:position_refAllele/altAllele format
        formattedVarIdBuffer.append(splitStringArray[0]);
        formattedVarIdBuffer.append(":");
        formattedVarIdBuffer.append(splitStringArray[1]);
        formattedVarIdBuffer.append("_");
        formattedVarIdBuffer.append(splitStringArray[2]);
        formattedVarIdBuffer.append("/");
        formattedVarIdBuffer.append(splitStringArray[3]);

        // return
        return formattedVarIdBuffer.toString();
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getReferenceAllele() {
        return referenceAllele;
    }

    public void setReferenceAllele(String referenceAllele) {
        this.referenceAllele = referenceAllele;
    }

    public String getAlternateAllele() {
        return alternateAllele;
    }

    public void setAlternateAllele(String alternateAllele) {
        this.alternateAllele = alternateAllele;
    }
}
