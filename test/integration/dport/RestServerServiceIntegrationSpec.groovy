package dport

import grails.test.spock.IntegrationSpec
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



    @Before
    void setup() {

    }

    @After
    void tearDown() {

    }


    void "test  smoke"() {
        when:
        int i = 1
        then:
        assert i==1
    }







    void "test retrieveTreatAsSpecifiedByGenomicRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchForTraitBySpecifiedRegion(9,21940000,22190000)
        then:
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }


    void "test retrieveTreatByUnparsedGenomicRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchTraitByUnparsedRegion("chr9:21,940,000-22,190,000")
        then:
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }





    void "test searchTraitByName"() {
        when:
        JSONObject jsonObject = restServerService.searchTraitByName("BMI",0.000005)
        then:
        assert jsonObject
        jsonObject["is_error"] == false
        jsonObject["variants"].size() > 0
    }


    void "test retrieveTraitInfoByVariant"() {
        when:
        JSONObject jsonObject = restServerService.retrieveTraitInfoByVariant("rs4457676")
        then:
        assert jsonObject
        jsonObject["is_error"] == false
        jsonObject["trait-info"].size() > 0
    }




    void "test connection to diabetes server"() {
        given:
        String testJson = """{
"gene_symbol": "SLC30A8",
"columns": ["ID", "CHROM", "BEG", "END", "Function_description", "_13k_T2D_VAR_TOTAL", "_13k_T2D_ORIGIN_VAR_TOTALS", "_13k_T2D_lof_NVAR", "_13k_T2D_lof_MINA_MINU_RET",
"_13k_T2D_lof_METABURDEN", "_13k_T2D_GWS_TOTAL", "_13k_T2D_NOM_TOTAL", "EXCHP_T2D_VAR_TOTALS", "EXCHP_T2D_GWS_TOTAL", "EXCHP_T2D_NOM_TOTAL", "GWS_TRAITS",
"GWAS_T2D_GWS_TOTAL", "GWAS_T2D_NOM_TOTAL", "GWAS_T2D_VAR_TOTAL"],
"user_group": "ui"
}
""".toString()
        when:
        JSONObject jsonObject = restServerService.postServiceJson("http://t2dgenetics.org/mysql/rest/server/gene-info",
                testJson)
        then:
        assert jsonObject
    }




    void "test retrieveGeneInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveGeneInfoByName("PANX1")
        then:
        assert jsonObject
    }

    void "test retrieveVariantInfoByName"() {
        when:
        JSONObject jsonObject = restServerService.retrieveVariantInfoByName("rs13266634")
        then:
        assert jsonObject
    }



    void "test retrieveGenomicRegionBySpecifiedRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchGenomicRegionBySpecifiedRegion(9,21940000,22190000)
        then:
        assert jsonObject
    }

    void "test retrieveGenomicRegionAsSpecifiedByUsers"() {
        when:
        JSONObject jsonObject = restServerService.searchGenomicRegionAsSpecifiedByUsers("chr9:21,940,000-22,190,000")
        then:
        assert jsonObject
    }





}
