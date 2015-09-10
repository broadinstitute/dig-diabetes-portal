package org.broadinstitute.mpg.diabetes.metadata.parser;

import org.broadinstitute.mpg.diabetes.metadata.DataSet;
import org.broadinstitute.mpg.diabetes.metadata.Experiment;
import org.broadinstitute.mpg.diabetes.metadata.ExperimentBean;
import org.broadinstitute.mpg.diabetes.metadata.MetaDataRoot;
import org.broadinstitute.mpg.diabetes.metadata.MetaDataRootBean;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup;
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean;
import org.broadinstitute.mpg.diabetes.metadata.visitor.AllDataSetHashSetVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.DataSetDirectChildByTypeVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.ExperimentByVersionVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.GwasTechSampleGroupByPhenotypeVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.JsNameTranslationVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.PhenotypeByNameVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.PhenotypeNameVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.PropertyByNameFinderVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.PropertyByPropertyTypeVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.PropertyPerExperimentVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.SampleGroupByIdSelectingVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.SampleGroupForPhenotypeVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.SearchableCommonPropertyVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.SearchablePropertyIncludingChildrenVisitor;
import org.broadinstitute.mpg.diabetes.metadata.visitor.SearchablePropertyVisitor;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.codehaus.groovy.grails.web.json.JSONTokener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

/**
 * Class to parse the json input string into a metadata tree structure
 *
 */
public class JsonParser {
    // static singleton
    private static JsonParser service;

    // private cached results
    private MetaDataRoot metaDataRoot = null;
    private String jsonString;

    // cached data set map
    Map<String, DataSet> dataSetMap = new HashMap<String, DataSet>();

    /**
     * singleton service to parse metadata
     * @return
     */
    public static JsonParser getService() {
        if (service == null) {
            service = new JsonParser();
        }

        return service;
    }


    /**
     * return all the experiments in the metadata chache
     *
     * @return                  all the experiments in the metadata chache
     */
    /*
    public List<Experiment> getAllExperiments() {
        // check to see if the experiments are already loaded
        if (this.metaDataRoot == null) {
            // load the json
            this.metaDataRoot = new MetaDataRootBean();

            try {
                // get the metadata root experiment
                this.parseExperiments(this.metaDataRoot.getExperiments());


            } catch (PortalException exception) {
                // TODO - message
                Log.e(this.getClass().getName(), "Got portal exception loading experiments: " + exception.getMessage());
            }
        }

        // return
        return this.metaDataRootBean.getExperiments();
    }
    */

    /**
     * returns the root object containing the parsed json onformation
     *
     * @return
     */
    public MetaDataRoot getMetaDataRoot() throws PortalException {
        if (this.metaDataRoot == null) {
            // create a new metadata root object
            this.metaDataRoot = this.populateMetaDataRoot();
        }

        return metaDataRoot;
    }

    /**
     * force a reload of the metadata, normally after having reset the metadata string to parse
     *
     * @throws PortalException
     */
    public void forceMetadataReload(String jsonString) throws PortalException {
        this.jsonString = jsonString;
        this.metaDataRoot = this.populateMetaDataRoot();
        this.dataSetMap.clear();
    }

    /**
     * create and populate the metadata root object from the given json string
     *
     * @return
     * @throws PortalException
     */
    protected MetaDataRoot populateMetaDataRoot() throws PortalException {
        // local variables
        String jsonString;
        JSONTokener tokener;
        JSONObject rootJson;
        MetaDataRootBean metaDataBean = new MetaDataRootBean();
        JSONArray tempArray;
        Property tempProperty;

        // parse the json
        try {
            // get the json string
            jsonString = this.getJsonMetadata();

            // create the tokener
            tokener = new JSONTokener(jsonString);

            // create the json object from the string
            rootJson = new JSONObject(tokener);

            // parse the experiments
            this.parseExperiments(metaDataBean.getExperiments(), rootJson, metaDataBean);

            // parse the common properties
            // get the sub properties
            tempArray = rootJson.getJSONArray(PortalConstants.JSON_PROPERTIES_KEY);
            for (int i = 0; i < tempArray.length(); i++) {
                tempProperty = this.createPropertyFromJson(tempArray.getJSONObject(i), metaDataBean);
                metaDataBean.getProperties().add(tempProperty);
            }

        } catch (JSONException exception) {
            throw new PortalException("Got error creating metadata root: " + exception.getMessage());
        }

        return metaDataBean;
    }

