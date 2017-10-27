package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

import java.util.List;

/**
 * Interface to be implemented by objects that will encapulated getData query data
 */
public interface GetDataQuery {

    public void addQueryProperty(Property property);

    public void addFilterProperty(Property property, String operator, String value);

    public void addQueryFilter(QueryFilter queryFilter);

    public void addAllQueryFilters(List<QueryFilter> queryFilterList);

    public void addOrderByQueryFilter(QueryFilter queryFilter);

    public List<QueryFilter> getOrderByQueryFilters();

    public void isCount(boolean isCountQuery);

    public List<Property> getQueryPropertyList();

    public List<QueryFilter> getFilterList();

    public void setPassback(String passback);

    public void setResultFormat(String resultFormat);

    public void setEntity(String entity);

    public void setPageStart(int pageStart);

    public void setPageSize(int pageSize);

    public void setLimit(int limit);

    public String getPassback();

    public String getResultFormat();

    public String getEntity();

    public int getPageStart();

    public int getPageSize();

    public int getLimit();

    public boolean isCount();

    public List <Integer> getPropertyIndexList(String propertyName);

    public void addToCovariateList(Covariate covariate);

    public void addAllToCovariateList(List<Covariate> covariateList);

    public List<Covariate> getCovariateList();

    public String getVersion();
    public void setVersion( String mdvString );

    public String getGene();
    public void setGene( String geneString );

    public String getPhenotype();
    public void setPhenotype( String phenotypeString );

}