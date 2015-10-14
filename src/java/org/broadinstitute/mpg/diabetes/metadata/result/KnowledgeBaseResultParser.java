package org.broadinstitute.mpg.diabetes.metadata.result;

import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValue;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValueBean;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.VariantBean;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Class to parse getData variant array results into object form
 *
 */
public class KnowledgeBaseResultParser {
    // instance variables
    String jsonString;
    JsonParser jsonParser = JsonParser.getService();

    public KnowledgeBaseResultParser(String jsonString) {
        this.jsonString = jsonString;
    }

    /**
     * parse the json string and return the variant list
     *
     * @return
     * @throws PortalException
     */
    public List<Variant> parseResult() throws PortalException {
        // local variables
        Integer recordCountIndicated = null;
        String tempString = null;
        JSONObject jsonObject;
        JSONArray jsonArray;
        List<Variant> variantList = new ArrayList<Variant>();

        if (this.jsonString != null) {
            // get the json object
            jsonObject = new JSONObject(this.jsonString);

            // get the property count given
            tempString = jsonObject.getString(PortalConstants.JSON_NUMBER_RECORDS_KEY);
            recordCountIndicated = Integer.parseInt(tempString);

            // get the property json array
            jsonArray = jsonObject.getJSONArray(PortalConstants.JSON_VARIANTS_KEY);

            // the variants json array is a series of json object arrays
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONArray tempArray = jsonArray.getJSONArray(i);

                // create variant
                Variant variant = new VariantBean();

                // parse
                variant.addAllToPropertyValues(this.parsePropertyValues(tempArray));

                // add variant to the list
                variantList.add(variant);
            }
        } else {
            throw new PortalException("Got null getData string to parse");
        }

        // return
        return variantList;
    }

    /**
     * parse the json array of json objects comprising one variant result entity
     *
     * @param jsonArray
     * @return
     * @throws PortalException
     */
    protected List<PropertyValue> parsePropertyValues(JSONArray jsonArray) throws PortalException {
        // local variables
        List<PropertyValue> propertyValueList = new ArrayList<PropertyValue>();
        PropertyValue propertyValue = null;
        JSONObject jsonObject = null;

        // parse the array
        for (int i = 0; i < jsonArray.length(); i++) {
            jsonObject = jsonArray.getJSONObject(i);
            propertyValue = this.parseProperty(jsonObject);
            propertyValueList.add(propertyValue);
        }

        // return
        return propertyValueList;
    }

    /**
     * parse the json object comprising one property value result
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    protected PropertyValue parseProperty(JSONObject jsonObject) throws PortalException {
        // local variables
        PropertyValue propertyValue = null;
        String propertyName = null;
        String sampleGroupName = null;
        String phenotypeName = null;
        String value = null;
        String tempString = null;
        JSONObject tempObject = null;
        Property property = null;

        // the property name is the key
        Iterator<String> keyIterator = jsonObject.keys();
        propertyName = keyIterator.next();

        // if transcript annotation, do not parse (too complicated)
        if (PortalConstants.NAME_PHENOTYPE_PROPERTY_TRANSCRIPT_ANNOT.equals(propertyName)) {
            value = jsonObject.get (propertyName).toString();
            property = this.jsonParser.findCommonPropertyWithName(PortalConstants.NAME_PHENOTYPE_PROPERTY_TRANSCRIPT_ANNOT);

        } else {
            // now find out if is is a complex object
            try {
                tempObject = jsonObject.getJSONObject(propertyName);

            } catch (JSONException exception) {
                // do nothing, not a key/value object
            }

            // if temp object is still null, then the value is a string
            if (tempObject == null) {
                tempString = jsonObject.getString(propertyName);
                value = tempString;

            } else  {
                // try again to see if the object is more complex than a sample group property
                // key of new object will be sample group
                keyIterator = tempObject.keys();
                sampleGroupName = keyIterator.next();
                JSONObject tempObject2 = null;

                // if this sub object is simple key value pair, then only sample group property
                try {
                    tempObject2 = tempObject.getJSONObject(sampleGroupName);

                } catch (JSONException exception) {
                    // do nothing, not a key/value object
                }

                // if string still null, then it is a sample group property
                if (tempObject2 == null) {
                    tempString = tempObject.getString(sampleGroupName);
                    value = tempString;

                } else {
                    // this time, should be simple key/value pair
                    // key of new object will be phenotype
                    keyIterator = tempObject2.keys();
                    phenotypeName = keyIterator.next();
                    value = tempObject2.getString(phenotypeName);
                }
            }

            // get the property from the parser
            property = this.jsonParser.getPropertyGivenItsAndPhenotypeAndSampleGroupNames(propertyName, phenotypeName, sampleGroupName);
        }

        // create property value
        propertyValue = new PropertyValueBean(property, value);

        // return
        return propertyValue;
    }

}
