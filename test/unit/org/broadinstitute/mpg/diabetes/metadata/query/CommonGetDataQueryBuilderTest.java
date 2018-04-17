package org.broadinstitute.mpg.diabetes.metadata.query;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.metadata.Phenotype;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.util.PortalException;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.List;
import java.util.Scanner;

/**
 * Test class to test the common query builder
 *
 */
public class CommonGetDataQueryBuilderTest extends TestCase {
    // local variables
    JsonParser jsonParser;
    CommonGetDataQueryBuilder commonGetDataQueryBuilder;

    @Before
    public void setUp() throws Exception {
        // set the json builder
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream("../parser/metadata.json");
        String jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(jsonString);

        // set up the query builder
        this.commonGetDataQueryBuilder = new CommonGetDataQueryBuilder();
    }

    @Test
    public void testSetup() {
        try {
            assertNotNull(this.jsonParser);
            assertNotNull(this.jsonParser.getMetaDataRoot());
        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }
    }

    @Test
    public void testGetDataQueryForPhenotypeAndPosition() {
        // local variables
        GetDataQuery getDataQuery = null;
        Phenotype phenotype = null;

        try {
            // get the phenotype to test
            List<Phenotype> phenotypeList = this.jsonParser.getPhenotypeListByTechnologyAndVersion("GWAS", "mdv2");
            if (phenotypeList.size() > 0) {
                phenotype = phenotypeList.get(0);

            } else {
                fail("Got no phenotypes for gwas/mdv2 search");
            }

            // get the query
            getDataQuery = this.commonGetDataQueryBuilder.getDataQueryForPhenotype(phenotype, "9", 1000000, 2000000, "0.005");

        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }

        // test
        assertNotNull(getDataQuery);
        assertTrue(getDataQuery.getFilterList().size() > 0);
        assertTrue(getDataQuery.getQueryPropertyList().size() > 0);
        assertEquals(4, getDataQuery.getFilterList().size());
        assertEquals(18, getDataQuery.getQueryPropertyList().size());
    }

    @Test
    public void testGetDataQueryForPhenotype() {
        // local variables
        GetDataQuery getDataQuery = null;
        Phenotype phenotype = null;

        try {
            // get the phenotype to test
            List<Phenotype> phenotypeList = this.jsonParser.getPhenotypeListByTechnologyAndVersion("GWAS", "mdv31");
            if (phenotypeList.size() > 0) {
                phenotype = phenotypeList.get(0);

            } else {
                fail("Got no phenotypes for gwas/mdv2 search");
            }

            // get the query
            getDataQuery = this.commonGetDataQueryBuilder.getDataQueryForPhenotype(phenotype, "0.005");

        } catch (PortalException exception) {
            fail("Got error: " + exception.getMessage());
        }

        // test
        assertNotNull(getDataQuery);
        assertTrue(getDataQuery.getFilterList().size() > 0);
        assertTrue(getDataQuery.getQueryPropertyList().size() > 0);
        assertEquals(1, getDataQuery.getFilterList().size());
        assertEquals(18, getDataQuery.getQueryPropertyList().size());
    }
}
