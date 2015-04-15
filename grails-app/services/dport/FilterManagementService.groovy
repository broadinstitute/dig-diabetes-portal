package dport

import grails.transaction.Transactional
import org.apache.juli.logging.LogFactory

@Transactional
class FilterManagementService {

    private static final log = LogFactory.getLog(this)
    RestServerService restServerService
    SharedToolsService sharedToolsService

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
            "dataSetGwas"    :
                    """{ "filter_type": "STRING", "operand": "IN_GWAS", "operator": "EQ", "value": "1" }""".toString(),
            "dataSetDiagramGwas"    :
                    """{ "filter_type": "FLOAT", "operand": "GWAS_T2D_PVALUE", "operator": "GTE", "value": 0 }""".toString(),
            "dataSetSigma"   :
                    """{ "filter_type": "FLOAT", "operand": "SIGMA_T2D_P", "operator": "GTE", "value":  0 }""".toString(),
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
            case "setExomeChipMaximum" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "EXCHP_T2D_MAF", "operator": "LTE", "value": ${parm2} }""".toString()
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
            case "setOrValueLTE" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "${parm1}", "operator": "LTE", "value": ${parm2} }""".toString()
                break;
            case "setOrValueGTE" :
                returnValue = """{ "filter_type": "FLOAT", "operand": "${parm1}", "operator": "GTE", "value": ${parm2} }""".toString()
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

    /***
     * take the parameters from the variant search page and build a call to the REST API. You need to
     * end up generating three things:
     * 1) a list of the filters that are part of the API call  itself
     * 2) a textbased representation of those same filters for human consumption
     * 3) a list of front-end widget settings  which we will use if the user goes to rrefine their search
     *
     * @param incomingParameters
     * @param currentlySigma
     * @return
     */
    public LinkedHashMap  parseVariantSearchParameters (HashMap incomingParameters,Boolean currentlySigma) {
        LinkedHashMap  buildingFilters = [filters:new ArrayList<String>(),
                                          filterDescriptions:new ArrayList<String>(),
                                          parameterEncoding:new ArrayList<String>()]


        buildingFilters = determineDataSet (buildingFilters,incomingParameters)

        String datatypeOperand = buildingFilters.datatypeOperand

        buildingFilters = determineThreshold (buildingFilters, incomingParameters, datatypeOperand)

        buildingFilters = factorInTheOddsRatios(buildingFilters, incomingParameters, datatypeOperand)

        buildingFilters = setRegion(buildingFilters, incomingParameters)

        buildingFilters = setAlleleFrequencies(buildingFilters, incomingParameters)

        buildingFilters = caseControlOnly(buildingFilters, incomingParameters,currentlySigma,datatypeOperand)

        buildingFilters = predictedEffectsOnProteins(buildingFilters, incomingParameters)

        buildingFilters = predictedImpactOfMissenseMutations(buildingFilters, incomingParameters)

        return buildingFilters

    }



    public HashMap storeParametersInHashmap ( String gene,
                                              String significance,
                                              String dataset,
                                              String region,
                                              String filter ) {
        HashMap returnValue = [:]

        if (dataset) {
            switch (dataset) {
                case 'gwas' :
                    returnValue['datatype']  = 'gwas'
                    break;
                case 'sigma' :
                    returnValue['datatype']  = 'sigma'
                    break;
                case 'exomeseq' :
                    returnValue['datatype']  = 'exomeseq'
                    break;
                case 'exomechip' :
                    returnValue['datatype']  = 'exomechip'
                    break;
                default:
                    break;
            }
        }


        if (significance) {
            switch (significance) {
                case 'everything' : // this is equivalent to P>0,
                    // is it also equivalent to P not specified?
                    break;
                case 'genome-wide' :
                    returnValue['significance']  = 'genomewide'
                    break;
                case 'locus' :
                    returnValue['significance']  = 'locus'
                    break;
                case 'nominal' : // this is equivalent to P>0,
                    returnValue['significance']  = 'nominal'
                    break;
                default:
                    break;
            }
        }

        if (region) { // If there's a region then use it. Otherwise depend on the gene name. Don't use both
            LinkedHashMap extractedNumbers = restServerService.extractNumbersWeNeed(region)
            if (extractedNumbers) {
                if (extractedNumbers["chromosomeNumber"]) {
                    returnValue["region_chrom_input"] = extractedNumbers["chromosomeNumber"]
                }
                if (extractedNumbers["startExtent"]) {
                    returnValue["region_start_input"] = extractedNumbers["startExtent"]
                }
                if (extractedNumbers["endExtent"]) {
                    returnValue["region_stop_input"] = extractedNumbers["endExtent"]
                }
            }
        } else if (gene) {
            returnValue['region_gene_input']  = gene
        }


        if (filter) {
            returnValue = interpretSpecialFilters (returnValue, filter)
        }



        return returnValue
    }



     private HashMap interpretSpecialFilters(HashMap developingParameterCollection,String filter)  {
         LinkedHashMap returnValue = new LinkedHashMap()
         if (filter) {
             String[] requestPortionList =  filter.split("-")
             if (requestPortionList.size() > 1) {  //  multipiece searches
                 String ethnicity = requestPortionList[1]
                 if (ethnicity == 'exchp') { // we have no ethnicity. Everything comes from the European exome chipset
                     returnValue['datatype'] = 'exomechip'
                     switch ( requestPortionList[0] ){
                         case "total":
                             returnValue['ethnicity_af_EU-min'] = 0.0
                             returnValue['ethnicity_af_EU-max'] = 1.0
                             break;
                         case "common":
                             returnValue['ethnicity_af_EU-min'] = 0.05
                             returnValue['ethnicity_af_EU-max'] = 1.0
                             break;
                         case "lowfreq":
                             returnValue['ethnicity_af_EU-min'] = 0.005
                             returnValue['ethnicity_af_EU-max'] = 0.05
                             break;
                         case "rare":
                             returnValue['ethnicity_af_EU-min'] = 0.0
                             returnValue['ethnicity_af_EU-max'] = 0.005
                             break;
                         default:
                             log.error("FilterManagementService:interpretSpecialFilters. Unexpected string 1 = ${requestPortionList[0]}")
                             break;
                     }
                 } else {   // we have ethnicity data
                     developingParameterCollection['datatype']  = 'exomeseq'
                     String baseEthnicityMarker =  "ethnicity_af_"+ ethnicity  + "-"
                     switch ( requestPortionList[0]){
                         case "total":
                             returnValue[baseEthnicityMarker  +'min'] = 0.0
                             returnValue[baseEthnicityMarker  +'max'] = 1.0
                             break;
                         case "common":
                             returnValue[baseEthnicityMarker  +'min'] = 0.05
                             returnValue[baseEthnicityMarker  +'max'] = 1.0
                             break;
                         case "lowfreq":
                             returnValue[baseEthnicityMarker  +'min'] = 0.005
                             returnValue[baseEthnicityMarker  +'max'] = 0.05
                             break;
                         case "rare":
                             returnValue[baseEthnicityMarker  +'min'] = 0.0
                             returnValue[baseEthnicityMarker  +'max'] = 0.005
                             break;
                         default:
                             log.error("FilterManagementService:interpretSpecialFilters. Unexpected string 2 = ${requestPortionList[0]}")
                             break;
                     }
                 }

             } else {  // we can put specialized searches here
                 switch (requestPortionList[0]) {
                     case "lof":
                         returnValue['datatype']  = 'exomeseq'
                         returnValue['predictedEffects']  = 'protein-truncating'
                         break;
                     default:
                         log.error("FilterManagementService:interpretSpecialFilters. Unexpected string 3 = ${requestPortionList[0]}")
                         break;
                 }
             }

         }
         if (developingParameterCollection)  {
             developingParameterCollection.each{ k, v -> returnValue["${k}"]=v}
         }

         return returnValue
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
            String requestedDataSet =  incomingParameters ["datatype"]

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
     * level of interaction for this routine because other aspects of the filter set we are building our dependent
     * on the selection of the data set. Therefore produce one additional key  ( "datatypeOperand" ) which can then
     * be available  for any other routines that want to look at it
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
                    filters <<  retrieveFilterString("dataSetGwas")
                    filterDescriptions << "Is observed in Diagram GWAS"
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
                default:
                    log.error("FilterManagementService.determineDataSet: unexpected dataSetDistinguisher = ${dataSetDistinguisher}")
                    break;
            }
        }
        buildingFilters["datatypeOperand"]  =  datatypeOperand
        return buildingFilters

    }















    private  LinkedHashMap  determineThreshold (LinkedHashMap  buildingFilters, HashMap incomingParameters,String datatypeOperand){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // set threshold
        if  (incomingParameters.containsKey("significance"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String requestedDataSet =  incomingParameters ["significance"]
            switch (requestedDataSet)   {
                case  "genomewide":
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,5e-8 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 5e-8"
                    parameterEncoding << "2:0"
                    break;
                case  "locus":
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,1e-4 as BigDecimal)
                    filterDescriptions << "P-value for association with T2D is less than or equal to 0.0001"
                    parameterEncoding << "2:2"
                    parameterEncoding << "3:0.0001"
                    break;
                case  "nominal":
                    filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,0.05 as BigDecimal) 
                    filterDescriptions << "P-value for association with T2D is less than or equal to 0.05"
                    parameterEncoding << "2:1"
                    break;
                case  "custom":
                    if (incomingParameters.containsKey("custom_significance_input")) {
                        parameterEncoding << "2:2"
                        String stringCustomThreshold = incomingParameters["custom_significance_input"]
                        BigDecimal numericCustomThreshold = 0.05
                        try {
                            numericCustomThreshold = new BigDecimal(stringCustomThreshold)
                            parameterEncoding << ("3:"+numericCustomThreshold.toString())
                        }  catch (exception)  {
                            // presumably we have a nonnumeric value in the custom threshold
                            // ignore the request for custom threshold altogether in this case
                            //TODO: this is an error condition. User supplied a nonnumeric custom threshold
                            log.error("FilterManagementService.determineThreshold: nonnumeric threshold provided by user = ${stringCustomThreshold}")
                            break;
                        }
                        filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,numericCustomThreshold) 
                        filterDescriptions << "P-value for association with T2D is less than or equal to ${numericCustomThreshold}"
                    } else {
                        //TODO: this is an error condition. User requested a custom threshold but supplied no threshold
                        // description of that threshold. We need a specification of what to do ( from Mary?)
                        log.error("FilterManagementService.determineThreshold: no threshold provided by user ")
                        break;
                    }
                    break;
                default:
                    log.error("FilterManagementService.determineThreshold: no threshold provided by user ")
                    break;
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
            String stringParameter = incomingParameters["region_gene_input"]
            filters << retrieveParameterizedFilterString("setRegionGeneSpecification", stringParameter, 0) 
            filterDescriptions << "In the gene ${stringParameter}"
            parameterEncoding << "4:${stringParameter}"
        }

        // set gene to search
        Boolean errorFree = true
        if (incomingParameters.containsKey("region_chrom_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_chrom_input"]
            String  chromosomeString = sharedToolsService.parseChromosome(stringParameter)
            //java.util.regex.Matcher chromosomeNumber = stringParameter =~ /\d+/
            if (chromosomeString != "")   {
                filters << retrieveParameterizedFilterString("setRegionChromosomeSpecification", chromosomeString, 0)
                filterDescriptions << "Chromosome is equal to ${chromosomeString}"
                parameterEncoding << "5:${chromosomeString}"
            } else {
                log.error("FilterManagementService.setRegion: no numeric portion of chromosome specifier = ${stringParameter}")
                // TODO: ERROR CONDITION.  DEFAULT?
            }

        }

        // set beginning chromosome extent
        if (incomingParameters.containsKey("region_start_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_start_input"]
            String startExtentString =   sharedToolsService.parseExtent(stringParameter)
            if (startExtentString  != "")  {
                parameterEncoding << "6:${stringParameter}"
                filters << retrieveParameterizedFilterString("setRegionPositionStart", startExtentString, 0)
                filterDescriptions << "Chromosomal position is greater than or equal to ${startExtentString}"
            }
         }

        // set ending chromosome extent
        if (incomingParameters.containsKey("region_stop_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_stop_input"]
            String endExtentString =   sharedToolsService.parseExtent(stringParameter)
            if (endExtentString  != "")  {
                filters << retrieveParameterizedFilterString("setRegionPositionEnd", endExtentString, 0)
                filterDescriptions << "Chromosomal position is less than or equal to ${endExtentString}"
                parameterEncoding << "7:${endExtentString}"
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
                   String specificAlleleFrequency = incomingParameters[ethnicityReference]
                   if ( (!"undefined".equals(specificAlleleFrequency))&&
                   (specificAlleleFrequency) &&
                           (specificAlleleFrequency.length() > 0)) {
                       Boolean errorFree = true
                       BigDecimal alleleFrequency
                       try {
                           alleleFrequency = new BigDecimal(specificAlleleFrequency)
                       } catch (exception) {
                           errorFree = false
                           // TODO: this is an error condition -- the user-specified a non-numeric allele frequency.  Default behavior?
                           log.error("FilterManagementService.setAlleleFrequencies: unexpected non-numeric allele frequency = ${specificAlleleFrequency}, ${ethnicityReference}")
                           exception.printStackTrace()
                       }
                       if (errorFree) {
                           if (minOrMax == 'min') {
                               // if we are searching exome chip data then use a different filter. Everything else is the same
                               if (incomingParameters.datatype=="exomechip"){
                                   filters << retrieveParameterizedFilterString("setExomeChipMinimumAbsolute", ethnicity[1], alleleFrequency)
                               } else {
                                   filters << retrieveParameterizedFilterString("setEthnicityMinimumAbsolute", ethnicity[1], alleleFrequency)
                               }
                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is greater than ${alleleFrequency}"
                               parameterEncoding << "${fieldSpecifier}:${alleleFrequency}"
                           } else {
                               if (incomingParameters.datatype=="exomechip"){
                                   filters << retrieveParameterizedFilterString("setExomeChipMaximum", ethnicity[1], alleleFrequency)
                               } else {
                                   filters << retrieveParameterizedFilterString("setEthnicityMaximum", ethnicity[1], alleleFrequency)
                               }

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
                String specificAlleleFrequency = incomingParameters[ethnicityReference]
                if ((specificAlleleFrequency) &&
                        (specificAlleleFrequency.length() > 0)) {
                    Boolean errorFree = true
                    BigDecimal alleleFrequency
                    try {
                        alleleFrequency = new BigDecimal(specificAlleleFrequency)
                    } catch (exception) {
                        errorFree = false
                        // TODO: this is an error condition -- the user-specified a non-numeric allele frequency.  Default behavior?
                        log.error("FilterManagementService.setAlleleFrequencies: unexpected non-numeric allele frequency = ${specificAlleleFrequency} ${ethnicityReference}")
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



    private  LinkedHashMap caseControlOnly (LinkedHashMap  buildingFilters, HashMap incomingParameters, Boolean usingSigma,caseControlOnly){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("t2dcases")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenCaseSigma") 
                filterDescriptions << "Number of minor alleles observed in controls in SIGMA analysis is equal to 0"
                parameterEncoding << "20:0"
            } else {
                filters << retrieveFilterString("onlySeenCaseT2d") 
                filterDescriptions << "Number of observations in controls is equal to 0"
                parameterEncoding << "20:1"
            }
        }
        if  (incomingParameters.containsKey("t2dcontrols")) {
            if (usingSigma) {
                filters << retrieveFilterString("onlySeenControlSigma") 
                filterDescriptions << "Number of minor alleles observed in cases in SIGMA analysis is equal to 0"
                parameterEncoding << "21:0"
            } else {
                filters << retrieveFilterString("onlySeenControlT2d") 
                filterDescriptions << "Number of observations in cases is equal to 0"
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
            String predictedEffects =  incomingParameters ["predictedEffects"]

            switch (predictedEffects)   {
                case  "all-effects":
                    // this is the default, do nothing
                    parameterEncoding << "23:0"
                    break;
                case  "protein-truncating":
                    filters <<  retrieveFilterString("proteinTruncatingCheckbox") 
                    filterDescriptions << "Predicted effect: protein-truncating"
                    parameterEncoding << "23:1"
                    break;
                case  "missense":
                    filters <<  retrieveFilterString("missenseCheckbox") 
                    filterDescriptions << "Predicted effect: missense"
                    parameterEncoding << "23:2"
                    break;
                case  "noEffectSynonymous":
                    filters <<  retrieveFilterString("synonymousCheckbox")
                    //filterDescriptions << "Estimated classification for no effects (synonymous)"
                    filterDescriptions << "No predicted effect (synonymous)"
                    parameterEncoding << "23:3"
                    break;
                case  "noEffectNoncoding":
                    filters <<  retrieveFilterString("noncodingCheckbox")
                    //filterDescriptions <<  "Estimated classification for no effects (non-coding)"
                    filterDescriptions <<  "No predicted effect (non-coding)"
                    parameterEncoding << "23:4"
                    break;

                default:
                    log.error("FilterManagementService.predictedEffectsOnProteins: unexpected predictedEffects = ${predictedEffects}")
                    break;
            }
        }

        return buildingFilters

    }


    private  LinkedHashMap predictedImpactOfMissenseMutations (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        if  (incomingParameters.containsKey("predictedEffects") &&
            (incomingParameters ["predictedEffects"]== "missense"))  { // we only perform this processing if the user
                                                                           // is asking about missense mutation

            // There are three types of predictions to consider, corresponding to checkboxes
            //      polyphen_select
            //      sift_select
            //      condel_select
            // Handle these one at a time.  The process is simplified because the filter name uses parameters
            // that map precisely to the combo box elements on the front end

            //  polyphen2
            if (incomingParameters.containsKey("polyphenSelect")){
                String choiceOfOptions =  incomingParameters["polyphenSelect"]
                filters <<  retrieveParameterizedFilterString("polyphenSelect",choiceOfOptions,0.0)
                filterDescriptions << "PolyPhen2 prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "24:${choiceOfOptions}"
            }

            //  SIFT
            if (incomingParameters.containsKey("siftSelect")){
                String choiceOfOptions =  incomingParameters["siftSelect"]
                filters <<  retrieveParameterizedFilterString("siftSelect",choiceOfOptions,0.0)
                filterDescriptions << "SIFT prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "25:${choiceOfOptions}"
            }

            //  Condel
            if (incomingParameters.containsKey("condelSelect")){
                String choiceOfOptions =  incomingParameters["condelSelect"]
                filters <<  retrieveParameterizedFilterString("condelSelect",choiceOfOptions,0.0)
                filterDescriptions << "Condel prediction is equal to ${choiceOfOptions}"
                parameterEncoding << "26:${choiceOfOptions}"
            }

        }

        return buildingFilters

    }

    /***
     * Here we consider two fields: one is a numeric value, and the other is an inequality specification ( that is,
     * do we want numbers' greater than' or else 'less than' the numeric value we've been given.
     * @param buildingFilters
     * @param incomingParameters
     * @return
     */
    private  LinkedHashMap factorInTheOddsRatios (LinkedHashMap  buildingFilters, HashMap incomingParameters,String datatypeOperand){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        boolean greaterThanInequality = false

        if  (( incomingParameters.containsKey("or-select")  ) &&
                ( incomingParameters.containsKey("or-value"))){
            String inequality = incomingParameters ["or-select"]
            String orValueStr = incomingParameters ["or-value"]
            Boolean errorFree = true
            Double adjustedValue
            Double orValue
            try {
                orValue = new Double(orValueStr)
            } catch (exception) {
                errorFree = false
                // TODO: this is an error condition -- the user-specified a non-numeric allele frequency.  Default behavior?
                log.error("FilterManagementService.factorInTheOddsRatios: nonnumeric orValueStr = ${orValueStr}")
                exception.printStackTrace()
            }
            String filterInequalityDescription = ""
            if (errorFree)  {

            }
            String chooseColumn
            if (errorFree)  {
                if (datatypeOperand == "_13k_T2D_P_EMMAX_FE_IV") {      // exome seq
                    chooseColumn = "_13k_T2D_OR_WALD_DOS_FE_IV"
                } else if (datatypeOperand == "GWAS_T2D_PVALUE") {
                    chooseColumn = "GWAS_T2D_OR"
                }  else if (datatypeOperand == "EXCHP_T2D_P_value") {
                    chooseColumn = "EXCHP_T2D_BETA"
                }  else {
                    chooseColumn = "SIGMA_T2D_OR"
                }
            }

            // exome chip filtering is special
            if ( chooseColumn == "EXCHP_T2D_BETA")  {
               if (orValue > 0){
                   adjustedValue = Math.log(orValue)
               } else {
                   log.error("FilterManagementService.factorInTheOddsRatios: nonpositive orValue specifier= ${orValue}")
                   errorFree = false
               }
            }  else  {
                adjustedValue =  orValue
            }


            if (errorFree) {
                if (inequality == "GTE") {
                    filters <<  retrieveParameterizedFilterString("setOrValueGTE",chooseColumn,adjustedValue as BigDecimal)
                    filterDescriptions << "Odds ratio greater than or equal to ${orValue}"
                    parameterEncoding << "27:1"
                    parameterEncoding << "28:${orValue}"
                } else if (inequality == "LTE") {
                    filters <<  retrieveParameterizedFilterString("setOrValueLTE",chooseColumn,adjustedValue as BigDecimal)
                    filterDescriptions << "Odds ratio less than or equal to ${orValue}"
                    parameterEncoding << "27:2"
                    parameterEncoding << "28:${orValue}"
                }  else {
                    log.error("FilterManagementService.factorInTheOddsRatios: unexpected inequality specifier= ${inequality}")
                    errorFree = false
                }
            }

        }
       return buildingFilters

    }



    public LinkedHashMap processNewParameters ( String dataSet,
            String gene,
                                                      String geneExpander,
                                                      String phenotype,
                                                      String pValue,
                                                      String pValueInequality,
                                                      String orValue,
                                                      String orValueInequality,
                                                      String filters ) {
        LinkedHashMap returnValue = [:]

        if (dataSet) {
            returnValue['dataSet']  = dataSet
        }

        if (gene) {
            returnValue['gene']  = gene
        }

        if (geneExpander) {
            int expander = 0
            try {
                expander = Integer.parseInt(geneExpander)
            } catch (e) {
                ; // not really a big deal if we fail -- it just means there is no expansion defined
            }
            returnValue['geneExpander']  = expander
        }


        if (phenotype) {
            returnValue['phenotype']  = phenotype
        }


        if (pValue) {
            float value = 0
            try {
                value = Float.parseFloat(pValue)
                returnValue['pValue']  = value
            } catch (e) {
                ; // no P value defined if we fail the conversion
            }
        }

        if (pValueInequality) {
            returnValue['pValueInequality']  = pValueInequality
        }


        if (orValue) {
            float value = 0
            try {
                value = Float.parseFloat(orValue)
                returnValue['orValue']  = value
            } catch (e) {
                ; // no or value defined if we fail the conversion
            }
        }

        if (orValueInequality) {
            returnValue['orValueInequality']  = orValueInequality
        }

        if (filters) {
            returnValue['filters']  = filters
        }

        return returnValue
    }


    public List <LinkedHashMap<String,String>> combineNewAndOldParameters ( LinkedHashMap newParameters,
                                                String encodedOldParameters) {
        // decode the old parameters and make them into a map
        // create a new list, with new parameters as the first element
        //  and subsequent parameter lists following
        List <LinkedHashMap> returnValue = []
        returnValue << newParameters
        return returnValue
    }


    public List <LinkedHashMap<String,String>> encodeAllFilters ( List <LinkedHashMap> allFilters ) {
        // Each set of filters in the list now needs to be broken into three parts:
        //   (displayable strings can be created dynamically with a taglib), so we return only
        //   encoded (to go back and forth to the browser)
        //   filters (the JSON we pass to the API to perform a query)
        //
        //Important note: combineNewAndOldParameters and encodeAllFilters both return
        //  List <LinkedHashMap<String,String>>, but it's not the same data structure.
        //  In the first case each map contains a collection of different keys and values,
        //  one for each selectable filter. In the second case each map contains only two
        //  elements: 1) encoded parameters, and 2) JSON filters ready for action
        List <LinkedHashMap> returnValue = []
        returnValue << [encoded:"",jsonFilters:""]
        return returnValue
    }



}
