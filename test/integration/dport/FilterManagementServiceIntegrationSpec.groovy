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
class FilterManagementServiceIntegrationSpec  extends IntegrationSpec {
    FilterManagementService filterManagementService


    @Before
    void setup() {

    }

    @After
    void tearDown() {

    }

    @Unroll("testing  distinguishBetweenDataSets with #label")
    void "test  distinguishBetweenDataSets"() {
        given:
        HashMap  incomingParameters = [datatype:incoming]

        when:
        int varAssign = filterManagementService.distinguishBetweenDataSets(incomingParameters)
        then:
        varAssign ==  variableAssignment

        where:
        label       |   incoming            | variableAssignment
        "gwas"      |   'gwas'              |  0
        "sigma"     |   'sigma'             |  1
        "exomeseq"  |   'exomeseq'          |  2
        "exomechip" | 'exomechip'           |  3
    }



    @Unroll("testing  determineDataSet with #label")
    void "test  determineDataSet"() {
        given:
        HashMap  incomingParameters = [datatype:incoming]

        when:
        LinkedHashMap  buildingFilters  = [:]
        buildingFilters.filters = []
        buildingFilters.filterDescriptions = []
        buildingFilters.parameterEncoding = []
        buildingFilters.transferableFilter  = []
        LinkedHashMap  returnValue  =  filterManagementService.determineDataSet(buildingFilters,incomingParameters)
        then:
        returnValue.filterDescriptions[0].contains(description)


        where:
        label       |   incoming            | description
        "gwas"      |   'gwas'              |  "GWAS"
        "sigma"     |   'sigma'             |  "SIGMA"
        "exomeseq"  |   'exomeseq'          |  "Exome sequencing"
        "exomechip" | 'exomechip'           |  "Exome chip"
    }





}