    /**
     * return all the distinct phenotype names in the metadata
     *
     * @return
     */
    public List<String> getAllDistinctPhenotypeNames() throws PortalException {
        // instance variables
        HashSet<String> hashSet = new HashSet<String>();
        PhenotypeNameVisitor visitor = new PhenotypeNameVisitor();
        List<String> nameList;

        // go through tree and add in any phenotype names
        for (Experiment experiment : this.getMetaDataRoot().getExperiments()) {
            experiment.acceptVisitor(visitor);
        }
        hashSet = visitor.getResultSet();

        // convert the set to a list
        nameList = new ArrayList<String>();
        nameList.addAll(hashSet);

        // sort the list
        Collections.sort(nameList);

        // return the list
        return nameList;
    }

    public List<Property> getAllPropertiesWithNameForExperimentOfVersion(String propertyName, String version, String technology) throws PortalException {
        List<Property> propertyList = new ArrayList<Property>();
        List<Experiment> experimentList;
        List<Property> finalPropertyList = new ArrayList<Property>();

        // find the experiment
        ExperimentByVersionVisitor experimentVisitor = new ExperimentByVersionVisitor(version);
        this.getMetaDataRoot().acceptVisitor(experimentVisitor);
        experimentList = experimentVisitor.getExperimentList();

        // for experiment, find the property list
        for (Experiment experiment : experimentList) {
            if (experiment.getTechnology().equalsIgnoreCase(technology)){
                PropertyPerExperimentVisitor propertyPerExperimentVisitor = new PropertyPerExperimentVisitor(propertyName);
                experiment.acceptVisitor(propertyPerExperimentVisitor);
                propertyList = propertyPerExperimentVisitor.getPropertyList();
                finalPropertyList.addAll(propertyList);
            }
        }

        return finalPropertyList;
    }


    public List<Phenotype> getAllPhenotypesWithName(String phenotypeName, String version, String technology) throws PortalException {
        List<Phenotype> phenotypeList = new ArrayList<Phenotype>();
        List<Experiment> experimentList;
        List<Phenotype> finalPhenotypeList = new ArrayList<Phenotype>();

        // find the experiment
        ExperimentByVersionVisitor experimentVisitor = new ExperimentByVersionVisitor(version);
        this.getMetaDataRoot().acceptVisitor(experimentVisitor);
        experimentList = experimentVisitor.getExperimentList();

        // for experiment, find the property list
        for (Experiment experiment : experimentList) {
            if ((technology != null) && (technology.length()>0)) { // we are filtering on technology
                if (experiment.getTechnology().equalsIgnoreCase(technology)){
                    PhenotypeByNameVisitor phenotypeByNameVisitor = new PhenotypeByNameVisitor(phenotypeName);
                    experiment.acceptVisitor(phenotypeByNameVisitor);
                    phenotypeList = phenotypeByNameVisitor.getPhenotypeList();
                    finalPhenotypeList.addAll(phenotypeList);
                }
            } else { // any old technology is good
                PhenotypeByNameVisitor phenotypeByNameVisitor = new PhenotypeByNameVisitor(phenotypeName);
                experiment.acceptVisitor(phenotypeByNameVisitor);
                phenotypeList = phenotypeByNameVisitor.getPhenotypeList();
                finalPhenotypeList.addAll(phenotypeList);
            }
        }

        return finalPhenotypeList;
    }

    /**
     * get the json metadata
     *
     * @return
     */
    protected String getJsonMetadata() throws PortalException {
        if (this.jsonString == null) {
         throw new PortalException("the metadata json string has not been set");
        }

        return this.jsonString;
    }

    /**
     * method to return a list of experiments from the json string
     *
     * @param experimentList                a not null experiment list
     * @throws PortalException              if there are any errors
     */
    protected void parseExperiments(List<Experiment> experimentList, JSONObject rootJson, DataSet parent) throws PortalException {
        // local variables
        JSONObject tempJson;
        JSONArray experimentArray, dataSetArray;
        SampleGroup sampleGroup;

        try {
            // get the array of experiments
            experimentArray = rootJson.getJSONArray(PortalConstants.JSON_EXPERIMENT_KEY);

            // reinitialize the experiment list
            experimentList.clear();

            // build the experiments
            for (int i = 0; i < experimentArray.length(); i++) {
                tempJson = experimentArray.getJSONObject(i);
                ExperimentBean experiment = new ExperimentBean();
                experiment.setName(tempJson.getString(PortalConstants.JSON_NAME_KEY));
                experiment.setTechnology(tempJson.getString(PortalConstants.JSON_TECHNOLOGY_KEY));
                experiment.setVersion(tempJson.getString(PortalConstants.JSON_VERSION_KEY));
                experimentList.add(experiment);
                experiment.setParent(parent);

                // look for sample groups
                dataSetArray = tempJson.getJSONArray(PortalConstants.JSON_DATASETS_KEY);
                for (int j = 0; j < dataSetArray.length(); j++) {
                    // for each dataset, create a dataset object and add to experiment
                    sampleGroup = this.createSampleGroupFromJson(dataSetArray.getJSONObject(j), experiment);
                    experiment.getSampleGroups().add(sampleGroup);
                }
            }

        } catch (JSONException exception) {
            // log error if need be, convert exception
            throw new PortalException(exception.getMessage());
        }
    }

