package dport

import grails.transaction.Transactional

@Transactional
class GeneManagementService {

    public List <String> deliverPartialMatches(String firstCharacters, int maximumMatches) {
        List <String> returnValue = []
        println "Gene size deliverPartialMatches "
        if ((firstCharacters  !=  null) &&
            (firstCharacters.length() > 0))   {
            String upperCasedCharacters = firstCharacters.toUpperCase()
            println "Gene size= ${Gene.findAll().size ()}"
            List <Gene> rawGeneRecords = Gene.findAll(
                   "from Gene as b where b.name2 like '"+firstCharacters+"%' order by b.name2",
                   [], [max: maximumMatches, offset: 0] )
            rawGeneRecords.each {  Gene gene ->
                returnValue.add(gene.name2)
            }
        }
        return  returnValue
    }


    public String deliverPartialMatchesInJson(String firstCharacters, int maximumMatches) {
        StringBuilder sb = new StringBuilder("[")
        List <String> partialMatchList = deliverPartialMatches(firstCharacters,maximumMatches)
        int numberOfMatches = partialMatchList.size()
        for ( int i=0 ; i<numberOfMatches ; i++ ) {
             sb << "\"${partialMatchList[i]}\""
            if ((i+1)<numberOfMatches){
                sb << ",\n"
            } else {
                sb << "\n"
            }
        }
        sb << "]"
        return sb.toString()
    }
}
