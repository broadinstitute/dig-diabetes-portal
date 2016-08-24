package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Created by mduby on 9/7/15.
 */
public class JsNamingQueryTranslator {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();

    // constants
    public final static String QUERY_DELIMITER_STRING                 = "^";
    public final static String QUERY_NUMBER_DELIMITER_STRING          = "=";

    public final static String QUERY_OPERATOR_EQUALS_STRING               = "|";
    public final static String QUERY_OPERATOR_MORE_THAN_STRING            = ">";
    public final static String QUERY_OPERATOR_LESS_THAN_STRING            = "<";

    public final static String QUERY_SAMPLE_GROUP_BEGIN_STRING            = "\\[";
    public final static String QUERY_SAMPLE_GROUP_AND_STRING            = "\\]";

    public final static String QUERY_GENE_LINE_NUMBER                             = "7";
    public final static String QUERY_CHROMOSOME_LINE_NUMBER                       = "8";
    public final static String QUERY_START_POSITION_LINE_NUMBER                   = "9";
    public final static String QUERY_END_POSITION_LINE_NUMBER                     = "10";
    public final static String QUERY_PROTEIN_EFFECT_LINE_NUMBER                   = "11";
    public final static String QUERY_PROPERTY_FILTER_LINE_NUMBER                  = "17";




    public static String determineOperatorSplitCharacter(String holdingString) throws PortalException {
        String operatorSplitCharacter="";
        if (holdingString.contains(QUERY_OPERATOR_EQUALS_STRING)) {
            operatorSplitCharacter = Pattern.quote(QUERY_OPERATOR_EQUALS_STRING);      // '|' string is special regexp string

        } else if (holdingString.contains(QUERY_OPERATOR_LESS_THAN_STRING)) {
            operatorSplitCharacter = QUERY_OPERATOR_LESS_THAN_STRING;

        } else if (holdingString.contains(QUERY_OPERATOR_MORE_THAN_STRING)) {
            operatorSplitCharacter = QUERY_OPERATOR_MORE_THAN_STRING;

        } else {
            throw new PortalException("did not find expected operator in query string: " + holdingString);
        }
        return operatorSplitCharacter;
    }



    public static  String convertSymbolicOperatorToString(String symbolicOperator) throws PortalException{
        String operator="";
        if (Pattern.quote(QUERY_OPERATOR_EQUALS_STRING).equals(symbolicOperator)) {
            operator = PortalConstants.OPERATOR_EQUALS;
        } else if (QUERY_OPERATOR_LESS_THAN_STRING.equals(symbolicOperator)) {
            operator = PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS;
        } else if (QUERY_OPERATOR_MORE_THAN_STRING.equals(symbolicOperator)) {
            operator = PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS;
       } else {
            throw new PortalException("Got unsupported operator in query string: " + symbolicOperator);
        }
       return operator;
    }


    private String convertStringOperatorToSymbol(String stringOperator) throws PortalException{
        String operator="";
        if (PortalConstants.OPERATOR_EQUALS.equals(stringOperator)) {
            operator = this.QUERY_OPERATOR_EQUALS_STRING;
        } else if (PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS.equals(stringOperator)) {
            operator = this.QUERY_OPERATOR_LESS_THAN_STRING;
        } else if (PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS.equals(stringOperator)) {
            operator = this.QUERY_OPERATOR_MORE_THAN_STRING;
        } else {
            throw new PortalException("Got unsupported string operator : " + stringOperator);
        }
        return operator;
    }







