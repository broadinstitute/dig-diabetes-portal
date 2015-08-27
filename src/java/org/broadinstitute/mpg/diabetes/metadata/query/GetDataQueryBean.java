package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mduby on 8/27/15.
 */
public class GetDataQueryBean implements GetDataQuery {
    // local variables
    private List<Property> queryPropertyList = new ArrayList<Property>();
    private List<QueryFilter> filterList = new ArrayList<QueryFilter>();

    public void addQueryProperty(Property property) {
        this.queryPropertyList.add(property);
    }

    public void addFilterProperty(Property property, String operator, String value) {
        this.filterList.add(new QueryFilterBean(property, operator, value));
    }

    public void addOrderByProperty(Property property) {

    }

    public void isCount(boolean isCountQuery) {

    }

    public List<Property> getQueryPropertyList() {
        return queryPropertyList;
    }

    public List<QueryFilter> getFilterList() {
        return filterList;
    }
}
