package dport

import grails.transaction.Transactional

@Transactional
class SearchBuilderService {


    SharedToolsService sharedToolsService
    FilterManagementService filterManagementService


    /***
     * write out the custom filters in a human readable form
     * @param customFilter
     * @return
     */
    public String makeFiltersPrettier (String customFilter){
        StringBuilder sb = new StringBuilder()
        if (customFilter){
            LinkedHashMap mappedFilter = filterManagementService.parseCustomFilterString(customFilter)
            if ((mappedFilter.property) && (mappedFilter.equivalence)) {// parsing successful
                sb << "${sharedToolsService.translator (mappedFilter.phenotype)}["
                sb << "${sharedToolsService.translator (mappedFilter.sampleSet)}]"
                sb << "${sharedToolsService.translator (mappedFilter.property)}"
                if (mappedFilter.equivalence == "LT"){
                    sb << "<"
                }else if (mappedFilter.equivalence == "GT"){
                    sb << ">"
                }else if (mappedFilter.equivalence == "EQ") {
                    sb << "="
                }
                sb << "${sharedToolsService.translator (mappedFilter.value)}"
            }
        }
    }




    /***
     * put custom filters into a pleasing, human readable form.   Store them in a list, so that
     * a subsequent method can write them out one per line
     * @param allFilters
     * @return
     */
    public List<String> composeCustomFiltersForClause(LinkedHashMap allFilters) {
        List<String> returnValue = []
        LinkedHashMap customFilters = allFilters.findAll{ it.key =~ /^filter/ }
        int numberOfCustomFiltersLeft = customFilters.size()
        customFilters.each {String key, String value->
            returnValue << """
                                <div class="phenotype filterElement">${makeFiltersPrettier(value)}</div>
                    """.toString()
        }
        return returnValue

    }














    /***
     * put standard (non-custom) filters into a pleasing, human readable form.   Store them in a list, so that
     * a subsequent method can write them out with commas
     * @param allFilters
     * @return
     */
    public List<String> composeFiltersForClause(LinkedHashMap allFilters) {
        List<String> returnValue = []
        if ( allFilters ) {


            // a line to describe the odds ratio
            if (allFilters.orValue) {
                String inequality = "&gt;"
                if (allFilters.orValueInequality == "lessThan"){
                    inequality = "&lt;"
                }
                returnValue << """
                        <span class="cc filterElement">OR ${inequality}&nbsp; ${allFilters.orValue}</span>
                                            """.toString()
            }  // a single line for the odds ratio

            // a line to describe the P value
            if (allFilters.pValue) {
                String inequality = "&lt;"
                if (allFilters.pValueInequality == "greaterThan"){
                    inequality = "&gt;"
                }
                returnValue << """
                            <span class="dd filterElement">p-value ${inequality}&nbsp; ${allFilters.pValue}</span>
                            """.toString()
            }// a single line for the P value

            // a line to describe the P value
            if (allFilters.esValue) {
                String inequality = "&lt;"
                if (allFilters.esValueInequality == "greaterThan"){
                    inequality = "&gt;"
                }
                returnValue << """
                        <span class="dd filterElement">effect size ${inequality}&nbsp; ${allFilters.esValue}</span>
                        """.toString()
            }// a single line for the effect value

            // a line to describe the polyphen value
            if (allFilters.regionChromosomeInput) {
                returnValue << """
                                <span class="dd filterElement">chromosome: ${allFilters.regionChromosomeInput}</span>
                                """.toString()
            }// a single line for the P value

            // a line to describe the polyphen value
            if (allFilters.regionStartInput) {
                returnValue << """
                                <span class="dd filterElement">start position:&nbsp; ${allFilters.regionStartInput}</span>
                                """.toString()
            }// a single line for the P value

            // a line to describe the polyphen value
            if (allFilters.regionStopInput) {
                returnValue << """
                                <span class="dd filterElement">end position:&nbsp; ${allFilters.regionStopInput}</span>
                                """.toString()
            }// a single line for the P value

            // a line to describe the polyphen value
            if (allFilters.gene) {
                returnValue << """
                                <span class="dd filterElement">${allFilters.gene}</span>
                                """.toString()
            }// a single line for the P value

            // a line to describe the polyphen value
            if (allFilters.predictedEffects) {
                if (allFilters.predictedEffects != "all-effects")  {  // don't display the default
                    returnValue << """
                                <span class="dd filterElement">predicted effects: ${allFilters.predictedEffects}</span>
                                """.toString()
                }
            }// a single line for the P value

            if (allFilters.polyphenSelect) {
                returnValue << """
                                <span class="dd filterElement">polyphen prediction: ${allFilters.polyphenSelect}</span>
                                """.toString()
            }// a single line for the P value
            if (allFilters.siftSelect) {
                returnValue << """
                                <span class="dd filterElement">sift prediction: ${allFilters.siftSelect}</span>
                                """.toString()
            }// a single line for the P value
            if (allFilters.condelSelect) {
                returnValue << """
                                <span class="dd filterElement">condel prediction: ${allFilters.condelSelect}</span>
                                """.toString()
            }// a single line for the P value


        }  // the section containing all filters
        
        return returnValue

    }



    public String writeOutFiltersAsHtml( out, LinkedHashMap allFilters ){
        List<String> listOfCustomFilters = composeCustomFiltersForClause( allFilters )
        List<String> listOfFilters =  composeFiltersForClause( allFilters )
        for (String customFilter in listOfCustomFilters){ // no need to count, since all are handled the same way
            out << customFilter
        }
        String filtersWithCommas = listOfFilters.join(",")     //we need to count these, since the last one doesn't get a comma
        out << filtersWithCommas
//        for ( int  i = 0 ; i < numberOfFilters ; i++ ){
//            out << listOfFilters [i]
//            if (i <  numberOfFilters-1){
//                out << ","
//            }
//        }

    }



}
