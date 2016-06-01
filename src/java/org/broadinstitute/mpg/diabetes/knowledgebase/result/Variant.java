package org.broadinstitute.mpg.diabetes.knowledgebase.result;

import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.Collection;
import java.util.List;

/**
 * Created by mduby on 9/2/15.
 */
public interface Variant {

    public String getChromosome();

    public String getVariantId();

    public String getPolyphenPredictor();

    public String getSiftPredictor();

    public Integer getMostDelScore();

    public List<PropertyValue> getPropertyValues();

    public void addAllToPropertyValues(Collection<PropertyValue> values);

    public void addToPropertyValues(PropertyValue value);

    public String getVariantIdWithFormat(String formatKey) throws PortalException;

    /**
     * returns the given property value if the given property search terms find one; null otherwise
     *
     * @param propertyName
     * @param sampleGroupName
     * @param phenotypeName
     * @return
     */
    public PropertyValue getPropertyValueFromCollection(String propertyName, String sampleGroupName, String phenotypeName);

    public int getPosition();

    public void setPosition(int position);

    public String getReferenceAllele();

    public void setReferenceAllele(String referenceAllele);

    public String getAlternateAllele();

    public void setAlternateAllele(String alternateAllele);

    public void setChromosome(String chromosome);
}
