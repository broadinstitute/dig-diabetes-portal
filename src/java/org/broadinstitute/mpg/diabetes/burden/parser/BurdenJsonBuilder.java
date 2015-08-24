package org.broadinstitute.mpg.diabetes.burden.parser;

import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mduby on 8/21/15.
 */
public class BurdenJsonBuilder {
    // singleton instance
    private static BurdenJsonBuilder burdenJsonBuilder;


    /**
     * singleton getter
     *
     * @return
     */
    public static BurdenJsonBuilder getBurdenJsonBuilder() {
        if (burdenJsonBuilder == null) {
            burdenJsonBuilder = new BurdenJsonBuilder();
        }

        return burdenJsonBuilder;
    }

    /**
     * returns a json object to use for a json burden port request object
     *
     * @param variantList               the variants to include; if null or empty, exception is thrown
     * @param covariatesList            the list of covariates; if null or empty, include first 10
     * @return
     * @throws PortalException
     */
    public JSONObject getBurdenPostJson(List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        JSONObject finalObject;

        // create the json object
        try {
            finalObject = new JSONObject(this.getBurdenPostJsonString(variantList, covariatesList));
        } catch (JSONException exception) {
            throw new PortalException(("got json creation exception for burden test payload geneeration: " + exception.getMessage()));
        }

        // return
        return finalObject;
    }

    /**
     * returns a string from which to build a json burden port request object
     *
     * @param variantList               the variants to include; if null or empty, exception is thrown
     * @param covariatesList            the list of covariates; if null or empty, include first 10
     * @return
     * @throws PortalException
     */
    public String getBurdenPostJsonString(List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        String finalString;
        StringBuilder stringBuilder = new StringBuilder();

        // create the variant list json object string
        stringBuilder.append("{\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_VARIANTS_KEY);
        stringBuilder.append("\" : [");
        if (variantList == null) {
            throw new PortalException("Got null variant list for the burden test");
        } else if (variantList.size() == 0) {
                throw new PortalException("Got empty variant list for the burden test");
        } else {
            for (int i = 0; i < variantList.size(); i++) {
                stringBuilder.append("\"" + variantList.get(i) + "\"");
                if (i < variantList.size() - 1) {
                    stringBuilder.append(",");
                }
            }
        }
        stringBuilder.append("],");

        // create the covariates list json object string
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_COVARIATES_KEY);
        stringBuilder.append("\" : [");
        if ((covariatesList == null) || (covariatesList.size() == 0)) {
            for (int i = 1; i < 11; i++) {
                stringBuilder.append("\"C" + i + "\"");
                if (i < 10) {
                    stringBuilder.append(",");
                }
            }
        }
        stringBuilder.append("]}");

        // create the filters list object string
        // TODO - no filters for DIGP-42 09/13/15 deadline

        // return
        return stringBuilder.toString();
    }

    /**
     * return a bruce force constrcuted string for the getData query to return all variants for a gene with a certain most del score
     *
     * @param geneString
     * @param mostDelScore
     * @return
     * @throws PortalException
     */
    public String getKnowledgeBaseQueryPayloadForVariantSearch(String sampleGroup, String geneString, int mostDelScore) throws PortalException {
        // local variables
        StringBuilder stringBuilder = new StringBuilder();

        // build the header of the search query
        stringBuilder.append("{\"passback\": \"123abc\", \"entity\": \"variant\", \"page_number\": 0, \"page_size\": 100, \"limit\": 1000, \"count\": false,");

        // add in the properties
       stringBuilder.append("\"properties\": { \"cproperty\": [\"VAR_ID\"], \"orderBy\": [\"CHROM\"], \"dproperty\": {}, \"pproperty\": {}},");

        // add in the filters
        // phenotype filter
        stringBuilder.append("\"filters\": [{\"dataset_id\": \"");
        stringBuilder.append(sampleGroup);
        stringBuilder.append("\", \"phenotype\": \"T2D\", \"operand\": \"P_FIRTH_FE_IV\", \"operator\": \"LTE\", \"value\": 0.05, \"operand_type\": \"FLOAT\"},");

        // gene filter
        stringBuilder.append("{\"dataset_id\": \"blah\", \"phenotype\": \"blah\", \"operand\": \"GENE\", \"operator\": \"EQ\", \"value\": \"");
        stringBuilder.append(geneString);
        stringBuilder.append("\", \"operand_type\": \"STRING\"},");

        // most del score filter
        stringBuilder.append("{\"dataset_id\": \"blah\", \"phenotype\": \"blah\", \"operand\": \"MOST_DEL_SCORE\", \"operator\": \"LT\", \"value\": ");
        stringBuilder.append(mostDelScore);
        stringBuilder.append(", \"operand_type\": \"FLOAT\"}]}");

        // return
        return stringBuilder.toString();
    }

    /**
     * get the variant list from the getData variant search json result
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    public List<String> getVariantListFromJson(JSONObject jsonObject) throws PortalException {
        // local variables
        List<String> variantList = new ArrayList<String>();
        JSONObject tempObject;
        JSONArray tempArray, tempArray2;
        String varId;

        // get the variants object
        if (jsonObject != null) {
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_VARIANTS_KEY);

            // get the array under the variants object
            if ((tempArray != null) && (tempArray.size() > 0)) {
                for (int i = 0; i < tempArray.size(); i++) {
                    tempArray2 = (JSONArray)tempArray.get(i);
                    if ((tempArray2 != null) && (tempArray2.size() > 0)) {
                        tempObject = (JSONObject) tempArray2.get(0);

                        // get the var_id
                        varId = tempObject.getString(PortalConstants.JSON_VARIANT_ID_KEY);
                        variantList.add(varId);
                    }
                }
            } else {
                throw new PortalException("got no variants json object for burden test variant list building");
            }
        } else {
            throw new PortalException("got null json object for burden test variant list building");
        }

        // return the list
        return variantList;
    }
}
