package org.broadinstitute.mpg.diabetes.json.builder;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean;
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
        PropertyBean pValueProperty;
        String jsonQueryString;
        DataSet rootDataSet = null;
        System.out.println(this.phenotypeString + " " + this.rootDataSetString);
        // get a dummy p-value property--we don't want to look it up because we don't know (or care) about
        // dataset, we just need to add a p-value property to the query
        // TODO: DIGP-354: Review property spoofing for Hail multiple phenotype call to see if appropriate
        pValueProperty = new PropertyBean();
        pValueProperty.setName("P_VALUE");
        pValueProperty.setVariableType(PortalConstants.OPERATOR_TYPE_FLOAT);
        PhenotypeBean phenotypeBean = new PhenotypeBean();
        phenotypeBean.setName(this.phenotypeString);
        SampleGroupBean sgBean = new SampleGroupBean();
        sgBean.setName("ExSeq_17k_mdv2");
        phenotypeBean.setParent(sgBean);
        pValueProperty.setParent(phenotypeBean);
        // end property spoofing

        // get the query properties
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        query.addQueryProperty(pValueProperty);
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_EFFECT_ALLELE));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_REFERENCE_ALLELE));
        query.setLimit(5000);

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
