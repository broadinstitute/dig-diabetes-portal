package org.broadinstitute.mpg.diabetes.metadata.parser

import junit.framework.TestCase
import org.broadinstitute.mpg.diabetes.metadata.*
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.diabetes.util.PortalException
import org.codehaus.groovy.grails.web.json.JSONException
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.json.JSONTokener
import org.junit.Before
import org.junit.Test

/**
 * Test class to test the json parsing service for the metadata objects
 */
class JsonParserTest extends TestCase {
    JsonParser jsonParser;
    String jsonString;

    @Before
    public void setUp() throws Exception {
        // set up the service
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream('metadata.json');
        this.jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);
    }

    public void testSetup() {
        assertNotNull(this.jsonParser);
        assertNotNull(this.jsonParser.getJsonMetadata());
    }

    @Test
    public void testParseExperiments() {
        // local variables
        List<Experiment> experimentList = new ArrayList<Experiment>();
        String jsonString = null;
        String simpleJsonString = "{\"experiments\": []}";
        JSONTokener tokener;
        JSONObject rootJson = null;
        MetaDataRootBean metaDataRootBean = new MetaDataRootBean();

        // get the json strong to test
        try {
            tokener = new JSONTokener(this.jsonString);
            rootJson = new JSONObject(tokener);

        } catch (FileNotFoundException exception) {
            fail("got file exception: " + exception.getMessage());
        } catch (JSONException exception) {
            fail("got json exception: " + exception.getMessage());
        }

        // parse the experiments
        try {
            this.jsonParser.parseExperiments(experimentList, rootJson, metaDataRootBean);

        } catch (PortalException exception) {
            fail("got json parsing exception: " + exception.getMessage());
        }

        // test size and non null of list
        assertNotNull(experimentList);
        assertTrue(experimentList.size() > 0);
        assertEquals(25, experimentList.size());

        // test the children dataset
        Experiment experiment = experimentList.get(0);
        assertNotNull(experiment);
        assertTrue(experiment.getSampleGroups().size() > 0);

        // test the grandchildren datasets
        SampleGroup sampleGroup = experiment.getSampleGroups().get(0);
        assertNotNull(sampleGroup);
        assertTrue(sampleGroup.getSampleGroups().size() > 0);
        assertTrue(sampleGroup.getRecursiveChildren().size() > sampleGroup.getSampleGroups().size());

        // get first child of sampe group; make sure it has parent
        DataSet firstChild = sampleGroup.getSampleGroups().get(0);
        assertNotNull(firstChild);
        assertNotNull(firstChild.getParent());

    }

    /**
     * test the get phenotype name list
     */
    @Test
    public void testGetAllDistinctPhenotypeNames() {
        // local variables
        List<Experiment> experimentList = new ArrayList<Experiment>();
        List<String> nameList = null;

        // get the phenotype name list
        try {
            nameList = this.jsonParser.getAllDistinctPhenotypeNames();

        } catch (PortalException exception) {
            fail("Got portal exception: " + exception.getMessage());
        }
        assertNotNull(nameList);
        assertTrue(nameList.size() > 0);
        assertEquals(29, nameList.size());

    }

    /**
     * test the get sample group name for phenotype name list
     */
    @Test
    public void testGetSamplesGroupsForPhenotype() {
        // local variables
        String phenotype = "T2D";
        List<SampleGroup> groupList = null;

        // get the phenotype name list
        try {
            groupList = this.jsonParser.getSamplesGroupsForPhenotype(phenotype, "mdv2");

        } catch (PortalException exception) {
            fail("Got portal exception: " + exception.getMessage());
        }
        assertNotNull(groupList);
        assertTrue(groupList.size() > 0);
        assertEquals(29, groupList.size());
    }

    /**
     * test retrieving the metadata root object
     */
    @Test
    public void testGetMetaDataRoot() {
        // local variables
        String jsonString = null;
        MetaDataRoot metaData = null;

        // get the phenotype name list
        try {
            metaData = this.jsonParser.getMetaDataRoot();

        } catch (PortalException exception) {
            fail("Got portal exception: " + exception.getMessage());
        }

        // test
        assertNotNull(metaData);
        assertNotNull(metaData.getExperiments());
        assertNotNull(metaData.getProperties());
        assertTrue(metaData.getExperiments().size() > 0);
        assertTrue(metaData.getProperties().size() > 0);
        assertEquals(25, metaData.getExperiments().size());
        assertEquals(13, metaData.getProperties().size());
    }

    /**
     * test for the search for the searchable property list for a sample group id
     *
     */
    @Test
    public void testGetSearchablePropertiesForSampleGroupId() {
        // local variables
        String sampleGroupId = "ExSeq_13k_hs_genes_mdv1";
        List<Property> propertyList;

        // search for the searchable properties
        propertyList = this.jsonParser.getSearchablePropertiesForSampleGroupId(sampleGroupId);

        // test
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(4, propertyList.size());

        // test sorting
        Collections.sort(propertyList);
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(4, propertyList.size());
        PropertyBean newBean;
        for (Property prop : propertyList) {
            PropertyBean secondBean = (PropertyBean)prop;
            if (newBean != null) {
                assertTrue(secondBean.getSortOrder() >= newBean.getSortOrder());
            }
            newBean = secondBean;
        }
    }

    /**
     * test the searchable property visitor result
     *
     */
    @Test
    public void testGetSearchableCommonProperties() {
        List<Property> propertyList;

        // get the common searchable properties
        propertyList = this.jsonParser.getSearchableCommonProperties();

        // test
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(10, propertyList.size());
    }

    /**
     * test searching for the GWAS sample group based on phenotype
     *
     */
    @Test
    public void testGetGwasSampleGroupNameForPhenotype() {
        String sampleGroupName;
        String phenotypeName = "UACR";

        // get the sample group
        sampleGroupName = this.jsonParser.getGwasSampleGroupNameForPhenotype(phenotypeName);

        // test
        assertNotNull(sampleGroupName);
        assertEquals("CKDGenConsortium", sampleGroupName);
    }

    @Test
    public void testGetSearchablePropertiesForSampleGroupAndChildren() {
        String sampleGroupId = "GWAS_MAGIC_mdv2";
        List<String> propertyNameList;

        // get the searchable property list from the parser
        propertyNameList = this.jsonParser.getSearchablePropertiesForSampleGroupAndChildren(sampleGroupId);

        // test
        assertNotNull(propertyNameList);
        assertTrue(propertyNameList.size() > 0);
        assertEquals(4, propertyNameList.size());
    }

    @Test
    public void testFindPropertyByName() {
        // local variables
        String propertyName = "SE";
        Property property;
        String correctFilter = "{\"dataset_id\": \"ExSeq_13k_aa_genes_mdv1\", \"phenotype\": \"BMI\", \"operand\": \"SE\", \"operator\": \"<\", \"value\": 45, \"operand_type\": \"FLOAT\"}";
        String generatedFilter;

        // find the property
        property = this.jsonParser.findPropertyByName(propertyName);
        generatedFilter  = property.getWebServiceFilterString("<", "45");

        // test
        assertNotNull(property);
        assertEquals(propertyName, property.getName());
        assertNotNull(generatedFilter);
        assertEquals(correctFilter, generatedFilter);
    }

    @Test
    public void testGetMapOfAllDataSetNodes() {
        // local variables
        Map<String, DataSet> dataSetMap = null;

        // get the map
        try {
            dataSetMap = this.jsonParser.getMapOfAllDataSetNodes();

        } catch (PortalException exception) {
            fail("got data set map error: " + exception.getMessage());
        }

        // test
        assertNotNull(dataSetMap);
        assertTrue(dataSetMap.size() > 0);
        assertEquals(3088, dataSetMap.size());
    }

    @Test
    void testGetPropertyListOfPropertyType() {
        // local variables
        List<Property> propertyList = null;
        String tempString = "";

        // get the common properties
        propertyList = this.jsonParser.getPropertyListOfPropertyType(this.jsonParser.getMetaDataRoot(), PortalConstants.TYPE_COMMON_PROPERTY_KEY);

        // test
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(13, propertyList.size());

        // get the sample group properties
        propertyList = this.jsonParser.getPropertyListOfPropertyType(this.jsonParser.getMetaDataRoot(), PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY);

        // USED TO CAPTURE PROPERTY ID
        for (Property property: propertyList) {
            tempString = property.getId();
            System.out.println(tempString);
        }

        // test
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(225, propertyList.size());

        // get the phenotype properties
        propertyList = this.jsonParser.getPropertyListOfPropertyType(this.jsonParser.getMetaDataRoot(), PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY);

        // USED TO CAPTURE PROPERTY ID
        /*
        for (Property property: propertyList) {
            tempString = property.getId();
            System.out.println(tempString);
        }
        */

        // test
        assertNotNull(propertyList);
        assertTrue(propertyList.size() > 0);
        assertEquals(2362, propertyList.size());
    }

    @Test
    void testGetPropertyFromJavaScriptNamingScheme() {
        // local variables
        Property property;
        String inputJsName, expectedPropertyId;

        try {
            // set the variables
            inputJsName = "T2D[ExSeq_17k_mdv2]P_FIRTH_FE_IV";
            expectedPropertyId = "metadata_root_ExSeq_17k_mdv2_17kT2DP_FIRTH_FE_IV";

            // get the property
            property = this.jsonParser.getPropertyFromJavaScriptNamingScheme(inputJsName);

            // test
            assertNotNull(property);
            assertEquals(expectedPropertyId, property.getId());

        } catch (PortalException exception) {
            fail("got exception finding property: " + inputJsName + ": " + exception.getMessage());
        }

        try {
            // set the variables
            inputJsName = "HOMAB[GWAS_MAGIC_mdv2]MAF";
            expectedPropertyId = "metadata_root_GWAS_MAGIC_mdv2_MAGICMAF";

            // get the property
            property = this.jsonParser.getPropertyFromJavaScriptNamingScheme(inputJsName);

            // test
            assertNotNull(property);
            assertEquals(expectedPropertyId, property.getId());

        } catch (PortalException exception) {
            fail("got exception finding property: " + inputJsName + ": " + exception.getMessage());
        }

        try {
            // set the variables
            inputJsName = "HOMAB[GWAS_MAGIC_mdv1]MAF";
            expectedPropertyId = "metadata_root_GWAS_MAGIC_mdv1_MAGICMAF";

            // get the property
            property = this.jsonParser.getPropertyFromJavaScriptNamingScheme(inputJsName);

            // test
            assertNotNull(property);
            assertEquals(expectedPropertyId, property.getId());

        } catch (PortalException exception) {
            fail("got exception finding property: " + inputJsName + ": " + exception.getMessage());
        }

        try {
            // set the variables
            inputJsName = "FG[GWAS_MAGIC_mdv2]BETA";
            expectedPropertyId = "metadata_root_GWAS_MAGIC_mdv2_MAGICFGBETA";

            // get the property
            property = this.jsonParser.getPropertyFromJavaScriptNamingScheme(inputJsName);

            // test
            assertNotNull(property);
            assertEquals(expectedPropertyId, property.getId());

        } catch (PortalException exception) {
            fail("got exception finding property: " + inputJsName + ": " + exception.getMessage());
        }
    }

    @Test
    public void testGetImmediateChildrenOfType() {
        // local variables
        List<DataSet> childList = null;
        DataSet rootDataSet = null;

        // get the 26k root data set to search from
        rootDataSet = this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_26k_ID);
        assertNotNull(rootDataSet);

        // get the children
        childList = this.jsonParser.getImmediateChildrenOfType(rootDataSet, PortalConstants.TYPE_SAMPLE_GROUP_KEY);

        // test
        assertNotNull(childList);
        assertTrue(childList.size() > 0);
        assertEquals(5, childList.size());

        // get the 26k root data set to search from
        rootDataSet = this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.BURDEN_SAMPLE_GROUP_ROOT_13k_ID);
        assertNotNull(rootDataSet);

        // get the children
        childList = this.jsonParser.getImmediateChildrenOfType(rootDataSet, PortalConstants.TYPE_SAMPLE_GROUP_KEY);

        // test
        assertNotNull(childList);
        assertTrue(childList.size() > 0);
        assertEquals(5, childList.size());
    }
}