    /**
     * create and add dataset from json object
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    protected SampleGroup createSampleGroupFromJson(JSONObject jsonObject, DataSet parent) throws PortalException {
        // local variables
        SampleGroupBean sampleGroup = new SampleGroupBean();
        JSONArray tempArray;
        SampleGroup tempSampleGroup;
        Property tempProperty;
        Phenotype tempPhenotype;
        String tempJsonValue;

        try {
            // create the object and add the primitive variables
            sampleGroup.setName(jsonObject.getString(PortalConstants.JSON_NAME_KEY));
            sampleGroup.setAncestry(jsonObject.getString(PortalConstants.JSON_ANCESTRY_KEY));
            sampleGroup.setSystemId(jsonObject.getString(PortalConstants.JSON_ID_KEY));
            sampleGroup.setParent(parent);

            // add in sort order
            tempJsonValue = jsonObject.getString(PortalConstants.JSON_SORT_ORDER_KEY);
            if (tempJsonValue != null) {
                sampleGroup.setSortOrder(Float.valueOf(tempJsonValue).intValue());
            }

            // add in properties
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_PROPERTIES_KEY);
            for (int i = 0; i < tempArray.length(); i++) {
                tempProperty = this.createPropertyFromJson(tempArray.getJSONObject(i), sampleGroup);
                sampleGroup.getProperties().add(tempProperty);
            }

            // add in phenotypes
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_PHENOTYPES_KEY);
            for (int i = 0; i < tempArray.length(); i++) {
                tempPhenotype = this.createPhenotypeFromJson(tempArray.getJSONObject(i), sampleGroup);
                sampleGroup.getPhenotypes().add(tempPhenotype);
            }

            // recursively add in any other child sample groups
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_DATASETS_KEY);
            for (int i = 0; i < tempArray.length(); i++) {
                tempSampleGroup = this.createSampleGroupFromJson(tempArray.getJSONObject(i), sampleGroup);
                sampleGroup.getSampleGroups().add(tempSampleGroup);
            }

        } catch (JSONException exception) {
            throw new PortalException("Got error creating dataSet: " + exception.getMessage());
        }

        // return the object
        return sampleGroup;
    }

    /**
     * create a property object from the json object handed in
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    protected Property createPropertyFromJson(JSONObject jsonObject, DataSet parent) throws PortalException {
        // local variables
        PropertyBean property = new PropertyBean();
        String tempJsonValue;

        // get values and put in new object
        try {
            property.setName(jsonObject.getString(PortalConstants.JSON_NAME_KEY));
            property.setVariableType(jsonObject.getString(PortalConstants.JSON_TYPE_KEY));
            tempJsonValue = jsonObject.getString(PortalConstants.JSON_SEARCHABLE_KEY);
            if (tempJsonValue != null) {
                property.setSearchable(Boolean.valueOf(tempJsonValue));
            }
            tempJsonValue = jsonObject.getString(PortalConstants.JSON_SORT_ORDER_KEY);
            if (tempJsonValue != null) {
                property.setSortOrder(Float.valueOf(tempJsonValue).intValue());
            }
            property.setParent(parent);

        } catch (JSONException exception) {
            throw new PortalException("Got property building exception: " + exception.getMessage());
        }

        return property;
    }

    /**
     * create a phenotype object from a given json object
     *
     * @param jsonObject
     * @return
     * @throws PortalException
     */
    protected Phenotype createPhenotypeFromJson(JSONObject jsonObject, DataSet parent) throws PortalException {
        // local variables
        PhenotypeBean phenotype = new PhenotypeBean();
        JSONArray tempArray;
        Property tempProperty;
        String tempJsonValue;

        // get values from json object and put in new phenotype object
        try {
            // get the primitive variables
            phenotype.setName(jsonObject.getString(PortalConstants.JSON_NAME_KEY));
            phenotype.setGroup(jsonObject.getString(PortalConstants.JSON_GROUP_KEY));
            tempJsonValue = jsonObject.getString(PortalConstants.JSON_SORT_ORDER_KEY);
            if (tempJsonValue != null) {
                phenotype.setSortOrder(Float.valueOf(tempJsonValue).intValue());
            }

            phenotype.setParent(parent);

            // get the sub properties
            tempArray = jsonObject.getJSONArray(PortalConstants.JSON_PROPERTIES_KEY);
            for (int i = 0; i < tempArray.length(); i++) {
                tempProperty = this.createPropertyFromJson(tempArray.getJSONObject(i), phenotype);
                phenotype.getProperties().add(tempProperty);
            }

        } catch (JSONException exception) {
            throw new PortalException("Got phenotype parsing error: " + exception.getMessage());
        }

        return phenotype;
    }

