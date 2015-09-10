package org.broadinstitute.mpg.diabetes.burden.parser;

import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.VariantBean;
import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery;
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryBean;
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter;
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilterBean;
import org.broadinstitute.mpg.diabetes.metadata.query.QueryJsonBuilder;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public JSONObject getBurdenPostJson(String dataset, List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        JSONObject finalObject;

        // create the json object
        try {
            finalObject = new JSONObject(this.getBurdenPostJsonString(dataset, variantList, covariatesList));

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
    public String getBurdenPostJsonString(String dataset, List<String> variantList, List<String> covariatesList) throws PortalException {
        // local variables
        String finalString;
        StringBuilder stringBuilder = new StringBuilder();

        // open the json object
        stringBuilder.append("{");

        // add in the dataset/study key
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_DATASET_KEY);
        stringBuilder.append("\": \"");
        stringBuilder.append(dataset);
        stringBuilder.append("\", ");

        // create the variant list json object string
        stringBuilder.append("\"");
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
     * return a bruce force constructed string for the getData query to return all variants for a gene with a certain most del score
     *
     * @param geneString
     * @param mostDelScore
     * @return
     * @throws PortalException
     */
    public String getKnowledgeBaseQueryPayloadForVariantSearch(String geneString, String mostDelScoreOperand, int mostDelScore, List<QueryFilter> additionalFilterList) throws PortalException {
        // local variables
        String jsonString = "";
        JsonParser parser = JsonParser.getService();
        QueryJsonBuilder jsonBuilder = new QueryJsonBuilder();

        // build the metadata query object
        GetDataQuery query = new GetDataQueryBean();

        // add in the query properties
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POLYPHEN_PRED));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_SIFT_PRED));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MOST_DEL_SCORE));

        // add in the filters
        query.addFilterProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_GENE), PortalConstants.OPERATOR_EQUALS, geneString);
        query.addFilterProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MOST_DEL_SCORE), mostDelScoreOperand, String.valueOf(mostDelScore));

        // add in any extra filters given
        for (QueryFilter filter: additionalFilterList) {
            query.addQueryFilter(filter);
        }

        // get the payload string
        jsonString = jsonBuilder.getQueryJsonPayloadString(query);

        // return
        return jsonString;

        /*
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
        */
    }

    /**
     * get the variant list from the getData variant search json result
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    public List<Variant> getVariantListFromJson(JSONObject jsonObject) throws PortalException {
        // local variables
        List<Variant> variantList = new ArrayList<Variant>();
        JSONObject tempObject;
        JSONArray tempArray, tempArray2;

        // get the variants object
        if (jsonObject != null) {
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_VARIANTS_KEY);

            // get the array under the variants object
            if ((tempArray != null) && (tempArray.size() > 0)) {
                for (int i = 0; i < tempArray.size(); i++) {
                    tempArray2 = (JSONArray)tempArray.get(i);
                    VariantBean variant = new VariantBean();
                    Map<String, Object> map = this.getHashMapOfJsonArray(tempArray2);
                    variant.setVariantId((String)map.get(PortalConstants.JSON_VARIANT_ID_KEY));
                    variant.setChromosome((String) map.get(PortalConstants.JSON_VARIANT_CHROMOSOME_KEY));
                    variant.setPolyphenPredictor((String) map.get(PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY));
                    variant.setSiftPredictor((String) map.get(PortalConstants.JSON_VARIANT_SIFT_PRED_KEY));
                    variant.setMostDelScore((Integer)map.get(PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY));
                    variantList.add(variant);
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

    /**
     * read in the json array of key/value pairs
     *
     * @param jsonArray
     * @return
     */
    protected Map<String, Object> getHashMapOfJsonArray(JSONArray jsonArray) {
        // local variables
        Map<String, Object> map = new HashMap<String, Object>();

        // loop through the array and put the values in a hash map
        if (jsonArray != null) {
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String key = (String)jsonObject.keySet().iterator().next();
                if (!jsonObject.isNull(key)) {
                    map.put(key, jsonObject.get(key));
                }
            }
        }

        return map;
    }

    /**
     * builds a list of minor allele frequency filters as required by the inputs given
     *
     * @param samplegGroupId
     * @param mafSampleGroupOption
     * @param mafValue
     * @return
     * @throws PortalException
     */
    protected List<QueryFilter> getMinorAlleleFrequencyFilters(int samplegGroupId, int mafSampleGroupOption, Float mafValue) throws PortalException {
        // local variables
        List<QueryFilter> queryFilterList = new ArrayList<QueryFilter>();
        List<DataSet> dataSetList = new ArrayList<DataSet>();
        DataSet rootDataSet = null;
        JsonParser parser = JsonParser.getService();
        List<Property> propertyList = new ArrayList<Property>();

        // if mafValue not null, then look at mafSampleGroupOption
        if (mafValue != null) {
            // get root data set
            if (samplegGroupId == PortalConstants.BURDEN_DATASET_OPTION_ID_13K) {
                rootDataSet = parser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_13k_ID);
            } else {
                rootDataSet = parser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_26k_ID);
            }

            // populate the sample group list
            if (mafSampleGroupOption == PortalConstants.BURDEN_MAF_OPTION_ID_ANCESTRY) {
                // if ancestry, get the list of child sample groups
                dataSetList = parser.getImmediateChildrenOfType(rootDataSet, PortalConstants.TYPE_SAMPLE_GROUP_KEY);

            } else {
                // if not ancestry, then only specified root sample group
                dataSetList.add(rootDataSet);
            }

            // for all sample groups in the list, find their MAF property and add it to the list
            for (DataSet sampleGroup: dataSetList) {
                List<DataSet> childPropertyList = parser.getImmediateChildrenOfType(sampleGroup, PortalConstants.TYPE_PROPERTY_KEY);

                // get MAF property
                for (DataSet property: childPropertyList) {
                    if (property.getName().equalsIgnoreCase("MAF")) {
                        propertyList.add((Property)property);
                    }
                }
            }

            // for all properties, add a new filter
            for (Property property: propertyList) {
                queryFilterList.add(new QueryFilterBean(property, PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS, mafValue.toString()));
            }

            // return
            return queryFilterList;
        }


        // return
        return queryFilterList;
    }

}
