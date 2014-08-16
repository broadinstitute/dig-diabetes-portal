package dport

import grails.test.mixin.TestFor
import groovy.json.JsonSlurper
import spock.lang.Specification
import spock.lang.Unroll

/**
 * Created by balexand on 7/17/2014.
 */
@Unroll
@TestFor(GeneManagementService)
class GeneManagementServiceUnitSpec extends Specification {
    Closure<List <Gene>> retrieveGene = { String searchString, int numberOfMatches ->
        List <Gene> mockedGeneRecords = []
        mockedGeneRecords << new Gene(name1: 'abc', name2:'ABC')
        mockedGeneRecords << new Gene(name1: 'abd', name2:'ABD')
        mockedGeneRecords << new Gene(name1: 'abe', name2:'ABE')
        mockedGeneRecords << new Gene(name1: 'ace', name2:'ACE')
        mockedGeneRecords << new Gene(name1: 'ace', name2:'ACE')
        mockedGeneRecords << new Gene(name1: 'a', name2:'A')
        mockedGeneRecords << new Gene(name1: 'b', name2:'B')
        List <Gene> returnValue  = mockedGeneRecords.findAll{true }
        return  returnValue
    }


    void "test deliverPartialMatches"() {
         given:
         String firstCharacters = "PP"
         int  maximumMatches = 20
         when:
         List <String> results = service.deliverPartialMatches(firstCharacters,maximumMatches,retrieveGene)
         then:
         assert results.size()==7
    }

    void "test deliverPartialMatchesInJson"() {
        given:
        String firstCharacters = "PP"
        int  maximumMatches = 20
        when:
        String results = service.deliverPartialMatchesInJson(firstCharacters,maximumMatches,retrieveGene)
        then:
        def userJson = new JsonSlurper().parseText(results )
        assert  userJson.getClass().name == 'java.util.ArrayList'
        assert service
    }

}