    /**
     * returns a sorted list of the names of sample groups that contain the given phenotype
     *
     * @param phenotypeName
     * @return
     */
    public List<SampleGroup> getSamplesGroupsForPhenotype(String phenotypeName, String dataVersion) throws PortalException {
        // local variables
        SampleGroupForPhenotypeVisitor sampleGroupVisitor = new SampleGroupForPhenotypeVisitor(phenotypeName);
        List<SampleGroup> groupList;

        // pass in visitor looking for sample groups with the selected phenotype
        for (Experiment experiment: this.getMetaDataRoot().getExperiments()) {
            // if no version, then go through all experiments
            if (dataVersion == null) {
                experiment.acceptVisitor(sampleGroupVisitor);

            // if version, first filter experiment on version
            } else {
                if (experiment.getVersion().equalsIgnoreCase(dataVersion)) {
                    experiment.acceptVisitor(sampleGroupVisitor);
                }
            }
        }

        // return the resulting string list
        groupList = sampleGroupVisitor.getSampleGroupList();

        return groupList;
    }

    /**
     * returns the list of searchable properties for a given sample group id
     *
     * @param sampleGroupId
     * @return
     * @throws PortalException
     */
    public List<Property> getSearchablePropertiesForSampleGroupId(String sampleGroupId) throws PortalException {
        // local variables
        List<Property> propertyList = new ArrayList<Property>();
        SampleGroup sampleGroup;

        // find the sample group
        // create the visitor
        SampleGroupByIdSelectingVisitor finderVisitor = new SampleGroupByIdSelectingVisitor(sampleGroupId);

        // visit the metadata root
        this.getMetaDataRoot().acceptVisitor(finderVisitor);
        sampleGroup = finderVisitor.getSampleGroup();

        // get the list of searchable properties for the sample group
        if (sampleGroup != null) {
            // create new searchable property visitor
           SearchablePropertyVisitor propertyVisitor = new SearchablePropertyVisitor();

            // visit the sample group
            sampleGroup.acceptVisitor(propertyVisitor);

            // get the list back
            propertyList = propertyVisitor.getPropertyList();
        }

        // return the list
        return propertyList;
    }

    /*
    protected JSONArray extractArrayFromJson(final JSONObject jsonObject, final String key) throws JSONException {
        final JSONArray jsonArray =  jsonObject.getJSONArray(key);
    }
    */

    public void setJsonString(String jsonString) {
        this.jsonString = jsonString;
    }

    /**
     * return the searchable common properties
     *
     * @return
     * @throws PortalException
     */
    public List<Property> getSearchableCommonProperties() throws PortalException {
        // local variables
        List<Property> commonPropertyList;

        // get the searchable common property visitor
        SearchableCommonPropertyVisitor visitor = new SearchableCommonPropertyVisitor();

        // set the visitor on the metadata root
        this.getMetaDataRoot().acceptVisitor(visitor);

        // get the common property list
        commonPropertyList = visitor.getProperties();

        // return the result
        return commonPropertyList;
    }

    /**
     * return the GWAS first level sample group with the phenotype name
     *
     * @param phenotypeString
     * @return
     * @throws PortalException
     */
    public String getGwasSampleGroupNameForPhenotype(String phenotypeString) throws PortalException {
        // local variables
        String sampleGroupName;

        // get the gwas phenotype visitor
        GwasTechSampleGroupByPhenotypeVisitor visitor = new GwasTechSampleGroupByPhenotypeVisitor(phenotypeString);

        // set the visitor on the metadata root
        this.getMetaDataRoot().acceptVisitor(visitor);

        // retrieve the sample group name and return
        sampleGroupName = visitor.getSampleGroupName();
        return sampleGroupName;
    }

