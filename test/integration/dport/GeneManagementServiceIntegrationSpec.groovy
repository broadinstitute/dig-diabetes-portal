package dport

import grails.test.spock.IntegrationSpec
import groovy.json.JsonSlurper
import org.junit.After
import org.junit.Before
import spock.lang.Unroll

/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class GeneManagementServiceIntegrationSpec   extends IntegrationSpec {
    GeneManagementService geneManagementService


    @Before
    void setup() {

    }

    @After
    void tearDown() {

    }

    void "test retrieveGene #description Through direct call"() {
        when:
        List <Gene> listOfGenes = geneManagementService.retrieveGene(userString,numberRequested)

        then:
        assert listOfGenes.size()==numberReturns

        where:
        description         |  userString           |   numberRequested     |   numberReturns
        "Single return"     |  "G"                  |   1                   |   1
        "Multiple return"   |  "G"                  |   5                   |   5
        "Nonexistent gene"  |  "asdfghjk"           |   10                  |   0
        "Lowercase=no match"|  "a"                  |   5                   |   0
        "Null matches all"  |  ""                   |   10                  |   10
    }



    void "test deliverPartialMatches #description"() {
        when:
        List <Gene> listOfGenes = geneManagementService.deliverPartialMatches( userString,
                                                                               numberRequested,
                                                                               geneManagementService.retrieveGene,
                                                                                geneManagementService.retrieveVariantDbSnp,
                                                                                geneManagementService.retrieveVariantVarId )

        then:
       // assert listOfGenes.size()==numberReturns
        assert listOfGenes.size()>0

        where:
        description         |  userString           |   numberRequested     |   numberReturns
        "Single return"     |  "G"                  |   1                   |   1
        "Multiple return"   |  "G"                  |   5                   |   5
        "Lowercase=match"   |  "a"                  |   5                   |   5
    }


    void "test deliverPartialMatchesInJson"() {
        given:
        String userString = "G"
        int numberRequested = 5

        when:
        String results = geneManagementService.deliverPartialMatchesInJson(userString,
                numberRequested,
                geneManagementService.retrieveGene,
                geneManagementService.retrieveVariantDbSnp,
                geneManagementService.retrieveVariantVarId)

        then:
        def userJson = new JsonSlurper().parseText(results)
        assert userJson.getClass().name == 'java.util.ArrayList'
    }

    void "test partialGeneMatches legal"() {
        when:
        String results = geneManagementService.partialGeneMatches(userString,
                numberRequested)

        then:
        def userJson = new JsonSlurper().parseText(results)
        assert userJson.getClass().name == 'java.util.ArrayList'

        where:
        description         |  userString           |   numberRequested
        "Single return"     |  "G"                  |   1
        "Multiple return"   |  "G"                  |   5
        "Lowercase=match"   |  "a"                  |   5

    }


    @Unroll("testing  partialGeneMatches with #label")
    void "test partialGeneMatches should correctly return nothing"() {
        when:
        String results = geneManagementService.partialGeneMatches(userString,10)

        then:
        def userJson = new JsonSlurper().parseText(results)
        assert userJson.size() == 0

        where:
        description         |  userString
        "Nonexistent gene"  |  "asdfghjk"
        "Null=no match"     |  ""

    }


    void "test get region specification for gene"() {
        when:
        String geneId = "SLC30A8"
        String regionSpecificationExpected = "chr8:117962462-118189003"

        then:
        assert regionSpecificationExpected == this.geneManagementService.getRegionSpecificationForGene(geneId, 0)
    }




}
