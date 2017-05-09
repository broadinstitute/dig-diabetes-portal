package org.broadinstitute.mpg.diabetes.json.builder;

import org.broadinstitute.mpg.diabetes.knowledgebase.result.Variant;
import org.broadinstitute.mpg.diabetes.knowledgebase.result.VariantBean;
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.metadata.query.Covariate;
import org.broadinstitute.mpg.diabetes.metadata.query.CovariateBean;
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
    private String rootDataSetString = "ExSeq_17k_mdv2";
    private String phenotypeString;
    private String propertyName = "P_VALUE";

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

    public LocusZoomJsonBuilder(String rootDataSetString, String phenotype, String propertyName) {
        this.rootDataSetString = rootDataSetString;
        this.phenotypeString = phenotype;
        this.propertyName = propertyName;
    }

    /**
     * build the locus zoom query string
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    public String getLocusZoomQueryString(String chromosome, int startPosition, int endPosition, List<Covariate> covariateList) throws PortalException {
        // local variables
        GetDataQuery query = new GetDataQueryBean();
        String jsonQueryString;
        System.out.println(this.phenotypeString + " " + this.rootDataSetString);

        // get the query object
        query = this.getLocusZoomQueryBean(chromosome, startPosition, endPosition, covariateList);

        // get the payload string
        jsonQueryString = this.jsonBuilder.getQueryJsonPayloadString(query);

        // return
        return jsonQueryString;
    }

    /**
     * build the locus zoom query object
     *
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @param covariateList
     * @return
     * @throws PortalException
     */
    public GetDataQuery getLocusZoomQueryBean(String chromosome, int startPosition, int endPosition, List<Covariate> covariateList) throws PortalException {
        // local variables
        GetDataQuery query = new GetDataQueryBean();
        PropertyBean pValueProperty;
        System.out.println(this.phenotypeString + " " + this.rootDataSetString+" "+this.propertyName);
        // get a dummy p-value property--we don't want to look it up because we don't know (or care) about
        // dataset, we just need to add a p-value property to the query
        // TODO: DIGP-354: Review property spoofing for Hail multiple phenotype call to see if appropriate
        pValueProperty = new PropertyBean();
        pValueProperty.setName(this.propertyName);
        pValueProperty.setVariableType(PortalConstants.OPERATOR_TYPE_FLOAT);
        PhenotypeBean phenotypeBean = new PhenotypeBean();
        phenotypeBean.setName(this.phenotypeString);
        SampleGroupBean sgBean = new SampleGroupBean();
        sgBean.setName(this.rootDataSetString);
        sgBean.setSystemId(this.rootDataSetString);
        phenotypeBean.setParent(sgBean);
        pValueProperty.setParent(phenotypeBean);
        // end property spoofing


        Property posteriorPValue =  jsonParser.getPropertyGivenItsAndPhenotypeAndSampleGroupNames( "POSTERIOR_P_VALUE",  this.phenotypeString,  rootDataSetString);

        // get the query properties
        if (posteriorPValue != null){
            query.addQueryProperty(posteriorPValue);
        }
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_MOST_DEL_SCORE));
        query.addQueryProperty(pValueProperty);
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_EFFECT_ALLELE));
        query.addQueryProperty((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_REFERENCE_ALLELE));
        query.setLimit(5000);

        // get the query filters
        query.addAllQueryFilters(this.getStandardQueryFilters(chromosome, startPosition, endPosition));
        query.addFilterProperty(pValueProperty, PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS, String.valueOf(0.0));

        // add the covariates
        if ((covariateList != null) && (covariateList.size() > 0)) {
            query.addAllToCovariateList(covariateList);
        }

        // return
        return query;
    }

    /**
     * parse the chrom_pos_ref_alt formatted string into variant objects
     *
     * @param variantStringList
     * @return
     * @throws PortalException
     */
    public List<Covariate> parseLzVariants(List<String> variantStringList) throws PortalException {
        // local variables
        List<Covariate> covariateList = new ArrayList<Covariate>();

        // loop through the strings, catch format exception
        if (variantStringList != null) {
            for (String variantString : variantStringList) {
                // split
                String[] split = variantString.split("_");
                if (split.length == 4) {
                    try {
                        Variant variant = new VariantBean();
                        variant.setChromosome(split[0]);
                        variant.setReferenceAllele(split[2]);
                        variant.setAlternateAllele(split[3]);

                        int position = Integer.valueOf(split[1]).intValue();
                        variant.setPosition(position);

                        // add to the collection
                        Covariate covariate = new CovariateBean();
                        covariate.setVariant(variant);
                        covariateList.add(covariate);

                    } catch (NumberFormatException exception) {
                        // add log here
                    }

                }
            }
        }

        // return
        return covariateList;
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

        // DIGKB-83: adding minimum MAC of 20 for the LZ plot; or else get large values for singletons
//        tempProperty = this.jsonParser.buildPropertyFromScratch(PortalConstants.PROPERTY_NAME_MINOR_ALLELE_COUNT, PortalConstants.OPERATOR_TYPE_INTEGER);
//        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_MORE_THAN_EQUALS, "20"));

        // add start position filter
        tempProperty = this.jsonParser.findCommonPropertyWithName(PortalConstants.PROPERTY_NAME_POSITION);
        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_MORE_THAN_EQUALS, String.valueOf(startPosition)));

        // add end position filter
        filterList.add(new QueryFilterBean(tempProperty, PortalConstants.OPERATOR_LESS_THAN_EQUALS, String.valueOf(endPosition)));

        // return
        return filterList;
    }
}