    /**
     * find all the seaechable properties for a sample group and all its children
     *
     * @param sampleGroupId
     * @return
     * @throws PortalException
     */
    public List<String> getSearchablePropertiesForSampleGroupAndChildren(String sampleGroupId) throws PortalException {
        // local variables
        SampleGroup sampleGroup;
        List<String> propertyNameList = new ArrayList<String>();

        // find the sample group
        SampleGroupByIdSelectingVisitor finderVisitor = new SampleGroupByIdSelectingVisitor(sampleGroupId);
        this.getMetaDataRoot().acceptVisitor(finderVisitor);
        sampleGroup = finderVisitor.getSampleGroup();

        // if the sample group exists, find all searchable properties
        if (sampleGroup != null) {
            SearchablePropertyIncludingChildrenVisitor propertyVisitor = new SearchablePropertyIncludingChildrenVisitor();
            sampleGroup.acceptVisitor(propertyVisitor);
            propertyNameList = propertyVisitor.getDistinctPropertyNameList();
        }

        // return the property string
        return propertyNameList;
    }

    /**
     * find the first property by its name
     *
     * @param propertyName
     * @return
     * @throws PortalException
     */
    public Property findPropertyByName(String propertyName) throws PortalException {
        Property property;

        // create the visitor and traverse from root
        PropertyByNameFinderVisitor propertyVisitor = new PropertyByNameFinderVisitor(propertyName);
        this.getMetaDataRoot().acceptVisitor(propertyVisitor);

        // get the property
        property = propertyVisitor.getProperty();

        // return
        return property;
    }

    /**
     * method to build the map of all data set nodes
     *
     * @return
     * @throws PortalException
     */
    public Map<String, DataSet> getMapOfAllDataSetNodes() throws PortalException {
        if ((this.dataSetMap == null) || (this.dataSetMap.size() < 1)) {
            // local variables
            Map<String, DataSet> dataSetMap = null;

            // create the visitor
            AllDataSetHashSetVisitor visitor = new AllDataSetHashSetVisitor();

            // visit the metadata root
            this.getMetaDataRoot().acceptVisitor(visitor);

            // make sure there were no errors
            if (visitor.getError() != null) {
                throw new PortalException("there was a duplicate map key: " + visitor.getError());
            }

            // if not, then get map
            dataSetMap = visitor.getDataSetMap();

            // set the dataSetMap
            this.dataSetMap = dataSetMap;
        }

        // return the map
        return this.dataSetMap;
    }

    /**
     * returns a list of all the properties of a given type
     *
     * @param propertyType
     * @return
     * @throws PortalException
     */
    public List<Property> getPropertyListOfPropertyType(DataSet dataSetNodeToStartFrom, String propertyType) throws PortalException {
        // local variables
        List<Property> propertyList = null;

        // create the visitor
        PropertyByPropertyTypeVisitor visitor = new PropertyByPropertyTypeVisitor(propertyType);

        // visit the metadata root
        dataSetNodeToStartFrom.acceptVisitor(visitor);

        // get the property list
        propertyList = visitor.getPropertyList();

        // return
        return propertyList;
    }

    /**
     * retrieve a property based on the JS naming schema
     *
     * @param jsNameString
     * @return
     * @throws PortalException
     */
    public Property getPropertyFromJavaScriptNamingScheme(String jsNameString) throws PortalException {
        // local variables
        Property property;

        // create the visitor
        JsNameTranslationVisitor visitor = new JsNameTranslationVisitor(jsNameString);

        // visit the root bean
        this.getMetaDataRoot().acceptVisitor(visitor);

        // get the property from the visitor
        property = visitor.getProperty();

        // return the property
        return property;
    }

    /**
     * get the list of immediate children of a certain type for a given data set node
     *
     * @param rootDataSet
     * @param childrenType
     * @return
     * @throws PortalException
     */
    public List<DataSet> getImmediateChildrenOfType(DataSet rootDataSet, String childrenType) throws PortalException {
        // local variables
        List<DataSet> childSet;

        // create the visitor
        DataSetDirectChildByTypeVisitor visitor = new DataSetDirectChildByTypeVisitor(childrenType);
        rootDataSet.acceptVisitor(visitor);

        // get the list of children
        childSet = visitor.getDataSetList();

        // return
        return childSet;
    }
}
