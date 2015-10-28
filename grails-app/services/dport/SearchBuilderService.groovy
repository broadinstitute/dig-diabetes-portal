package dport

import grails.transaction.Transactional
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.util.PortalConstants

@Transactional
class SearchBuilderService {


    SharedToolsService sharedToolsService
    SearchBuilderService searchBuilderService
    MetaDataService metaDataService

    /***
     * Printing the protein predictions is a bit of a bother. Here's the routine
     *
     * @param typeOfPrediction
     * @param codedValueAsString
     * @param operatorSplitCharacter
     * @return
     */
    public String prettyPrintPredictedEffect (int typeOfPrediction, String codedValueAsString,String operatorSplitCharacter){
        String returnValue = ""
        int codedValue = 0

        // DIGP-140: now account for non integer input for coded value, so check for that
        boolean gotNonIntCodedValue = false;

        try {
            codedValue = Integer.parseInt(codedValueAsString)
        } catch(e){
            gotNonIntCodedValue = true;
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
                if (gotNonIntCodedValue) {
                    return returnValue = codedValueAsString
                } else {
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
                }
                break;
            case PortalConstants.PROTEIN_PREDICTION_TYPE_SIFT:
                if (gotNonIntCodedValue) {
                    return returnValue = codedValueAsString
                } else {
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
                }
                break;
            case PortalConstants.PROTEIN_PREDICTION_TYPE_CONDEL:
                if (gotNonIntCodedValue) {
                    return returnValue = codedValueAsString
                } else {
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
                }
                break;
            default:
                log.error("Internal inconsistency: no typeOfPrediction = ${typeOfPrediction}")
                break;
        }
        String operatorPresentation = "="
        switch (operatorSplitCharacter){
            case "=":operatorPresentation = " : "
                break;
            case "<":operatorPresentation = " less than "
                break;
            case ">":operatorPresentation = " greater than "
                break;
            default: break
        }
        return "${operatorPresentation}${returnValue}"
    }





    public String writeOutFiltersAsHtml( out, String aFilter ){
        GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder([],searchBuilderService,metaDataService)
        String aDecodedFilter = getDataQueryHolder.decodeFilter(aFilter)
        return aDecodedFilter
    }



}
