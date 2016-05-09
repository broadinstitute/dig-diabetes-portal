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

    public void setEntity(String entity);

    public void setPageStart(int pageStart);

    public void setPageSize(int pageSize);

    public void setLimit(int limit);

    public String getPassback();

    public String getEntity();

    public int getPageStart();

    public int getPageSize();

    public int getLimit();

    public boolean isCount();

    public List <Integer> getPropertyIndexList(String propertyName);

}