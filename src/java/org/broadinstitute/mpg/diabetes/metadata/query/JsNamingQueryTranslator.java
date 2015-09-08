package org.broadinstitute.mpg.diabetes.metadata.query;

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
    private final String QUERY_DELIMITER_STRING                 = "^";
    private final String QUERY_NUMBER_DELIMITER_STRING          = "=";

    private final String QUERY_OPERATOR_EQUALS_STRING               = "|";
    private final String QUERY_OPERATOR_MORE_THAN_STRING            = ">";
    private final String QUERY_OPERATOR_LESS_THAN_STRING            = "<";

    private final String QUERY_CHROMOSOME_LINE_NUMBER                       = "8";
    private final String QUERY_START_POSITION_LINE_NUMBER                   = "9";
    private final String QUERY_END_POSITION_LINE_NUMBER                     = "10";
    private final String QUERY_PROTEIN_EFFECT_LINE_NUMBER                   = "11";
    private final String QUERY_PROPERTY_FILTER_LINE_NUMBER                  = "17";

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

            if (tempArray.length > 0) {
                for (int i = 0; i < tempArray.length; i++) {
                    // for each filter string, convert to a query filter
                    queryFilter = this.convertJsNamingQuery(tempArray[i]);

                    // add to the list
                    filterList.add(queryFilter);
                }
            } else {
                throw new PortalException("Got incorrect formatted query string: " + jsNamingFilterString);
            }
        } else {
            throw new PortalException("Got null query string: " + jsNamingFilterString);
        }

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
            tempArray = inputFilterString.split(this.QUERY_NUMBER_DELIMITER_STRING);

            // make sure we have two parts
            if (tempArray.length > 1) {
                lineNumberString = tempArray[0];
                tempString = tempArray[1];

                // get the line number and create the query
                if (lineNumberString == null) {
                    throw new PortalException("Got null line number string: " + lineNumberString);

                } else if (lineNumberString.equals(this.QUERY_CHROMOSOME_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_GENE), PortalConstants.OPERATOR_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_START_POSITION_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION), PortalConstants.OPERATOR_MORE_THAN_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_END_POSITION_LINE_NUMBER)) {
                    queryFilter = new QueryFilterBean((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION), PortalConstants.OPERATOR_LESS_THAN_EQUALS, tempString);

                } else if (lineNumberString.equals(this.QUERY_PROPERTY_FILTER_LINE_NUMBER) || lineNumberString.equals(this.QUERY_PROTEIN_EFFECT_LINE_NUMBER)) {
                    // find out what the operator is
                    if (tempString.contains(this.QUERY_OPERATOR_EQUALS_STRING)) {
                        operator = PortalConstants.OPERATOR_EQUALS;
                        operatorSplitCharacter = Pattern.quote(this.QUERY_OPERATOR_EQUALS_STRING);      // '|' string is special regexp string

                    } else if (tempString.contains(this.QUERY_OPERATOR_LESS_THAN_STRING)) {
                        operator = PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS;
                        operatorSplitCharacter = this.QUERY_OPERATOR_LESS_THAN_STRING;

                    } else if (tempString.contains(this.QUERY_OPERATOR_MORE_THAN_STRING)) {
                        operator = PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS;
                        operatorSplitCharacter = this.QUERY_OPERATOR_MORE_THAN_STRING;

                    } else {
                        throw new PortalException("Got unsupported operator in query string: " + tempString);
                    }

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
                    if (lineNumberString.equals(this.QUERY_PROTEIN_EFFECT_LINE_NUMBER)) {
                        propertyForFilter = this.jsonParser.findPropertyByName(propertyString);
                    } else {
                        propertyForFilter = this.jsonParser.getPropertyFromJavaScriptNamingScheme(propertyString);
                    }

                    // create the query
                    queryFilter = new QueryFilterBean(propertyForFilter, operator, operand);

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
