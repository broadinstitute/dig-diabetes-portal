package org.broadinstitute.mpg.diabetes.burden.parser;

import com.google.gson.JsonObject;
import org.broadinstitute.mpg.diabetes.MetaDataService;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.PropertyValueBean;
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
    public JSONObject getBurdenPostJson(String stringDataVersion, String phenotype, List<String> variantList, List<String> covariatesList,
                                        List<String> sampleList, String filters, String dataSet) throws PortalException {
        // local variables
        JSONObject finalObject;

        // create the json object
        try {
            finalObject = new JSONObject(this.getBurdenPostJsonString( stringDataVersion, phenotype, variantList, covariatesList,  sampleList, filters, dataSet));

        } catch (JSONException exception) {
            throw new PortalException(("got json creation exception for burden test payload generation: " + exception.getMessage()));
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
    public String getBurdenPostJsonString(String stringDataVersion , String phenotype, List<String> variantList, List<String> covariatesList,
                                          List<String> sampleList, String filters, String dataSet) throws PortalException {
        // local variables
        String finalString;
        StringBuilder stringBuilder = new StringBuilder();

        // open the json object
        stringBuilder.append("{");

        // add in the data version
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_DATA_VERSION_KEY);
        stringBuilder.append("\": \"");
        stringBuilder.append(stringDataVersion);
        stringBuilder.append("\", ");

        if (dataSet!= null) {
            stringBuilder.append("\"");
            stringBuilder.append(PortalConstants.JSON_BURDEN_DATASET_ID_KEY);
            stringBuilder.append("\": \"");
            stringBuilder.append(dataSet);
            stringBuilder.append("\", ");
        }

        // add in the phenotype
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_PHENOTYPE_KEY);
        stringBuilder.append("\": \"");
        stringBuilder.append(phenotype);
        stringBuilder.append("\", ");

        // add in the confidence interval calculation boolean
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_CI_CALC_KEY);
        stringBuilder.append("\": ");
        stringBuilder.append(true);
        stringBuilder.append(", ");

        // add in the confidence interval setting
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_CI_LEVEL_KEY);
        stringBuilder.append("\": ");
        stringBuilder.append(0.95);
        stringBuilder.append(", ");

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
        stringBuilder.append(PortalConstants.JSON_BURDEN_SAMPLES_KEY);
        stringBuilder.append("\" : [");
        if (sampleList == null) {
            throw new PortalException("Got null sampleList  for the burden test");
        } else {
            for (int i = 0; i < sampleList.size(); i++) {
                stringBuilder.append("\"" + sampleList.get(i) + "\"");
                if (i < sampleList.size() - 1) {
                    stringBuilder.append(",");
                }
            }
        }
        stringBuilder.append("],");

        // create the covariates list json object string
        stringBuilder.append("\"");
        stringBuilder.append(PortalConstants.JSON_BURDEN_COVARIATES_KEY);
        stringBuilder.append("\" : [");
        if (covariatesList != null)  {
            for (int i = 0; i < covariatesList.size(); i++) {
                stringBuilder.append("\"" + covariatesList.get(i) + "\"");
                if (i < covariatesList.size()-1) {
                    stringBuilder.append(",");
                }
            }
        }

        stringBuilder.append("],");
        stringBuilder.append(filters);
        stringBuilder.append("}");

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
    public String getKnowledgeBaseQueryPayloadForVariantSearch(String geneString, String mostDelScoreOperand, int mostDelScore, List<QueryFilter> additionalFilterList, List<Property> additionalProperties) throws PortalException {
        // local variables
        String jsonString = "";
        JsonParser parser = JsonParser.getService();
        QueryJsonBuilder jsonBuilder = new QueryJsonBuilder();

        // build the metadata query object
        GetDataQuery query = new GetDataQueryBean();

        // add in the query properties
        Property tproperty;
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_DBSNP_ID));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MOST_DEL_SCORE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CLOSEST_GENE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CONSEQUENCE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_REFERENCE_ALLELE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_PROTEIN_CHANGE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_EFFECT_ALLELE));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POLYPHEN_PRED));
        query.addQueryProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_SIFT_PRED));
        tproperty = (Property) parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MUTATION_TASTER_PRED );
        if (tproperty != null) {query.addQueryProperty(tproperty);}
        tproperty = (Property) parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_LRT_PRED );
        if (tproperty != null) {query.addQueryProperty(tproperty);}
        tproperty = (Property) parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POLYPHEN2_HVAR_PRED );
        if (tproperty != null) {query.addQueryProperty(tproperty);}
        tproperty = (Property) parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POLYPHEN2_HDIV_PRED );
        if (tproperty != null) {query.addQueryProperty(tproperty);}

        // add minor allele count if it exists for this data set
        if (additionalProperties != null){
            for (Property property: additionalProperties){
                query.addQueryProperty(property);
            }
        }

        // add in the filters
        query.addFilterProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_GENE), PortalConstants.OPERATOR_EQUALS, geneString);
        query.addFilterProperty((Property)parser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MOST_DEL_SCORE), mostDelScoreOperand, String.valueOf(mostDelScore));

        // add in any extra filters given
        for (QueryFilter filter: additionalFilterList) {
            query.addQueryFilter(filter);
        }

        // get the payload string
        query.setPageSize(1000);
        query.setLimit(1000);
        jsonString = jsonBuilder.getQueryJsonPayloadString(query);

        // return
        return jsonString;

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
                    if (map.get("MAF") != null) {
                        JSONObject jsonObject1 = (JSONObject) map.get("MAF");

                        String key = (String)jsonObject1.keySet().iterator().next();
                        if (!jsonObject1.isNull(key)) {
                            Double mafValue = (Double)jsonObject1.get(key);
                            variant.setMaf(mafValue.floatValue() );
                        }
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY) == null) {
                        variant.setPolyphenPredictor((String)"");
                    }else{
                        variant.setPolyphenPredictor((String) map.get(PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY));
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_SIFT_PRED_KEY) == null) {
                        variant.setSiftPredictor((String)"");
                    }else{
                        variant.setSiftPredictor((String) map.get(PortalConstants.JSON_VARIANT_SIFT_PRED_KEY));
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_POLYPHEN2_HDIV_PRED_KEY) == null) {
                        variant.setPolyphenHdivPredictor((String)"");
                    }else{
                        variant.setPolyphenHdivPredictor((String) map.get(PortalConstants.JSON_VARIANT_POLYPHEN2_HDIV_PRED_KEY));
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_POLYPHEN2_HVAR_PRED_KEY) == null) {
                        variant.setPolyphenHvarPredictor((String)"");
                    }else{
                        variant.setPolyphenHvarPredictor((String) map.get(PortalConstants.JSON_VARIANT_POLYPHEN2_HVAR_PRED_KEY));
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_MUTATION_TASTER_PRED_KEY) == null) {
                        variant.setMutationTasterPredictor((String)"");
                    }else{
                        variant.setMutationTasterPredictor((String) map.get(PortalConstants.JSON_VARIANT_MUTATION_TASTER_PRED_KEY));
                    }
                    if (map.get(PortalConstants.JSON_VARIANT_LRT_PRED_KEY) == null) {
                        variant.setLrtPredictor((String)"");
                    }else{
                        variant.setLrtPredictor((String) map.get(PortalConstants.JSON_VARIANT_LRT_PRED_KEY));
                    }
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







    protected List<QueryFilter> getMinorAlleleFrequencyFiltersByString(String versionString, int mafSampleGroupOption, Float mafValue, String dataSet, MetaDataService metaDataService) throws PortalException {
        // local variables
        List<QueryFilter> queryFilterList = new ArrayList<QueryFilter>();
        List<DataSet> dataSetList = new ArrayList<DataSet>();
        DataSet rootDataSet = null;
        JsonParser parser = JsonParser.getService();
        List<Property> propertyList = new ArrayList<Property>();
        Property rootProperty = null;
        Boolean unexpectedData = false;

        // get root data set.  We need to get this from the metadata, but we will use a workaround for now.
//        if (("mdv2".equals("mdv2"))||
//                (versionString.equals("mdv21") )||
//                (versionString.equals("mdv22") )||
//                (versionString.equals("mdv23") )) {
//            rootDataSet = metaDataService.getSampleGroupByName("ExSeq_17k_" + versionString );
//        }
        rootDataSet = metaDataService.getSampleGroupByName( dataSet );

        // always add a check that MAF is greater than 0 for the root data set specified to make sure we are not pulling variants that do not occur
        try {
            rootProperty = parser.getExpectedUniquePropertyFromSampleGroup("MAF", rootDataSet);
            queryFilterList.add(new QueryFilterBean(rootProperty, PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS, "0.0"));
        } catch (PortalException e) {
            unexpectedData = true;
        }


        // if mafValue not null, then look at mafSampleGroupOption
        if ((!unexpectedData)&&(mafValue != null)) {
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
                propertyList.add(parser.getExpectedUniquePropertyFromSampleGroup("MAF", sampleGroup));
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
        Property rootProperty = null;
        Boolean unexpectedData = false;

        // get root data set.  We need to get this from the metadata, but we will use a workaround for now.
        if (samplegGroupId == PortalConstants.BURDEN_DATASET_OPTION_ID_13K) {
            rootDataSet = parser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_13k_ID);
        } else if (samplegGroupId == PortalConstants.BURDEN_DATASET_OPTION_ID_17K) {
            rootDataSet = parser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_17k_ID);
        } else {
            rootDataSet = parser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_26k_ID);
            unexpectedData = true;
        }

        // always add a check that MAF is greater than 0 for the root data set specified to make sure we are not pulling variants that do not occur
        try {
            rootProperty = parser.getExpectedUniquePropertyFromSampleGroup("MAF", rootDataSet);
            queryFilterList.add(new QueryFilterBean(rootProperty, PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS, "0.0"));
        } catch (PortalException e) {
            unexpectedData = true;
        }


        // if mafValue not null, then look at mafSampleGroupOption
        if ((!unexpectedData)&&(mafValue != null)) {
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
                propertyList.add(parser.getExpectedUniquePropertyFromSampleGroup("MAF", sampleGroup));
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



    public List<QueryFilter> getPValueFilters(String sampleGroupName,  Float pValue, String phenotypeName, String pValueName ) throws PortalException {
        List<QueryFilter> queryFilterList = new ArrayList<QueryFilter>();
        JsonParser parser = JsonParser.getService();

        Property rootProperty =  parser.getPropertyGivenItsAndPhenotypeAndSampleGroupNames(pValueName, phenotypeName, sampleGroupName);
        queryFilterList.add(new QueryFilterBean(rootProperty, PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS, pValue.toString()));

        return queryFilterList;
    }







}
