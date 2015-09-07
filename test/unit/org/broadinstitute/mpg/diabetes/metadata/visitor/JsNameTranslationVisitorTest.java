package org.broadinstitute.mpg.diabetes.metadata.visitor;

import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;

/**
 * Created by mduby on 9/5/15.
 */
public class JsNameTranslationVisitorTest extends TestCase {

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testParseInputString() {
        // local variables
        String inputString = "T2D[ExSeq_17k_mdv2]P_FIRTH_FE_IV";
        String propertyName = "P_FIRTH_FE_IV";
        String phenotypeName = "T2D";
        String sampleGroupName = "ExSeq_17k_mdv2";
        JsNameTranslationVisitor visitor = new JsNameTranslationVisitor(inputString);

        // test
        assertNotNull(visitor.getPropertyName());
        assertNotNull(visitor.getPhenotypeName());
        assertNotNull(visitor.getSampleGroupName());
        assertEquals(propertyName, visitor.getPropertyName());
        assertEquals(phenotypeName, visitor.getPhenotypeName());
        assertEquals(sampleGroupName, visitor.getSampleGroupName());
    }

    @Test
    public void testParseInputString2() {
        // local variables
        String inputString = "FG[GWAS_MAGIC_mdv2]BETA";
        String propertyName = "BETA";
        String phenotypeName = "FG";
        String sampleGroupName = "GWAS_MAGIC_mdv2";
        JsNameTranslationVisitor visitor = new JsNameTranslationVisitor(inputString);

        // test
        assertNotNull(visitor.getPropertyName());
        assertNotNull(visitor.getPhenotypeName());
        assertNotNull(visitor.getSampleGroupName());
        assertEquals(propertyName, visitor.getPropertyName());
        assertEquals(phenotypeName, visitor.getPhenotypeName());
        assertEquals(sampleGroupName, visitor.getSampleGroupName());
    }

}
