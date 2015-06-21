package dport

import grails.transaction.Transactional

@Transactional
class GeneManagementService {

    /***
     * Return a list of all the genes that satisfy our partial match criteria. Note that
     * encapsulating this data generation functionality inside a closure serves two purposes:
     * 1) it should simplify the conversion when it comes time to pull these values back
     * from the backend server as opposed to an intermediate database, and 2) is vastly
     * simplifies testing, since otherwise mocking the calls that supply these data
     * becomes both tricky and brittle.
     */
    private Closure<List <Gene>> retrieveGene = { String searchString, int numberOfMatches ->
        return  (Gene.findAll(
                "from Gene as b where b.name2 like '"+searchString+"%' order by b.name2",
                [], [max: numberOfMatches, offset: 0] ))
    }


    private Closure<List <Variant>> retrieveVariantDbSnp = { String searchString, int numberOfMatches ->
        return  (Variant.findAll(
                "from Variant as b where b.dbSnpId like '"+searchString+"%' order by b.dbSnpId",
                [], [max: numberOfMatches, offset: 0] ))
    }

    private Closure<List <Variant>> retrieveVariantVarId = { String searchString, int numberOfMatches ->
        return  (Variant.findAll(
                "from Variant as b where b.varId like '"+searchString+"%' order by b.varId",
                [], [max: numberOfMatches, offset: 0] ))
    }




    /***
     * Before we can deliver a list of partial matches we want first to uppercase the incoming
     * parameter. For return values we need only the name -- we don't care about the rest of the
     * record.  The actual choice of database records is performed by the supplied closure
     *
     * @param firstCharacters
     * @param maximumMatches
     * @param retrieveGene
     * @return
     */
    private List <String> deliverPartialMatches(String firstCharacters,
                                               int maximumMatches,
                                               Closure retrieveGene,
                                               Closure retrieveVariantDbSnp,
                                               Closure retrieveVariantVarId) {
        List <String> returnValue = []
        if ((firstCharacters  !=  null) &&
            (firstCharacters.length() > 0))   {
            String upperCasedCharacters = firstCharacters.toUpperCase()
            List <Gene> rawGeneRecords = retrieveGene (upperCasedCharacters, maximumMatches/3 as int)
            rawGeneRecords.each {  Gene gene ->
                returnValue.add(gene.name2)
            }
            List <Variant> rawVariantRecords1 = retrieveVariantDbSnp (upperCasedCharacters, maximumMatches/3 as int)
            rawVariantRecords1.each {  Variant variant ->
                returnValue.add(variant.dbSnpId)
            }
            List <Variant> rawVariantRecords2 = retrieveVariantVarId (upperCasedCharacters, maximumMatches/3 as int)
            rawVariantRecords2.each {  Variant variant ->
                returnValue.add(variant.varId)
            }

        }
        return  returnValue
    }

    /***
     * Take the list of results (which happened me gene names) we get from deliverPartialMatches
     * and wrap it up in Json. We pass in the closure which will ultimately do the lookup of the values
     * we need
     *
     * @param firstCharacters
     * @param maximumMatches
     * @param retrieveGene
     * @return
     */
    private String deliverPartialMatchesInJson( String firstCharacters,
                                               int maximumMatches,
                                               Closure retrieveGene,
                                               Closure retrieveVariantDbSnp,
                                               Closure retrieveVariantVarId) {
        StringBuilder sb = new StringBuilder("[")
        List <String> partialMatchList = deliverPartialMatches(firstCharacters,maximumMatches,retrieveGene,retrieveVariantDbSnp,retrieveVariantVarId)
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

    /***
     * Encapsulate the private closure that generates the database calls. This is the public facing portion
     * of the partial match functionality -- everything else is hidden.
     *
     * @param firstCharacters
     * @param maximumMatches
     * @return
     */
    public String partialGeneMatches( String firstCharacters,
                                               int maximumMatches) {
        return   deliverPartialMatchesInJson(  firstCharacters,
                 maximumMatches,
                 retrieveGene,
                retrieveVariantDbSnp,
                retrieveVariantVarId )

    }

}
