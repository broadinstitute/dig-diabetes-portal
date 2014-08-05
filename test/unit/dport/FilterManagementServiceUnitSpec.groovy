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
//        List <Gene> mockedGeneRecords = []
//        mockedGeneRecords << new Gene(name1: 'abc', name2:'ABC')
//        mockedGeneRecords << new Gene(name1: 'abd', name2:'ABD')
//        mockedGeneRecords << new Gene(name1: 'abe', name2:'ABE')
//        mockedGeneRecords << new Gene(name1: 'ace', name2:'ACE')
//        mockedGeneRecords << new Gene(name1: 'ace', name2:'ACE')
//        mockedGeneRecords << new Gene(name1: 'a', name2:'A')
//        mockedGeneRecords << new Gene(name1: 'b', name2:'B')
//        List <Gene> returnValue  = mockedGeneRecords.findAll{
//            true }
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

    void "test setRegion"() {
        given:
        StringBuilder sb = new StringBuilder()
        List<String> r1 = ["t1"]
        HashMap incomingParameters = [ "region_gene_input": r1]
        when:
        String results = service.setRegion(sb,incomingParameters)
        then:
         assert  sb
         assert sb.length() > 0
    }


    void "test setAlleleFrequencies"() {
        given:
        StringBuilder sb = new StringBuilder()
        List<String> r1 = ["t1"]
        List<String> r2 = ["33"]
        HashMap incomingParameters1 = [ "ethnicity_af_AA-min": r1]
        HashMap incomingParameters2 = [ "ethnicity_af_AA-min": r2]
        when:
        String sb1 = service.setAlleleFrequencies(sb,incomingParameters1)
        String sb2 = service.setAlleleFrequencies(sb,incomingParameters2)
        then:
        sb1.length() ==0
        assert  sb2
        assert sb2.length() > 0
    }


}
