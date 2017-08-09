package org.broadinstitute.mpg.diabetes.metadata.query;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.impl.Log4JLogger;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.sort.PropertyListForQueryComparator;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Concrete class to represent the getData query data
 *
 */
public class GetDataQueryBean implements GetDataQuery {
    // local variables
    private Map<String, Property> queryPropertyMap = new HashMap<String, Property>();
    private List<QueryFilter> filterList = new ArrayList<QueryFilter>();
    private List<QueryFilter> orderByList = new ArrayList<QueryFilter>();
    String passback = "abc123";
    String entity = "variant";
    String resultFormat = "\"verbose\"";
    // default pageStart/pageSize to -1, to signify to the KB
    // that there is no setting. If they are set, then the limit is
    // ignored. In practice, the limit is used more than the pageStart/pageSize
    // settings, so default these to be ignored.
    int pageStart = -1;
    int pageSize = -1;
    int limit = 1000;

    // some optional properties we can use for our aggregated call
    private String version = null;
    private String phenotype = null;
    private String gene = null;

    boolean isCount = false;
    private List<Covariate> covariateList = new ArrayList<Covariate>();

    // creating log
    Log queryLog = new Log4JLogger(this.getClass().getName());


    public Map<String, Property> getQueryPropertyMap() {
        return queryPropertyMap;
    }

    public void setQueryPropertyMap(Map<String, Property> queryPropertyMap) {
        this.queryPropertyMap = queryPropertyMap;
    }


    public void addQueryProperty(Property property) {
        if (!(this.queryPropertyMap.containsKey(property.getId()))){
            this.queryPropertyMap.put(property.getId(), property);
        }
    }

    public void addFilterProperty(Property property, String operator, String value) {
        this.filterList.add(new QueryFilterBean(property, operator, value));
    }

    public void addQueryFilter(QueryFilter queryFilter) {
        this.filterList.add(queryFilter);
    }

    public void addAllQueryFilters(List<QueryFilter> queryFilterList) {
        this.filterList.addAll(queryFilterList);
    }

    public void addOrderByQueryFilter(QueryFilter queryFilter) {
        this.orderByList.add(queryFilter);
    }

    public List<QueryFilter> getOrderByQueryFilters() {
        return this.orderByList;
    }

    public void isCount(boolean isCountQuery) {
        this.isCount = isCountQuery;
    }

    public void setPassback(String passback) {
        this.passback = passback;
    }

    public void setResultFormat(String resultFormat) {
        this.resultFormat = resultFormat;
    }

    public void setEntity(String entity) {
        this.entity = entity;
    }

    public void setPageStart(int pageStart) {
        this.pageStart = pageStart;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public String getPassback() {
        return passback;
    }

    public String getResultFormat() {
        return resultFormat;
    }

    public String getEntity() {
        return entity;
    }

    public int getPageStart() {
        return pageStart;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getLimit() {
        return limit;
    }

    public boolean isCount() {
        return isCount;
    }

    public String getVersion(){ return this.version; }
    public void setVersion( String mdvString ){  this.version = mdvString; }

    public String getGene(){ return this.gene; }
    public void setGene( String geneString ){  this.gene = geneString; }

    public String getPhenotype(){ return this.phenotype; }
    public void setPhenotype( String phenotypeString ){  this.phenotype = phenotypeString; }

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


    /**
     * would it really hurt to put some comments here to know what this is for ???????????????
     *
     *
     * @param propertyName
     * @return
     */
    public List <Integer> getPropertyIndexList(String propertyName){
        List <Integer> returnValue = new ArrayList<Integer>();
        if (propertyName!=null) {
            List<Property> propertyList = getQueryPropertyList();
            for (int i = 0; i < propertyList.size(); i++) {
                Property property = propertyList.get(i);
                if (propertyName.equals(property)) {
                    returnValue.add(new Integer(i));
                }
            }
        }
        return returnValue;
    }

    /**
     * add to the covariate list
     *
     * @param covariate
     */
    public void addToCovariateList(Covariate covariate) {
        if (this.covariateList == null) {
            this.covariateList = new ArrayList<Covariate>();
        }

        this.covariateList.add(covariate);
    }

    /**
     * add all covariates to the query covariate list
     *
     * @param covariateList
     */
    public void addAllToCovariateList(List<Covariate> covariateList) {
        if (this.covariateList == null) {
            this.covariateList = new ArrayList<Covariate>();
        }

        // add
        this.queryLog.info("added covariates list of size: " + this.covariateList.size());
        this.covariateList.addAll(covariateList);
    }

    public List<Covariate> getCovariateList() {
        return covariateList;
    }
}
