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
    SharedToolsService sharedToolsService


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
        JSONObject jsonObject = restServerService.postServiceJson(restServerService.currentRestServer()+"gene-info",
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


    void "test retrieveGenomicRegionBySpecifiedRegion"() {
        when:
        JSONObject jsonObject = restServerService.searchGenomicRegionBySpecifiedRegion("9","21940000","22190000")
        then:
        assert jsonObject
    }

    void "test retrieveGenomicRegionAsSpecifiedByUsers"() {
        when:
        JSONObject jsonObject = restServerService.searchGenomicRegionAsSpecifiedByUsers("chr9:21,940,000-22,190,000")
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
