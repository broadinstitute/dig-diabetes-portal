package dport

import dport.meta.UserQueryContext
import grails.transaction.Transactional
import org.apache.juli.logging.LogFactory

@Transactional
class FilterManagementService {

    private static final log = LogFactory.getLog(this)
    RestServerService restServerService
    SharedToolsService sharedToolsService
    SearchBuilderService searchBuilderService

    private String exomeSequence  = "ExSeq_17k_mdv2"
    private String gwasData  = "GWAS_DIAGRAM_mdv2"
    private String exomeChip  = "ExChip_82k_mdv2"
    private String sigmaData  = "unknown"
    // KDUXTD-33: switching from EMMAX to FIRTH p-values
    private String exomeSequencePValue  = "P_FIRTH_FE_IV"
    private String gwasDataPValue  = "P_VALUE"
    private String exomeChipPValue  = "P_VALUE"
    private String sigmaDataPValue  = "P_VALUE"

    private String chooseDataSet(String dataSetCode){
        String returnValue = exomeSequence
        switch (dataSetCode) {
            case "gwas": returnValue = gwasData; break;
            case "sigma": returnValue = sigmaData; break;
            case "exomeseq": returnValue = exomeSequence; break;
            case "exomechip": returnValue = exomeChip; break;
            default: break;
        }
        return returnValue
    }


   private String formatFilter (String dataSetId,
                                String phenotype,
                                String operand,
                                String operator,
                                String value,
                                String operandType){
       String returnValue = ""
       if ( ("FLOAT".equals(operandType)) || ("INTEGER".equals(operandType))){
           returnValue =  """{"dataset_id": "${dataSetId}", "phenotype": "${phenotype}", "operand": "${operand}", "operator": "${operator}", "value": ${value}, "operand_type": "${operandType}"}""".toString()
       } else if  ("STRING".equals(operandType)) {
           returnValue =  """{"dataset_id": "${dataSetId}", "phenotype": "${phenotype}", "operand": "${operand}", "operator": "${operator}", "value": "${value}", "operand_type": "${operandType}"}""".toString()
       } else {
           log.error("FilterManagementService:formatFilter. Unexpected operandType = ${dataSetId}")
       }
       return returnValue
   }




    private String generateFilterForApi (UserQueryContext userQueryContext){
        return formatFilter (userQueryContext.getDataSetId (),userQueryContext.getPhenotype(),userQueryContext.getOperand (),
                userQueryContext.getOperator(),userQueryContext.getValue (),userQueryContext.getOperandType())
    }





