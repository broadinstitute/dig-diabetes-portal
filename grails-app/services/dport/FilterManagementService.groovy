package dport

import grails.transaction.Transactional

@Transactional
class FilterManagementService {

    LinkedHashMap<String, String> standardFilterStrings = [
            "t2d-genomewide"  :
                    """{ "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 5e-8 }""".toString(),
            "t2d-nominal"     :
                    """{ "filter_type": "FLOAT", "operand": "_13k_T2D_P_EMMAX_FE_IV", "operator": "LTE", "value": 5e-2 }""".toString(),
            "exchp-genomewide":
                    """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 5e-8 }""".toString(),
            "exchp-nominal"   :
                    """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_P_value", "operator": "LTE", "value": 5e-2 }""".toString(),
            "lof"             :
                    """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 1 }""".toString(),
            "gwas-genomewide" :
                    """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 5e-8 }""".toString(),
            "gwas-nominal"    :
                    """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "LTE", "value": 5e-2 }""".toString(),
            "dataSetExseq"        :
                    """{ "filter_type": "STRING", "operand": "IN_EXSEQ", "operator": "EQ", "value": 1 }""".toString(),
            "dataSetExchp"        :
                    """{ "filter_type": "STRING", "operand": "IN_EXCHP", "operator": "EQ", "value": 1 }""".toString(),
            "dataSetDiagramGwas"    :
                    """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "GTE", "value": 0 }""".toString(),
            "dataSetSigma"   :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "GTE", "value":  }""".toString(),
            "sigma-genomewide":
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 5e-8 }""".toString(),
            "sigma-nominal"   :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "LTE", "value": 5e-2 }""".toString(),
            "onlySeenCaseT2d"        :
                    """{ "filter_type": "FLOAT", "operand": "_13k_T2D_MINU", "operator": "EQ", "value": 0 }""".toString(),
            "onlySeenCaseSigma"        :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MINU", "operator": "EQ", "value": 0 }""".toString(),
            "onlySeenControlT2d"        :
                    """{ "filter_type": "FLOAT", "operand": "_13k_T2D_MINA", "operator": "EQ", "value": 0 }""".toString(),
            "onlySeenControlSigma"        :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MINA", "operator": "EQ", "value": 0 }""".toString(),
            "onlySeenHomozygotes"        :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MINA", "operator": "EQ", "value": 0 }""".toString(),
            "proteinTruncatingCheckbox"        :
                    """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 1 }""".toString(),
            "missenseCheckbox"        :
                    """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 2 }""".toString(),
            "polyphenSelect"        :
                    """{ "filter_type": "STRING", "operand": "PolyPhen_PRED", "operator": "EQ", "value": "" }""".toString(),
            "condelSelect"        :
                    """{ "filter_type": "STRING", "operand": "Condel_PRED", "operator": "EQ", "value": "" }""".toString(),
            "siftSelect"        :
                    """{ "filter_type": "STRING", "operand": "SIFT_PRED", "operator": "EQ", "value": "" }""".toString(),
            "synonymousCheckbox"        :
                    """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 3 }""".toString(),
            "noncodingCheckbox"        :
                    """{ "filter_type": "FLOAT", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 4 }""".toString(),
            "in-sigma"        :
                    """{ "filter_type": "STRING", "operand": "IN_SIGMA", "operator": "EQ", "value": 1 }""".toString()

    ]


    String retrieveParameterizedFilterString (String filterName,
                                              String parm1,
                                              BigDecimal parm2) {
        String returnValue = ""
        switch (filterName){
            case "setPValueThreshold" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "${parm1}", "operator": "LTE", "value": ${parm2} }""".toString()
                break;
            case "setRegionGeneSpecification" :
                returnValue = """{ "filter_type": "STRING", "operand": "IN_GENE", "operator": "EQ", "value": "${parm1}" }""".toString()
                break;
            case "setRegionChromosomeSpecification" :
                returnValue = """{ "filter_type": "STRING", "operand": "CHROM", "operator": "EQ", "value": ${parm1} }""".toString()
                break;
            case "setRegionPositionStart" :
                returnValue = """{ "filter_type": "STRING", "operand": "POS", "operator": "GTE", "value": ${parm1} }""".toString()
                break;
            case "setRegionPositionEnd" :
                returnValue = """{ "filter_type": "STRING", "operand": "POS", "operator": "LTE", "value": ${parm1} }""".toString()
                break;
            case "setEthnicityMaximum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "_13k_T2D_${parm1}_MAF", "operator": "LTE", "value": ${parm2} }""".toString()
                break;
            case "setEthnicityMinimum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "_13k_T2D_${parm1}_MAF", "operator": "GTE", "value": ${parm2} }""".toString()
                break;
            case "setSigmaMinorAlleleFrequencyMinimum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MAF", "operator": "GTE", "value": ${parm2} }""".toString()
                break;
            case "setSigmaMinorAlleleFrequencyMaximum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MAF", "operator": "LTE", "value": ${parm2} }""".toString()
                break;

            default: break;
        }
         return  returnValue
    }


    String retrieveFilterString (String filterName) {
        String returnValue = ""
        if (standardFilterStrings.containsKey(filterName))     {
            returnValue =  standardFilterStrings [filterName]
        }
        return  returnValue
    }




    public String parseVariantSearchParameters (HashMap incomingParameters,Boolean currentlySigma) {
        StringBuilder sb  = new  StringBuilder ()

        LinkedHashMap map = determineDataSet (sb,incomingParameters)

        String datatypeOperand = map.datatypeOperand
        sb = map.sb

        sb = determineThreshold (sb, incomingParameters, datatypeOperand)

        sb = setRegion(sb, incomingParameters)

        sb = setAlleleFrequencies(sb, incomingParameters)

        sb = caseControlOnly(sb, incomingParameters,currentlySigma)

        sb = predictedEffectsOnProteins(sb, incomingParameters)

        return sb.toString()

    }




    private  LinkedHashMap determineDataSet (StringBuilder sb, HashMap incomingParameters){
        LinkedHashMap returnValue =  [:]
        String datatypeOperand = ""

        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["datatype"][0]

            switch (requestedDataSet)   {
                case  "sigma":
                    datatypeOperand = 'SIGMA_T2D_P'
                    sb <<  retrieveFilterString("dataSetSigma") << "\n"
                    break;
                case  "exomeseq":
                    datatypeOperand = '_13k_T2D_P_EMMAX_FE_IV'
                    sb <<  retrieveFilterString("dataSetExseq") << "\n"
                    break;
                case  "exomechip":
                    datatypeOperand = 'EXCHP_T2D_P_value'
                    sb <<  retrieveFilterString("dataSetExchp") << "\n"
                    break;
                case  "gwas":
                    datatypeOperand = 'GWAS_T2D_PVALUE'
                    sb <<  retrieveFilterString("dataSetDiagramGwas") << "\n"
                    break;
                default: break;
            }
        }

        return [sb:sb, datatypeOperand:datatypeOperand]

    }


    private  StringBuilder determineThreshold (StringBuilder sb, HashMap incomingParameters,String datatypeOperand){
        // set threshold
        if  (incomingParameters.containsKey("significance"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["significance"][0]
            switch (requestedDataSet)   {
                case  "genomewide":
                    sb <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,5e-8 as BigDecimal) << "\n"
                    break;
                case  "nominal":
                    sb << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,0.05 as BigDecimal) << "\n"
                    break;
                case  "custom":
                    if (incomingParameters.containsKey("custom_significance_input")) {
                        String stringCustomThreshold = incomingParameters["custom_significance_input"][0]
                        BigDecimal numericCustomThreshold
                        try {
                            numericCustomThreshold = new BigDecimal(stringCustomThreshold)
                        }  catch (exception)  {
                            // presumably we have a nonnumeric value in the custom threshold
                            // ignore the request for custom threshold altogether in this case
                            //TODO: this is an error condition. User supplied a nonnumeric custom threshold
                            break;
                        }
                        sb << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,numericCustomThreshold) << "\n"
                    } else {
                        //TODO: this is an error condition. User requested a custom threshold but supplied no threshold
                        // description of that threshold. We need a specification of what to do ( from Mary?)
                        break;
                    }
                    break;
                default: break;
            }
        }

        return sb
    }

    private  StringBuilder setRegion (StringBuilder sb, HashMap incomingParameters) {
        // set the search region
        // set gene to search
        if (incomingParameters.containsKey("region_gene_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_gene_input"][0]
            sb << retrieveParameterizedFilterString("setRegionGeneSpecification", stringParameter, 0) << "\n"
        }

        // set gene to search
        if (incomingParameters.containsKey("region_chrom_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_chrom_input"][0]
            java.util.regex.Matcher chromosomeNumber = stringParameter =~ /\d+/
            if (chromosomeNumber)   {
                sb << retrieveParameterizedFilterString("setRegionChromosomeSpecification", chromosomeNumber[0].toString(), 0) << "\n"
            } else {
                // TODO: ERROR CONDITION.  DEFAULT?
            }

        }

        // set beginning chromosome extent
        if (incomingParameters.containsKey("region_start_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_start_input"][0]
            Integer extentDelimiter
            Boolean errorFree = true
            try {
                extentDelimiter = new BigDecimal(stringParameter).intValue()
            } catch (exception) {
                // TODO: this is an error condition -- the user-specified a non-numeric extent. What is the correct default action here ?
                exception.printStackTrace()
                errorFree = false
            }
            if (errorFree) {
                sb << retrieveParameterizedFilterString("setRegionPositionStart", extentDelimiter.toString(), 0) << "\n"
            }

        }

        // set ending chromosome extent
        if (incomingParameters.containsKey("region_stop_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_stop_input"][0]
            Integer extentDelimiter
            Boolean errorFree = true
            try {
                extentDelimiter = new BigDecimal(stringParameter).intValue()
            } catch (exception) {
                // TODO: this is an error condition -- the user-specified a non-numeric extent. What is the correct default action here ?
                exception.printStackTrace()
                errorFree = false
            }
            if (errorFree) {
                sb << retrieveParameterizedFilterString("setRegionPositionEnd", extentDelimiter.toString(), 0) << "\n"
            }

        }
        return  sb

    }



    private  StringBuilder setAlleleFrequencies (StringBuilder sb, HashMap incomingParameters) {
       List <String> ethnicities = ['AA', 'EA', 'SA', 'EU', 'HS']
       List <String> minMax = ['min', 'max']
       for (String ethnicity in ethnicities) {
           for (String minOrMax in minMax) {
               // work with individual ethnicities
               String ethnicityReference  =  "ethnicity_af_" + ethnicity + "-" +minOrMax
               if (incomingParameters.containsKey(ethnicityReference)) {
                   String specificAlleleFrequency = incomingParameters[ethnicityReference][0]
                   if ((specificAlleleFrequency) &&
                           (specificAlleleFrequency.length() > 0)) {
                       Boolean errorFree = true
                       BigDecimal alleleFrequency
                       try {
                           alleleFrequency = new BigDecimal(specificAlleleFrequency)
                       } catch (exception) {
                           errorFree = false
                           // TODO: this is an error condition -- the user-specified a non-numeric allele frequency.  Default behavior?
                           exception.printStackTrace()
                       }
                       if (errorFree) {
                           if (minOrMax == 'min') {
                               sb << retrieveParameterizedFilterString("setEthnicityMinimum", ethnicity, alleleFrequency) << "\n"
                           } else {
                               sb << retrieveParameterizedFilterString("setEthnicityMaximum", ethnicity, alleleFrequency) << "\n"
                           }
                       }

                   }
               }

           }

       }
       for (String minOrMax in minMax) {
            String ethnicityReference  =  "ethnicity_af_sigma-" +minOrMax
            if (incomingParameters.containsKey(ethnicityReference)) {
                String specificAlleleFrequency = incomingParameters[ethnicityReference][0]
                if ((specificAlleleFrequency) &&
                        (specificAlleleFrequency.length() > 0)) {
                    Boolean errorFree = true
                    BigDecimal alleleFrequency
                    try {
                        alleleFrequency = new BigDecimal(specificAlleleFrequency)
                    } catch (exception) {
                        errorFree = false
                        // TODO: this is an error condition -- the user-specified a non-numeric allele frequency.  Default behavior?
                        exception.printStackTrace()
                    }
                    if (errorFree) {
                        if (minOrMax == 'min') {
                            sb << retrieveParameterizedFilterString("setSigmaMinorAlleleFrequencyMinimum", "", alleleFrequency) << "\n"
                        } else {
                            sb << retrieveParameterizedFilterString("setSigmaMinorAlleleFrequencMaximum", "", alleleFrequency) << "\n"
                        }
                    }

                }
            }

        }
        return sb
    }



    private  StringBuilder caseControlOnly (StringBuilder sb, HashMap incomingParameters, Boolean usingSigma){

        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("t2dcases")) {
            if (usingSigma) {
                sb << retrieveFilterString("onlySeenCaseSigma") << "\n"
            } else {
                sb << retrieveFilterString("onlySeenCaseT2d") << "\n"
            }
        }
        if  (incomingParameters.containsKey("t2dcontrols")) {
            if (usingSigma) {
                sb << retrieveFilterString("onlySeenControlSigma") << "\n"
            } else {
                sb << retrieveFilterString("onlySeenControlT2d") << "\n"
            }
        }
        if  (incomingParameters.containsKey("homozygotes")) {
            sb << retrieveFilterString("onlySeenHomozygotes") << "\n"
        }

        return sb

    }


    private  StringBuilder predictedEffectsOnProteins (StringBuilder sb, HashMap incomingParameters){

        if  (incomingParameters.containsKey("predictedEffects"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String predictedEffects =  incomingParameters ["predictedEffects"][0]

            switch (predictedEffects)   {
                case  "all-effects":
                    // this is the default, do nothing
                    break;
                case  "protein-truncating":
                    sb <<  retrieveFilterString("proteinTruncatingCheckbox") << "\n"
                    break;
                case  "missense":
                    sb <<  retrieveFilterString("missenseCheckbox") << "\n"
                    break;
                case  "noEffectSynonymous":
                     sb <<  retrieveFilterString("synonymousCheckbox") << "\n"
                    break;
                case  "noEffectNoncoding":
                    sb <<  retrieveFilterString("noncodingCheckbox") << "\n"
                    break;

                default: break;
            }
        }

        return sb

    }




}
