package org.broadinstitute.mpg

import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import org.broadinstitute.mpg.FilterManagementService
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import spock.lang.Specification
import spock.lang.Unroll
/**
 * Created by balexand on 7/17/2014.
 */
@Unroll
@TestFor(FilterManagementService)
@Mock([RestServerService, SharedToolsService])
class FilterManagementServiceUnitSpec extends Specification {




    void "test ancestry group variation filters"() {
        given: "prepare the inputs"
            String filter = "lowfreq-ea"
            Map hashMap = ["region_gene_input": "SLC30A8"]

        when:
            Map resultMap = service.interpretSpecialFilters(hashMap, filter)

        then:
        resultMap.containsValue("SLC30A8")
        resultMap.containsValue("11=MOST_DEL_SCORE<4")
    }
}

//
//    Closure<List <Gene>> retrieveGene = { String searchString, int numberOfMatches ->
//        return  returnValue
//    }
//
//
//    /***
//     *  pass a simple  filter generation  parameter to  setRegion
//     */
//    void "test setRegion"() {
//        given:
//        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
//                                          filterDescriptions:new ArrayList<String>(),
//                                          parameterEncoding:new ArrayList<String>()]
//        List<String> r1 = ["t1"]
//        HashMap incomingParameters = [ "region_gene_input": r1]
//        when:
//        LinkedHashMap results = service.setRegion(buildingFilters,incomingParameters)
//        then:
//        assert  results.filters.size() > 0
//        assert  results.filterDescriptions.size() > 0
//        assert  results.parameterEncoding.size() > 0
//    }
//
//    /***
//     * try stacking up two calls
//     */
//    void "test setAlleleFrequencies"() {
//        given:
//        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
//                                          filterDescriptions:new ArrayList<String>(),
//                                          parameterEncoding:new ArrayList<String>()]
//        String r1 = "0.0001"
//        String r2 = "33"
//        HashMap incomingParameters1 = [ "ethnicity_af_AA-min": r1]
//        HashMap incomingParameters2 = [ "ethnicity_af_AA-min": r2]
//        when:
//        buildingFilters = service.setAlleleFrequencies(buildingFilters,incomingParameters1)
//        buildingFilters = service.setAlleleFrequencies(buildingFilters,incomingParameters2)
//        then:
//        assert  buildingFilters.filters.size() > 1
//        assert  buildingFilters.filterDescriptions.size() > 1
//        assert  buildingFilters.parameterEncoding.size() > 1
//
//    }
//
//
//    /***
//     * This call is particularly important because other requests we build have a dependency
//     * on the data set chosen here. Be sure to check the additional parameter that comes back (datatypeOperand )
//     */
//    @Unroll("testing  determineDataSet with #label")
//    void "test determineDataSet"() {
//        given:
//        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
//                                          filterDescriptions:new ArrayList<String>(),
//                                          parameterEncoding:new ArrayList<String>()]
//
//        when:
//        HashMap incomingParameters = [ "datatype": dataSetDistinguisher]
//        buildingFilters = service.determineDataSet(buildingFilters,incomingParameters)
//
//        then:
//        assert  buildingFilters.datatypeOperand  ==   datatypeOperand
//
//        where:
//        label                       | dataSetDistinguisher  | datatypeOperand
//        "dataSetDistinguisher=1"    | "sigma"               |   "SIGMA_T2D_P"
//        "dataSetDistinguisher=2"    | "exomeseq"            |   "_13k_T2D_P_EMMAX_FE_IV"
//        "dataSetDistinguisher=3"    | "exomechip"           |   "EXCHP_T2D_P_value"
//        "dataSetDistinguisher=0"    | "gwas"                |   "GWAS_T2D_PVALUE"
//    }
//
//
//
//
//    /***
//     * This call is particularly important because other requests we build have a dependency
//     * on the data set chosen here. Be sure to check the additional parameter that comes back (datatypeOperand )
//     */
//    @Unroll("testing  determineThreshold with #label")
//    void "test determineThreshold"() {
//        given:
//        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
//                                          filterDescriptions:new ArrayList<String>(),
//                                          parameterEncoding:new ArrayList<String>()]
//
//        when:
//        HashMap incomingParameters = [ "significance":significance,"custom_significance_input":custom]
//        buildingFilters = service.determineThreshold(buildingFilters,incomingParameters,datatypeOperand)
//
//        then:
//        print buildingFilters.filters[0]=filter
//
//
//        where:
//                label                       | significance          | datatypeOperand               |   custom  | filter
//                "sigma"                     | "genomewide"          |   "SIGMA_T2D_P"               |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 5E-8 }""".toString()
//                "exome seq _EMMAX_FE_IV"    | "genomewide"          |   "_13k_T2D_P_EMMAX_FE_IV"    |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 5E-8 }""".toString()
//                "exome chipr=3"             | "genomewide"          |   "EXCHP_T2D_P_value"         |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 5E-8 }""".toString()
//                "gwas"                      | "genomewide"          |   "GWAS_T2D_PVALUE"           |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 5E-8 }""".toString()
//                "sigma"                     | "nominal"             |   "SIGMA_T2D_P"               |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 0.05 }""".toString()
//                "exome seq _EMMAX_FE_IV"    | "nominal"             |   "_13k_T2D_P_EMMAX_FE_IV"    |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 0.05 }""".toString()
//                "exome chipr=3"             | "nominal"             |   "EXCHP_T2D_P_value"         |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 0.05 }""".toString()
//                "gwas"                      | "nominal"             |   "GWAS_T2D_PVALUE"           |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 0.05 }""".toString()
//                "sigma"                     | "custom"              |   "SIGMA_T2D_P"               |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 0.47 }""".toString()
//                "exome seq _EMMAX_FE_IV"    | "custom"              |   "_13k_T2D_P_EMMAX_FE_IV"    |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 0.47 }""".toString()
//                "exome chipr=3"             | "custom"              |   "EXCHP_T2D_P_value"         |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 0.47 }""".toString()
//                "gwas"                      | "custom"              |   "GWAS_T2D_PVALUE"           |   "0.47"  |  """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 0.47 }""".toString()
//    }
//


//}
