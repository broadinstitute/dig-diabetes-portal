package org.broadinstitute.mpg

import grails.transaction.Transactional
import org.broadinstitute.mpg.Gene
import org.broadinstitute.mpg.SqlService
import org.broadinstitute.mpg.Variant

@Transactional
class GeneManagementService {
    SqlService sqlService

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

    private Closure<List <Variant>> retrieveVariantVarIdUsingNamedQueries = { String searchString, int numberOfMatches ->
        List <Variant> returnList

        if (searchString?.length() < 7) {
            returnList = (Variant.searchByVarIdFirstCharacters(searchString).list(max: numberOfMatches))
            log.info("using new varId shortened search column for term: " + searchString + " and got number of results: " + returnList.size())
        } else {
            returnList = (Variant.searchByVarId(searchString, searchString[0..6]).list(max: numberOfMatches))
            log.info("using varId full search column for term: " + searchString + " and got number of results: " + returnList.size())
        }

        return returnList
    }

    private Closure<List <Variant>> retrieveVariantDbSnpUsingNamedQueries = { String searchString, int numberOfMatches ->
        List <Variant> returnList

        if (searchString?.length() < 7) {
            returnList = (Variant.searchByDbSnpIdFirstCharacters(searchString).list(max: numberOfMatches))
            log.info("using new dbSnpId shortened search column for term: " + searchString + " and got number of results: " + returnList.size())
        } else {
            returnList = (Variant.searchByDbSnpId(searchString, searchString[0..6]).list(max: numberOfMatches))
            log.info("using dbSnpId full search column for term: " + searchString + " and got number of results: " + returnList.size())
        }

        return returnList
    }

    /**
     * closure to call gene search closure and return string list
     */
    private Closure<List <String>> retrieveGeneStrings = { String searchString, int numberOfMatches ->
        List<String> geneStringList = []
        this.retrieveGene(searchString, numberOfMatches).each { Gene gene ->
            geneStringList << gene.name2
        }
        return  geneStringList
    }

    /**
     * closure to return var id string list using sql rlike mysql call
     */
    private Closure<List <String>> retrieveVariantVarIdStringList = { String searchString, int numberOfMatches ->
        return this.sqlService.getVariantStringListFromSnippetUsingForcedIndexQuery(searchString, numberOfMatches)
    }

