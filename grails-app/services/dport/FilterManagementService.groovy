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
                    """{ "filter_type": "STRING", "operand": "IN_EXSEQ", "operator": "EQ", "value": "1" }""".toString(),
            "dataSetExchp"        :
                    """{ "filter_type": "STRING", "operand": "IN_EXCHP", "operator": "EQ", "value": "1" }""".toString(),
            "dataSetDiagramGwas"    :
                    """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "GTE", "value": 0 }""".toString(),
            "dataSetSigma"   :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "GTE", "value":  }""".toString(),   // TODO: We need a number here
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
                returnValue = """{ "filter_type": "STRING", "operand": "CHROM", "operator": "EQ", "value": "${parm1}" }""".toString()
                break;
            case "setRegionPositionStart" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "POS", "operator": "GTE", "value": ${parm1} }""".toString()
                break;
            case "setRegionPositionEnd" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "POS", "operator": "LTE", "value": ${parm1} }""".toString()
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



    public LinkedHashMap  parseVariantSearchParameters (HashMap incomingParameters,Boolean currentlySigma) {
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>()]


        buildingFilters = determineDataSet (buildingFilters,incomingParameters)

        String datatypeOperand = buildingFilters.datatypeOperand

        buildingFilters = determineThreshold (buildingFilters, incomingParameters, datatypeOperand)

        buildingFilters = setRegion(buildingFilters, incomingParameters)

        buildingFilters = setAlleleFrequencies(buildingFilters, incomingParameters)

        buildingFilters = caseControlOnly(buildingFilters, incomingParameters,currentlySigma)

        buildingFilters = predictedEffectsOnProteins(buildingFilters, incomingParameters)

        return buildingFilters

    }

    /***
     * user has requested a search based on gene name, potentially with additional filtering based on ethnicity.
     *
     * @param geneId
     * @param receivedParameters
     * @return
     */
    public LinkedHashMap constructGeneSearch(String geneId,String receivedParameters) {
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>()]

        buildingFilters = findFiltersForGeneBasedSearch (buildingFilters,geneId)

        buildingFilters = findFiltersBasedOnMaf (buildingFilters,receivedParameters)

        return buildingFilters
    }


    /***
     * user has requested a search based on gene name, potentially with additional filtering based on ethnicity.  Construct
     * filters for them.
     * @param buildingFilters
     * @param geneId
     * @param receivedParameters
     * @return
     */
    LinkedHashMap findFiltersForGeneBasedSearch (LinkedHashMap  buildingFilters, String geneId ) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions

        filters <<  retrieveParameterizedFilterString("setRegionGeneSpecification",geneId,0)
        filterDescriptions << "Restricted to gene "+geneId

        return buildingFilters
    }




    LinkedHashMap findFiltersBasedOnMaf(LinkedHashMap  buildingFilters, String receivedParameters ) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions

        if (receivedParameters) {
            String[] requestPortionList =  receivedParameters.split("-")
            if (requestPortionList.size() > 1) {
                String ethnicity = requestPortionList[1]
                switch ( requestPortionList[0] ){
                    case "total":
                        filters << retrieveFilterString("dataSetDiagramGwas")
                        filterDescriptions << "GWAS P value > 0"
                        break;
                    case "common":
                        filters << retrieveParameterizedFilterString("setEthnicityMinimum",ethnicity,0.05)
                        filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than or equal to 0.05"
                        break;
                    case "lowfreq":
                        filters << retrieveParameterizedFilterString("setEthnicityMinimum",ethnicity,0.005)
                        filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than or equal to 0.005"
                        filters << retrieveParameterizedFilterString("setEthnicityMaximum",ethnicity,0.05)
                        filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is less than 0.05"
                        break;
                    case "rare":
                        filters << retrieveParameterizedFilterString("setEthnicityMinimum",ethnicity,0)
                        filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than or equal to 0.005"
                        filters << retrieveParameterizedFilterString("setEthnicityMaximum",ethnicity,0.005)
                        filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is less than 0.05"
                        break;
                    default: break;
                }

            }

        }
        return buildingFilters
    }






    private  LinkedHashMap determineDataSet (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        String datatypeOperand = ""

        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["datatype"][0]

            switch (requestedDataSet)   {
                case  "sigma":
                    datatypeOperand = 'SIGMA_T2D_P'
                    filters <<  retrieveFilterString("dataSetSigma") 
                    filterDescriptions << "Whether variant is included in SIGMA analysis is equal to 1"
                    break;
                case  "exomeseq":
                    datatypeOperand = '_13k_T2D_P_EMMAX_FE_IV'
                    filters <<  retrieveFilterString("dataSetExseq") 
                    filterDescriptions << "Is observed in exome sequencing"
                    break;
                case  "exomechip":
                    datatypeOperand = 'EXCHP_T2D_P_value'
                    filters <<  retrieveFilterString("dataSetExchp") 
                    filterDescriptions << "Is observed in exome chip"
                    break;
                case  "gwas":
                    datatypeOperand = 'GWAS_T2D_PVALUE'
                    filters <<  retrieveFilterString("dataSetDiagramGwas") 
                    filterDescriptions << "P-value for association with T2D in GWAS dataset is greater than or equal to 0"
                    break;
                default: break;
            }
        }
        buildingFilters["datatypeOperand"]  =  datatypeOperand
        return buildingFilters

    }


    private  LinkedHashMap determineThreshold (LinkedHashMap  buildingFilters, HashMap incomingParameters,String datatypeOperand){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        // set threshold
        if  (incomingParameters.containsKey("significance"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["significance"][0]
            switch (requestedDataSet)   {
                case  "genomewide":
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,5e-8 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 5e-8"
                    break;
                case  "nominal":
                    filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,0.05 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 0.05"
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
                        filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,numericCustomThreshold) 
                        filterDescriptions << "P-value for association with T2D is less than or equal to ${numericCustomThreshold}"
                    } else {
                        //TODO: this is an error condition. User requested a custom threshold but supplied no threshold
                        // description of that threshold. We need a specification of what to do ( from Mary?)
                        break;
                    }
                    break;
                default: break;
            }
        }

        return buildingFilters
    }

    private  LinkedHashMap setRegion (LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        // set the search region
        // set gene to search
        if (incomingParameters.containsKey("region_gene_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_gene_input"][0]
            filters << retrieveParameterizedFilterString("setRegionGeneSpecification", stringParameter, 0) 
            filterDescriptions << "In the gene ${stringParameter}"
        }

        // set gene to search
        if (incomingParameters.containsKey("region_chrom_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_chrom_input"][0]
            java.util.regex.Matcher chromosomeNumber = stringParameter =~ /\d+/
            if (chromosomeNumber)   {
                filters << retrieveParameterizedFilterString("setRegionChromosomeSpecification", chromosomeNumber[0].toString(), 0) 
                filterDescriptions << "Chromosome is equal to ${stringParameter}"
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
                filters << retrieveParameterizedFilterString("setRegionPositionStart", extentDelimiter.toString(), 0) 
                filterDescriptions << "Chromosomal position is greater than or equal to ${extentDelimiter.toString()}"
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
                filters << retrieveParameterizedFilterString("setRegionPositionEnd", extentDelimiter.toString(), 0) 
                filterDescriptions << "Chromosomal position is less than or equal to ${extentDelimiter.toString()}"
            }

        }
        return  buildingFilters

    }



    private  LinkedHashMap setAlleleFrequencies (LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        //ethnicities and minor allele frequencies
       List <List<String>> ethnicities = []
        ethnicities << ['African-Americans','AA']
        ethnicities << ['East Asians','EA']
        ethnicities << ['Europeans','EU']
        ethnicities << ['South Asians','SA']
        ethnicities << ['Hispanics','HS']
       List <String> minMax = ['min', 'max']
       for (List<String> ethnicity in ethnicities) {
           for (String minOrMax in minMax) {
               // work with individual ethnicities
               String ethnicityReference  =  "ethnicity_af_" + ethnicity[1] + "-" +minOrMax
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
                               filters << retrieveParameterizedFilterString("setEthnicityMinimum", ethnicity[1], alleleFrequency) 
                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is greater than or equal to ${alleleFrequency}"
                           } else {
                               filters << retrieveParameterizedFilterString("setEthnicityMaximum", ethnicity[1], alleleFrequency) 
                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is less than or equal to  ${alleleFrequency}"
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
                            filters << retrieveParameterizedFilterString("setSigmaMinorAlleleFrequencyMinimum", "", alleleFrequency) 
                            filterDescriptions << "Minor allele frequency is greater than or equal to ${alleleFrequency}"
                        } else {
                            filters << retrieveParameterizedFilterString("setSigmaMinorAlleleFrequencMaximum", "", alleleFrequency) 
                            filterDescriptions << "Minor allele frequency less than or equal to ${alleleFrequency}"
                        }
                    }

                }
            }

        }
        return buildingFilters

    }



    private  LinkedHashMap caseControlOnly (LinkedHashMap  buildingFilters, HashMap incomingParameters, Boolean usingSigma){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("t2dcases")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenCaseSigma") 
                filterDescriptions << "Number of minor alleles observed in cases in SIGMA analysis is equal to 0"
            } else {
                filters << retrieveFilterString("onlySeenCaseT2d") 
                filterDescriptions << "Number of case observations is equal to 0"
            }
        }
        if  (incomingParameters.containsKey("t2dcontrols")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenControlSigma") 
                filterDescriptions << "Number of minor alleles observed in controls in SIGMA analysis is equal to 0"
            } else {
                filters << retrieveFilterString("onlySeenControlT2d") 
                filterDescriptions << "Number of control observations is equal to 0"
            }
        }
        if  (incomingParameters.containsKey("homozygotes")) {
            filters << retrieveFilterString("onlySeenHomozygotes") 
            filterDescriptions << "Number of minor alleles observed in homozygotes is equal to 0"
        }

        return buildingFilters

    }


    private  LinkedHashMap predictedEffectsOnProteins (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        if  (incomingParameters.containsKey("predictedEffects"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String predictedEffects =  incomingParameters ["predictedEffects"][0]

            switch (predictedEffects)   {
                case  "all-effects":
                    // this is the default, do nothing
                    break;
                case  "protein-truncating":
                    filters <<  retrieveFilterString("proteinTruncatingCheckbox") 
                    filterDescriptions << "Estimated classification for proteins truncating variant effect"
                    break;
                case  "missense":
                    filters <<  retrieveFilterString("missenseCheckbox") 
                    filterDescriptions << "Estimated classification for missense effect"
                    break;
                case  "noEffectSynonymous":
                    filters <<  retrieveFilterString("synonymousCheckbox") 
                    filterDescriptions << "Estimated classification for no effects (synonymous)"
                    break;
                case  "noEffectNoncoding":
                    filters <<  retrieveFilterString("noncodingCheckbox") 
                    filterDescriptions <<  "Estimated classification for no effects (non-coding)"
                    break;

                default: break;
            }
        }

        return buildingFilters

    }




}