    public String encodeFilters(QueryFilter queryFilter)  throws PortalException {
        String returnValue = "";
        // cProperties are a little simpler, while pProps and dProps require an extra step
        Property property = queryFilter.getProperty();
        String value = queryFilter.getValue();
        String operator = queryFilter.getOperator();
        if (property.getParent().getParent()==null) { // cprop
            if (PortalConstants.PROPERTY_KEY_COMMON_GENE.equals(property.getId())){ // gene specifier
                returnValue =  QUERY_GENE_LINE_NUMBER+
                               QUERY_NUMBER_DELIMITER_STRING+
                               value;
            } else if (PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME.equals(property.getId())){ // chromosome specifier
                returnValue =  QUERY_CHROMOSOME_LINE_NUMBER+
                        QUERY_NUMBER_DELIMITER_STRING+
                        value;
            } else if (PortalConstants.PROPERTY_KEY_COMMON_POSITION.equals(property.getId())){ // one of the two position specifiers
                if ((PortalConstants.OPERATOR_LESS_THAN_EQUALS.equals(operator)) ||
                        (PortalConstants.OPERATOR_LESS_THAN_EQUALS.equals(operator))) {
                    returnValue = QUERY_END_POSITION_LINE_NUMBER +
                            QUERY_NUMBER_DELIMITER_STRING +
                            value;
                } else {
                    returnValue = QUERY_START_POSITION_LINE_NUMBER +
                            QUERY_NUMBER_DELIMITER_STRING +
                            value;

                }
            } else { // everything else is marked as a type 11
                returnValue =  QUERY_PROTEIN_EFFECT_LINE_NUMBER +
                        QUERY_NUMBER_DELIMITER_STRING+
                        property.getName()+
                        convertStringOperatorToSymbol(operator)+
                        value;
            }
        } else {
            String identifyParentType = property.getParent().getClass().getName(); // parent dependent on pProp vs dProp
            if (identifyParentType.contains("SampleGroupBean")){ // we have a dProp
                SampleGroupBean sampleGroupBean =  (SampleGroupBean) property.getParent();
                String systemId = sampleGroupBean.getSystemId();
                String requestedPhenotype = queryFilter.getRequestedPhenotype();
                if ((requestedPhenotype !=  null ) && (requestedPhenotype.length() > 0)) {
                    returnValue = QUERY_PROPERTY_FILTER_LINE_NUMBER +
                            QUERY_NUMBER_DELIMITER_STRING +
                            requestedPhenotype + "[" +
                            systemId + "]" +
                            property.getName() +
                            convertStringOperatorToSymbol(operator) +
                            value;
                } else {
                    returnValue =  QUERY_PROPERTY_FILTER_LINE_NUMBER+
                            QUERY_NUMBER_DELIMITER_STRING+
                            "T2D"+"["+                 // default phenotype-- this should never be used, I think
                            systemId+"]"+
                            property.getName()+
                            convertStringOperatorToSymbol(operator)+
                            value;
                }

            } else { // pProp
                PhenotypeBean phenotypeBean = (PhenotypeBean) property.getParent();
                SampleGroupBean sampleGroupBean = (SampleGroupBean) property.getParent().getParent();
                String systemId = sampleGroupBean.getSystemId();
                returnValue =  QUERY_PROPERTY_FILTER_LINE_NUMBER+
                        QUERY_NUMBER_DELIMITER_STRING+
                        phenotypeBean.getName()+"["+
                        systemId+"]"+
                        property.getName()+
                        convertStringOperatorToSymbol(operator)+
                        value;
            }
        }
        return returnValue;
    }















    public List<String> encodeGetFilterData(GetDataQuery getDataQuery, String propertyType ) throws PortalException{
        List <String> allFilters = new ArrayList<String>();
        for (QueryFilter queryFilter : getDataQuery.getFilterList()){
            if (queryFilter.getProperty().getPropertyType() == propertyType){
                String encodedFilter = encodeFilters(queryFilter);
                if ((encodedFilter !=  null ) &&
                        (encodedFilter.length() > 0)){
                    allFilters.add(encodedFilter);
                }
            }
        }
        return allFilters;
    }













    public List<String> encodeGetFilterData(GetDataQuery getDataQuery ) throws PortalException{
        List <String> allFilters = new ArrayList<String>();
        for (QueryFilter queryFilter : getDataQuery.getFilterList()){
            String encodedFilter = encodeFilters(queryFilter);
            if ((encodedFilter !=  null ) &&
                (encodedFilter.length() > 0)){
                allFilters.add(encodedFilter);
            }
        }
        return allFilters;
    }





    /**
     * convert the js naming filter string into query filter objects
     *
     * @param jsNamingFilterString
     * @return
     * @throws PortalException
     */
    public List<QueryFilter> getQueryFilters(String jsNamingFilterString) throws PortalException {
        // local variables
        List<QueryFilter> filterList = new ArrayList<QueryFilter>();
        String[] tempArray;
        QueryFilter queryFilter;

        if (jsNamingFilterString != null) {
            // split the string on the query delimiter character
            tempArray = jsNamingFilterString.split(Pattern.quote(this.QUERY_DELIMITER_STRING));

            for (int i = 0; i < tempArray.length; i++) {
                // for each filter string, convert to a query filter
                queryFilter = this.convertJsNamingQuery(tempArray[i]);

                // add to the list
                filterList.add(queryFilter);
            }

        } else {
            throw new PortalException("Got null query string: " + jsNamingFilterString);
        }

        // return
        return filterList;
    }