    private String filtersForApi(String filterName,
                  String parm1,
                  BigDecimal parm2,
                  String parm3="junk") {
        String returnValue = ""
        switch (filterName){
            case "dataSetGwas"        :
                UserQueryContext userQueryContext = new UserQueryContext([sampleGroup:"gwas", phenotype:"T2D"])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "dataSetSigma" :
                UserQueryContext userQueryContext = new UserQueryContext([sampleGroup:"sigma", phenotype:"T2D"])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "dataSetExseq"        :
                UserQueryContext userQueryContext = new UserQueryContext([sampleGroup:"exomeseq", phenotype:"T2D"])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "dataSetExchp"        :
                UserQueryContext userQueryContext = new UserQueryContext([sampleGroup:"exomechip", phenotype:"T2D"])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setPValueThreshold" :
                UserQueryContext userQueryContext = new UserQueryContext([sampleGroup:parm3,value:parm2.toString(), phenotype:"T2D"])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setRegionGeneSpecification" :
                UserQueryContext userQueryContext = new UserQueryContext([propertyCategory:"GENE", value:parm1])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setRegionChromosomeSpecification" :
                UserQueryContext userQueryContext = new UserQueryContext([propertyCategory:"CHROM", value:parm1])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setRegionPositionStart" :
                UserQueryContext userQueryContext = new UserQueryContext([propertyCategory:"POS_GTE", value:parm1.toString()])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setRegionPositionEnd" :
                UserQueryContext userQueryContext = new UserQueryContext([propertyCategory:"POS_LTE", value:parm1.toString()])
                returnValue =  generateFilterForApi (userQueryContext)
                break;
            case "setEthnicityMaximum" :
                returnValue = """{"dataset_id": "ExSeq_17k_""" + (parm1.equals("eu") || parm1.equals("hs") ? parm1 : "${parm1}_genes") + """_mdv2", "phenotype": "blah", "operand": "MAF", "operator": "LTE", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setEthnicityMaximumAbsolute" :
                returnValue = """{"dataset_id": "ExSeq_17k_""" + (parm1.equals("eu") || parm1.equals("hs") ? parm1 : "${parm1}_genes") + """_mdv2", "phenotype": "blah", "operand": "MAF", "operator": "LT", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setEthnicityMinimum" :
                returnValue = """{"dataset_id": "ExSeq_17k_""" + (parm1.equals("eu") || parm1.equals("hs") ? parm1 : "${parm1}_genes") + """_mdv2", "phenotype": "blah", "operand": "MAF", "operator": "GTE", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setEthnicityMinimumAbsolute" :
                returnValue = """{"dataset_id": "ExSeq_17k_""" + (parm1.equals("eu") || parm1.equals("hs") ? parm1 : "${parm1}_genes") + """_mdv2", "phenotype": "blah", "operand": "MAF", "operator": "GT", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setExomeChipMinimum" :
                returnValue = """{"dataset_id": "${exomeChip}", "phenotype": "blah", "operand": "MAF", "operator": "GTE", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setExomeChipMinimumAbsolute" :
                returnValue = """{"dataset_id": "${exomeChip}", "phenotype": "blah", "operand": "MAF", "operator": "GT", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setExomeChipMaximum" :
                returnValue = """{"dataset_id": "${exomeChip}", "phenotype": "blah", "operand": "MAF", "operator": "LTE", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "setExomeChipMaximumAbsolute" :
                returnValue = """{"dataset_id": "${exomeChip}", "phenotype": "blah", "operand": "MAF", "operator": "LT", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
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
            case "setSpecificPValue" :
                returnValue = """{"dataset_id": "${exomeSequence}", "phenotype": "${parm1}", "operand": "P_FIRTH_FE_IV", "operator": "LTE", "value": ${parm2}, "operand_type": "FLOAT"}""".toString()
                break;
            case "proteinTruncatingCheckbox"        :
                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 1, "operand_type": "FLOAT"}""".toString()
                break;
            case "missenseCheckbox"        :
                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 2, "operand_type": "FLOAT"}""".toString()
                break;
            case "synonymousCheckbox"        :
                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 3, "operand_type": "FLOAT"}""".toString()
                break;
            case "noncodingCheckbox"        :
                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "EQ", "value": 4, "operand_type": "FLOAT"}""".toString()
                break ;
            case "lessThan_noEffectNoncoding"        :
                returnValue = """{"dataset_id": "blah", "phenotype": "blah", "operand": "MOST_DEL_SCORE", "operator": "LT", "value": 4, "operand_type": "FLOAT"}""".toString()
                break ;

            default: break;
        }
        return  returnValue

    }




    String retrieveCustomizedFilterString (String dataSet,
                                              String phenotype,
                                              String property,
                                              String equivalence,
                                              String value,
                                              String operandType = "FLOAT") {
        String retval=""
        BigDecimal bigDecimal = 1  //  emergency default, so that at least we don't pass garbage to the rest API
        try{
            bigDecimal =  value as  BigDecimal
        } catch(e) {
            log.error("Received nonnumeric value in retrieveCustomizedFilterString = ${value}.  Shouldn't this have been filtered on the front end?")
        }
        retval= """{"dataset_id": "${dataSet}", "phenotype": "${phenotype}", "operand": "${property}", "operator": "${equivalence}", "value": ${bigDecimal}, "operand_type": "${operandType}"}""".toString()
        return  retval
       }




    String retrieveParameterizedFilterString (String filterName,
                                              String parm1,
                                              BigDecimal parm2,
                                              String parm3 = "junk") {
        return filtersForApi( filterName,parm1,parm2,parm3)
    }


    String retrieveFilterString (String filterName,
                                 String parm3 = "junk") {
        return filtersForApi( filterName,"junk",0.0 as BigDecimal,parm3)
    }

    /***
     * turn a list of properties (which may be empty) into a string that can go down to the browser (and then come back
     * during an Ajax call)
     * @param propertyList
     * @return
     */
    public String convertPropertyListToTransferableString (List<LinkedHashMap> propertyList){
        String returnValue
        List<String> tempForm = []
        for (LinkedHashMap propertyRecord in propertyList){
            tempForm << "${propertyRecord.phenotype}:${propertyRecord.dataset}:${propertyRecord.property}".toString()
        }
        returnValue = tempForm.join("^")
        return java.net.URLEncoder.encode( returnValue)
    }


				

    public LinkedHashMap  parseExtendedVariantSearchParameters (HashMap incomingParameters,Boolean currentlySigma,LinkedHashMap  buildingFilters) {
        if (!buildingFilters){
            buildingFilters = [filters:new ArrayList<String>(),
                               filterDescriptions:new ArrayList<String>(),
                               parameterEncoding:new ArrayList<String>(),
                               positioningInformation :new LinkedHashMap <String,String> (),
                               transferableFilter: new ArrayList<String>()]
        }




        buildingFilters = determineDataSet (buildingFilters,incomingParameters)

        String datatypeOperand = buildingFilters.datatypeOperand

        buildingFilters = processCustomFilters (buildingFilters, incomingParameters )

        buildingFilters = factorInTheOddsRatios(buildingFilters, incomingParameters, datatypeOperand)

        buildingFilters = setRegion(buildingFilters, incomingParameters)

        buildingFilters = setAlleleFrequencies(buildingFilters, incomingParameters)

        buildingFilters = predictedEffectsOnProteins(buildingFilters, incomingParameters)

        buildingFilters = predictedImpactOfMissenseMutations(buildingFilters, incomingParameters)

        buildingFilters = setSpecificPValue(buildingFilters, incomingParameters)

        return buildingFilters

    }

    /***
     * let's use the same machinery we use to launch a variant request in order to simply generate the filters upon request for a calling routine
     *
     * @param geneId
     * @param receivedParameters
     * @param significance
     * @param dataset
     * @param region
     * @return
     */
  public  List<String> retrieveFilters (  String geneId, String significance,String dataset,String region,String receivedParameters )    {
      Map paramsMap = storeParametersInHashmap (geneId,significance,dataset,region,receivedParameters)
      LinkedHashMap<String, String> parsedFilterParameters = parseExtendedVariantSearchParameters(paramsMap,false,[:])
      return  parsedFilterParameters.filters
  }


    public HashMap storeParametersInHashmap ( String gene,
                                              String significance,
                                              String dataset,
                                              String region,
                                              String filter) {
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
                    returnValue['predictedEffects'] = 'lessThan_noEffectNoncoding';
                    break;
                case 'exomechip' :
                    returnValue['datatype']  = 'exomechip'
                    returnValue['predictedEffects'] = 'lessThan_noEffectNoncoding';
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

    /***
     * Assign each new source filter into the target list UNLESS the filter is already there, in which case
     * the assignment can be skipped.
     *
     * @param targetList
     * @param sourceFilter
     * @return
     */
    private List<LinkedHashMap> assignUniqueFilters(List<LinkedHashMap> targetList,LinkedHashMap sourceFilter){
        boolean skipIt = false;
        if (
        ((sourceFilter?.containsKey("region_chrom_input")) &&
                (targetList?.findAll{LinkedHashMap map->map?.containsKey('region_chrom_input')}))
                ||
                ((sourceFilter.containsKey("region_start_input")) &&
                        (targetList?.findAll{LinkedHashMap map->map?.containsKey("region_start_input")}))
                ||
                ((sourceFilter.containsKey("region_stop_input")) &&
                        (targetList?.findAll{LinkedHashMap map->map?.containsKey("region_stop_input")}))
                ||
                ((sourceFilter.containsKey("region_gene_input")) &&
                        (targetList?.findAll{LinkedHashMap map->map?.containsKey("region_gene_input")}))
                ||
                ((sourceFilter.containsKey("predictedEffects")) &&
                        (targetList?.findAll{LinkedHashMap map->map?.containsKey("predictedEffects")}))

        ){
            skipIt = true; // it was a repeated filter -- no need to include it
        }
        sourceFilter.each{String key,String value->
            if ((skipIt==false)&&(key?.startsWith('customFilter'))){
                if (targetList.findAll{LinkedHashMap map->map.containsValue(value)}) {
                    skipIt = true;
                }
            }
        }
        if (!skipIt){
            targetList << sourceFilter
        }
        return targetList
    }









    /***
     * Here is an intermediate code for a filter. We have to read these somewhere else in this file and convert them
     * into actual filters.    If the filters and recognized here then we aren't going to deal with it anywhere.
     *
     * The goal is to start with a list of maps, where each map references a collection of filters. By the time we
     * leave this routine we should have a list of actionable maps -- these are the filters we care about and that we actually
     * intend to deal with.
     *
     * @param combinedFilters
     * @return
     */
    public List<LinkedHashMap> storeCodedParametersInHashmap (
                                              List <LinkedHashMap> combinedFilters
                                              ) {
        List<LinkedHashMap> returnValue = []


        for (LinkedHashMap map in combinedFilters){

            LinkedHashMap singleFilterSet = [:]

            // let's get those custom filters
            LinkedHashMap savedValues = map.findAll{ it.key =~ /^filter/ }
            int cnt = 0
            for (savedValue in savedValues){
                singleFilterSet["customFilter${cnt++}"]  = savedValue.value as String
            }
            if (map.containsKey("regionChromosomeInput")  ){
                String chromosome  = map["regionChromosomeInput"]
                singleFilterSet["region_chrom_input"] = chromosome
            }
            if (map.containsKey("regionStartInput")  ){
                String startExtent  = map["regionStartInput"]
                singleFilterSet["region_start_input"] = startExtent
            }
            if (map.containsKey("regionStopInput")  ){
                String endExtent  = map["regionStopInput"]
                singleFilterSet["region_stop_input"] = endExtent
            }
            if (map.containsKey("gene")  ){
                String endExtent  = map["gene"]
                singleFilterSet["region_gene_input"] = endExtent
            }

            if (map.containsKey("predictedEffects")  ){
                String predictedEffects  = map["predictedEffects"]
                singleFilterSet["predictedEffects"] = predictedEffects
            }

           // returnValue = assignUniqueFilters(returnValue,singleFilterSet)

            returnValue << singleFilterSet

        }

        return returnValue
    }















    private HashMap interpretSpecialFilters(HashMap developingParameterCollection,String filter)  {
         LinkedHashMap returnValue = new LinkedHashMap()

        // KDUXTD-38: adding default filter for 'variation across continental ancestry' drill down
        developingParameterCollection['predictedEffects'] = 'lessThan_noEffectNoncoding';

        if (filter) {
             String[] requestPortionList =  filter.split("-")
             if (requestPortionList.size() > 1) {  //  multipiece searches
                 String ethnicity = (requestPortionList[1]).toLowerCase()
                 if (ethnicity == 'exchp') { // we have no ethnicity. Everything comes from the European exome chipset
                     returnValue['datatype'] = 'exomechip'
                     switch ( requestPortionList[0] ){
                         case "total":
                             returnValue['ethnicity_af_eu-min'] = 0.0
                             returnValue['ethnicity_af_eu-max'] = 1.0
                             break;
                         case "common":
                             returnValue['ethnicity_af_eu-min'] = 0.05
                             returnValue['ethnicity_af_eu-max'] = 1.0
                             break;
                         case "lowfreq":
                             returnValue['ethnicity_af_eu-min'] = 0.0005
                             returnValue['ethnicity_af_eu-max'] = 0.05
                             break;
                         case "rare":
                             returnValue['ethnicity_af_eu-min'] = 0.0
                             returnValue['ethnicity_af_eu-max'] = 0.0005
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
                             returnValue[baseEthnicityMarker  +'min'] = 0.0005
                             returnValue[baseEthnicityMarker  +'max'] = 0.05
                             break;
                         case "rare":
                             returnValue[baseEthnicityMarker  +'min'] = 0.0
                             returnValue[baseEthnicityMarker  +'max'] = 0.0005
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
 * This is a placeholder for a method yet to come
 * @param incomingParameters
 * @return
 */
    public  int identifyAllRequestedDataSets (List <HashMap> incomingParameters){
        int returnValue = 0;
        for (HashMap map in incomingParameters){
            if  (map.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?
                String requestedDataSet =  incomingParameters ["datatype"]

                switch (requestedDataSet)   {
                    case  "gwas":
                        returnValue += 0
                        break;
                    case  "sigma":
                        returnValue += 1
                        break;
                    case  "exomeseq":
                        returnValue += 2
                        break;
                    case  "exomechip":
                        returnValue += 3
                        break;

                    default: break;
                }
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
        List <String> transferableFilter =  buildingFilters.transferableFilter
        String datatypeOperand = ""

        BigDecimal significance = 1
        // it is possible to set significance explicitly with a key value.  Attend to that parameter right here:
        switch (incomingParameters ["significance"])   {
            case  "genomewide":
                significance = 5e-8
                break;
            case  "locus":
                significance = 5e-4
                break;
            case  "nominal":
                significance = 0.05
                break;
            case  "custom": // this is an antiquated approach, but still used by Beacon.  We need to get rid of it eventually
                if (incomingParameters.containsKey("custom_significance_input")) {
                    parameterEncoding << "2:2".toString()
                    String stringCustomThreshold = incomingParameters["custom_significance_input"]
                    BigDecimal numericCustomThreshold = 0.05
                    try {
                        numericCustomThreshold = new BigDecimal(stringCustomThreshold)
                        parameterEncoding << ("3:"+numericCustomThreshold.toString())
                    }  catch (exception)  {
                        // presumably we have a nonnumeric value in the custom threshold
                        // ignore the request for custom threshold altogether in this case
                        //TODO: this is an error condition. User supplied a nonnumeric custom threshold
                        log.error("FilterManagementService.determineDataSet: nonnumeric threshold provided by user = ${stringCustomThreshold}")
                        break;
                    }
                    filters << retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,numericCustomThreshold,dataSetSpecifier)
                    filterDescriptions << "P-value for association with T2D is less than or equal to ${numericCustomThreshold}".toString()
                } else {
                    //TODO: this is an error condition. User requested a custom threshold but supplied no threshold
                    // description of that threshold. We need a specification of what to do ( from Mary?)
                    log.error("FilterManagementService.determineDataSet: no threshold provided by user ")
                    break;
                }
                break;
            default:
                log.error("FilterManagementService.determineDataSet: no threshold provided by user ")
                break;
        }



        // datatype: Sigma, exome sequencing, exome chip, or diagram GWAS
        if  (incomingParameters.containsKey("datatype"))  {      // user has requested a particular data set. Without explicit request what is the default?
            String dataSetSpecifier = incomingParameters ["datatype"]
            int dataSetDistinguisher =   distinguishBetweenDataSets ( incomingParameters)


            switch (dataSetDistinguisher)   {
                case  0:
                    datatypeOperand = gwasDataPValue
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,significance,dataSetSpecifier)
                    if (significance == 1){
                        filterDescriptions << "GWAS p-value for association with T2D is not null".toString()
                    }else {
                        filterDescriptions << "GWAS p-value for association with T2D is less than or equal to ${significance}".toString()
                    }
                    parameterEncoding << "2:2".toString()
                    parameterEncoding << "3:${significance}".toString()
                    transferableFilter << "47:T2D[${chooseDataSet(dataSetSpecifier)}]${datatypeOperand}<${significance}".toString()
                    break;

                case  1:
                    datatypeOperand = sigmaDataPValue
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,significance,dataSetSpecifier)
                    if (significance == 1){
                        filterDescriptions << "SIGMA p-value for association with T2D is not null".toString()
                    }else {
                        filterDescriptions << "SIGMA p-value for association with T2D is less than or equal to ${significance}".toString()
                    }
                    parameterEncoding << "2:2".toString()
                    parameterEncoding << "3:${significance}".toString()
                    transferableFilter << "47:T2D[${chooseDataSet(dataSetSpecifier)}]${datatypeOperand}<${significance}".toString()
                    break;
                case  2:
                    datatypeOperand = exomeSequencePValue
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,significance,dataSetSpecifier)
                    if (significance == 1){
                        filterDescriptions << "Exome sequencing p-value for association with T2D is not null".toString()
                    }else {
                        filterDescriptions << "Exome sequencing p-value for association with T2D is less than or equal to ${significance}".toString()
                    }
                    parameterEncoding << "2:2".toString()
                    parameterEncoding << "3:${significance}".toString()
                    transferableFilter << "47:T2D[${chooseDataSet(dataSetSpecifier)}]${datatypeOperand}<${significance}".toString()
                    break;
                case  3:
                    datatypeOperand = exomeChipPValue
                    filters <<  retrieveParameterizedFilterString("setPValueThreshold",datatypeOperand,significance,dataSetSpecifier)
                    if (significance == 1){
                        filterDescriptions << "Exome chip p-value for association with T2D is not null".toString()
                    }else {
                        filterDescriptions << "Exome chip p-value for association with T2D is less than or equal to ${significance}".toString()
                    }
                    parameterEncoding << "2:2".toString()
                    parameterEncoding << "3:${significance}".toString()
                    transferableFilter << "47:T2D[${chooseDataSet(dataSetSpecifier)}]${datatypeOperand}<${significance}".toString()
                    break;
                default:
                    log.error("FilterManagementService.determineDataSet: unexpected dataSetDistinguisher = ${dataSetDistinguisher}")
                    break;
            }
        }
        buildingFilters["datatypeOperand"]  =  datatypeOperand
        return buildingFilters

    }





    public LinkedHashMap<String,String> parseCustomFilterString (String customFilterString)  {
        LinkedHashMap<String,String> returnValue = [:]
        List <String> filterPieces = customFilterString.tokenize ("[")
        returnValue ["phenotype"]  =  filterPieces [0]
        List <String> filterPieces2 = (filterPieces[1]).tokenize ("]")
        returnValue ["sampleSet"]  =  filterPieces2 [0]
        if (filterPieces2[1].indexOf("<") > -1){
            int equivalencePosition = filterPieces2[1].indexOf("<")
            returnValue ["property"]  = filterPieces2[1].substring(0,equivalencePosition)
            returnValue ["value"]  = filterPieces2[1].substring(equivalencePosition+1)
            returnValue ["equivalence"]  = "LT"
        } else if (filterPieces2[1].indexOf(">") > -1){
            int equivalencePosition = filterPieces2[1].indexOf(">")
            returnValue ["property"]  = filterPieces2[1].substring(0,equivalencePosition)
            returnValue ["value"]  = filterPieces2[1].substring(equivalencePosition+1)
            returnValue ["equivalence"]  = "GT"
        }  else if (filterPieces2[1].indexOf("|") > -1){
            int equivalencePosition = filterPieces2[1].indexOf("|")
            returnValue ["property"]  = filterPieces2[1].substring(0,equivalencePosition)
            returnValue ["value"]  = filterPieces2[1].substring(equivalencePosition+1)
            returnValue ["equivalence"]  = "EQ"
        }
        return returnValue
    }




    private  LinkedHashMap processCustomFilters(LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // set the search region
        // set gene to search
        LinkedHashMap savedValues = incomingParameters.findAll{ it.key =~ /^customFilter/ }
        for (savedValue in savedValues){
            String customFilterString =   savedValue.value as String
            LinkedHashMap<String,String> parsedFilterString = parseCustomFilterString (customFilterString)
            filters << retrieveCustomizedFilterString(parsedFilterString.sampleSet,
                    parsedFilterString.phenotype,
                    parsedFilterString.property,
                    parsedFilterString.equivalence,
                    parsedFilterString.value,
                    "FLOAT")
            //filterDescriptions << "${parsedFilterString.property} value ${parsedFilterString.equivalence} ${parsedFilterString.value} for ${parsedFilterString.sampleSet}"
            filterDescriptions << "${searchBuilderService.makeFiltersPrettier(customFilterString)}".toString()
            parameterEncoding << "47:${customFilterString}".toString()
        }
         return  buildingFilters

    }





    private  LinkedHashMap setSpecificPValue(LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        // set the search region
        // set gene to search
        if (incomingParameters.containsKey("spec_p_value") && (incomingParameters.containsKey("spec_pheno_ind"))) {
            // P value for a particular phenotype
            String stringPValue = incomingParameters["spec_p_value"]
            String stringPhenotypeIndicator = incomingParameters["spec_pheno_ind"]
            filters << retrieveParameterizedFilterString("setSpecificPValue",stringPhenotypeIndicator,stringPValue as BigDecimal)
            filterDescriptions << "P value < ${stringPValue} for ${stringPhenotypeIndicator}".toString()
            parameterEncoding << "27:${stringPValue}".toString()
        }
        return  buildingFilters

    }











    private  LinkedHashMap setRegion (LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        LinkedHashMap <String,String> positioningInformation =  buildingFilters.positioningInformation
        // set the search region
        // set gene to search
        if (incomingParameters.containsKey("region_gene_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_gene_input"]
            filters << retrieveParameterizedFilterString("setRegionGeneSpecification", stringParameter, 0) 
            filterDescriptions << "In the gene ${stringParameter}".toString()
            parameterEncoding << "4:${stringParameter}".toString()
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
                filterDescriptions << "Chromosome is equal to ${chromosomeString}".toString()
                parameterEncoding << "5:${chromosomeString}".toString()
                positioningInformation["chromosomeSpecified"] = "${chromosomeString}".toString()
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
                parameterEncoding << "6:${stringParameter}".toString()
                filters << retrieveParameterizedFilterString("setRegionPositionStart", startExtentString, 0)
                filterDescriptions << "Chromosomal position is greater than or equal to ${startExtentString}".toString()
                positioningInformation["beginningExtentSpecified"] = "${startExtentString}".toString()
            }
         }

        // set ending chromosome extent
        if (incomingParameters.containsKey("region_stop_input")) {
            // user has requested a particular data set. Without explicit request what is the default?
            String stringParameter = incomingParameters["region_stop_input"]
            String endExtentString =   sharedToolsService.parseExtent(stringParameter)
            if (endExtentString  != "")  {
                filters << retrieveParameterizedFilterString("setRegionPositionEnd", endExtentString, 0)
                filterDescriptions << "Chromosomal position is less than or equal to ${endExtentString}".toString()
                parameterEncoding << "7:${endExtentString}".toString()
                positioningInformation["endingExtentSpecified"] = "${endExtentString}".toString()
            }

        }
        return  buildingFilters

    }



    private  LinkedHashMap setAlleleFrequencies (LinkedHashMap  buildingFilters, HashMap incomingParameters) {
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        List <String> transferableFilter =  buildingFilters.transferableFilter
        //ethnicities and minor allele frequencies
       List <List<String>> ethnicities = []
        ethnicities << ['African-Americans','aa']
        ethnicities << ['East Asians','ea']
        ethnicities << ['South Asians','sa']
        ethnicities << ['Europeans','eu']
        ethnicities << ['Hispanics','hs']
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
                                   transferableFilter << "47:T2D[ExChip_82k_mdv2]MAF>${alleleFrequency}".toString()
                               } else {
                                   filters << retrieveParameterizedFilterString("setEthnicityMinimumAbsolute", ethnicity[1], alleleFrequency)
                                   String p1 = ethnicity[1]
                                   transferableFilter << "47:T2D[ExSeq_17k_${(p1.equals("eu") || p1.equals("hs") ? p1 : "${p1}_genes")}_mdv2]MAF>${alleleFrequency}".toString()
                               }
                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is greater than ${alleleFrequency}"
                               parameterEncoding << "${fieldSpecifier}:${alleleFrequency}".toString()
                           } else {
                               if (incomingParameters.datatype=="exomechip"){
                                   filters << retrieveParameterizedFilterString("setExomeChipMaximum", ethnicity[1], alleleFrequency)
                                   transferableFilter << "47:T2D[ExChip_82k_mdv2]MAF<${alleleFrequency}".toString()
                               } else {
                                   String p1 = ethnicity[1]
                                   filters << retrieveParameterizedFilterString("setEthnicityMaximum", ethnicity[1], alleleFrequency)
                                   transferableFilter << "47:T2D[ExSeq_17k_${(p1.equals("eu") || p1.equals("hs") ? p1 : "${p1}_genes")}_mdv2]MAF<${alleleFrequency}".toString()
                               }

                               filterDescriptions << "Minor allele frequency in ${ethnicity[0]} is less than or equal to  ${alleleFrequency}"
                               parameterEncoding << "${fieldSpecifier}:${alleleFrequency}".toString()
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


    private  LinkedHashMap predictedEffectsOnProteins (LinkedHashMap  buildingFilters, HashMap incomingParameters){
        List <String> filters =  buildingFilters.filters
        List <String> filterDescriptions =  buildingFilters.filterDescriptions
        List <String> parameterEncoding =  buildingFilters.parameterEncoding
        List <String> transferableFilter =  buildingFilters.transferableFilter
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
                    transferableFilter << "23:1"
                    break;
                case  "missense":
                    filters <<  retrieveFilterString("missenseCheckbox") 
                    filterDescriptions << "Predicted effect: missense"
                    parameterEncoding << "23:2"
                    transferableFilter << "23:2"
                    break;
                case  "noEffectSynonymous":
                    filters <<  retrieveFilterString("synonymousCheckbox")
                    //filterDescriptions << "Estimated classification for no effects (synonymous)"
                    filterDescriptions << "No predicted effect (synonymous)"
                    parameterEncoding << "23:3"
                    transferableFilter << "23:3"
                    break;
                case  "noEffectNoncoding":
                    filters <<  retrieveFilterString("noncodingCheckbox")
                    //filterDescriptions <<  "Estimated classification for no effects (non-coding)"
                    filterDescriptions <<  "No predicted effect (non-coding)"
                    parameterEncoding << "23:4"
                    transferableFilter << "23:4"
                    break;
                case  "lessThan_noEffectNoncoding":
                    filters <<  retrieveFilterString("lessThan_noEffectNoncoding")
                    //filterDescriptions <<  "Estimated classification for no effects (non-coding)"
                    filterDescriptions <<  "Protein truncating,missense, and synonymous variants"
                    parameterEncoding << "23:5"
                    transferableFilter << "23:5"
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
        List <String> transferableFilter =  buildingFilters.transferableFilter
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

   private String convertCustomFilters (String key,String value){
       // first loop through and break everything into pairs
       String returnValue = ""
       List <String> filterPieces = key.tokenize ("^")
       if (filterPieces.size()==5){
           String phenotype = filterPieces [1]
           String sample = filterPieces [2]
           String inequivalence = filterPieces [3]
           String propertyHolder = filterPieces [4]
           String property = propertyHolder.substring(0,propertyHolder.indexOf("___valueId"))
           String inequalitySignifier
           switch(inequivalence){
               case "lessThan" :
                   inequalitySignifier =  "<"
                   break
               case "greaterThan" :
                   inequalitySignifier = ">"
                   break
               case "equalTo" :
                   inequalitySignifier =  "|"
                   break
               default:
                   inequalitySignifier =  "<"
                   break
           }
           returnValue = "${phenotype}[${sample}]${property}${inequalitySignifier}${value}"
       }
       return returnValue
   }

    public LinkedHashMap processNewParameters ( LinkedHashMap <String,String> customFilters,
                                                String dataSet,
                                                String esValue,
                                                      String esValueInequality,
                                                      String phenotype,
                                                      String filters,//?
                                                      String datasetExomeChip,
                                                      String datasetExomeSeq,
                                                      String datasetGWAS,
                                                      String regionStopInput,
                                                      String regionStartInput,
                                                      String regionChromosomeInput,
                                                      String regionGeneInput,
                                                      String predictedEffects,
                                                      String condelSelect,
                                                      String polyphenSelect,
                                                      String siftSelect ) {
        LinkedHashMap returnValue = [:]

        int i = 0
        customFilters.each{ String key, String value ->
            returnValue["filter${i++}"] = convertCustomFilters (key, value)
        }


        if (dataSet) {
            returnValue['dataSet']  = dataSet
        }

        if (regionGeneInput) {
            returnValue['gene']  = regionGeneInput
        }

        if (regionChromosomeInput) {
            returnValue['regionChromosomeInput']  = regionChromosomeInput
        }
        if (regionStartInput) {
            returnValue['regionStartInput']  = regionStartInput
        }
        if (regionStopInput) {
            returnValue['regionStopInput']  = regionStopInput
        }
        if ((predictedEffects) &&
                (predictedEffects != "undefined")){
            returnValue['predictedEffects']  = predictedEffects
        }

        if ((condelSelect) &&
                (condelSelect != "undefined")){
            returnValue['condelSelect']  = condelSelect
        }

        if ((polyphenSelect) &&
                (polyphenSelect != "undefined")){
            returnValue['polyphenSelect']  = polyphenSelect
        }

        if ((siftSelect) &&
                (siftSelect != "undefined")){
            returnValue['siftSelect']  = siftSelect
        }

        if (phenotype) {
            returnValue['phenotype']  = phenotype
        }


        if (esValue) {
            float value = 0
            try {
                value = Float.parseFloat(esValue)
                returnValue['esValue']  = value
            } catch (e) {
                ; // no or value defined if we fail the conversion
            }
        }

        if (esValueInequality) {
            returnValue['esValueInequality']  = esValueInequality
        }


        if (filters) {
            returnValue['filters']  = filters
        }

        returnValue['datasetExomeChip']  = (datasetExomeChip)?Boolean.TRUE:Boolean.FALSE
        returnValue['datasetExomeSeq']  = (datasetExomeSeq)?Boolean.TRUE:Boolean.FALSE
        returnValue['datasetGWAS']  = (datasetGWAS)?Boolean.TRUE:Boolean.FALSE

        return returnValue
    }

    // pull back only the parameters we want with the regex
    public List <String> observeMultipleFilters (parameters){
       List <String> returnValue = []
       LinkedHashMap savedValues = parameters.findAll{ it.key =~ /^savedValue/ }
       for (savedValue in savedValues){
           returnValue << savedValue.value as String
       }
       return returnValue
    }

    // pull back only the parameters we want with the regex
    public LinkedHashMap <String,String> retrieveCustomFilters (parameters){
        LinkedHashMap savedValues = parameters.findAll{ it.key =~ /^custom47/ }
        return savedValues
    }



    public List <LinkedHashMap<String,String>> combineNewAndOldParameters ( LinkedHashMap newParameters,
                                                List <String> encodedOldParameterList) {
        // decode the old parameters and make them into a map
        // create a new list, with new parameters as the first element
        //  and subsequent parameter lists following
        List <LinkedHashMap> returnValue = []

        if (encodedOldParameterList){
            for (String value in encodedOldParameterList){
                returnValue << sharedToolsService.decodeAFilterList(value)
            }
        }


        // It is possible to send back an null filter, which we can then drop from further processing
        // does perform that test right here
        if ((newParameters)&&
                (
                        (newParameters.findAll{ it.key =~ /^filter/ }?.size()>0)  ||
                        (newParameters.findAll{ it.key =~ /^gene/ }?.size()>0)  ||
                        (newParameters.findAll{ it.key =~ /^predictedEffects/ }?.size()>0)  ||
                        (newParameters.findAll{ it.key =~ /^region/ }?.size()>0)
                )
        ){
            returnValue << newParameters
        }


        return returnValue
    }

    /***
     * search parameters of been coded into a single string. Unpack that string and turn it into
     * a hashmap that resembles the parameters the search builder passes to itself. That way I can
     * use the same machinery to generate queries run during interactive search building
     *
     * @param codedParameters
     * @return
     */
    public LinkedHashMap generateParamsForSearchRefinement(String codedParameters){
        LinkedHashMap returnValue = [:]
        if ( (codedParameters) &&
             (codedParameters.length() > 0) ) {
            List <String> listOfFilters = codedParameters.tokenize(",")
            for (String oneFilter in listOfFilters){
                if (oneFilter){
                    List <String> typeOfFilter = oneFilter.tokenize (":")
                    String value = (typeOfFilter[1]?.trim());
                    switch (typeOfFilter [0]){
                        case "1":break;
                        case "2":break;
                        case "3":break;
                        case "4":
                            returnValue ["region_gene_input"] = value
                            break;
                        case "5":
                            returnValue ["region_chrom_input"] = value
                            break;
                        case "6":
                            returnValue ["region_start_input"] = value
                            break;
                        case "7":
                            returnValue ["region_stop_input"] = value
                            break;
                        case "8":break;
                        case "9":break;
                        case "10":break;
                        case "11":
                            break;
//                        case 20:break;
//                        case 21:break;
//                        case 22:break;
                        case "23":
                            switch (value){
                                case "0":
                                    returnValue ["predictedEffects"] = "all-effects"
                                    break;
                                case "1":
                                    returnValue ["predictedEffects"] = "protein-truncating"
                                    break;
                                case "2":
                                    returnValue ["predictedEffects"] = "missense"
                                    break;
                                case "3":
                                    returnValue ["predictedEffects"] = "noEffectSynonymous"
                                    break;
                                case "4":
                                    returnValue ["predictedEffects"] = "noEffectNoncoding"
                                    break;
                                case "5":
                                    returnValue ["predictedEffects"] = "lessThan_noEffectNoncoding"
                                    break;
                                default:
                                    returnValue ["predictedEffects"] = "all-effects"
                                    break;
                            }
                            break;
                        case "24":
                            switch (value){
                                case "0":
                                    returnValue ["polyphenSelect"] = "probably_damaging"
                                    break;
                                case "1":
                                    returnValue ["polyphenSelect"] = "possibly_damaging"
                                    break;
                                case "2":
                                    returnValue ["polyphenSelect"] = "benign"
                                    break;
                                default:
                                    returnValue ["polyphenSelect"] = "probably_damaging"
                                    break;
                            }
                            break;
                        case "25":
                            switch (value){
                                case "0":
                                    returnValue ["sift"] = "probably_damaging"
                                    break;
                                case "1":
                                    returnValue ["sift"] = "possibly_damaging"
                                    break;
                                default:
                                    returnValue ["sift"] = "probably_damaging"
                                    break;
                            }
                            break;
                        case "26":
                            switch (value){
                                case "0":
                                    returnValue ["condel"] = "deleterious"
                                    break;
                                case "1":
                                    returnValue ["condel"] = "benign"
                                    break;
                                default:
                                    returnValue ["condel"] = "deleterious"
                                    break;
                            }
                            break;
                        case "47":
                            LinkedHashMap parsedFilterString = parseCustomFilterString(value)
                            String equivalenceCode
                            switch (parsedFilterString.equivalence){
                                case "LT":equivalenceCode = "lessThan"; break;
                                case "GT":equivalenceCode = "greaterThan"; break;
                                case "EQ":equivalenceCode = "equalTo"; break;
                                default:equivalenceCode = "lessThan";break;
                            }
                            String filterDefinition = "custom47^${parsedFilterString.phenotype}^${parsedFilterString.sampleSet}^${equivalenceCode}^${parsedFilterString.property}___valueId"
                            returnValue [filterDefinition] = parsedFilterString.value
                            break;

                    }
                }

            }
        }
       return returnValue
    }







    /***
     * Process everything that the user has sent us as they try to build up their filter set for a search
     * @param params
     * @return
     */
  public handleFilterRequestFromBrowser (params)     {

      // pull out the phenotype and data set dependent filter requests (such as P value or odds ratio or whatever else)
      LinkedHashMap <String,String> customFilters=retrieveCustomFilters(params)

      // pull out all the common requests, independent of   phenotype and data set. Add in the custom filters from above,
      //  and store everything in one combined map
      LinkedHashMap newParameters = processNewParameters (
              customFilters,
              params.dataSet,
              params.esValue,
              params.esEquivalence,
              params.phenotype,
              params.filters,
              params.datasetExomeChip,
              params.datasetExomeSeq,
              params.datasetGWAS,
              params.region_stop_input,
              params.region_start_input,
              params.region_chrom_input,
              params.region_gene_input,
              params.predictedEffects,
              params.condelSelect,
              params.polyphenSelect,
              params.siftSelect
      )

      // pull out the saved requests, which need to be handled separately since they have to be decoded
      List <String> oldFilters=observeMultipleFilters(params)

      // finally combine the old filters (that is, the ones that would previously been saved) with whichever ones we've
      //  just now processed.  Put them all into a list of hash maps
      List <LinkedHashMap> combinedFilters = combineNewAndOldParameters(newParameters,
              oldFilters)

      return  combinedFilters
  }



  private int positioner(LinkedHashMap<String, LinkedHashMap> holder, LinkedHashMap<String, String> parsedFilter)   {
      int returnValue = 0
        if (parsedFilter !=  null ){
            LinkedHashMap phenotypeHolder
           if (holder.containsKey(parsedFilter.phenotype)) {// we have seen this phenotype before
               phenotypeHolder = holder [parsedFilter.phenotype]
           } else {// we haven't seen this phenotype before
               phenotypeHolder = new LinkedHashMap()
               holder [parsedFilter.phenotype] = phenotypeHolder
           }
            if (phenotypeHolder.containsKey(parsedFilter.sampleSet)) {// we have seen this phenotype before
                returnValue = phenotypeHolder [parsedFilter.sampleSet]
            } else {// we haven't seen this phenotype before
                int highestCurrentValue = holder ["highestCurrentValue"]
                highestCurrentValue++
                holder ["highestCurrentValue"] = highestCurrentValue
                phenotypeHolder [parsedFilter.sampleSet] = highestCurrentValue
                returnValue = highestCurrentValue
            }
        }
      return returnValue
  }

    /***
     * Add something to a hash map in the prescribed position. Create one if none exists already
     * @param growingList
     * @param index
     * @param key
     * @param value
     */
  private addOrExtend(List<LinkedHashMap<String, String>> growingList,int index,String key,String value){
      LinkedHashMap currentGatherer
      if (growingList[index] ==  null ){
          currentGatherer = new LinkedHashMap()
          growingList << currentGatherer
      } else {
          currentGatherer = growingList[index]
      }
      currentGatherer[key]=value
  }

    /***
     * The idea is to take a map of filters and to group them by unique combinations of phenotype
     * and sample group. This unique grouping is done by the positioner method
     * @param unorderedFilters
     * @return
     */
    public List <LinkedHashMap<String, String>> grouper(LinkedHashMap<String, String> unorderedFilters)   {
        LinkedHashMap<String, LinkedHashMap> holder = [:]
        holder["highestCurrentValue"] = -1
        List<LinkedHashMap<String, String>> returnValue = []
        for (Map.Entry<String, Object> entry : unorderedFilters.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue() as String;
            if (!(key =~ /^filter/)) {// not a complex filter. Put it in the first group
                addOrExtend(returnValue,0, key, value)
            } else { // complex filter. Need to figure out where it goes
                LinkedHashMap parsedFilter = parseCustomFilterString (value)
                int assignedLocation = positioner (holder,parsedFilter)
                addOrExtend(returnValue,assignedLocation, key, value)
            }

        }
        return  returnValue
    }










}
