package org.broadinstitute.mpg
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SearchBuilderService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.query.JsNamingQueryTranslator
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class FilterManagementService {

    private static final log = LogFactory.getLog(this)
    RestServerService restServerService
    SharedToolsService sharedToolsService
    SearchBuilderService searchBuilderService
    MetaDataService metaDataService
    FilterManagementService filterManagementService
    GeneManagementService geneManagementService


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




    /***
     * Build a few specialized filters based on known parameters. The originating searches come from the gene info and/or variant info pages
     * @param geneId
     * @param significance
     * @param dataset
     * @param region
     * @param receivedParameters
     * @return
     */
    public  List <String>  retrieveFiltersCodedFilters (  String geneId, Float significance,String dataset,String region,String receivedParameters,String phenotype)    {
        List <String> listOfCodedFilters = storeParametersInHashmap (geneId,significance,dataset,region,receivedParameters, phenotype)
        return  listOfCodedFilters
    }


    /***
     * Take a list of sample groups and a single phenotype and package up some information that we can pass down to the browser
     * @param sampleGroupList
     * @param phenotypeName
     * @return
     */
    public JSONObject convertSampleGroupListToJson (List <SampleGroup> sampleGroupList,String phenotypeName){
        LinkedHashMap<String,LinkedHashMap<String,String>> mapSampleGroupsToProperties = [:]
        List<SampleGroup> uniqueSampleGroupList = sampleGroupList.unique{ a,b -> a.getSystemId() <=> b.getSystemId() }
        for (SampleGroup sampleGroup in uniqueSampleGroupList){
            LinkedHashMap<String,String> sampleGroupProperties = [:]
            sampleGroupProperties["name"] =  sampleGroup.systemId
            sampleGroupProperties["value"] =  sampleGroup.systemId
            sampleGroupProperties["pvalue"] =  filterManagementService.findFavoredMeaningValue ( sampleGroup.systemId, phenotypeName, "P_VALUE" )
            sampleGroupProperties["orvalue"] =  filterManagementService.findFavoredMeaningValue ( sampleGroup.systemId, phenotypeName, "ODDS_RATIO" )
            sampleGroupProperties["betavalue"] =  filterManagementService.findFavoredMeaningValue ( sampleGroup.systemId, phenotypeName, "BETA" )
            sampleGroupProperties["technology"] =  metaDataService.getTechnologyPerSampleGroup( sampleGroup.systemId )
            sampleGroupProperties["maf"] = metaDataService.getSampleGroupProperty(sampleGroup.systemId, "MAF")?.getName()
            sampleGroupProperties["count"] =  "${sampleGroup.subjectsNumber}"
            mapSampleGroupsToProperties[sampleGroup.systemId] = sampleGroupProperties
        }
        String technologyListAsJson = sharedToolsService.packageUpASingleLevelTreeAsJson(mapSampleGroupsToProperties)
        JsonSlurper slurper = new JsonSlurper()
        return slurper.parseText(technologyListAsJson)
    }







    public String findFavoredMeaningValue ( String dataSetName, String phenotypeName, String meaningWeWant ) {
        String favoredPValue = "" // is a default better than nothing in this context
        if (phenotypeName){
            List<Property> propertyList = metaDataService.getSpecificPhenotypeProperties(dataSetName,phenotypeName)
            List<Property> sortedPValueProps = propertyList.
                    findAll{Property property->property.hasMeaning(meaningWeWant)}.
                    sort{Property property1,Property property2->property1.sortOrder<=>property2.sortOrder}
            if (sortedPValueProps.size()>0){
                favoredPValue = sortedPValueProps[0]?.name
            }
        }
        return favoredPValue
    }






    /***
     * Assign those filters
     * @param gene
     * @param significance
     * @param dataset
     * @param region
     * @param filter
     * @return
     */
    public List<String> storeParametersInHashmap(String gene,
                                                 Float significance,
                                                 String dataset,
                                                 String region,
                                                 String technology,
                                                 String phenotype) {
        List<String> returnValue = []

        String pValueSpec = ""

            if (dataset) {

                pValueSpec = findFavoredMeaningValue(dataset, phenotype, "P_VALUE")

                switch (technology) {
                    case RestServerService.TECHNOLOGY_GWAS:
                        break;
                    case RestServerService.TECHNOLOGY_EXOME_SEQ:
                        returnValue << "11=MOST_DEL_SCORE<4"
                        break;
                    case RestServerService.TECHNOLOGY_EXOME_CHIP:
                        returnValue << "11=MOST_DEL_SCORE<4"
                        break;
                    default:
                        break;
                }
            }

            // data set and P value implies another restriction
            if ((dataset) && (pValueSpec) && (phenotype)) {
                returnValue << "17=${phenotype}[${dataset}]${pValueSpec}<${significance}".toString()
            } else {
                returnValue << "11=MOST_DEL_SCORE<4"
            }

            // we can restrict by region...
            if (region) { // If there's a region then use it. Otherwise depend on the gene name. Don't use both
                LinkedHashMap extractedNumbers = restServerService.extractNumbersWeNeed(region)
                List<String> regionSpecifierList = []
                if (extractedNumbers) {
                    if (extractedNumbers["chromosomeNumber"]) {
                        regionSpecifierList << "8=${extractedNumbers['chromosomeNumber']}".toString()
                    }
                    if (extractedNumbers["startExtent"]) {
                        regionSpecifierList << "9=${extractedNumbers['startExtent']}".toString()
                    }
                    if (extractedNumbers["endExtent"]) {
                        regionSpecifierList << "10=${extractedNumbers['endExtent']}".toString()
                    }
                    returnValue << "${regionSpecifierList.join('^')}".toString()
                }
            } else if (gene) { // ...or we can restrict by Jean
                returnValue << "7=${gene}".toString()
            }




        return returnValue
    }


    public List<String> generateSampleGroupLevelQueries (String geneName, String sampleGroupName, String technology, Float lowerValue, Float higherValue, String propertyName)   {
        List<String> returnValue = []
        if (technology == "GWAS"){
            LinkedHashMap regionSpecificationDetailsForGene = geneManagementService.getRegionSpecificationDetailsForGene(geneName,50000)
            if (regionSpecificationDetailsForGene.chromosome) {
                returnValue << "8=${regionSpecificationDetailsForGene.chromosome}".toString()
            }
            if (regionSpecificationDetailsForGene.startPosition) {
                returnValue << "9=${regionSpecificationDetailsForGene.startPosition}".toString()
            }
            if (regionSpecificationDetailsForGene.endPosition) {
                returnValue << "10=${regionSpecificationDetailsForGene.endPosition}".toString()
            }

        } else if ((technology == "ExChip")||(technology == "ExSeq")){
            returnValue << "7=${geneName}".toString()
            returnValue << "11=MOST_DEL_SCORE<4"
        }
        returnValue << "17=T2D[${sampleGroupName}]${propertyName}>${lowerValue.toString()}".toString()
        returnValue << "17=T2D[${sampleGroupName}]${propertyName}<${higherValue.toString()}".toString()

        return returnValue
    }







    /***
     *
     * @param key
     * @param value
     * @return
     */
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
           Double valueAsDouble = 0d
           try {
               valueAsDouble =new Double(value)
           }catch (e){
               return ""
           }
           returnValue = "${phenotype}[${sample}]${property}${inequalitySignifier}${valueAsDouble.toString()}"
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

        int cFilterCount = 0
//        if (dataSet) {
//            returnValue['dataSet']  = dataSet
//        }

        if (regionGeneInput) {
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_GENE_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}${regionGeneInput}"
        }

        if (regionChromosomeInput) {
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_CHROMOSOME_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}${regionChromosomeInput}"
        }
        if (regionStartInput) {
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_START_POSITION_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}${regionStartInput}"
        }
        if (regionStopInput) {
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_END_POSITION_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}${regionStopInput}"
        }
        if ((predictedEffects) &&
                (predictedEffects != "undefined")&&
                (predictedEffects != "0")){
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_PROTEIN_EFFECT_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}"+
                    "${PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY}${JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING}${predictedEffects}"
        }

        if ((condelSelect) &&
                (condelSelect != "undefined")&&
                (condelSelect != "0")){
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_PROTEIN_EFFECT_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}"+
                    "${PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY}${JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING}${condelSelect}"
        }

        if ((polyphenSelect) &&
                (polyphenSelect != "undefined")&&
                (polyphenSelect != "0")){
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_PROTEIN_EFFECT_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}"+
                    "${PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY}${JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING}${polyphenSelect}"
        }

        if ((siftSelect) &&
                (siftSelect != "undefined")&&
                (siftSelect != "0")){
            returnValue["cfilter${cFilterCount++}"] = "${JsNamingQueryTranslator.QUERY_PROTEIN_EFFECT_LINE_NUMBER}${JsNamingQueryTranslator.QUERY_NUMBER_DELIMITER_STRING}"+
                    "${PortalConstants.JSON_VARIANT_SIFT_PRED_KEY}${JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING}${siftSelect}"
        }

        if (filters) {
            returnValue['filters']  = filters
        }

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



    public LinkedHashMap<String,String> combineNewAndOldParameters ( LinkedHashMap newParameters,
                                                List <String> encodedOldParameterList) {
        // decode the old parameters and make them into a map
        // create a new list, with new parameters as the first element
        //  and subsequent parameter lists following
        LinkedHashMap returnValue = [:]

        if (encodedOldParameterList){
            //for (String value in encodedOldParameterList){
                sharedToolsService.decodeAFilterList(encodedOldParameterList,returnValue)
            //}
        }


        // It is possible to send back an null filter, which we can then drop from further processing
        // does perform that test right here
        if (newParameters){

            List <String> cFilters = newParameters.keySet().findAll{ it =~ /^cfilter/ } as List
            for (String cFilter in cFilters){
                if (!returnValue.containsKey(cFilter)){
                    returnValue[cFilter] = newParameters[cFilter]
                }

            }
            List <String> pFilters = newParameters.keySet().findAll{ it =~ /^filter/ } as List
            for (String pFilter in pFilters){
                if (!returnValue.containsKey(pFilter)){
                    returnValue[pFilter] = "17=${newParameters[pFilter]}"
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
  public LinkedHashMap<String,String> handleFilterRequestFromBrowser (params)     {

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
      LinkedHashMap<String,String> combinedFilters = combineNewAndOldParameters(newParameters,
              oldFilters)

      return  combinedFilters
  }











}