    public List<QueryFilter> getQueryFilters(String metaFilterDesignator, List<QueryFilter> incomingFilterList) throws PortalException {
        // local variables
        List<QueryFilter> filterList = new ArrayList<QueryFilter>();
        String[] tempArray;
        QueryFilter queryFilter;

        PropertyBean property = new PropertyBean();

        property.setName(metaFilterDesignator);

        // for each filter string, convert to a query filter
        queryFilter = new QueryFilterBean(property, PortalConstants.OPERATOR_EQUALS, incomingFilterList);

        // add to the list
        filterList.add(queryFilter);


        // return
        return filterList;
    }




    /**
     * create a query filter given a js naming property filter; throws exception if formatting is not as expected
     *
     * @param inputFilterString
     * @return
     * @throws PortalException
     */
    protected QueryFilter convertJsNamingQuery(String inputFilterString) throws PortalException {
        // local variables
        QueryFilter queryFilter;
        String[] tempArray;
        String operatorSplitCharacter;
        String operator, operand, lineNumberString, tempString, propertyString;
        Property property;

        if (inputFilterString != null) {
            // split the string on the line delimiter
            tempArray = inputFilterString.split(this.QUERY_NUMBER_DELIMITER_STRING,2);

            // make sure we have two parts
            if (tempArray.length > 1) {
                lineNumberString = tempArray[0].trim();
                tempString = tempArray[1].trim();

                // get the line number and create the query
                if (lineNumberString == null) {
                    throw new PortalException("Got null line number string: " + lineNumberString);

                } else if (lineNumberString.equals(this.QUERY_GENE_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_GENE), PortalConstants.OPERATOR_EQUALS, tempString);

                }else if (lineNumberString.equals(this.QUERY_CHROMOSOME_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME), PortalConstants.OPERATOR_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_START_POSITION_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION), PortalConstants.OPERATOR_MORE_THAN_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_END_POSITION_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION), PortalConstants.OPERATOR_LESS_THAN_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_PROPERTY_FILTER_LINE_NUMBER) || lineNumberString.equals(this.QUERY_PROTEIN_EFFECT_LINE_NUMBER)) {
                    // find out what the operator is
                    operatorSplitCharacter = JsNamingQueryTranslator.determineOperatorSplitCharacter(tempString);
                    operator = JsNamingQueryTranslator.convertSymbolicOperatorToString (operatorSplitCharacter);

                    // split the string
                    tempArray = tempString.split(operatorSplitCharacter);
                    propertyString = tempArray[0];
                    operand = tempArray[1];

                    // check
                    if (propertyString == null) {
                        throw new PortalException("Got null property in query string: " + tempString);
                    } else if (operand == null) {
                        throw new PortalException("Got null operand in query string: " + tempString);
                    }

                    // get the property
                    Property propertyForFilter = null;
                    String requestedPhenotype = null;
                    if (lineNumberString.equals(this.QUERY_PROTEIN_EFFECT_LINE_NUMBER)) {
                        propertyForFilter = this.jsonParser.findPropertyByName(propertyString);
                    } else {
                        propertyForFilter = this.jsonParser.getPropertyFromJavaScriptNamingScheme(propertyString);
                        // when the user has requested a sample group, we need to remember which phenotype they are asking about
                        String[] tempArray2 = propertyString.split(QUERY_SAMPLE_GROUP_BEGIN_STRING);
                        if ((tempArray2  !=  null ) &&
                                (tempArray2.length == 2)){
                            requestedPhenotype = tempArray2[0];
                        }
                    }

                    // create the query
                    if ((requestedPhenotype !=  null ) &&
                        (requestedPhenotype.length() > 0))   {
                        // if this is a P property- based filter then we can get the information from the property, and we will
                        //  at the point of filter generation, thereby ignoring the requestedPhenotype parameter. If however
                        //  this is a D property then currently we need to know, since every query made by user exists within
                        //  the context of a phenotype.  In the long run we will have a better solution, I'm sure, but for now
                        //  letter D properties and P properties are used interchangeably from the user's perspective
                        queryFilter = new QueryFilterBean(propertyForFilter, operator, operand,requestedPhenotype);
                    } else {
                        queryFilter = new QueryFilterBean(propertyForFilter, operator, operand);
                    }


                } else {
                    throw new PortalException("Got incorrect line number string: " + lineNumberString);
                }

            } else {
                throw new PortalException("Got badly formatted filter string: " + inputFilterString + " creating array: " + tempArray);
            }

        } else {
            throw new PortalException("Got null filter string: " + inputFilterString);
        }

        // return
        return queryFilter;
    }
}
