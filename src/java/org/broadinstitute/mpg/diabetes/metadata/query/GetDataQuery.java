package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

import java.util.List;

/**
 * Interface to be implemented by objects that will encapulated getData query data
 */
public interface GetDataQuery {

    public void addQueryProperty(Property property);

    public void addFilterProperty(Property property, String operator, String value);

    public void addOrderByProperty(Property property);

    public void isCount(boolean isCountQuery);

    public List<Property> getQueryPropertyList();

    public List<QueryFilter> getFilterList();
}