package org.broadinstitute.mpg.diabetes.metadata.query;

import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.sort.PropertyListForQueryComparator;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by mduby on 8/27/15.
 */
public class GetDataQueryBean implements GetDataQuery {
    // local variables
    private Map<String, Property> queryPropertyMap = new HashMap<String, Property>();
    private List<QueryFilter> filterList = new ArrayList<QueryFilter>();

    public void addQueryProperty(Property property) {
        this.queryPropertyMap.put(property.getId(), property);
    }

    public void addFilterProperty(Property property, String operator, String value) {
        this.filterList.add(new QueryFilterBean(property, operator, value));
    }

    public void addOrderByProperty(Property property) {

    }

    public void isCount(boolean isCountQuery) {

    }

    /**
     * returns a sorted list of distinct properties to query
     *
     * @return
     */
    public List<Property> getQueryPropertyList() {
        List<Property> propertyList = new ArrayList<Property>();

        // add all distinct properties
        propertyList.addAll(this.queryPropertyMap.values());

        // sort
        Collections.sort(propertyList, new PropertyListForQueryComparator());

        // return
        return propertyList;
    }

    public List<QueryFilter> getFilterList() {
        return filterList;
    }
}