    /**
     * closure to return variant db snp id string list
     */
    private Closure<List <String>> retrieveVariantDbSnpStringList = { String searchString, int numberOfMatches ->
        return this.sqlService.getDbSnpIdStringListFromSnippetUsingForcedIndexQuery(searchString, numberOfMatches)
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
     * Before we can deliver a list of partial matches we want first to uppercase the incoming
     * parameter. For return values we need only the name -- we don't care about the rest of the
     * record.  The actual choice of database records is performed by the supplied closure
     *
     * @param firstCharacters
     * @param maximumMatches
     * @param retrieveGene
     * @return
     */
    private List <String> deliverPartialMatchesUsingStringLists(String firstCharacters,
                                                int maximumMatches,
                                                Closure retrieveGeneStringList,
                                                Closure retrieveVariantDbSnpStringList,
                                                Closure retrieveVariantVarIdStringList) {
        List <String> returnValue = []
        if ((firstCharacters  !=  null) &&
                (firstCharacters.length() > 0))   {
            String upperCasedCharacters = firstCharacters.toUpperCase()

            // add gene strings
            if (retrieveGeneStringList.maximumNumberOfParameters>1){
                returnValue.addAll(retrieveGeneStringList(upperCasedCharacters, maximumMatches/3 as int))
            }


            // add variant dbsnp id strings
            if (retrieveVariantDbSnpStringList.maximumNumberOfParameters>1) {
                returnValue.addAll(retrieveVariantDbSnpStringList(upperCasedCharacters, maximumMatches / 3 as int))
            }

            // add variant var id strings
            if (retrieveVariantVarIdStringList.maximumNumberOfParameters>1) {
                returnValue.addAll(retrieveVariantVarIdStringList(upperCasedCharacters, maximumMatches / 3 as int))
            }

        }

        return returnValue
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

    /**
     * TODO - fix so don't repeat logic; this doesn't follow DRY
     * TODO - need to add method to Bootstrap to add 'rlike' function to h2db for tests (will do this after vacation)
     *
     * @param firstCharacters
     * @param maximumMatches
     * @param retrieveGene
     * @param retrieveVariantDbSnp
     * @param retrieveVariantVarId
     * @return
     */
    private String deliverPartialMatchesInJsonUsingStringLists( String firstCharacters,
                                                int maximumMatches,
                                                Closure retrieveGene,
                                                Closure retrieveVariantDbSnp,
                                                Closure retrieveVariantVarId) {
        StringBuilder sb = new StringBuilder("[")
        // KDUXTD-83: try to speed up type ahead of gene search
        List <String> partialMatchList = deliverPartialMatchesUsingStringLists(firstCharacters,maximumMatches,retrieveGene,retrieveVariantDbSnp,retrieveVariantVarId)

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



    private String deliverPartialMatchesInJsonGenesOnly( String firstCharacters,
                                                                int maximumMatches,
                                                                Closure retrieveGene) {
        StringBuilder sb = new StringBuilder("[")
        // KDUXTD-83: try to speed up type ahead of gene search
        List <String> partialMatchList = deliverPartialMatchesUsingStringLists(firstCharacters,maximumMatches,retrieveGene,{},{})

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


    private String deliverPartialMatchesInJsonVariantsOnly( String firstCharacters,
                                                                int maximumMatches,
                                                                Closure retrieveVariantDbSnp,
                                                                Closure retrieveVariantVarId) {
        StringBuilder sb = new StringBuilder("[")
        // KDUXTD-83: try to speed up type ahead of gene search
        List <String> partialMatchList = deliverPartialMatchesUsingStringLists(firstCharacters,maximumMatches,{},retrieveVariantDbSnp,retrieveVariantVarId)

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
                retrieveVariantDbSnpUsingNamedQueries,
                retrieveVariantVarIdUsingNamedQueries )

    }

    public String partialGeneOnlyMatches( String firstCharacters,
                                      int maximumMatches) {
        return   deliverPartialMatchesInJsonGenesOnly(  firstCharacters,
                maximumMatches,
                retrieveGene )

    }


    public String partialVariantOnlyMatches( String firstCharacters,
                                      int maximumMatches) {
        return   deliverPartialMatchesInJsonVariantsOnly(  firstCharacters,
                maximumMatches,
                retrieveVariantDbSnpUsingNamedQueries,
                retrieveVariantVarIdUsingNamedQueries )

    }



    /**
     * same method as above but using String lists and one sql service call to use MySQL specific call
     *
     * @param firstCharacters
     * @param maximumMatches
     * @return
     */
    public String partialGeneMatchesUsingStringLists( String firstCharacters,
                                      int maximumMatches) {
        // KDUXTD-83: try to speed up type ahead for search input
        return   this.deliverPartialMatchesInJsonUsingStringLists(  firstCharacters,
                maximumMatches,
                retrieveGeneStrings,
                retrieveVariantDbSnpStringList,
                retrieveVariantVarIdStringList )

    }

    /**
     * return the region specification for a given gene and given buffer space in bases
     *
     * @param geneId
     * @param bufferSpace
     * @return
     */
    public LinkedHashMap getRegionSpecificationDetailsForGene(String geneId, int bufferSpace) {
        // local variables
        LinkedHashMap returnValue =  [:]
        Gene gene = null

        // get the gene
        gene = Gene.findByName2(geneId);
        if (gene != null) {
            Long startPosition = 0;
            Long endPosition = 0;
            String chromosome  = null;
            startPosition = gene?.addrStart;
            endPosition = gene?.addrEnd;
            chromosome = gene?.chromosome
            // it might be that chromosome number starts with the string 'chr'
            if ((chromosome)&&
                    (chromosome.startsWith("chr")) &&
                    (chromosome.length()>3)){
                chromosome = chromosome.substring(3)
            }

            // increment start/end positions of need be
            if ((bufferSpace != null) && (bufferSpace != 0)) {
                startPosition = startPosition - bufferSpace;
                endPosition = endPosition + bufferSpace;
            }

            returnValue["startPosition"] = startPosition
            returnValue["endPosition"] = endPosition
            returnValue["chromosome"] = chromosome


        }

        // return
        return returnValue;
    }



    public String getRegionSpecificationForGene(String geneId, int bufferSpace) {
        // local variables
        Gene gene = null
        Long startPosition = 0;
        Long endPosition = 0;
        String chromosome  = null;
        String regionSpecification = null;

        LinkedHashMap regionSpecificationDetailsForGene = getRegionSpecificationDetailsForGene( geneId,  bufferSpace)
        // get the gene

        if (!regionSpecificationDetailsForGene.isEmpty())
            // create the region specification
            regionSpecification = regionSpecificationDetailsForGene.chromosome + ":" + regionSpecificationDetailsForGene.startPosition?.toString() + "-" + regionSpecificationDetailsForGene.endPosition?.toString();

        // return
        return regionSpecification;
    }



}
