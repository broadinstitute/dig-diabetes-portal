package dport
import grails.test.mixin.TestFor
import spock.lang.Specification
import spock.lang.Unroll
/**
 * Created by balexand on 7/17/2014.
 */
@Unroll
@TestFor(FilterManagementService)
class FilterManagementServiceUnitSpec extends Specification {
    Closure<List <Gene>> retrieveGene = { String searchString, int numberOfMatches ->
        return  returnValue
    }


    void "test Filter management smoke"() {
        given:
         int    i = 1
        when:
        i = 2
        then:
        i == 2
    }

    /***
     *  pass a simple  filter generation  parameter to  setRegion
     */
    void "test setRegion"() {
        given:
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]
        List<String> r1 = ["t1"]
        HashMap incomingParameters = [ "region_gene_input": r1]
        when:
        LinkedHashMap results = service.setRegion(buildingFilters,incomingParameters)
        then:
        assert  results.filters.size() > 0
        assert  results.filterDescriptions.size() > 0
        assert  results.parameterEncoding.size() > 0
    }

    /***
     * try stacking up two calls
     */
    void "test setAlleleFrequencies"() {
        given:
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]
        List<String> r1 = ["0.0001"]
        List<String> r2 = ["33"]
        HashMap incomingParameters1 = [ "ethnicity_af_AA-min": r1]
        HashMap incomingParameters2 = [ "ethnicity_af_AA-min": r2]
        when:
        buildingFilters = service.setAlleleFrequencies(buildingFilters,incomingParameters1)
        buildingFilters = service.setAlleleFrequencies(buildingFilters,incomingParameters2)
        then:
        assert  buildingFilters.filters.size() > 1
        assert  buildingFilters.filterDescriptions.size() > 1
        assert  buildingFilters.parameterEncoding.size() > 1

    }


}
