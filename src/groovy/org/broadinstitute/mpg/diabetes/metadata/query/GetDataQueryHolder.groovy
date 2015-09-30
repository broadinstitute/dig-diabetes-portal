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

class GetDataQueryHolder {

    GetDataQuery getDataQuery

    SearchBuilderService searchBuilderService
    MetaDataService metaDataService

    public
    static GetDataQueryHolder createGetDataQueryHolder(String filterString, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
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


    public static GetDataQueryHolder createGetDataQueryHolder(GetDataQuery getDataQuery) {
        return new GetDataQueryHolder(getDataQuery)
    }


    public
    static GetDataQueryHolder createGetDataQueryHolder(List<String> filterList, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
        return new GetDataQueryHolder(filterList, searchBuilderService, metaDataService)
    }

    public static GetDataQueryHolder createGetDataQueryHolder() {
        return new GetDataQueryHolder()
    }


    public GetDataQueryHolder(List<String> filterList, SearchBuilderService searchBuilderService, MetaDataService metaDataService) {
        this()
        this.searchBuilderService = searchBuilderService
        this.metaDataService = metaDataService
        getDataQuery = generateGetDataQuery(filterList)
    }

    public GetDataQueryHolder(GetDataQuery getDataQuery) {
        this()
        this.getDataQuery = getDataQuery
    }

    public GetDataQueryHolder() {
        this.getDataQuery = new GetDataQueryBean()
    }


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



    private addSpecificCProperties(LinkedHashMap resultColumnsToDisplay) {
        if ((resultColumnsToDisplay) &&
                (resultColumnsToDisplay['cproperty'])) {
            List<String> cProperties = resultColumnsToDisplay['cproperty']
            for (String cProperty in cProperties) {
                Property displayProperty = metaDataService.getCommonPropertyByName(cProperty)
                getDataQuery.addQueryProperty(displayProperty)
            }
        }
    }


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


    public void addProperties(LinkedHashMap columnsWeWant) {
        addSpecificCProperties(columnsWeWant)
        addSpecificDProperties(columnsWeWant)
        addSpecificPProperties(columnsWeWant)
    }


    public String retrieveAllFiltersAsJson() {
        List<QueryFilter> filterList = getDataQuery.getFilterList()
        List<String> filtersAsJson = filterList.collect { it -> it.getFilterString() }
        return "${filtersAsJson.join(',')}"
    }


    public List<String> listOfEncodedFilters() {
        JsNamingQueryTranslator jsNamingQueryTranslator = new JsNamingQueryTranslator()
        return jsNamingQueryTranslator.encodeGetFilterData(this.getDataQuery)
    }



    public List<String> listOfEncodedFilters(String propertyType) {
        JsNamingQueryTranslator jsNamingQueryTranslator = new JsNamingQueryTranslator()
        return jsNamingQueryTranslator.encodeGetFilterData(this.getDataQuery,propertyType)
    }




    public List<String> listOfUrlEncodedFilters(List<String> encodedFilters) {
        return encodedFilters.collect { it -> java.net.URLEncoder.encode(it) }
    }




    public Boolean isValid() {
        return ((getDataQuery) &&
                (getDataQuery.filterList))
    }


    public GetDataQuery retrieveGetDataQuery() {
        return getDataQuery
    }


    public List<String> listOfReadableFilters(List<String> encodedFilters) {
        return decodeEncodedFilters(encodedFilters)
    }


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
                        proteinEffect = tempArray[1].tokenize(operatorSplitCharacter);
                        if (proteinEffect.size()>0){
                            switch (proteinEffect[0]) {
                                case PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY:
                                    returnValue = "predicted effects ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_PROTEINEFFECT, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY:
                                    returnValue = "predicted effects ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_POLYPHEN, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_SIFT_PRED_KEY:
                                    returnValue = "predicted effects ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_SIFT, proteinEffect[1],operatorSplitCharacter)}"
                                    break;
                                case PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY:
                                    returnValue = "predicted effects ${searchBuilderService.prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_CONDEL, proteinEffect[1],operatorSplitCharacter)}"
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
