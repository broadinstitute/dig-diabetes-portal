package dport

import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import groovy.json.JsonSlurper
import org.apache.commons.fileupload.disk.DiskFileItem
import org.springframework.web.multipart.commons.CommonsMultipartFile
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@Unroll
@TestFor(SharedToolsService)
@Mock(Phenotype)
class SharedToolsServiceUnitSpec extends Specification {




    void "test convertStringToArray"() {
        when:
        List <String> converted = service.convertStringToArray(inString)
        then:
        converted.size() == theSize
        where:
        inString            |       theSize
        "\"ABC\",\"def\""   |       2
        "123,def"           |       2
        "123_123"           |       1
        ""                  |       0

    }



    void "test  convertListToString{"() {
        when:
        String converted = service.convertListToString(inList)
        then:
        converted.size() == theSize
        where:
        inList              |       theSize
        ["s"]               |       3
        [""]                |       0
        ["","",""]          |       0
        ["a","",3]          |       7
    }






    void "test  convertMultilineToList"() {
        given:
        String string1 = """12321
cdsaed
""".toString()
        String string2 = """12321""".toString()
        String string3 = """12321


"ghg"

p
""".toString()
        when:
        List<String> list1 = service.convertMultilineToList(string1)
        List<String> list2 = service.convertMultilineToList(string2)
        List<String> list3 = service.convertMultilineToList(string3)
        then:
        list1.size() == 2
        list2.size() == 1
        list3.size() == 3
    }

    /***
     * let's see if we can make some legal Json given a list
     */
    void "test  createDistributedBurdenTestInput"() {
        when:
        List list = ["a","b"]
        String results = service.createDistributedBurdenTestInput(list)
        def userJson = new JsonSlurper().parseText(results )
        then:
        userJson.keySet().size() == 3
    }




//    void "test convertMultipartFileToString"() {
//        when:
//        DiskFileItem diskFileItem = new DiskFileItem("a","txt",false,"fileName",10,new File("path"))
//        CommonsMultipartFile incomingFile = new CommonsMultipartFile(diskFileItem)
//        then:
//        service.convertMultipartFileToString(incomingFile)
//    }




        /***
     * We can call the service method  but with mocked data  we are really only testing the behavior
     * in the case of an empty domain object
     */
    void "test urlEncodedListOfPhenotypes"() {
        when:
        String status = service.urlEncodedListOfPhenotypes()
        then:
        assertNotNull status
    }

    /***
     * Distinguish good chromosome specifications from bad?
     */
    void "test parseChromosome"() {
        when:
        String chr1 = service.parseChromosome('chr9')
        String chr2 = service.parseChromosome('chrX')
        String chr3 = service.parseChromosome('chrY')
        String chr4 = service.parseChromosome('chrZ')
        then:
        chr1=='9'
        chr2=='X'
        chr3=='Y'
        chr4==''
    }

    /***
     * try encoding and decoding some values
     */
    void "test Filter encoding"() {
        when:
        String encoded = service.encodeAFilterList([phenotype:'t2d',
        'dataset':'ExSeq',
        'orValue':'123',
        'pValue':'0.123'])
        LinkedHashMap<String,String>  decoded = service.decodeAFilterList(encoded)
        then:
        decoded['phenotype']=='t2d'
        decoded['dataset']=='ExSeq'
        decoded['orValue']=='123'
        decoded['pValue']=='0.123'
    }





}
