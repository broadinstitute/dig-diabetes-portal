package org.broadinstitute.mpg.diabetes.metadata.parser

import junit.framework.TestCase
import org.broadinstitute.mpg.diabetes.metadata.*
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
        List<String> nameList = null;

        // get the phenotype name list
        try {
            nameList = this.jsonParser.getSamplesGroupsForPhenotype(phenotype);

        } catch (PortalException exception) {
            fail("Got portal exception: " + exception.getMessage());
        }
        assertNotNull(nameList);
        assertTrue(nameList.size() > 0);
        assertEquals(69, nameList.size());
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
}
