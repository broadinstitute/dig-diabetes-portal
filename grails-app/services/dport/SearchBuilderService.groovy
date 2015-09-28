package dport

import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.util.PortalConstants

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
    public List<String> composeCustomFiltersForClause( String aFilter ) {
        List<String> returnValue = []

            if (aFilter.contains("[")) {//we only want to handle custom filters
                returnValue << """
                                <div class="phenotype filterElement">${makeFiltersPrettier(aFilter)}</div>
                    """.toString()
            }

//        LinkedHashMap customFilters = allFilters.findAll{ it.key =~ /^filter/ }
//        int numberOfCustomFiltersLeft = customFilters.size()
//        customFilters.each {String key, String value->
//            returnValue << """
//                                <div class="phenotype filterElement">${makeFiltersPrettier(value)}</div>
//                    """.toString()
//        }
        return returnValue

    }




    private String prettyPrintPredictedEffect (int typeOfPrediction, String codedValueAsString){
        String returnValue = ""
        int codedValue = 0
        try {
            codedValue = Integer.parseInt(codedValueAsString)
        } catch(e){
            log.error("Internal inconsistency: non integer codedValue = '${codedValueAsString}'")
        }
        switch (typeOfPrediction){
            case PortalConstants.PROTEIN_PREDICTION_TYPE_PROTEINEFFECT:
                switch (codedValue){
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_EFFECT_CODING_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_EFFECT_CODING_NAME
                        break;
                    default:
                        log.error("Internal inconsistency: no PROTEINEFFECT codedValue = ${codedValue}")
                        break;
                }
                break;
            case PortalConstants.PROTEIN_PREDICTION_TYPE_POLYPHEN:
                switch (codedValue){
                    case PortalConstants.PROTEIN_PREDICTION_POLYPHEN_NONE_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_POLYPHEN_NONE_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_POLYPHEN_BENIGN_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_POLYPHEN_BENIGN_NAME
                        break;
                    default:
                        log.error("Internal inconsistency: no POLYPHEN codedValue = ${codedValue}")
                        break;
                }
                break;
            case PortalConstants.PROTEIN_PREDICTION_TYPE_SIFT:
                switch (codedValue){
                    case PortalConstants.PROTEIN_PREDICTION_SIFT_NONE_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_SIFT_NONE_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_SIFT_DELETERIOUS_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_SIFT_DELETERIOUS_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_SIFT_TOLERATED_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_SIFT_TOLERATED_NAME
                        break;
                    default:
                        log.error("Internal inconsistency: no SIFT codedValue = ${codedValue}")
                        break;
                }
                break;
            case PortalConstants.PROTEIN_PREDICTION_TYPE_CONDEL:
                switch (codedValue){
                    case PortalConstants.PROTEIN_PREDICTION_CONDEL_NONE_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_CONDEL_NONE_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_CONDEL_DELETERIOUS_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_CONDEL_DELETERIOUS_NAME
                        break;
                    case PortalConstants.PROTEIN_PREDICTION_CONDEL_BENIGN_CODE:
                        returnValue = PortalConstants.PROTEIN_PREDICTION_CONDEL_BENIGN_NAME
                        break;
                    default:
                        log.error("Internal inconsistency: no CONDEL codedValue = ${codedValue}")
                        break;
                }
                break;
            default:
                log.error("Internal inconsistency: no typeOfPrediction = ${typeOfPrediction}")
                break;
        }
        return returnValue
    }









    /***
     * put standard (non-custom) filters into a pleasing, human readable form.   Store them in a list, so that
     * a subsequent method can write them out with commas
     * @param allFilters
     * @return
     */
    public List<String> composeFiltersForClause(String aFilter) {
        List<String> returnValue = []
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder()
        String aDecodedFilter = getDataQueryHolder.decodeFilter(aFilter)
        if (!aDecodedFilter.contains("[")){
            returnValue << """
                                <span class="dd filterElement">${getDataQueryHolder.decodeFilter(aFilter)}</span>
                                """.toString()
        }

      //  }

//            // a line to describe the polyphen value
//            if (allFilters.regionChromosomeInput) {
//                returnValue << """
//                                <span class="dd filterElement">chromosome: ${allFilters.regionChromosomeInput}</span>
//                                """.toString()
//            }// a single line for the P value
//
//            // a line to describe the polyphen value
//            if (allFilters.regionStartInput) {
//                returnValue << """
//                                <span class="dd filterElement">start position:&nbsp; ${allFilters.regionStartInput}</span>
//                                """.toString()
//            }// a single line for the P value
//
//            // a line to describe the polyphen value
//            if (allFilters.regionStopInput) {
//                returnValue << """
//                                <span class="dd filterElement">end position:&nbsp; ${allFilters.regionStopInput}</span>
//                                """.toString()
//            }// a single line for the P value
//
//            // a line to describe the polyphen value
//            if (allFilters.gene) {
//                returnValue << """
//                                <span class="dd filterElement">${allFilters.gene}</span>
//                                """.toString()
//            }// a single line for the P value
//
//            // a line to describe the polyphen value
//            if (allFilters.predictedEffects) {
//                if (allFilters.predictedEffects != "${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}")  {  // don't display the default
//                    returnValue << """
//                                <span class="dd filterElement">predicted effects: ${prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_PROTEINEFFECT,allFilters.predictedEffects)}</span>
//                                """.toString()
//                }
//            }// a single line for the P value
//
//            if (allFilters.polyphenSelect) {
//                returnValue << """
//                                <span class="dd filterElement">polyphen prediction: ${prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_POLYPHEN,allFilters.polyphenSelect)}</span>
//                                """.toString()
//            }// a single line for the P value
//            if (allFilters.siftSelect) {
//                returnValue << """
//                                <span class="dd filterElement">sift prediction: ${prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_SIFT,allFilters.siftSelect)}</span>
//                                """.toString()
//            }// a single line for the P value
//            if (allFilters.condelSelect) {
//                returnValue << """
//                                <span class="dd filterElement">condel prediction: ${prettyPrintPredictedEffect(PortalConstants.PROTEIN_PREDICTION_TYPE_CONDEL,allFilters.condelSelect)}</span>
//                                """.toString()
//            }// a single line for the P value
//
//
//        }  // the section containing all filters
        
        return returnValue

    }



    public String writeOutFiltersAsHtml( out, String aFilter ){
        List<String> listOfCustomFilters = composeCustomFiltersForClause( aFilter )
        List<String> listOfFilters =  composeFiltersForClause( aFilter )
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
