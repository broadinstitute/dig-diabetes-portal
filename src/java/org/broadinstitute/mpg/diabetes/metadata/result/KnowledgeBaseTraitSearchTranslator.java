package org.broadinstitute.mpg.diabetes.metadata.result;

import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValue;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.List;

/**
 * Concrete class to translate from the new getData result API to the old trait-search result API
 *
 */
public class KnowledgeBaseTraitSearchTranslator implements KnowledgeBaseResultTranslator {
    // constants
    private final String KEY_VAR_ID         = "VAR_ID";
    private final String KEY_ID             = "ID";
    private final String KEY_BETA           = "BETA";
    private final String KEY_ZSCORE         = "ZSCORE";
    private final String KEY_P_VALUE        = "P_VALUE";
    private final String KEY_PVALUE         = "PVALUE";
    private final String KEY_ODDS_RATIO     = "ODDS_RATIO";
    private final String KEY_EFFECT_ALLELE  = "EFFECT_ALLELE";
    private final String KEY_OTHER_ALLELE   = "OTHER_ALLELE";
    private final String KEY_DIR            = "DIR";

    /**
     * translate getData result into trait-search expected result format
     *
     * @param variantList
     * @return
     */
    public JSONObject translate(List<Variant> variantList) throws PortalException {
        // local variables
        JSONArray jsonArray = null;
        JSONObject rootObject = new JSONObject();
        JSONObject tempObject = null;

        // create a variants array and add it to root
        jsonArray = new JSONArray();
        rootObject.put(PortalConstants.JSON_VARIANTS_KEY, jsonArray);

        // for each row, add in a json object with property key/value pairs and add it to the json array
        for (Variant variant: variantList) {
            tempObject = this.getTraitSearchJsonObject(variant);
            if (tempObject != null) {
                jsonArray.add(tempObject);
            }
        }

        // if got here, no error, so indicate
        rootObject.put(PortalConstants.JSON_ERROR_KEY, false);

        // add in the number of records
        rootObject.put(PortalConstants.JSON_NUMBER_RECORDS_KEY, variantList.size());

        // return
        return rootObject;
    }

    /**
     * translate a getData variant result into the trait-search result API type; return null object if the getData result does not conform to the tait-search data rules
     * <br/>
     * ex: null returned if DIR is null or 0
     *
     * @param variant
     * @return
     * @throws PortalException
     */
    protected JSONObject getTraitSearchJsonObject(Variant variant) throws PortalException {
        // local variables
        JSONObject jsonObject = new JSONObject();
        String tempPropertyValue = null;

        // for each property, add in a key/value property to the json object
        for (PropertyValue propertyValue: variant.getPropertyValues()) {
            // translate null text value to null json value
            if ((propertyValue.getValue() != null) && (!"null".equals(propertyValue.getValue()))) {
                tempPropertyValue = propertyValue.getValue();
            } else {
                tempPropertyValue = null;
            }

            // now cast based on property type
            if (propertyValue.getProperty().getVariableType().equals(PortalConstants.OPERATOR_TYPE_FLOAT)) {
                try {
                    jsonObject.put(propertyValue.getProperty().getName(), (tempPropertyValue == null ? JSONObject.NULL : Float.valueOf(tempPropertyValue).floatValue()));

                    if (propertyValue.getProperty().getName().equals(this.KEY_P_VALUE)) {
                        // add in translated key value for trait-search emulation
                        jsonObject.put(this.KEY_PVALUE, (tempPropertyValue == null ? JSONObject.NULL : Float.valueOf(tempPropertyValue).floatValue()));
                    }

                } catch (NumberFormatException exception) {
                    jsonObject.put(propertyValue.getProperty().getName(), JSONObject.NULL);
                }

            } else if (propertyValue.getProperty().getVariableType().equals(PortalConstants.OPERATOR_TYPE_INTEGER)) {
                    // if DIR property and is null or 0, return null object
                    if (this.KEY_DIR.equals(propertyValue.getProperty().getName())) {
                        try {
                            if (tempPropertyValue == null) {
                                return null;
                            } else if (Integer.valueOf(tempPropertyValue).intValue() == 0) {
                                jsonObject.put(this.KEY_DIR, JSONObject.NULL);
                            } else if (Integer.valueOf(tempPropertyValue).intValue() > 0) {
                                jsonObject.put(this.KEY_DIR, "up");
                            } else {
                                jsonObject.put(this.KEY_DIR, "down");
                            }

                        } catch (NumberFormatException exception) {
                            return null;
                        }

                    } else {
                        // all other integer property types that are not DIR
                        try {
                            jsonObject.put(propertyValue.getProperty().getName(), (tempPropertyValue == null ? JSONObject.NULL : Integer.valueOf(tempPropertyValue).intValue()));
                        } catch (NumberFormatException exception) {
                            jsonObject.put(propertyValue.getProperty().getName(), JSONObject.NULL);
                        }
                    }


            } else if (propertyValue.getProperty().getVariableType().equals(PortalConstants.OPERATOR_TYPE_STRING)) {
                jsonObject.put(propertyValue.getProperty().getName(), tempPropertyValue);

                if (propertyValue.getProperty().getName().equals(this.KEY_VAR_ID)) {
                    // add in translated key value for trait-search emulation
                    jsonObject.put(this.KEY_ID, tempPropertyValue);
                }

            } else {
                throw new PortalException("Got property value with incorrect property value type: " + propertyValue.getProperty().getVariableType());
            }

            // if the property is a phenotype property, then also add in the phenotype name as well as a 'trait'
            if (propertyValue.getProperty().getPropertyType().equals(PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY)) {
                Phenotype phenotype = (Phenotype)propertyValue.getProperty().getParent();
                jsonObject.put(PortalConstants.KEY_PHENOTYPE_FOR_TRAIT_SEARCH, phenotype.getName());
            }

            // add in a few 0 keys that are not covered in getData
            jsonObject.put(this.KEY_BETA, 0);
            jsonObject.put(this.KEY_ZSCORE, 0);
            jsonObject.put(this.KEY_EFFECT_ALLELE, JSONObject.NULL);
            jsonObject.put(this.KEY_OTHER_ALLELE, JSONObject.NULL);

            // add in odds ratio if it doens't exist
            if (!jsonObject.has(this.KEY_ODDS_RATIO)) {
                jsonObject.put(this.KEY_ODDS_RATIO, JSONObject.NULL);
            }
        }

        // return
        return jsonObject;
    }
}
