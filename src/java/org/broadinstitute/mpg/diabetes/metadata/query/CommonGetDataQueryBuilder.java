package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;

import java.util.List;

/**
 * Class to create common getData queries
 *
 */
public class CommonGetDataQueryBuilder {
    // instance variables
    JsonParser jsonParser = null;

    /**
     * default constructor
     *
     */
    public CommonGetDataQueryBuilder() {
        this.jsonParser = JsonParser.getService();
    }

    /**
     * create a get data query bean for a search for phenotype, chromosome and variant position
     *
     * @param phenotype
     * @param chromosome
     * @param startPosition
     * @param endPosition
     * @return
     * @throws PortalException
     */
    public GetDataQuery getDataQueryForPhenotype(Phenotype phenotype, String chromosome, int startPosition, int endPosition) throws PortalException {
        // local variables
        GetDataQuery queryBean = new GetDataQueryBean();
        List<Property> propertyList = null;
        SampleGroup sampleGroup = null;
        List<Property> commonProperties = this.jsonParser.getAllCommonProperties();
        Property property = null;

        // add in all the default query properties
        this.addInAllCommonAndParentAndSelfProperties(queryBean, phenotype);

        // add in the filter properties
        property = this.getPropertyByNameAndPropertyType(commonProperties, PortalConstants.NAME_COMMON_PROPERTY_CHROMOSOME, PortalConstants.TYPE_COMMON_PROPERTY_KEY);
        queryBean.addFilterProperty(property, PortalConstants.OPERATOR_EQUALS, chromosome);
        property = this.getPropertyByNameAndPropertyType(commonProperties, PortalConstants.NAME_COMMON_PROPERTY_POSITION, PortalConstants.TYPE_COMMON_PROPERTY_KEY);
        queryBean.addFilterProperty(property, PortalConstants.OPERATOR_MORE_THAN_EQUALS, String.valueOf(startPosition));
        queryBean.addFilterProperty(property, PortalConstants.OPERATOR_LESS_THAN_EQUALS, String.valueOf(endPosition));

        // make sure there is a match for the phenotype
        for (Property tempProperty : phenotype.getProperties()) {
            if (tempProperty.getName().equals(PortalConstants.NAME_PHENOTYPE_PROPERTY_P_VALUE)) {
                property = tempProperty;
                break;
            }
        }
        // if p-value property found, the add filter property that will ensure we only get variants that have p values for this trait/phenotype
        if (property != null) {
            queryBean.addFilterProperty(property, PortalConstants.OPERATOR_LESS_THAN_EQUALS, "2");
        }

        // return
        return queryBean;
    }

    /**
     * adds in all common properties, parent sample group properties and phenotype properties as query properties
     *
     * @param queryBean
     * @param phenotype
     * @return
     * @throws PortalException
     */
    protected GetDataQuery addInAllCommonAndParentAndSelfProperties(GetDataQuery queryBean, Phenotype phenotype) throws PortalException {
        // local variables
        List<Property> propertyList = null;
        SampleGroup sampleGroup = null;

        // add in all the common properties
        propertyList = this.jsonParser.getAllCommonProperties();
        for (Property property : propertyList) {
            queryBean.addQueryProperty(property);
        }

        // add in all the phenotype sample group parent's properties
        sampleGroup = (SampleGroup)phenotype.getParent();
        for (Property property : sampleGroup.getProperties()) {
            queryBean.addQueryProperty(property);
        }

        // add in all the phenotype's properties
        for (Property property : phenotype.getProperties()) {
            queryBean.addQueryProperty(property);
        }

        // return
        return queryBean;
    }

    /**
     * quick loop through list of properties to find one we want
     *
     * @param propertyList
     * @param name
     * @param propertyType
     * @return
     */
    protected Property getPropertyByNameAndPropertyType(List<Property> propertyList, String name, String propertyType) throws PortalException {
        // local variables
        Property property = null;

        // loop through and find the property
        for (Property tempProperty : propertyList) {
            if (tempProperty.getName().equals(name) && tempProperty.getPropertyType().equals(propertyType)) {
                property = tempProperty;
                break;
            }
        }

        // exception if null
        if (property == null) {
            throw new PortalException("Did not find property of name: " + name + " and property type: " + propertyType);
        }

        // return
        return property;
    }
}
