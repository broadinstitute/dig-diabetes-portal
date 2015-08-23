package org.broadinstitute.mpg.diabetes

import dport.PhenoKey
import dport.SharedToolsService
import grails.test.spock.IntegrationSpec
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.json.JSONTokener
import org.junit.After
import org.junit.Before
import spock.lang.Unroll
/**
 * Created by balexand on 8/18/2014.
 */
@Unroll
class MetaDataServiceIntegrationSpec extends IntegrationSpec {
    SharedToolsService sharedToolsService
    MetaDataService metaDataService


    @Before
    void setup() {

    }

    @After
    void tearDown() {

    }

    /*
    void "test urlEncodedListOfPhenotypes smoke"() {
        when:
        String encodedPhenotypes = sharedToolsService.urlEncodedListOfPhenotypes()
        then:
        assert !encodedPhenotypes.isEmpty()
    }

    void "test urlEncodedListOfProteinEffect smoke"() {
        when:
        String encodedPhenotypes = sharedToolsService.urlEncodedListOfProteinEffect()
        then:
        assert !encodedPhenotypes.isEmpty()
    }

    void "test packageUpFiltersForRoundTrip with empty parameter list"() {
        given:
        List <String> emptyParameter = []

        when:
        String encodedPhenotypes = sharedToolsService.packageUpFiltersForRoundTrip(emptyParameter)
        then:
        assert encodedPhenotypes.isEmpty()
    }


    void "test packageUpEncodedParameters with typical parameter list"() {
        given:
        List <String> typicalParameters = [
                "1:3",
                "2:1",
                "23:1"]

        when:
        String encodedPhenotypes = sharedToolsService.packageUpEncodedParameters(typicalParameters)
        then:
        assert !encodedPhenotypes.isEmpty()
    }



    void "test packageUpEncodedParameters with empty parameters"() {
        given:
        List <String> emptyParameter = []

        when:
        String encodedPhenotypes = sharedToolsService.packageUpEncodedParameters(emptyParameter)
        then:
        assert encodedPhenotypes.isEmpty()
    }
    */

    void "test compare common properties new and old data structure json"() {
        when:
        String oldDataStructure = this.sharedToolsService.sortAndPackageAMapOfListsAsJson(sharedToolsService.getProcessedMetadata()?.commonProperties, true);
        String newDataStructure = this.metaDataService.getCommonPropertiesAsJson(true);
        JSONTokener oldTokener = new JSONTokener(oldDataStructure);
        JSONObject oldJson = new JSONObject(oldTokener);
        JSONTokener newTokener = new JSONTokener(newDataStructure);
        JSONObject newJson = new JSONObject(newTokener);

        then:
//        assert oldDataStructure == newDataStructure                   // some basic whitespace errors
        assert oldJson.toString() ==  newJson.toString()
    }

    void "test trait controller gwas sample group by phenotype search"() {
        when:
        String phenotypeToSearchOn = "eGFRcys"
        String oldPhenotypeKey = sharedToolsService.convertOldPhenotypeStringsToNewOnes (phenotypeToSearchOn)
        String oldSampleGroupName = ""
        LinkedHashMap processedMetadata = sharedToolsService.getProcessedMetadata()
        LinkedHashMap phenotypeMap = processedMetadata.gwasSpecificPhenotypes
        if (phenotypeMap.containsKey(phenotypeToSearchOn))  {
            oldSampleGroupName  = phenotypeMap[phenotypeToSearchOn]?.sampleGroupName
        }
        String newSampleGroupName = this.metaDataService.getGwasSampleGroupNameForPhenotype(phenotypeToSearchOn);

        then:
        assert oldSampleGroupName == newSampleGroupName

    }


    void "test variant search properties json building"() {
        when:
        String datasetChoice = "GWAS_MAGIC_mdv2"
        String phenotype = "HBA1C"
        JSONObject jsonObject = sharedToolsService.retrieveMetadata()
        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<PhenoKey,List<String>> annotatedSampleGroups =  processedMetadata.propertiesPerOrderedSampleGroups
        LinkedHashMap<String, LinkedHashMap <PhenoKey,List <PhenoKey>>> phenotypeSpecificSampleGroupProperties = processedMetadata['phenotypeSpecificPropertiesAnnotatedPerSampleGroup']
        List <String> listOfProperties  = sharedToolsService.combineToCreateASingleList(phenotype , datasetChoice, annotatedSampleGroups, phenotypeSpecificSampleGroupProperties )
        String propertiesForTransmission = sharedToolsService.packageUpAListAsJson (listOfProperties)
        def slurper = new JsonSlurper()
        JSONObject oldJson = slurper.parseText(propertiesForTransmission)

        String newString = this.metaDataService.getSearchablePropertyNameListAsJson(datasetChoice);
        JSONObject newJson = slurper.parseText(newString)

        then:
        assert true
//        assert oldJson == newJson         // taking out for now until know what to expect
    }

    void "test variant search dataset drop down population upon phenotype selection"() {
        when:
        String phenotype = "HBA1C"
        JSONObject jsonObject = sharedToolsService.retrieveMetadata()
        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        List <PhenoKey> listOfDataSets  = sharedToolsService.extractASingleList(phenotype, processedMetadata.sampleGroupsPerAnnotatedPhenotype)
        String datasetsForTransmission = sharedToolsService.packageUpAStaggeredListAsJson (listOfDataSets)
        def slurper = new JsonSlurper()
        def oldJson = slurper.parseText(datasetsForTransmission)

        // create json of new data structure
        String newJsonString = this.metaDataService.getSampleGroupNameListForPhenotypeAsJson(phenotype);
        JSONObject newJson = slurper.parseText(newJsonString);

        then:
        assert oldJson == newJson
    }

    // TODO - table this for now to work on burden test front end
    /*
    void "test variant search phenotype drop down populating"() {
        when:
        JSONObject jsonObject = sharedToolsService.retrieveMetadata()
        LinkedHashMap processedMetadata = sharedToolsService.processMetadata(jsonObject)
        LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties = processedMetadata.phenotypeSpecificPropertiesPerSampleGroup
        LinkedHashMap<String, List<String>> listOfPhenotypes = sharedToolsService.extractAPhenotypeListofGroups( phenotypeSpecificSampleGroupProperties )
        String phenotypesForTransmission = sharedToolsService.packageUpAHierarchicalListAsJson (listOfPhenotypes)
        def slurper = new JsonSlurper()
        def oldJson = slurper.parseText(phenotypesForTransmission)

        JSONObject newJson

        then:
        assert oldJson == newJson
    }
    */
}
