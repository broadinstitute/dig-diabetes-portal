package org.broadinstitute.mpg.diabetes.json.builder;

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

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mduby on 12/18/15.
 */
public class LocusZoomJsonBuilder {
    // instance variables
    JsonParser jsonParser = JsonParser.getService();
    QueryJsonBuilder jsonBuilder = new QueryJsonBuilder();
    private String rootDataSetString;
    private String phenotypeString;

    /**
     * default constructor
     *
     * @param rootDataSetString
     * @param phenotype
     */
    public LocusZoomJsonBuilder(String rootDataSetString, String phenotype) {
        this.rootDataSetString = rootDataSetString;
        this.phenotypeString = phenotype;
    }

    public String getLocusZoomQueryString(String chromosome, int startPosition, int endPosition) throws PortalException {
        // local variables
        GetDataQuery query = new GetDataQueryBean();
        Property pValueProperty;
        String jsonQueryString;
        DataSet rootDataSet = null;

        // find the pvalue property based on the instance variables
        pValueProperty = this.jsonParser.getPropertyGivenItsAndPhenotypeAndSampleGroupNames(PortalConstants.PROPERTY_NAME_P_FIRTH, this.phenotypeString, this.rootDataSetString);

        // get the query properties
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        query.addQueryProperty(pValueProperty);
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_EFFECT_ALLELE));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_REFERENCE_ALLELE));

        // get the query filters
        query.addAllQueryFilters(this.getStandardQueryFilters(chromosome, startPosition, endPosition));
        query.addFilterProperty(pValueProperty, PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS, String.valueOf(0.0));

        // get the payload string
        jsonQueryString = this.jsonBuilder.getQueryJsonPayloadString(query);

        // return
        return jsonQueryString;
    }

    /**
     * build the query filter list for the LZ query
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    protected List<QueryFilter> getStandardQueryFilters(String chromosome, int startPosition, int endPosition) throws PortalException {
        // local variables
        List<QueryFilter> filterList = new ArrayList<QueryFilter>();
        Property tempProperty;

        // add chromosome filter
        tempProperty = this.jsonParser.findCommonPropertyWithName(PortalConstants.PROPERTY_NAME_CHROMOSOME);
        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_EQUALS, chromosome));

        // add start position filter
        tempProperty = this.jsonParser.findCommonPropertyWithName(PortalConstants.PROPERTY_NAME_POSITION);
        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_MORE_THAN_EQUALS, String.valueOf(startPosition)));

        // add end position filter
        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_LESS_THAN_EQUALS, String.valueOf(endPosition)));

        // return
        return filterList;
    }
}
