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

    public void addOrderByProperty(Property property);

    public void isCount(boolean isCountQuery);

    public List<Property> getQueryPropertyList();

    public List<QueryFilter> getFilterList();

    public void setPassback(String passback);

    public void setEntity(String entity);

    public void setPageNumber(int pageNumber);

    public void setPageSize(int pageSize);

    public void setLimit(int limit);

    public String getPassback();

    public String getEntity();

    public int getPageNumber();

    public int getPageSize();

    public int getLimit();

    public boolean isCount();

    public List <Integer> getPropertyIndexList(String propertyName);

}