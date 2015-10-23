package org.broadinstitute.mpg.diabetes.metadata.query

import dport.RestServerService
import dport.SearchBuilderService
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.springframework.beans.factory.annotation.Autowired

/**
 * Created by balexand on 9/17/2015.
 */

/***
 * Here is a wrapper around GetDataQuery allowing us to provide some additional functionality without messing with the underlying class unnecessarily.
 * (Also allowing me to program in Groovy instead of Java!)
 */
class GetDataQueryHolder {

    GetDataQuery getDataQuery

    //  a couple of services. We pass these in through the constructor
    SearchBuilderService searchBuilderService
    MetaDataService metaDataService

    /***
     * factory constructor to build a GetDataQueryHolder given a set of filters defined on a single line
     *
     * @param filterString
     * @param searchBuilderService
     * @param metaDataService
     * @return
     */
    public static GetDataQueryHolder createGetDataQueryHolder(String filterString, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
        if ((filterString) &&
                (filterString.size() > 0)) {
            String refinedFilterString = filterString
            //start with a special case.  Sometimes our filter string starts and ends with brackets.  If so then strip them off
            if ((filterString.getAt(0) == '[') &&
                    (filterString.getAt(filterString.length() - 1) == ']')) {
                refinedFilterString = filterString.replaceFirst(~/\[/, "")[0..-2]
            }
            List<String> filterList = refinedFilterString.tokenize("^")
            return createGetDataQueryHolder(filterList, searchBuilderService, metaDataService)
            // call the list of filters constructor
        } else {
            return createGetDataQueryHolder(); // if the string is empty then call the no parameter constructor
        }
    }

    /***
     * If you already have a GetDataQuery then you could pass it into this factory constructor
     * @param getDataQuery
     * @return
     */
    public static GetDataQueryHolder createGetDataQueryHolder(GetDataQuery getDataQuery) {
        return new GetDataQueryHolder(getDataQuery)
    }

    /***
     *   Build a GetDataQueryHolder using a list of filter definitions. Note that these are the same filter definitions that are provided by
     *   the method listOfEncodedFilters, and that these filters can (and regularly are) passed down into the GSP machinery. This provides
     *   a convenient way to collapse a GetDataQueryHolder into something that can be passed to the browser, and then re-create an equivalent
     *   object using strings that the browser passes back up.
     *
     * @param filterList
     * @param searchBuilderService
     * @param metaDataService
     * @return
     */
    public static GetDataQueryHolder createGetDataQueryHolder(List<String> filterList, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
        return new GetDataQueryHolder(filterList, searchBuilderService, metaDataService)
    }

    /***
     * Sometimes we don't need the full object, so we can use this abbreviated factory method
     * @return
     */
    public static GetDataQueryHolder createGetDataQueryHolder() {
        return new GetDataQueryHolder()
    }

    /***
     * this is the primary constructor method
     * @param filterList
     * @param searchBuilderService
     * @param metaDataService
     */
    public GetDataQueryHolder(List<String> filterList, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
        this()
        this.searchBuilderService = searchBuilderService
        this.metaDataService = metaDataService
        getDataQuery = generateGetDataQuery(filterList)
    }

    /***
     * constructor
     * @param getDataQuery
     */
    public GetDataQueryHolder(GetDataQuery getDataQuery) {
        this()
        this.getDataQuery = getDataQuery
    }

    /***
     * constructor
     */
    public GetDataQueryHolder() {
        this.getDataQuery = new GetDataQueryBean()
    }

    /***
     * This method is used by the constructor to build a GetDataQuery out of a set of filters
     * @param listOfCodedFilters
     * @return
     */
    public GetDataQuery generateGetDataQuery(List<String> listOfCodedFilters) {
        GetDataQuery query = new GetDataQueryBean()
        JsNamingQueryTranslator jsNamingQueryTranslator = new JsNamingQueryTranslator()
        List<QueryFilter> combinedQueryFilterList = []
        for (String codedFilters in listOfCodedFilters) {
            List<QueryFilter> queryFilterList = jsNamingQueryTranslator.getQueryFilters(codedFilters)
            for (QueryFilter queryFilter in queryFilterList) {
                combinedQueryFilterList << queryFilter
            }
        }
        for (QueryFilter queryFilter in combinedQueryFilterList) {
            query.addQueryFilter(queryFilter)
        }
        return query
    }

    /***
     * add C properties. The incoming data structure is built by the getColumnsToDisplayStructure method in SharedToolsService
     * @param resultColumnsToDisplay
     */
    private addSpecificCProperties(LinkedHashMap resultColumnsToDisplay) {
        if ((resultColumnsToDisplay) &&
                (resultColumnsToDisplay['cproperty'])) {
            List<String> cProperties = resultColumnsToDisplay['cproperty']
            for (String cProperty in cProperties?.unique()) {
                Property displayProperty = metaDataService.getCommonPropertyByName(cProperty)
                if (!(cProperty in getDataQuery.getQueryPropertyList()?.name)){
                    getDataQuery.addQueryProperty(displayProperty)
                }
            }
        }
    }

    /***
     * add D properties. The incoming data structure is built by the getColumnsToDisplayStructure method in SharedToolsService
     * @param resultColumnsToDisplay
     */
    private addSpecificDProperties(LinkedHashMap resultColumnsToDisplay) {
        if ((resultColumnsToDisplay) &&
                (resultColumnsToDisplay['dproperty'])) {
            LinkedHashMap dProperties = resultColumnsToDisplay['dproperty']
            dProperties.each { String phenoKey, LinkedHashMap dataSets ->
                dataSets?.each { String dataSetKey, List props ->
                    for (String prop in props) {
                        Property displayProperty = metaDataService.getSampleGroupProperty(dataSetKey, prop)
                        getDataQuery.addQueryProperty(displayProperty)
                    }
                }
            }
        }
    }


    /***
     * add P properties. The incoming data structure is built by the getColumnsToDisplayStructure method in SharedToolsService
     * @param resultColumnsToDisplay
     */
    private addSpecificPProperties(LinkedHashMap resultColumnsToDisplay) {
        if ((resultColumnsToDisplay) &&
                (resultColumnsToDisplay['pproperty'])) {
            LinkedHashMap dProperties = resultColumnsToDisplay['pproperty']
            dProperties.each { String phenoKey, LinkedHashMap dataSets ->
                dataSets?.each { String dataSetKey, List props ->
                    for (String prop in props) {
                        List<Property> displayProperties = metaDataService.getPhenotypeSpecificSampleGroupPropertyCollection(phenoKey, dataSetKey, ["^${prop}"])
                        for (Property displayProperty in displayProperties) {
                            getDataQuery.addQueryProperty(displayProperty)
                        }
                    }
                }
            }
        }
    }

    /***
     * Convenience routine to call the three different types of property builders
     * @param columnsWeWant
     */
    public void addProperties(LinkedHashMap columnsWeWant) {
        addSpecificCProperties(columnsWeWant)
        addSpecificDProperties(columnsWeWant)
        addSpecificPProperties(columnsWeWant)
    }

    /***
     * write out all the filters into a string, suitable for passing to the REST server.  It would be nice if this method
     * becomes unnecessary because all of the JSON is handled behind the scenes, but we aren't there yet.  Consider this a
     * bridge routine until we can achieve that goal
     * @return
     */
    public String retrieveAllFiltersAsJson() {
        List<QueryFilter> filterList = getDataQuery.getFilterList()
        List<String> filtersAsJson = filterList.collect { it -> it.getFilterString() }
        return "${filtersAsJson.join(',')}"
    }

    /***
     * Sometimes we need to know if a given set of filters provides a definition of a genomic range. If it does
     * then pass back the three parts (start here, end here, and chromosome name) in a map
     * @return
     */
    public LinkedHashMap<String,String> positioningInformation() {
        LinkedHashMap<String, String> returnValue = [:]
        List<QueryFilter> filterList = getDataQuery.getFilterList()
        for (QueryFilter queryFilter in filterList) {
            switch (queryFilter.property.getName()) {
                case "POS":
                    if ((queryFilter.operator == PortalConstants.OPERATOR_LESS_THAN_EQUALS) ||
                            (queryFilter.operator == PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS)) {
                        returnValue["endingExtentSpecified"] = queryFilter.value
                    } else if ((queryFilter.operator == PortalConstants.OPERATOR_MORE_THAN_EQUALS) ||
                            (queryFilter.operator == PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS)) {
                        returnValue["beginningExtentSpecified" ] = queryFilter.value
                    } else if (queryFilter.operator == PortalConstants.OPERATOR_EQUALS) {
                        returnValue["beginningExtentSpecified"] = queryFilter.value
                        returnValue["endingExtentSpecified"] = queryFilter.value
                    }
                    break;
                case "CHROM":
                    returnValue["chromosomeSpecified"] = queryFilter.value
                    break
                default:
                    break
            }

        }
        return returnValue
    }

    /***
     * Take all of the filters that make up this holder and convert them into a list. This list is then
     * read by some of the other methods, or else may be used to reconstruct an equivalent object from scratch
     * @return
     */
    public List<String> listOfEncodedFilters() {
        JsNamingQueryTranslator jsNamingQueryTranslator = new JsNamingQueryTranslator()
        return jsNamingQueryTranslator.encodeGetFilterData(this.getDataQuery)
    }

    /***
     * Sometimes it's useful to take a subset of the properties.  Specifically it's nice to be able to
     * breakout common properties from d and p properties
     * @param propertyType
     * @return
     */
    public List<String> listOfEncodedFilters(String propertyType) {
        JsNamingQueryTranslator jsNamingQueryTranslator = new JsNamingQueryTranslator()
        return jsNamingQueryTranslator.encodeGetFilterData(this.getDataQuery,propertyType)
    }

    /***
     * uuencode a list of filters
     * @param encodedFilters
     * @return
     */
    public List<String> listOfUrlEncodedFilters(List<String> encodedFilters) {
        return encodedFilters.collect { it -> java.net.URLEncoder.encode(it) }
    }

    /***
     * Could we go to the REST server with this getDataQuery?
     * @return
     */
    public Boolean isValid() {
        return ((getDataQuery) &&
                (getDataQuery.filterList))
    }

    /***
     * accessor
     * @return
     */
    public GetDataQuery retrieveGetDataQuery() {
        return getDataQuery
    }

    /***
     * Take one of our list of encoded filters and turn it into something that people could read
     * @param encodedFilters
     * @return
     */
    public List<String> listOfReadableFilters(List<String> encodedFilters) {
        return decodeEncodedFilters(encodedFilters)
    }



    public void isCount(boolean isCountQuery){
        getDataQuery.isCount(isCountQuery)
    }





    /***
     * write a filter out in a form that humans can understand
     * @param encodedFilter
     * @return
     * @throws PortalException
     */
    public String decodeFilter(String encodedFilter) throws PortalException {
        String returnValue = ""
        if ((encodedFilter != null) &&
                (encodedFilter.length() > 0)) {
            List<String> tempArray
            tempArray = encodedFilter.tokenize(JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING);
            if (tempArray.size() != 2) {
                throw new PortalException("Expected '" + JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING + "' in " + encodedFilter);
            } else {
                switch (tempArray[0]) {
                    case JsNamingQueryTranslator.QUERY_GENE_LINE_NUMBER:
                        returnValue =  tempArray[1]
                        break
                    case JsNamingQueryTranslator.QUERY_CHROMOSOME_LINE_NUMBER:
                        returnValue = "chromosome = " + tempArray[1];
                        break
                    case JsNamingQueryTranslator.QUERY_START_POSITION_LINE_NUMBER:
                        returnValue = "position >  " + tempArray[1];
                        break
                    case JsNamingQueryTranslator.QUERY_END_POSITION_LINE_NUMBER:
                        returnValue = "position < " + tempArray[1];
                        break
                    case JsNamingQueryTranslator.QUERY_PROTEIN_EFFECT_LINE_NUMBER:
                        List<String> proteinEffect
                        String operatorSplitCharacter = JsNamingQueryTranslator.determineOperatorSplitCharacter(tempArray[1]);
                        if (operatorSplitCharacter.contains("|")){
                            operatorSplitCharacter = "|" //
                        }
                        proteinEffect = tempArray[1].tokenize(operatorSplitCharacter);
                        if (proteinEffect.size()>0){
                            switch (proteinEffect[0]) {
                                case PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY:
                                    returnValue = "predicted effects ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_PROTEINEFFECT, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY:
                                    returnValue = "Polyphen-2 prediction ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_POLYPHEN, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_SIFT_PRED_KEY:
                                    returnValue = "SIFT prediction ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_SIFT, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY:
                                    returnValue = "CONDEL prediction ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_CONDEL, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                            }

                        }
                        break
                    case JsNamingQueryTranslator.QUERY_PROPERTY_FILTER_LINE_NUMBER:
                        returnValue = "${tempArray[1]}".trim()
                        break
                }
            }
        }

        return returnValue;
    }

    /***
     * write out a whole list of filters in a form that humans can understand
     * @param encodedFilterList
     * @return
     * @throws PortalException
     */
    private List<String> decodeEncodedFilters(List<String> encodedFilterList) throws PortalException {
        List<String> allFilters = new ArrayList<String>();
        for (String encodedFilter : encodedFilterList) {
            String decodedFilter = decodeFilter(encodedFilter);
            if ((decodedFilter != null) &&
                    (decodedFilter.length() > 0)) {
                allFilters.add(decodedFilter);
            }
        }
        return allFilters;
    }


}
