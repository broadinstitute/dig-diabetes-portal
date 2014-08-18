package dport

import grails.transaction.Transactional

@Transactional
class FilterManagementService {


    RestServerService restServerService

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
            case "setEthnicityMaximumAbsolute" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "_13k_T2D_${parm1}_MAF", "operator": "LT", "value": ${parm2} }""".toString()
                break;
            case "setEthnicityMinimum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "_13k_T2D_${parm1}_MAF", "operator": "GTE", "value": ${parm2} }""".toString()
                break;
            case "setEthnicityMinimumAbsolute" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "_13k_T2D_${parm1}_MAF", "operator": "GT", "value": ${parm2} }""".toString()
                break;
            case "setExomeChipMinimum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_MAF", "operator": "GTE", "value": ${parm2} }""".toString()
                break;
            case "setExomeChipMinimumAbsolute" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_MAF", "operator": "GT", "value": ${parm2} }""".toString()
                break;
            case "setExomeChipMaximumAbsolute" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_MAF", "operator": "LT", "value": ${parm2} }""".toString()
                break;
            case "setSigmaMinorAlleleFrequencyMinimum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MAF", "operator": "GTE", "value": ${parm2} }""".toString()
                break;
            case "setSigmaMinorAlleleFrequencyMaximum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_MAF", "operator": "LTE", "value": ${parm2} }""".toString()
                break;
            case "polyphenSelect" :
                returnValue = """{ "filter_type": "STRING", "operand": "PolyPhen_PRED", "operator": "EQ", "value": "${parm1}" }""".toString()
                break;
            case "condelSelect"        :
                returnValue = """{ "filter_type": "STRING", "operand": "Condel_PRED", "operator": "EQ", "value": "${parm1}" }""".toString()
                break;
            case  "siftSelect"        :
                returnValue = """{ "filter_type": "STRING", "operand": "SIFT_PRED", "operator": "EQ", "value": "${parm1}" }""".toString()
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
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]


        buildingFilters = determineDataSet (buildingFilters,incomingParameters)

        String datatypeOperand = buildingFilters.datatypeOperand

        buildingFilters = determineThreshold (buildingFilters, incomingParameters, datatypeOperand)

        buildingFilters = setRegion(buildingFilters, incomingParameters)

        buildingFilters = setAlleleFrequencies(buildingFilters, incomingParameters)

        buildingFilters = caseControlOnly(buildingFilters, incomingParameters,currentlySigma)

        buildingFilters = predictedEffectsOnProteins(buildingFilters, incomingParameters)

        buildingFilters = predictedImpactOfMissenseMutations(buildingFilters, incomingParameters)

        return buildingFilters

    }






    /***
     * user has requested a search based on gene name, potentially with additional filtering based on ethnicity.
     *
     * @param geneId
     * @param receivedParameters
     * @return
     */
    public LinkedHashMap constructGeneWideSearch(String geneId,String significance, String dataset, String region) {
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]

        // We need to use  determineDataSet First, since it determines the data type operand that is passed to determineThreshold
        LinkedHashMap passInDataset = [:]
        passInDataset["datatype"] = [dataset]

        buildingFilters = parameterizedDataSet (  buildingFilters, passInDataset,significance)

        if ( region ) { // If there's a region then use it. Otherwise depend on the gene name. Don't use both
            LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(region)
            if ((extractedNumbers)   &&
                    (extractedNumbers["startExtent"])   &&
                    (extractedNumbers["endExtent"])&&
                    (extractedNumbers["chromosomeNumber"]) ) {

                LinkedHashMap packagedParameters = [:]
                packagedParameters ["region_chrom_input"]  =  [extractedNumbers["chromosomeNumber"]]
                packagedParameters ["region_start_input"]  =  [extractedNumbers["startExtent"]]
                packagedParameters ["region_stop_input"]  =  [extractedNumbers["endExtent"]]
                buildingFilters = setRegion (buildingFilters,  packagedParameters)
            }

        }  else {
                buildingFilters = findFiltersForGeneBasedSearch (buildingFilters,geneId)
        }




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
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]

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
        List <String> parameterEncoding =  buildingFilters.parameterEncoding

        filters <<  retrieveParameterizedFilterString("setRegionGeneSpecification",geneId,0)
        filterDescriptions << "Restricted to gene "+geneId
        parameterEncoding << ("4:"+geneId)

        return buildingFilters
    }




    LinkedHashMap findFiltersBasedOnMaf(LinkedHashMap  buildingFilters, String receivedParameters ) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding

        if (receivedParameters) {
            String[] requestPortionList =  receivedParameters.split("-")
            if (requestPortionList.size() > 1) {  //  multipiece searches
                String ethnicity = requestPortionList[1]
                int ethnicityFieldIndex = 0
                if (ethnicity == 'exchp'){ // we have no ethnicity. Everything comes from the European exome chipset
                    switch ( requestPortionList[0] ){
                        case "total":
                            filters << retrieveParameterizedFilterString("setExomeChipMinimum","",0)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is greater than or equal to zero"
                            parameterEncoding << ("14:0")
                            parameterEncoding << ("15:1")
                            break;
                        case "common":
                            filters << retrieveParameterizedFilterString("setExomeChipMinimum","",0.05)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is greater than or equal to 0.05"
                            parameterEncoding << ("14:0.05")
                            parameterEncoding << ("15:1")
                            break;
                        case "lowfreq":
                            filters << retrieveParameterizedFilterString("setExomeChipMinimum",ethnicity,0.005)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is greater than or equal to 0.005"
                            filters << retrieveParameterizedFilterString("setExomeChipMaximumAbsolute",ethnicity,0.05)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is less than 0.05"
                            parameterEncoding << ("14:0.005")
                            parameterEncoding << ("15:0.05")
                            break;
                        case "rare":
                            filters << retrieveParameterizedFilterString("setExomeChipMinimumAbsolute",ethnicity,0)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is greater than 0"
                            filters << retrieveParameterizedFilterString("setExomeChipMaximumAbsolute",ethnicity,0.005)
                            filterDescriptions << "Minor allele frequency in exome chip dataset is less than 0.005"
                            parameterEncoding << ("14:0")
                            parameterEncoding << ("15:0.005")
                            break;
                        default: break;
                    }

                } else {   // we have ethnicity data
                    switch (ethnicity) {
                        case 'AA': ethnicityFieldIndex = 8; break;
                        case 'EA': ethnicityFieldIndex = 10; break;
                        case 'SA': ethnicityFieldIndex = 12; break;
                        case 'EU': ethnicityFieldIndex = 14; break;
                        case 'HS': ethnicityFieldIndex = 16; break;
                        default: ethnicityFieldIndex = 8;
                    }
                    switch ( requestPortionList[0] ){
                        case "total":
                            filters << retrieveParameterizedFilterString("setEthnicityMinimumAbsolute",ethnicity,0)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than 0"
                            parameterEncoding << ("${ethnicityFieldIndex}:0")
                            parameterEncoding << ("${ethnicityFieldIndex+1}:1")
                            break;
                        case "common":
                            filters << retrieveParameterizedFilterString("setEthnicityMinimum",ethnicity,0.05)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than or equal to 0.05"
                            parameterEncoding << ("${ethnicityFieldIndex}:05")
                            parameterEncoding << ("${ethnicityFieldIndex+1}:1")
                            break;
                        case "lowfreq":
                            filters << retrieveParameterizedFilterString("setEthnicityMinimum",ethnicity,0.005)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than or equal to 0.005"
                            filters << retrieveParameterizedFilterString("setEthnicityMaximumAbsolute",ethnicity,0.05)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is less than 0.05"
                            parameterEncoding << ("${ethnicityFieldIndex}:0.005")
                            parameterEncoding << ("${ethnicityFieldIndex+1}:0.05")
                            break;
                        case "rare":
                            filters << retrieveParameterizedFilterString("setEthnicityMinimumAbsolute",ethnicity,0)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is greater than 0"
                            filters << retrieveParameterizedFilterString("setEthnicityMaximumAbsolute",ethnicity,0.005)
                            filterDescriptions << "Minor allele frequency in ${ethnicity} from exome sequencing data set is less than 0.005"
                            parameterEncoding << ("${ethnicityFieldIndex}:0")
                            parameterEncoding << ("${ethnicityFieldIndex+1}:0.005")
                            break;
                        default: break;
                    }
                }

            } else {  // we can put specialized searches here
                switch (requestPortionList[0]) {
                    case "lof":
                        filters << retrieveFilterString ("lof")
                        filterDescriptions << "Variant predicted to result in loss of function"
                        parameterEncoding << ("23:1")
                        break;
                    default: break;
                }
            }

        }
        return buildingFilters
    }


    /***
     * Here's the string matching that is usually done inside the filter compilation methods below. We also call this one routine directly from
     * the VariantController, however, so it makes sense to perform this comparison in its own module
     * @param incomingParameters
     * @return
     */
    public  int distinguishBetweenDataSets (HashMap incomingParameters){
        int returnValue = 0;
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["datatype"][0]

            switch (requestedDataSet)   {
                case  "gwas":
                    returnValue = 0
                    break;
                case  "sigma":
                    returnValue = 1
                    break;
                case  "exomeseq":
                    returnValue = 2
                    break;
                case  "exomechip":
                    returnValue = 3
                    break;

                default: break;
            }
        }
        return returnValue

    }

    /***
     * Like most of the other routines in this module we are mapping parameters to filters. There is one additional
     * level of interaction for this routine because some other unrelated routine also needs to be able to make this
     * distinction.  Therefore we break out this string matching and put it in external method   (distinguishBetweenDataSets)
     * so that our code stays nice and DRY
     *
     * @param buildingFilters
     * @param incomingParameters
     * @return
     */
    private  LinkedHashMap determineDataSet (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        String datatypeOperand = ""

        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?

            int dataSetDistinguisher =   distinguishBetweenDataSets ( incomingParameters)


            switch (dataSetDistinguisher)   {
                case  0:
                    datatypeOperand = 'GWAS_T2D_PVALUE'
                    filters <<  retrieveFilterString("dataSetDiagramGwas")
                    filterDescriptions << "P-value for association with T2D in GWAS dataset is greater than or equal to 0"
                    parameterEncoding << "1:3"
                    break;

                case  1:
                    datatypeOperand = 'SIGMA_T2D_P'
                    filters <<  retrieveFilterString("dataSetSigma") 
                    filterDescriptions << "Whether variant is included in SIGMA analysis is equal to 1"
                    parameterEncoding << "1:0"
                    break;
                case  2:
                    datatypeOperand = '_13k_T2D_P_EMMAX_FE_IV'
                    filters <<  retrieveFilterString("dataSetExseq") 
                    filterDescriptions << "Is observed in exome sequencing"
                    parameterEncoding << "1:1"
                    break;
                case  3:
                    datatypeOperand = 'EXCHP_T2D_P_value'
                    filters <<  retrieveFilterString("dataSetExchp") 
                    filterDescriptions << "Is observed in exome chip"
                    parameterEncoding << "1:2"
                    break;
                default: break;
            }
        }
        buildingFilters["datatypeOperand"]  =  datatypeOperand
        return buildingFilters

    }















    private  LinkedHashMap parameterizedDataSet (LinkedHashMap  buildingFilters, HashMap incomingParameters, String significance){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        String datatypeOperand = ""

        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?

            int dataSetDistinguisher =   distinguishBetweenDataSets ( incomingParameters)


            switch (dataSetDistinguisher)   {
                case  0:
                    datatypeOperand = 'GWAS_T2D_PVALUE'
                    if (significance=="everything") {
                        filters <<  retrieveFilterString("dataSetDiagramGwas")
                        filterDescriptions << "P-value for association with T2D in GWAS dataset is greater than or equal to 0"
                        parameterEncoding << "1:3"
                    } else if (significance=="genome-wide") {
                        filters <<  retrieveFilterString("gwas-genomewide")
                        filterDescriptions << "P-value for association with T2D in GWAS dataset is less than or equal to 05e-8"
                        parameterEncoding << "1:3"
                        parameterEncoding << "2:0"
                    } else if (significance=="nominal"){
                        filters <<  retrieveFilterString("gwas-nominal")
                        filterDescriptions << "P-value for association with T2D in GWAS dataset is less than or equal to 0.05"
                        parameterEncoding << "1:3"
                        parameterEncoding << "2:1"
                    }
                    break;

                case  1:
                    datatypeOperand = 'SIGMA_T2D_P'
                    if (significance=="everything") {
                        filters <<  retrieveFilterString("dataSetSigma")
                        filterDescriptions << "P-value for association in SIGMA analysis is greater than or equal to 0"
                        parameterEncoding << "1:0"
                    } else if (significance=="genome-wide") {
                        filters <<  retrieveFilterString("sigma-genomewide")
                        filterDescriptions << "P-value for association in SIGMA analysis is less than or equal to 0.5e-8"
                        parameterEncoding << "1:0"
                        parameterEncoding << "2:0"
                    } else if (significance=="nominal"){
                        filters <<  retrieveFilterString("sigma-nominal")
                        filterDescriptions << "P-value for association in the SIGMA analysis is less than or equal to 0.05"
                        parameterEncoding << "1:0"
                        parameterEncoding << "2:1"
                    }
                    break;
                case  2:
                    datatypeOperand = '_13k_T2D_P_EMMAX_FE_IV'
                    if (significance=="everything") {
                        filters <<  retrieveFilterString("dataSetExseq")
                        filterDescriptions << "P-value for association in exome sequencing"
                        parameterEncoding << "1:1"
                    } else if (significance=="genome-wide") {
                        filters <<  retrieveFilterString("exchp-genomewide")
                        filterDescriptions << "P-value for association in exome sequencing"
                        filterDescriptions << "P-value significance is less than or equal to  0.5e-8"
                        parameterEncoding << "1:1"
                        parameterEncoding << "2:0"
                    } else if (significance=="nominal"){
                        filters <<  retrieveFilterString("exchp-nominal")
                        filterDescriptions << "P-value for association in exome sequencing"
                        filterDescriptions << "P-value significance is less than or equal to  0.05"
                        parameterEncoding << "1:1"
                        parameterEncoding << "2:1"
                    }
                    break;
                case  3:
                    datatypeOperand = 'EXCHP_T2D_P_value'
                    if (significance=="everything") {
                        filters <<  retrieveFilterString("dataSetExchp")
                        filterDescriptions << "P-value for association in exome chip studies"
                        parameterEncoding << "1:1"
                    } else if (significance=="genome-wide") {
                        filters <<  retrieveFilterString("t2d-genomewide")
                        filterDescriptions << "P-value for association in exome chip studies"
                        filterDescriptions << "P-value significance is less than or equal to  0.5e-8"
                        parameterEncoding << "1:1"
                        parameterEncoding << "2:0"
                    } else if (significance=="nominal"){
                        filters <<  retrieveFilterString("t2d-nominal")
                        filterDescriptions << "P-value for association in exome chip studies"
                        filterDescriptions << "P-value significance is less than or equal to  0.05"
                        parameterEncoding << "1:1"
                        parameterEncoding << "2:1"
                    }

                    filters <<  retrieveFilterString("dataSetExchp")
                    filterDescriptions << "Is observed in exome chip"
                    parameterEncoding << "1:2"
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
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // set threshold
        if  (incomingParameters.containsKey("significance"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["significance"][0]
            switch (requestedDataSet)   {
                case  "genomewide":
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,5e-8 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 5e-8"
                    parameterEncoding << "2:0"
                    break;
                case  "nominal":
                    filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,0.05 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 0.05"
                    parameterEncoding << "2:1"
                    break;
                case  "custom":
                    if (incomingParameters.containsKey("custom_significance_input")) {
                        parameterEncoding << "2:2"
                        String stringCustomThreshold = incomingParameters["custom_significance_input"][0]
                        BigDecimal numericCustomThreshold
                        try {
                            numericCustomThreshold = new BigDecimal(stringCustomThreshold)
                            parameterEncoding << ("3:"+numericCustomThreshold.toString())
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
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // set the search region
        // set gene to search
        if (incomingParameters.containsKey("region_gene_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_gene_input"][0]
            filters << retrieveParameterizedFilterString("setRegionGeneSpecification", stringParameter, 0) 
            filterDescriptions << "In the gene ${stringParameter}"
            parameterEncoding << "4:${stringParameter}"
        }

        // set gene to search
        if (incomingParameters.containsKey("region_chrom_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_chrom_input"][0]
            java.util.regex.Matcher chromosomeNumber = stringParameter =~ /\d+/
            if (chromosomeNumber)   {
                filters << retrieveParameterizedFilterString("setRegionChromosomeSpecification", chromosomeNumber[0].toString(), 0) 
                filterDescriptions << "Chromosome is equal to ${stringParameter}"
                parameterEncoding << "5:${stringParameter}"
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
                parameterEncoding << "6:${stringParameter}"
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
                parameterEncoding << "7:${stringParameter}"
            }

        }
        return  buildingFilters

    }



    private  LinkedHashMap setAlleleFrequencies (LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        //ethnicities and minor allele frequencies
       List <List<String>> ethnicities = []
        ethnicities << ['African-Americans','AA']
        ethnicities << ['East Asians','EA']
        ethnicities << ['South Asians','SA']
        ethnicities << ['Europeans','EU']
        ethnicities << ['Hispanics','HS']
       List <String> minMax = ['min', 'max']
        int fieldSpecifier = 8
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
                               parameterEncoding << "${fieldSpecifier}:${alleleFrequency}"
                           } else {
                               filters << retrieveParameterizedFilterString("setEthnicityMaximum", ethnicity[1], alleleFrequency) 
                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is less than or equal to  ${alleleFrequency}"
                               parameterEncoding << "${fieldSpecifier}:${alleleFrequency}"
                           }

                       }

                   }
               }
               fieldSpecifier++
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
                            parameterEncoding << "18:${alleleFrequency}"
                        } else {
                            filters << retrieveParameterizedFilterString("setSigmaMinorAlleleFrequencMaximum", "", alleleFrequency) 
                            filterDescriptions << "Minor allele frequency less than or equal to ${alleleFrequency}"
                            parameterEncoding << "19:${alleleFrequency}"
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
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("t2dcases")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenCaseSigma") 
                filterDescriptions << "Number of minor alleles observed in cases in SIGMA analysis is equal to 0"
                parameterEncoding << "20:0"
            } else {
                filters << retrieveFilterString("onlySeenCaseT2d") 
                filterDescriptions << "Number of case observations is equal to 0"
                parameterEncoding << "20:1"
            }
        }
        if  (incomingParameters.containsKey("t2dcontrols")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenControlSigma") 
                filterDescriptions << "Number of minor alleles observed in controls in SIGMA analysis is equal to 0"
                parameterEncoding << "21:0"
            } else {
                filters << retrieveFilterString("onlySeenControlT2d") 
                filterDescriptions << "Number of control observations is equal to 0"
                parameterEncoding << "21:1"
            }
        }
        if  (incomingParameters.containsKey("homozygotes")) {
            filters << retrieveFilterString("onlySeenHomozygotes") 
            filterDescriptions << "Number of minor alleles observed in homozygotes is equal to 0"
            parameterEncoding << "22:0"
        }

        return buildingFilters

    }


    private  LinkedHashMap predictedEffectsOnProteins (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        if  (incomingParameters.containsKey("predictedEffects"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String predictedEffects =  incomingParameters ["predictedEffects"][0]

            switch (predictedEffects)   {
                case  "all-effects":
                    // this is the default, do nothing
                    parameterEncoding << "23:0"
                    break;
                case  "protein-truncating":
                    filters <<  retrieveFilterString("proteinTruncatingCheckbox") 
                    filterDescriptions << "Estimated classification for proteins truncating variant effect"
                    parameterEncoding << "23:1"
                    break;
                case  "missense":
                    filters <<  retrieveFilterString("missenseCheckbox") 
                    filterDescriptions << "Estimated classification for missense effect"
                    parameterEncoding << "23:2"
                    break;
                case  "noEffectSynonymous":
                    filters <<  retrieveFilterString("synonymousCheckbox") 
                    filterDescriptions << "Estimated classification for no effects (synonymous)"
                    parameterEncoding << "23:3"
                    break;
                case  "noEffectNoncoding":
                    filters <<  retrieveFilterString("noncodingCheckbox") 
                    filterDescriptions <<  "Estimated classification for no effects (non-coding)"
                    parameterEncoding << "23:4"
                    break;

                default: break;
            }
        }

        return buildingFilters

    }


    private  LinkedHashMap predictedImpactOfMissenseMutations (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        if  (incomingParameters.containsKey("predictedEffects") &&
            (incomingParameters ["predictedEffects"][0] == "missense"))  { // we only perform this processing if the user
                                                                           // is asking about missense mutation

            // There are three types of predictions to consider, corresponding to checkboxes
            //      polyphen_select
            //      sift_select
            //      condel_select
            // Handle these one at a time.  The process is simplified because the filter name uses parameters
            // that map precisely to the combo box elements on the front end

            //  polyphen2
            if (incomingParameters.containsKey("polyphenSelect")){
                String choiceOfOptions =  incomingParameters["polyphenSelect"][0]
                filters <<  retrieveParameterizedFilterString("polyphenSelect",choiceOfOptions,0.0)
                filterDescriptions << "PolyPhen2 prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "24:${choiceOfOptions}"
            }

            //  SIFT
            if (incomingParameters.containsKey("siftSelect")){
                String choiceOfOptions =  incomingParameters["siftSelect"][0]
                filters <<  retrieveParameterizedFilterString("siftSelect",choiceOfOptions,0.0)
                filterDescriptions << "SIFT prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "25:${choiceOfOptions}"
            }

            //  Condel
            if (incomingParameters.containsKey("condelSelect")){
                String choiceOfOptions =  incomingParameters["condelSelect"][0]
                filters <<  retrieveParameterizedFilterString("condelSelect",choiceOfOptions,0.0)
                filterDescriptions << "Condel prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "26:${choiceOfOptions}"
            }

        }

        return buildingFilters

    }




}
