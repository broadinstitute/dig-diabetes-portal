package org.broadinstitute.mpg.diabetes.metadata.query;

import junit.framework.TestCase;
import org.broadinstitute.mpg.diabetes.metadata.Property;
import org.broadinstitute.mpg.diabetes.metadata.parser.JsonParser;
import org.broadinstitute.mpg.diabetes.metadata.sort.PropertyListForQueryComparator;
import org.broadinstitute.mpg.diabetes.util.PortalConstants;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

/**
 * Created by mduby on 8/27/15.
 */
public class QueryJsonBuilderTest extends TestCase {
    // instance variables
    QueryJsonBuilder queryJsonBuilder;
    JsonParser jsonParser;
    List<Property> propertyList;
    String jsonString;

    @Before
    public void setUp() throws Exception {
        this.queryJsonBuilder = QueryJsonBuilder.getQueryJsonBuilder();
        this.jsonParser = JsonParser.getService();
        InputStream inputStream = getClass().getResourceAsStream("../parser/metadata.json");
        this.jsonString = new Scanner(inputStream).useDelimiter("\\A").next();
        this.jsonParser.setJsonString(this.jsonString);

        // build map and populate it for the tests
        this.propertyList = new ArrayList<Property>();
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CLOSEST_GENE));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_CONSEQUENCE));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_DBSNP_ID));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_POSITION));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_COMMON_VAR_ID));

        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_SG_MAF_82K));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_SG_MAF_SIGMA1));

        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_MINA_SIGMA1_T2D));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_MINU_SIGMA1_T2D));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_OR_FIRTH_SIGNA1_T2D));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_P_VALUE_82K_T2D));
        this.propertyList.add((Property)this.jsonParser.getMapOfAllDataSetNodes().get(PortalConstants.PROPERTY_KEY_PH_P_VALUE_GWAS_DIAGRAM));

        // sort the list
        Collections.sort(this.propertyList, new PropertyListForQueryComparator());
    }

    @Test
    public void testGetCpropertiesString() {
        // local variables
        String compareString = "\"cproperty\": [ \"CHROM\" , \"CLOSEST_GENE\" , \"Consequence\" , \"DBSNP_ID\" , \"POS\" , \"VAR_ID\"], ";
        String generatedString = null;

        // generate the string
        generatedString = this.queryJsonBuilder.getCpropertiesString(this.propertyList);

        // test
        assertNotNull(generatedString);
        assertTrue(generatedString.length() > 0);
        assertEquals(compareString, generatedString);
    }
}