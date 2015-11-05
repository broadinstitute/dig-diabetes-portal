package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.MetadataUtilityService
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.After
import org.junit.Before
import spock.lang.Unroll

/**
 * Created by ben on 8/31/2014.
 */
@Unroll
class RestServerServiceIntegrationSpec  extends IntegrationSpec {
    RestServerService restServerService
    SharedToolsService sharedToolsService
    MetaDataService metaDataService // Initialize metadata if necessary
    MetadataUtilityService metadataUtilityService

    @Before
    void setup() {
        metaDataService.getCommonPropertiesAsJson(false)
    }

    @After
    void tearDown() {

    }



    void "test retrieveTraitAsSpecifiedByGenomicRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchForTraitBySpecifiedRegion("9","21940000","22190000")
        then:
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }


    void "test retrieveGeneInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveGeneInfoByName("PANX1")
        then:
        assert jsonObject
        jsonObject["is_error"] == false

    }

    void "test retrieveVariantInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveVariantInfoByName("rs13266634")
        then:
        assert jsonObject
        jsonObject["is_error"] == false
    }


    @Unroll("testing  requestGeneCountByPValue with #label")
    void "test requestGeneCountByPValue"() {
        when:
        JSONObject jsonObject = restServerService.requestGeneCountByPValue("PTEN",significance,dataset)

        then:
        assert jsonObject
        jsonObject["is_error"] == false

        where:
        label                       | significance      |   dataset
        "query exome seq all"       |   0.001           |   RestServerService.TECHNOLOGY_EXOME_SEQ
        "query exome chip gws"      |   0.005           |   RestServerService.TECHNOLOGY_EXOME_CHIP
        "query gwas locus sig"      |   0.000005        |   RestServerService.TECHNOLOGY_GWAS
        "query exome seq nominal"   |   0.5             |   RestServerService.TECHNOLOGY_EXOME_SEQ

    }


    void "test combinedVariantAssociationStatistics"() {
        when:
        JSONObject jsonObject = restServerService.combinedVariantAssociationStatistics("rs13266634")
        then:
        assert jsonObject
    }





    void "test howCommonIsVariantAcrossEthnicities"() {
        when:
        JSONObject jsonObject = restServerService.howCommonIsVariantAcrossEthnicities("rs13266634")
        then:
        assert jsonObject
    }



    void "test combinedVariantDiseaseRisk"() {
        when:
        JSONObject jsonObject = restServerService.combinedVariantDiseaseRisk("rs13266634")
        then:
        assert jsonObject
    }



    void "test combinedEthnicityTable"() {
        when:
        JSONObject jsonObject = restServerService.combinedEthnicityTable("FAT1")
        then:
        assert jsonObject
    }



    void "test gatherProteinEffect"() {
        when:
        JSONObject jsonObject = restServerService.gatherProteinEffect("rs13266634")
        then:
        assert jsonObject
    }




    void "test getTraitPerVariant"() {
        when:
        JSONObject jsonObject = restServerService.getTraitPerVariant("rs13266634")
        then:
        assert jsonObject
    }





    @Unroll("testing  extractNumbersWeNeed with #label")
    void "test extractNumbersWeNeed"() {

        setup:
        restServerService.sharedToolsService = sharedToolsService

        when:
        LinkedHashMap<String, String> result = restServerService.extractNumbersWeNeed(incoming)

        then:
        result["chromosomeNumber"]  == chromosomeNumber
        result["startExtent"]  == startExtentNumber
        result["endExtent"]  == endExtentNumber


        where:
        label                       | incoming                          | chromosomeNumber  |   startExtentNumber   |   endExtentNumber
        "extents have commas"       | 'chr9:21,940,000-22,190,000'      |   "9"             |   "21940000"          |   "22190000"
        "extents have no commas"    | 'chr9:21940000-22190000'          |   "9"             |   "21940000"          |   "22190000"
        "extents have other numbers"| 'chr23:4700-9999992'              |   "23"            |   "4700"              |   "9999992"
        "extents with big numbers"  | 'chr9:2-2002190000'               |   "9"             |   "2"                 |   "2002190000"
        "sex chromosome X"          | 'chrX:700-80000'                  |   "X"             |   "700"               |   "80000"
        "sex chromosome Y"          | 'chrY:600-8098000'                |   "Y"             |   "600"               |   "8098000"
        "chromosome has no text"    | '1:2-99999'                       |   "1"             |   "2"                 |   "99999"


    }





}
