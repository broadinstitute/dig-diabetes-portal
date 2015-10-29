package org.broadinstitute.mpg

import grails.plugin.mail.MailService
import grails.transaction.Transactional
import groovy.json.StringEscapeUtils
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery
import org.broadinstitute.mpg.diabetes.metadata.query.JsNamingQueryTranslator
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.people.Role
import org.broadinstitute.mpg.people.User
import org.broadinstitute.mpg.people.UserRole
import org.broadinstitute.mpg.people.UserSession
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.mapping.LinkGenerator

@Transactional
class SharedToolsService {

     MailService mailService
    GrailsApplication grailsApplication
    LinkGenerator grailsLinkGenerator
    RestServerService restServerService
    MetaDataService metaDataService
    FilterManagementService filterManagementService
     private static final log = LogFactory.getLog(this)
    JSONObject sharedMetadata = null
    LinkedHashMap sharedProcessedMetadata = null
    Integer forceProcessedMetadataOverride = -1
    Integer forceMetadataOverride = -1
    Integer showGwas = -1
    Integer showExomeChip = -1
    Integer showExomeSequence = -1
    Integer showGene = -1
    Integer showBeacon = -1
    Integer showNewApi = 1
    Integer dataVersion = 2
    String warningText = ""
    String dataSetPrefix = "mdv"
    LinkedHashMap trans = [:]
    String currentGeneChromosome = "1"
    String currentVariantChromosome = "1"
    Integer recognizedStringsOnly = 0
    Integer cachedVariantNumber;
    Integer cachedGeneNumber;
    // TODO remove hack: currently we get phenotypes from the old geneinfo call, but
    // we need to interpret them with the new API, which uses different strings in some cases.
    //  Eventually we will pull the strings from the new API and then throw away this conversion utility
    LinkedHashMap convertPhenotypes = ["T2D":"T2D",
                                       "FastGlu":"FG",
                                       "FastIns":"FI",
                                       "ProIns":"PI",
                                       "2hrGLU_BMIAdj":"2hrG",
                                       "2hrIns_BMIAdj":"2hrI",
                                       "HOMAIR":"HOMAIR",
                                       "HOMAB":"HOMAB",
                                       "HbA1c":"HBA1C",
                                       "BMI":"BMI",
                                       "WHR":"WHR",
                                       "Height":"HEIGHT",
                                       "TC":"CHOL",
                                       "HDL":"HDL",
                                       "LDL":"LDL",
                                       "TG":"TG",
                                       "CAD":"CAD",
                                       "CKD":"CKD",
                                       "eGFRcrea":"eGFRcrea",
                                       "eGFRcys":"eGFRcys",
                                       "UACR":"UACR",
                                       "MA":"MA",
                                       "BIP":"BIP",
                                       "SCZ":"SCZ",
                                       "MDD":"MDD"   ]

    LinkedHashMap convertPhenotypesFlipped = null;

    Integer helpTextSetting = 1 // 0== never display, 1== display conditionally, 2== always display

    public String retrieveCurrentGeneChromosome ()  {
        return  currentGeneChromosome
    }
    public String retrieveCurrentVariantChromosome ()  {
        return  currentVariantChromosome
    }

    public String getCurrentDataVersion (){
        return "${dataSetPrefix}${getDataVersion()}"
    }

    public Integer getRecognizedStringsOnly() {
        return recognizedStringsOnly
    }

    public void setRecognizedStringsOnly(Integer recognizedStringsOnly) {
        this.recognizedStringsOnly = recognizedStringsOnly
    }

    /**
     * retrieve cached number of variants in the portal DB; pass in true for the cached number to be refreshed
     *
     * @param forceReload               whether to refresh the number
     * @return                          the total number of cached variants in the portal DB
     */
    public Integer getCachedVariantNumber(Boolean forceReload) {
        if ((this.cachedVariantNumber == null) || forceReload) {
            this.cachedVariantNumber = Variant.totalNumberOfVariants();
        }
        return this.cachedVariantNumber;
    }

    /**
     * retrieve cached number of genes in the portal DB; pass in true for the cached number to be refreshed
     *
     * @param forceReload               whether to refresh the number
     * @return                          the total number of cached genes in the portal DB
     */
    public Integer getCachedGeneNumber(Boolean forceReload) {
        if ((this.cachedGeneNumber == null) || forceReload) {
            this.cachedGeneNumber = Gene.totalNumberOfGenes();
        }
        return this.cachedGeneNumber;
    }

    private String determineNextChromosome (String currentChromosome) {
        String returnValue
        if (currentChromosome == 'X')  {
            returnValue = 'Y'
        }  else  if (currentChromosome == 'Y')  {
            returnValue = ''
        }   else {
            int chromosomeNumber =  currentChromosome as int
            if (chromosomeNumber == 23 )  {
                returnValue = 'X'
            }   else {
                returnValue =  (++chromosomeNumber)
            }
        }
        return  returnValue
    }

    public void incrementCurrentGeneChromosome ()  {
        currentGeneChromosome =   determineNextChromosome (retrieveCurrentGeneChromosome () )
    }
    public void incrementCurrentVariantChromosome ()  {
        currentVariantChromosome =   determineNextChromosome (retrieveCurrentVariantChromosome () )
    }



    public void setHelpTextSetting(int newHelpTextSetting){
        if ((newHelpTextSetting>-1) && (newHelpTextSetting < 3)) {
            helpTextSetting = newHelpTextSetting
        }else{
            log.error("Attempt to set help text to ${newHelpTextSetting}.  Should be 0, 1, or 2.")
        }
    }


    public Integer getDataVersion() {
        return dataVersion
    }

    public void setDataVersion(String dataVersionString) {
        int dataVersion  =   dataVersionString as int
        this.dataVersion = dataVersion
    }



    public int getHelpTextSetting (){
        return helpTextSetting
    }

    public String getWarningText(){
        return warningText
    }

    public void setWarningText(String warningText){
        this.warningText = warningText
    }





    public void  initialize(){
        showGwas = (grailsApplication.config.portal.sections.show_gwas)?1:0
        showExomeChip = (grailsApplication.config.portal.sections.show_exchp)?1:0
        showExomeSequence = (grailsApplication.config.portal.sections.show_exseq)?1:0
        showGene = (grailsApplication.config.portal.sections.show_gene)?1:0
        showBeacon = (grailsApplication.config.portal.sections.show_beacon)?1:0
        showNewApi = 1

        // DIGP_170: commenting out for final push to move to new metadata data structure (10/18/2015)
        // retrieveMetadata()  // may as well get this early.  The value is stored in
    }

    public enum TypeOfSection {
        show_gwas, show_exchp, show_exseq, show_gene, show_beacon
    }


    public Boolean getSectionToDisplay( typeOfSection) {
        showGwas = (showGwas==-1)?grailsApplication.config.portal.sections.show_gwas:showGwas
        showExomeChip = (showExomeChip==-1)?grailsApplication.config.portal.sections.show_exchp:showExomeChip
        showExomeSequence = (showExomeSequence==-1)?grailsApplication.config.portal.sections.show_exseq:showExomeSequence
        showGene = (showGene==-1)?grailsApplication.config.portal.sections.show_gene:showGene
        showBeacon = (showBeacon==-1)?grailsApplication.config.portal.sections.show_beacon:showBeacon
        Boolean returnValue = false
        switch (typeOfSection) {
            case TypeOfSection.show_gwas:
                returnValue = showGwas
                break;
            case TypeOfSection.show_exchp:
                returnValue = showExomeChip
                break;
            case TypeOfSection.show_exseq:
                returnValue = showExomeSequence
                break;
            case TypeOfSection.show_gene:
                returnValue = showGene
                break;
            case TypeOfSection.show_beacon:
                returnValue = showBeacon
                break;
            default:break;
        }
        return returnValue
    }


    public Boolean setApplicationToT2dgenes() {
        showGwas = 1
        showExomeChip = 1
        showExomeSequence = 1
        showBeacon = 0
    }


    public Boolean getApplicationIsT2dgenes() {
        return ((!showBeacon) &&
                (showGwas || showExomeChip  || showExomeSequence))
    }


    public Boolean setApplicationToBeacon() {
        showGwas = 0
        showExomeChip = 0
        showExomeSequence = 0
        showBeacon = 1
    }

    public Boolean getApplicationIsBeacon() {
        return showBeacon
    }

    /**
     * returns whether a metadada override has been set but not run yet
     *
     * @return
     */
    // DIGP-170: switch looking for the override from the SharedToolService to the new metadata object
    /*
    public Boolean getMetadataOverrideStatus() {
        return (this.metaDataService.forceProcessedMetadataOverride == 1)
//        return (forceMetadataOverride==1)
    }

    public void setMetadataOverrideStatus(int metadataOverride) {
        this.forceMetadataOverride=metadataOverride
    }
    */


    public String  applicationName () {
        String returnValue = ""
        if (getApplicationIsT2dgenes())   {
            returnValue = "t2dGenes"
        }  else  if (getApplicationIsBeacon())   {
            returnValue = "Beacon"
        }  else  {
            returnValue = "Undetermined application: internal error"
        }
        return returnValue
    }

    /***
     * This is a hack that we have to use because we still do a few things with the old API calls.
     * @param oldKey
     * @return
     */
    public String convertOldPhenotypeStringsToNewOnes (String oldKey){
        String returnValue = ""
        if ((oldKey) && (oldKey.length ()> 0)){
            if (convertPhenotypes.containsKey(oldKey)){
                returnValue = convertPhenotypes [oldKey]
            } else { // this should presumably never happen, but in case it does will guess that the string hasn't changed
                returnValue = oldKey
            }
        }
        return returnValue
    }

    /**
     * hack to fix trait id mismatch between old trait-search call and new getData and getMetadata trait ids
     *
     * @param newKey
     * @return
     */
    public String convertNewPhenotypeStringsToOldOnes (String newKey){
        if (this.convertPhenotypesFlipped == null) {
            this.convertPhenotypesFlipped = [];
            for (String key in this.convertPhenotypes.keySet()) {
                if (!this.convertPhenotypes.get(key).equals(key)) {
                    this.convertPhenotypesFlipped.put(this.convertPhenotypes.get(key), key);
                }
            }
        }

        if (this.convertPhenotypesFlipped.get(newKey)) {
            return this.convertPhenotypesFlipped.get(newKey)
        } else {
            return newKey
        }
    }

    /***
     * take whatever weird string the user comes up with and try to turn it into a variant name that we recognize
     * @param rawString
     * @return
     */
    public String createCanonicalVariantName (String  rawString){
        String canonicalForm = rawString
        if (rawString){
            String chromosome
            String position
            String reference
            String alternate
            if (rawString.indexOf(':')){
                List <String> dividedByColons = rawString.tokenize(":")
                if (dividedByColons.size()>1){
                    chromosome = dividedByColons[0]
                    position = dividedByColons[1]
                    canonicalForm = "${chromosome}_${position}"
                }
                if (dividedByColons.size()>2){
                    reference = dividedByColons[2]
                    canonicalForm += "_${reference}"
                }
                if (dividedByColons.size()>3){
                    alternate = dividedByColons[3]
                    canonicalForm += "_${alternate}"
                }
            }
            canonicalForm = rawString.replaceAll('-','_')
        }
        return canonicalForm
    }



    /***
     * Here's a shareable method to retrieve the contents of the metadata. The first time it's called it will store and cache the result.
     * After that every call draws from the cache,  UNLESS  the variable has been set to force a metadata override.
     * @return
     */
    // DIGP_170: commenting out for final push to move to new metadata data structure (10/18/2015)
    /*
    public JSONObject retrieveMetadata (){
        if ( (!sharedMetadata) ||
             (forceMetadataOverride == 1) ){
            String temporary = restServerService.getMetadata()
            def slurper = new JsonSlurper()
            sharedMetadata = slurper.parseText(temporary)
            forceMetadataOverride = 0

            // whenever we update the metadata then let's go through the processing step
            forceProcessedMetadataOverride = 1
            processMetadata(sharedMetadata)
        }
        return sharedMetadata
    }
    */

    /***
     * walk through the metadata tree and pull out things we need
     * @param metadata
     * @return
     */
    // DIGP_170: commenting out for final push to move to new metadata data structure (10/18/2015)
    /*
    public LinkedHashMap processMetadata(JSONObject metadata) {
        if ((!sharedProcessedMetadata) ||
                (sharedProcessedMetadata.size() == 0) ||
                (forceProcessedMetadataOverride == 1)) {
            sharedProcessedMetadata = [:]
            forceProcessedMetadataOverride = 0
        }
        return sharedProcessedMetadata
    }
    */

    // DIGP_170: commenting out for final push to move to new metadata data structure (10/18/2015)
    /*
    public LinkedHashMap getProcessedMetadata(){
        JSONObject jsonObject = retrieveMetadata()
        return processMetadata(jsonObject)
    }
    */






    /***
     * Control the order in which the columns appear on the screen after a sort.  Here we take the tree
     * containing the meta information describing the columns and sort it using the data structures
     * we have already extracted from the metadata.
     *
     * @param processedMetadata
     * @param unsortedTree
     * @return
     */
    private LinkedHashMap sortEverything(LinkedHashMap unsortedTree) {

        // sort common
        if ((unsortedTree?.cproperty) && (unsortedTree?.cproperty?.size() > 0)) {
            LinkedHashMap temporaryHolder = [:]
            List <Property> commonProperties = metaDataService.getCommonProperties()
            for (String property in unsortedTree.cproperty) {
                if (commonProperties.collect{return it.name}?.contains(property)) {
                    temporaryHolder[property] = commonProperties.find{it.name==property}.sortOrder
                }
            }
            unsortedTree.cproperty = ["VAR_ID"]+temporaryHolder.sort { it.value }.keySet()
        }

        // sort dproperty
        if ((unsortedTree?.dproperty) && (unsortedTree?.dproperty?.size() > 0)) {
            for (String phenotype in unsortedTree.dproperty.keySet()) {
                for (String sampleGroup in unsortedTree.dproperty[phenotype].keySet()) {
                    List<String> properties =   unsortedTree.dproperty[phenotype][sampleGroup]
                    List<String> props = metaDataService.getPhenotypeSpecificSampleGroupPropertyList(sampleGroup,phenotype)
                    List<String> props2 = props.findAll{properties.contains(it)}
                    if ((props2)&&(props2.size()>0)){
                        unsortedTree.dproperty[phenotype][sampleGroup] = props2
                    }
                }

            }

        }


        // sort pproperty
        if ((unsortedTree?.pproperty) && (unsortedTree?.pproperty?.size() > 0)) {
            for (String phenotype in unsortedTree.pproperty.keySet()) {
                for (String sampleGroup in unsortedTree.pproperty[phenotype].keySet()) {
                    List<String> properties =   unsortedTree.pproperty[phenotype][sampleGroup]
                    List<String> props = metaDataService.getSpecificPhenotypePropertyList(sampleGroup,phenotype)
                    List<String> props2 = props.findAll{properties.contains(it)}
                    if ((props2)&&(props2.size()>0)){
                        unsortedTree.pproperty[phenotype][sampleGroup] = props2
                    }
                }

            }

        }
        return unsortedTree
    }











    /***
     * Subset the metadata to only columns we want to display
     * @param phenotypesToKeep The phenotypes to keep
     * @param sampleGroupsToKeep The sample groups to keep 
     * @param propertiesToKeep The properties to keep 
     * @return
     */
    public LinkedHashMap getColumnsToDisplayStructure(List <String> phenotypesToKeep=null,
                                                      List <String> sampleGroupsToKeep=null, List <String> propertiesToKeep=null,
                                                      List <String> commonProperties=null  ){

        // DIGP-170: modified method signature for final push to move to dynamic metadata structure
        if (phenotypesToKeep) {
            phenotypesToKeep = phenotypesToKeep.unique()
        }
        if (sampleGroupsToKeep) {
            sampleGroupsToKeep = sampleGroupsToKeep.unique()
        }
        if (propertiesToKeep) {
            propertiesToKeep = propertiesToKeep.unique()
        }

        LinkedHashMap returnValue = [:]

        returnValue["cproperty"] = commonProperties


        returnValue["dproperty"] = [:]
        returnValue["pproperty"] = [:]


            if (phenotypesToKeep == null) {

                phenotypesToKeep = metaDataService.getEveryPhenotype()
            } else
            {
                phenotypesToKeep = phenotypesToKeep.findAll({metaDataService.getEveryPhenotype().contains(it)})
            }

            for (String phenotype in phenotypesToKeep) {
                returnValue.pproperty[phenotype] = [:]
                returnValue.dproperty[phenotype] = [:]
                List<String> curSampleGroups = []
                if (sampleGroupsToKeep == null) {
                    curSampleGroups.addAll(metaDataService.getSampleGroupPerPhenotype(phenotype))
                } else {
                    curSampleGroups.addAll(sampleGroupsToKeep)
                    //curSampleGroups.addAll(sampleGroupsToKeep.findAll({metaDataService.getSampleGroupPerPhenotype(phenotype)?.contains(it)}))
                }
                for (String sampleGroup in curSampleGroups) {
                    returnValue.dproperty[phenotype][sampleGroup] = []
                    returnValue.pproperty[phenotype][sampleGroup] = []
                    if (propertiesToKeep == null) {
                        // I'm not sure that this branch is ever called
                        returnValue.dproperty[phenotype][sampleGroup].addAll(metaDataService.getSampleGroupPropertyList(sampleGroup).contains(it))
                        List<String> propertiesToAdd= metaDataService.getSpecificPhenotypePropertyList(sampleGroup,phenotype)
                        if ((propertiesToAdd) && (propertiesToAdd.size()>0)) {
                            returnValue.pproperty[phenotype][sampleGroup].addAll(propertiesToAdd)
                        }
                    } else {
                        returnValue.dproperty[phenotype][sampleGroup].addAll(propertiesToKeep.findAll({metaDataService.getSampleGroupPropertyList(sampleGroup).contains(it)}))
                        List<String> phenotypeProperties =metaDataService.getSpecificPhenotypePropertyList(sampleGroup,phenotype)
                        List<String> propertiesToAdd= propertiesToKeep.findAll{phenotypeProperties}
                        if ((propertiesToAdd) && (propertiesToAdd.size()>0)) {
                            returnValue.pproperty[phenotype][sampleGroup].addAll(propertiesToAdd)
                        }
                    }
                }

        }

        return sortEverything(returnValue)
    }





    public String packageUpAListAsJson (List <String> listOfStrings ){
        // now that we have a list, build it into a string suitable for JSON
        int numrec = 0
        StringBuilder sb = new StringBuilder ()
        if ((listOfStrings) && (listOfStrings?.size() > 0)){
            numrec = listOfStrings.size()
            for ( int  i = 0 ; i < numrec ; i++ ){
                sb << "\"${listOfStrings[i]}\"".toString()
                if (i < listOfStrings.size() - 1) {
                    sb << ","
                }
            }
        }

        return  """
{"is_error": false,
"numRecords":${numrec},
"dataset":[${sb.toString()}]
}""".toString()
    }




    public String packageUpATreeAsJson (LinkedHashMap<String, LinkedHashMap <String,List <String>>> bigTree ){
        // now that we have a multilevel tree, build it into a string suitable for JSON
        StringBuilder returnValue = new StringBuilder ()
        if ((bigTree) && (bigTree?.size() > 0)){
            List <String> phenotypeHolder = []
            bigTree.each {String phenotype,  LinkedHashMap phenotypeSpecificSampleGroups->
                StringBuilder sb = new StringBuilder ()
                sb << """  \"${phenotype}\":
    {""".toString()
                List <String> sampleGroupList = []
                if (phenotypeSpecificSampleGroups?.size() > 0){
                    phenotypeSpecificSampleGroups.each { String sampleGroupName, List<String> propertyNames ->
                        sampleGroupList << """        \"${sampleGroupName}\":[
      ${propertyNames.collect {return "\"$it\""}.join(",")}
 ]""".toString()
                    }
                }
                sb << """
          ${sampleGroupList.join(",")}
  }""".toString()
                phenotypeHolder << sb.toString()
            }
            returnValue << """{
            ${phenotypeHolder.join(",")}
            }"""
        }
        return returnValue.toString()
    }




    public String packageUpSortedHierarchicalListAsJson (LinkedHashMap mapOfSampleGroups ){
        // now that we have a list, build it into a string suitable for JSON
        int numberOfGroups = 0
        StringBuilder sb = new StringBuilder ()


        List <String> sampleGroupList = []
        if (mapOfSampleGroups?.size() > 0){
            mapOfSampleGroups.each { String sampleGroupName, List<String> propertyNames ->
                sampleGroupList << """        \"${sampleGroupName}\":[
      ${propertyNames.collect {return "\"$it\""}.join(",")}
 ]""".toString()
            }
        }
        sb << """
          ${sampleGroupList.join(",")}
""".toString()

        return  """
{"is_error": false,
"numRecords":${numberOfGroups},
"dataset":{${sb.toString()}}
}""".toString()
    }








    public String packageUpAHierarchicalListAsJson (LinkedHashMap mapOfStrings ){
        // now that we have a list, build it into a string suitable for JSON
        int numberOfGroups = 0
        StringBuilder sb = new StringBuilder ()

        if ((mapOfStrings) && (mapOfStrings?.size() > 0)){
            LinkedHashMap sortedMapOfStrings = mapOfStrings
            numberOfGroups = sortedMapOfStrings.size()
            int groupCounter  = 0
            sortedMapOfStrings.each{k,List v->
                sb <<  "\"${k}\":[".toString()
                int individualGroupLength  = v.size()
                    for ( int  i = 0 ; i < individualGroupLength ; i++ ){
                        sb << "\"${v[i]}\"".toString()
                        if (i < individualGroupLength - 1) {
                            sb << ","
                        }
                    }
                sb <<  "]"
                groupCounter++
                if (numberOfGroups > groupCounter) {
                    sb << ","
                }
            }
        }

        return  """
{"is_error": false,
"numRecords":${numberOfGroups},
"dataset":{${sb.toString()}}
}""".toString()
    }



    LinkedHashMap<String, LinkedHashMap<String, List <String>>> putPropertiesIntoHierarchy(String rawProperties){
        LinkedHashMap phenotypeHolder = [:]
        if ((rawProperties) &&
            (rawProperties.length())){
            List <String> listOfProperties = rawProperties.tokenize("^")
            for (String property in listOfProperties){
                List <String> propertyPieces = property.tokenize(":") // 0=Phenotype,1= data set,2= property
                LinkedHashMap datasetHolder
                if (phenotypeHolder.containsKey(propertyPieces[0])){
                    datasetHolder = phenotypeHolder[propertyPieces[0]]
                } else{
                    datasetHolder = [:]
                    phenotypeHolder[propertyPieces[0]] = datasetHolder
                }
                List propertyHolder
                if (datasetHolder.containsKey(propertyPieces[1])){
                    propertyHolder = datasetHolder[propertyPieces[1]]
                }else{
                    propertyHolder = []
                    datasetHolder[propertyPieces[1]] = propertyHolder
                }
                if (!propertyHolder.contains(propertyPieces[2])){
                    propertyHolder << propertyPieces[2]
               }

            }
        }
        return phenotypeHolder
    }





    public String  parseChromosome (String rawChromosomeString) {
        String returnValue = ""
        java.util.regex.Matcher chromosome = rawChromosomeString =~ /chr[\dXY]*/
        if (chromosome.size() == 0) {  // let's try to help if the user forgot to specify the chr
            chromosome = rawChromosomeString =~ /[\dXY]*/
        }
        if (chromosome.size() > 0) {
            java.util.regex.Matcher chromosomeString = chromosome[0] =~ /[\dXY]+/
            if (chromosomeString.size() > 0) {
                returnValue = chromosomeString[0]
            }
        }
        return returnValue;
    }


    public String  parseExtent (String rawExtentString) {
        String returnValue = ""
        java.util.regex.Matcher startExtentString = rawExtentString =~ /\d+/
        if (startExtentString.size()>0)  {
           returnValue =  startExtentString[0]
        }
        return returnValue;
    }


    public String convertMultipartFileToString(org.springframework.web.multipart.commons.CommonsMultipartFile incomingFile) {
        StringBuilder sb = []
        if (!incomingFile.empty) {
            java.io.InputStream inputStream = incomingFile.getInputStream()
            try {
                int temp
                while ((temp = inputStream.read()) != -1) {
                    sb << ((char) temp).toString()
                }
            } catch (Exception ex) {
                log.error('Problem reading input file=' + ex.toString() + '.')
            }
        } else {
            log.info('User passed us an empty file.')
        }
        return sb.toString()
    }

    /***
     * split up a compound string on the basis of commas.  Turn it into a nice clean list
     *
     * @param initialString
     * @return
     */
    List<String> convertStringToArray (String initialString){
        List<String> returnValue = []
        List<String> rawList = []
        if (initialString){
            rawList =  initialString.split(',')
        }
        for (String oneString in rawList){
            returnValue << oneString.replaceAll("[^a-zA-Z_\\d\\s:]","")
        }
        return returnValue
    }



    /***
     * Convert a simple list into a collection of strings enclosed in quotation marks and separated
     * by commas
     * @param list
     * @return
     */
    String convertListToString (List <String> list){
        String returnValue = ""
        if (list) {
            List filteredList = list.findAll{it.toString().size()>0} // make sure everything is a string with at least size > 0
            if (filteredList.size()>0){
                returnValue = "\""+filteredList.join("\",\"")+"\"" // put them together in a way that Json can consume
            }
        }
        return returnValue
    }

    /***
     * take the data from a multiple line representation (as one might find in a datafile) and
     * put every line into its own element in a list. While were at it remove quotation marks
     * as well as everything else that is in a digit, character, or underscore.
     *
     * @param multiline
     * @return
     */
    List<String> convertMultilineToList (String multiline){
        List<String> returnValue = []
        multiline.eachLine {
            if (it) {
                String filteredVersion =  it.toString().replaceAll("[^a-zA-Z_\\d\\s:]","")
                if (filteredVersion){
                    returnValue <<  filteredVersion
                }
            }
        }
        return returnValue
    }






    String createDistributedBurdenTestInput(List <String> variantList){
        String returnValue ="""{
            "variants":[
               ${convertListToString(variantList)}
        ],
            "covariates": [],
            "samples": []
        }"""
        return returnValue
    }





    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfProteinEffect() {
        List<ProteinEffect> proteinEffectList=ProteinEffect.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfProteinEffects  =  proteinEffectList.size()
        int iterationCount  = 0
        for (ProteinEffect proteinEffect in proteinEffectList){
            sb<< (proteinEffect.key + ":" + proteinEffect.name )
            iterationCount++
            if (iterationCount  < numberOfProteinEffects){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfUsers() {
        List<User> userList=User.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfUsers  =  userList.size()
        int iterationCount  = 0
        for (User user in userList){
            sb<< (user.username + ":" + (user.getPasswordExpired()?'T':'F') + ":" + (user.getAccountExpired()?'T':'F')+ ":" + user.getId())
            iterationCount++
            if (iterationCount  < numberOfUsers){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }


    public String urlEncodedListOfUserSessions(List<UserSession> userSessionList) {
        StringBuilder sb   = new StringBuilder ("")
        int numberOfUsers  =  userSessionList.size()
        int iterationCount  = 0
        for (UserSession userSession in userSessionList){
            sb<< (userSession.user.username + "#" + (userSession.getStartSession().toString()) + "#" + (userSession.getEndSession()?:'none')+ "#" +
                    (userSession.getRemoteAddress()?:'none') + "#" + (userSession.getDataField()?:'none') )
            iterationCount++
            if (iterationCount  < numberOfUsers){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



    /***
     * Given a user, translate their privileges into a flag integer
     *
     * @param userInstance
     * @return
     */
    public int extractPrivilegeFlags (User userInstance)  {
        int flag = 0
        List<UserRole> userRoleList = UserRole.findAllByUser(userInstance)
        for (UserRole oneUserRole in userRoleList) {
            if (oneUserRole.role == Role.findByAuthority("ROLE_USER")) {
                flag += 1
            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_ADMIN")) {
                flag += 2
            }  else  if (oneUserRole.role == Role.findByAuthority("ROLE_SYSTEM")) {
                flag += 4
            }
        }
        return flag
    }




    private void adjustPrivileges (User userInstance, int targetFlag,int currentFlag, int bitToConsider, String targetRole )  {
        if ((targetFlag&bitToConsider) > 0 ) {
            // we want them to have it

            if ((currentFlag&bitToConsider) == 0) {
                // we want them to have it and they don't. Give it to them
                Role role =  Role.findByAuthority(targetRole)
                UserRole.create userInstance,role
            }  // else we want them to have it and they do already == no-op

        }   else {
            // we don't want them to have it

            if ((currentFlag&bitToConsider) > 0) {
                // we don't want them to have it but they do. Take it away
                Role role =  Role.findByAuthority(targetRole)
                UserRole userRole = UserRole.findByUserAndRole(userInstance,role)
                        //               UserRole userRole =  UserRole.get(userInstance.id,role.id)
                userRole.delete()
            }  // else we don't want them to have it and they don't already == no-op

        }

    }



    /***
     * Give the user the privileges we want them to have – no more, no less
     * @param userInstance
     * @param flag
     * @return
     */
    public int storePrivilegesFromFlags (User userInstance,int targetFlag)  {
        // what privileges do they have already
        int currentFlag = extractPrivilegeFlags ( userInstance)

        // Now go through the flags we want them to have one by one and adjust accordingly
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x1, "ROLE_USER" )
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x2, "ROLE_ADMIN" )
        adjustPrivileges ( userInstance,  targetFlag, currentFlag, 0x4, "ROLE_SYSTEM" )

        return targetFlag
    }

    public int convertCheckboxesToPrivFlag(params){
        int flag = 0
        if (params["userPrivs"]=="on"){
            flag += 1
        }
        if (params["mgrPrivs"]=="on"){
            flag += 2
        }
        if (params["systemPrivs"]=="on"){
            flag += 4
        }
        return flag
    }

    /***
     * did we get enough information to find a spot on the genome? We need at least a chromosome specifier and
     * a position greater than and a position less than OR a gene (allowing us to infer the position).
     *
     * @param getDataQuery
     * @return
     */
    public LinkedHashMap validGenomicExtents (GetDataQuery getDataQuery) {
        LinkedHashMap returnValue = [:]
        List <Integer> geneIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_GENE)
        List <Integer> chromosomeIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME)
        List <Integer> positionIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_POSITION)
        if (geneIndex?.size()==1){
            Property property = getDataQuery.getFilterList()[geneIndex[0]]?.property
            Gene geneList = Gene.retrieveGene(property?.getName())
            if (geneList){
                returnValue["addrStart"] = geneList.addrStart
                returnValue["addrEnd"] = geneList.addrEnd
                returnValue["chromosome"] = geneList.chromosome
                returnValue["geneName"] = geneList.name2
            }
        } else if ((chromosomeIndex?.size()==1) &&
                   (positionIndex.size()==2) ){
            QueryFilter queryFilter0 = getDataQuery.getFilterList()[positionIndex[0]]
            QueryFilter queryFilter1 = getDataQuery.getFilterList()[positionIndex[1]]
            returnValue["addrStart"] = 0L
            returnValue["addrEnd"] = 3200000000L
            if ((queryFilter0.operator==PortalConstants.OPERATOR_LESS_THAN_EQUALS)  ||
                (queryFilter0.operator==PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS)){
                returnValue["addrEnd"] = queryFilter0.value as Long
            }
            if ((queryFilter1.operator==PortalConstants.OPERATOR_MORE_THAN_EQUALS)  ||
                    (queryFilter1.operator==PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS)){
                returnValue["addrStart"] = queryFilter1.value as Long
            }
            returnValue["chromosome"] = getDataQuery.getFilterList()[chromosomeIndex[0]]?.property
        }
        return returnValue
    }




    List <String> allEncompassedGenes (LinkedHashMap genomicExtents){
        List <String> returnValue = []
        if (genomicExtents.size()>0){
            List<Gene> geneList = Gene.findAllByChromosome("chr"+genomicExtents["chromosome"])
            for (Gene gene in geneList) {
                int startExtent = genomicExtents["addrStart"] as Long
                int endExtent = genomicExtents["addrEnd"] as Long
                if (((gene.addrStart >startExtent) && (gene.addrStart < endExtent)) ||
                        ((gene.addrEnd > startExtent) && (gene.addrEnd <endExtent))) {
                    returnValue << gene.name1 as String
                }
            }
        }
        return returnValue
    }


    List <String> allEncompassedGenes (GetDataQuery getDataQuery){
        LinkedHashMap genomicExtents = validGenomicExtents ( getDataQuery)
        return allEncompassedGenes (genomicExtents)
    }






    /***
     * packageUpFiltersForRoundTrip get back a list of filters that we need to pass to the backend. We package them up for a round trip to the client
     * and back via the Ajax call
     *
     * @param listOfAllFilters
     * @return
     */
    public String packageUpFiltersForRoundTrip (List <String> listOfAllFilters)  {

        StringBuilder sb = new  StringBuilder()
        if (listOfAllFilters) {
            for ( int i=0 ; i<listOfAllFilters.size() ; i++ ) {
                sb <<  listOfAllFilters[i]
                if ((i+1)<listOfAllFilters.size()) {
                    sb << ","
                }
            }
        }
        return java.net.URLEncoder.encode(sb.toString())

    }




    public LinkedHashMap<String,List<LinkedHashMap>> composePhenotypeOptions () {
        LinkedHashMap<String,List<LinkedHashMap>> returnValue = [:]
        LinkedHashMap<String, List<String>> propertyTree = metaDataService.getHierarchicalPhenotypeTree()
        propertyTree.each{String categoryName,List<String> phenotypeList->
            List<LinkedHashMap>  phenotypesAndTranslations = []
            for (String phenotype in phenotypeList) {
                phenotypesAndTranslations << ['mkey':phenotype,'name':translator(phenotype)]
            }
            returnValue[categoryName] =  phenotypesAndTranslations
        }
        return  returnValue
    }






    /***
     * build up a phenotype list
     * @return
     */
    public LinkedHashMap<String,List<LinkedHashMap>> composeDatasetOptions (){
        LinkedHashMap returnValue = [:]
        List ancestry = []
        ancestry << ['mkey':'AA','name':'African-American']
        ancestry << ['mkey':'EA','name':'East Asian']
        ancestry << ['mkey':'SA','name':'South Asian']
        ancestry << ['mkey':'EU','name':'European']
        ancestry << ['mkey':'HS','name':'Hispanic']
        returnValue ["ancestry"] = ancestry
        return returnValue
    }







    /***
     *  we need to  encode the list of parameters so that we can reset them when we reenter  the filter setting form.  It
     *  is certainly true that this is a different form of the same information that is held in BOTH the filter list and the
     *  filterDescription  list.  This one could be passed from a different page, however, so we really want a simple, unambiguous
     *  way to store it and pass it around
     *
     *  Note that these values will be interpreted by the client (browser) and they are guaranteed to have no funny characters.  Therefore
     *  we don't need to URL encode them
     *
     * @param listOfAllEncodedParameters
     * @return
     */
    public String packageUpEncodedParameters (List <String> listOfAllEncodedParameters ) {
        StringBuilder sbEncoded = new  StringBuilder()
        for ( int i=0 ; i<listOfAllEncodedParameters.size() ; i++ ) {
            sbEncoded <<  listOfAllEncodedParameters[i]
            if ((i+1)<listOfAllEncodedParameters.size()) {
                sbEncoded << ","
            }
        }

        return sbEncoded.toString()
    }


    public String encodeUser (String putativeUsername)  {
        int key=47
        String coded = ""
        for ( int i = 0; i < putativeUsername.length(); ++i )
        {

            char c = putativeUsername.charAt( i );
            int j = (int) c + key;
            coded+=(j+"-")


        }
        return  coded
    }



    public String unencodeUser (String encodedUsername)  {
        String returnValue = ""
        String[] elements = encodedUsername.split("-")
        for  ( int i = 0; i < elements.size(); ++i ){
            String encChar = elements[i]
            if (encChar.length()>0)    {
                int codedVal = encChar.toInteger()
                int decoded=codedVal-47
                String aChar = new Character((char) decoded).toString();
                returnValue +=  aChar
            }
        }
        return returnValue

    }





    public String sendForgottenPasswordEmail(String userEmailAddress){
        String serverUrl = "http://localhost:8080/dport"
        String passwordResetUrl = grailsLinkGenerator.link(controller:'admin', action:'resetPasswordInteractive',absolute: true)
        String bodyOfMessage = "Dear diabetes portal user;\n\n In order to access the updated version of the diabetes portal it will be necessary for you to reset your password."+
        "Please copy the following string into the URL of your browser:\n\n" +
                passwordResetUrl+ "/"+ encodeUser(userEmailAddress) +"\n"+
                "\n"+
                "If you did not request a password reset then you can safely ignore this e-mail"
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to userEmailAddress
            subject "Password reset necessary"
            body bodyOfMessage
        }

    }



    public String encodeAFilterList(LinkedHashMap<String,String> parametersToEncode,LinkedHashMap<String,String> customFiltersToEncode) {
        StringBuilder sb   = new StringBuilder ("")
        if (((parametersToEncode.containsKey("phenotype")) && (parametersToEncode["phenotype"]))) {
            sb << ("1="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["phenotype"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("dataSet")) && (parametersToEncode["dataSet"]))) {
            sb << ("2="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["dataSet"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("orValue")) && (parametersToEncode["orValue"]))) {
            sb << ("3="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["orValue"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("orValueInequality")) && (parametersToEncode["orValueInequality"]))) {
            sb << ("4="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["orValueInequality"])+"^")
        }
        if (((parametersToEncode.containsKey("pValue")) && (parametersToEncode["pValue"]))) {
            sb << ("5="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["pValue"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("pValueInequality")) && (parametersToEncode["pValueInequality"]))) {
            sb << ("6="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["pValueInequality"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("gene")) && (parametersToEncode["gene"]))) {
            sb << ("7="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["gene"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("regionChromosomeInput")) && (parametersToEncode["regionChromosomeInput"]))) {
            sb << ("8="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["regionChromosomeInput"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("regionStartInput")) && (parametersToEncode["regionStartInput"]))) {
            sb << ("9="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["regionStartInput"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("regionStopInput")) && (parametersToEncode["regionStopInput"]))) {
            sb << ("10="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["regionStopInput"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("predictedEffects")) && (parametersToEncode["predictedEffects"]))&&
                (parametersToEncode["predictedEffects"]!="0")) {
            sb << ("11="+
             StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY}|${parametersToEncode["predictedEffects"]}")+"^")
        }
        if (((parametersToEncode.containsKey("esValue")) && (parametersToEncode["esValue"]))) {
            sb << ("12="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["esValue"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("esValueInequality")) && (parametersToEncode["esValueInequality"]))) {
            sb << ("13="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["esValueInequality"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("condelSelect")) && (parametersToEncode["condelSelect"]))) {
            sb << ("11="+
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY}|${parametersToEncode["condelSelect"]}")+"^")
        }
        if (((parametersToEncode.containsKey("polyphenSelect")) && (parametersToEncode["polyphenSelect"]))) {
            sb << ("11="+
            StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY}|${parametersToEncode["polyphenSelect"]}")+"^")
        }
        if (((parametersToEncode.containsKey("siftSelect")) && (parametersToEncode["siftSelect"]))) {
            sb << ("11="+
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_SIFT_PRED_KEY}|${parametersToEncode["siftSelect"]}")+"^")
        }
        customFiltersToEncode?.each { String key, String value ->
            sb << ("17=" + StringEscapeUtils.escapeJavaScript(value.toString()) + "^")
        }


        return  sb.toString()
    }


    public LinkedHashMap getGeneExtent (String geneName){
        LinkedHashMap<String, Integer> returnValue  = [startExtent:0,endExtent:3000000000,chrom:"1"]
        if (geneName)   {
            String geneUpperCase =   geneName.toUpperCase()
            Gene gene = Gene.retrieveGene(geneUpperCase)
            returnValue.startExtent= gene?.addrStart ?: 0
            returnValue.endExtent= gene?.addrEnd ?: 0
            returnValue.chrom=gene?.chromosome
        }
        return returnValue
    }


    public LinkedHashMap getGeneExpandedExtent (String geneName){
        LinkedHashMap<String, Integer> returnValue  = [startExtent:0,endExtent:3000000000]
        if (geneName)   {
            LinkedHashMap<String, Integer> geneExtent = getGeneExtent (geneName)
            Integer addrStart =  geneExtent.startExtent
            if (addrStart){
                returnValue.startExtent = ((addrStart > 100000)?(addrStart - 100000):0)
            }
            returnValue.endExtent= geneExtent.endExtent+ 100000
            returnValue.chrom=geneExtent.chrom
        }
        return returnValue
    }




    public Long convertRegionString(String incomingExtent){
        Long returnValue = -1
        try {
            returnValue = Long.parseLong(incomingExtent)
        } catch (NumberFormatException nfe) {
            log.info("convertRegionString failed to convert= ${incomingExtent}")
            returnValue = -1
        }
        return returnValue
    }



    public String getGeneExpandedRegionSpec(String geneName){
        String returnValue = ""
        if (geneName)   {
            String geneUpperCase =   geneName.toUpperCase()
            Gene gene = Gene.retrieveGene(geneUpperCase)
            LinkedHashMap<String, Integer> geneExtent = getGeneExpandedExtent (geneName)
            returnValue = "${gene.chromosome}:${geneExtent.startExtent}-${geneExtent.endExtent}"
          }
        return returnValue
    }


    public void decodeAFilterList(List <String> encodedOldParameterList,LinkedHashMap<String,String> returnValue) {
        int filterCount = 0
        for (String encodedFilterString in encodedOldParameterList){
            if (encodedFilterString){
                List <String> parametersList =  encodedFilterString.split("\\^")
                for ( int  i = 0 ; i < parametersList.size() ; i++  > 0){
                    List <String> divKeys = parametersList[i].split("=")
                    if (divKeys.size() != 2){
                        log.info("Problem interpreting filter list = ${parametersList}")
                    }else {
                        int parameterKey
                        try {
                            parameterKey = Integer.parseInt(divKeys [0])
                        }catch (e){
                            log.info("Unexpected key when interpreting filter list = ${parametersList}")
                        }
                        returnValue ["ofilter${filterCount++}"] = StringEscapeUtils.unescapeJavaScript(parametersList[i]);
//                        switch (parameterKey){
//                            case 1:returnValue ["phenotype"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 2:returnValue ["dataSet"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 3:returnValue ["orValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 4:returnValue ["orValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 5:returnValue ["pValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 6:returnValue ["pValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 7:returnValue ["gene"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 8:returnValue ["regionChromosomeInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 9:returnValue ["regionStartInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 10:returnValue ["regionStopInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 11:returnValue ["predictedEffects"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 12:returnValue ["esValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 13:returnValue ["esValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 14:returnValue ["condelSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 15:returnValue ["polyphenSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 16:returnValue ["siftSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 17:returnValue ["ofilter${filterCount++}"] = StringEscapeUtils.unescapeJavaScript(parametersList[i]);
//                                break
//                            default:
//                                log.info("Unexpected parameter key  = ${parameterKey}")
//                        }
                    }
                }
            }
        }
        return
    }






public String translatorFilter (String filterToTranslate){
    //break apart the filter, substitute human readable strings
    String returnValue
    List <String> breakoutProperty = filterToTranslate.tokenize(JsNamingQueryTranslator.QUERY_SAMPLE_GROUP_AND_STRING)
    if (breakoutProperty.size ()==2){
        List <String> breakoutPhenotype = breakoutProperty [0].tokenize(JsNamingQueryTranslator.QUERY_SAMPLE_GROUP_BEGIN_STRING)
        if (breakoutPhenotype.size ()==2) {
            String comparator = ""
            String displayableComparator = ""
            if (breakoutProperty [1].contains (JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING)){
                comparator = JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING
                displayableComparator = "="
            } else if (breakoutProperty [1].contains (JsNamingQueryTranslator.QUERY_OPERATOR_MORE_THAN_STRING)){
                comparator = JsNamingQueryTranslator.QUERY_OPERATOR_MORE_THAN_STRING
                displayableComparator = "&gt;"
            } else if (breakoutProperty [1].contains (JsNamingQueryTranslator.QUERY_OPERATOR_LESS_THAN_STRING)){
                comparator = JsNamingQueryTranslator.QUERY_OPERATOR_LESS_THAN_STRING
                displayableComparator = "&lt;"
            } else {
                returnValue = filterToTranslate
            }
            if (comparator.length () > 0){
                // try for the fully expanded description
                List <String> valueComparisonBreakout = breakoutProperty [1].tokenize(comparator)
                if (valueComparisonBreakout.size () == 2){
                    returnValue = "${translator (breakoutPhenotype[0])}[${translator (breakoutPhenotype[1])}"+
                            "]${translator (valueComparisonBreakout[0])}${displayableComparator}${valueComparisonBreakout[1]}"
                }
            }
        }else {
            // something surprising happened. Let's take our best shot at a filter
            returnValue = filterToTranslate
        }
    }else {
        // something surprising happened. Let's take our best shot at a filter
        returnValue = filterToTranslate
    }
return returnValue

}











/***
 * Clearly these belong somewhere other than hardcoded in the middle of this method
 * TODO remove this gross hack
 * @param stringToTranslate
 * @return
 */
    public String translator(String stringToTranslate){
    if (stringToTranslate){
         if (trans.size()<=0) {
             trans["vT2D"]="Type 2 diabetes"
             trans["vBMI"]="BMI"
             trans["vCHOL"]="Cholesterol"
             trans["vDBP"]="Diastolic blood pressure"
             trans["vFG"]="Fasting glucose"
             trans["vFI"]="Fasting insulin"
             trans["vHBA1C"]="HbA1c"
             trans["vHDL"]="HDL cholesterol"
             trans["vHEIGHT"]="Height"
             trans["vHIPC"]="Hip circumference"
             trans["vLDL"]="LDL cholesterol"
             trans["vSBP"]="Systolic blood pressure"
             trans["vTG"]="Triglycerides"
             trans["vWAIST"]="Waist circumference"
             trans["vWHR"]="Waist-hip ratio"
             trans["vCAD"]="Coronary artery disease"
             trans["vCKD"]="Chronic kidney disease"
             trans["vUACR"]="Urinary albumin-to-creatinine ratio"
             trans["veGFRcrea"]="eGFR-creat (serum creatinine)"
             trans["veGFRcys"]="eGFR-cys (serum cystatin C)"
             trans["vTC"]="Total cholesterol"
             trans["v2hrG"]="Two-hour glucose"
             trans["v2hrI"]="Two-hour insulin"
             trans["vHOMAB"]="HOMA-B"
             trans["vHOMAIR"]="HOMA-IR"
             trans["vMA"]="Microalbuminuria"
             trans["vPI"]="Proinsulin levels"
             trans["vBIP"]="Bipolar disorder"
             trans["vMDD"]="Major depressive disorder"
             trans["vSCZ"]="Schizophrenia"
             trans["v13k"]= "13K exome sequence analysis"
             trans["v13k_aa_genes"]= "13K exome sequence analysis: African-Americans"
             trans["v13k_ea_genes"]= "13K exome sequence analysis: East Asians"
             trans["v13k_eu"]= "13K exome sequence analysis: Europeans"
             trans["v13k_eu_genes"]= "13K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["v13k_eu_go"]= "13K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["v13k_hs_genes"]= "13K exome sequence analysis: Latinos"
             trans["v13k_sa_genes"]= "13K exome sequence analysis: South Asians"
             trans["v17k"]= "17K exome sequence analysis"
             trans["v17k_aa"]= "17K exome sequence analysis: African-Americans"
             trans["v17k_aa_genes"]= "17K exome sequence analysis: African-Americans, T2D-GENES cohorts"
             trans["v17k_aa_genes_aj"]= "17K exome sequence analysis: African-Americans, Jackson Heart Study cohort"
             trans["v17k_aa_genes_aw"]= "17K exome sequence analysis: African-Americans, Wake Forest Study cohort"
             trans["v17k_ea_genes"]= "17K exome sequence analysis: East Asians"
             trans["v17k_ea_genes_ek"]= "17K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort"
             trans["v17k_ea_genes_es"]= "17K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort"
             trans["v17k_eu"]= "17K exome sequence analysis: Europeans"
             trans["v17k_eu_genes"]= "17K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["v17k_eu_genes_ua"]= "17K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort"
             trans["v17k_eu_genes_um"]= "17K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort"
             trans["v17k_eu_go"]= "17K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["v17k_hs"]= "17K exome sequence analysis: Latinos"
             trans["v17k_hs_genes"]= "17K exome sequence analysis: Latinos, T2D-GENES cohorts"
             trans["v17k_hs_genes_ha"]= "17K exome sequence analysis: Latinos, San Antonio cohort"
             trans["v17k_hs_genes_hs"]= "17K exome sequence analysis: Latinos, Starr County cohort"
             trans["v17k_hs_sigma"]= "17K exome sequence analysis: Latinos, SIGMA cohorts"
             trans["v17k_hs_sigma_mec"]= "17K exome sequence analysis: Multiethnic Cohort (MEC)"
             trans["v17k_hs_sigma_mexb1"]= "17K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort"
             trans["v17k_hs_sigma_mexb2"]= "17K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort"
             trans["v17k_hs_sigma_mexb3"]= "17K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort"
             trans["v17k_sa_genes"]= "17K exome sequence analysis: South Asians"
             trans["v17k_sa_genes_sl"]= "17K exome sequence analysis: South Asians, LOLIPOP cohort"
             trans["v17k_sa_genes_ss"]= "17K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort"
             trans["v26k"]= "26K exome sequence analysis"
             trans["v26k_aa"]= "26K exome sequence analysis: all African-Americans"
             trans["v26k_aa_esp"]= "26K exome sequence analysis: African-Americans, all ESP cohorts"
             trans["v26k_aa_genes"]= "26K exome sequence analysis: African-Americans, T2D-GENES cohorts"
             trans["v26k_aa_genes_aj"]= "26K exome sequence analysis: African-Americans, Jackson Heart Study cohort"
             trans["v26k_aa_genes_aw"]= "26K exome sequence analysis: African-Americans, Wake Forest Study cohort"
             trans["v26k_ea_genes"]= "26K exome sequence analysis: East Asians"
             trans["v26k_ea_genes_ek"]= "26K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort"
             trans["v26k_ea_genes_es"]= "26K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort"
             trans["v26k_eu"]= "26K exome sequence analysis: Europeans"
             trans["v26k_eu_esp"]= "26K exome sequence analysis: Europeans, all ESP cohorts"
             trans["v26k_eu_genes"]= "26K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["v26k_eu_genes_ua"]= "26K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort"
             trans["v26k_eu_genes_um"]= "26K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort"
             trans["v26k_eu_go"]= "26K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["v26k_eu_lucamp"]= "26K exome sequence analysis: Europeans, LuCamp cohort"
             trans["v26k_hs"]= "26K exome sequence analysis: Latinos"
             trans["v26k_hs_genes"]= "26K exome sequence analysis: Latinos, T2D-GENES cohorts"
             trans["v26k_hs_genes_ha"]= "26K exome sequence analysis: Latinos, San Antonio cohort"
             trans["v26k_hs_genes_hs"]= "26K exome sequence analysis: Latinos, Starr County cohort"
             trans["v26k_hs_sigma"]= "26K exome sequence analysis: Latinos, SIGMA cohorts"
             trans["v26k_hs_sigma_mec"]= "26K exome sequence analysis: Multiethnic Cohort (MEC)"
             trans["v26k_hs_sigma_mexb1"]= "26K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort"
             trans["v26k_hs_sigma_mexb2"]= "26K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort"
             trans["v26k_hs_sigma_mexb3"]= "26K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort"
             trans["v26k_sa_genes"]= "26K exome sequence analysis: South Asians"
             trans["v26k_sa_genes_sl"]= "26K exome sequence analysis: South Asians, LOLIPOP cohort"
             trans["v26k_sa_genes_ss"]= "26K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort"
             trans["v82k"]= "82K exome chip analysis"
             trans["vAfrican_American"]= "African-American"
             trans["vBETA"]= "Effect size (beta)"
             trans["vCARDIoGRAM"]= "CARDIoGRAM GWAS"
             trans["vCHROM"]= "Chromosome"
             trans["vCKDGenConsortium"]= "CKDGen GWAS"
             trans["vCLOSEST_GENE"]= "Nearest gene"
             trans["vCondel_PRED"]= "Condel prediction"
             trans["vConsequence"]= "Consequence"
             trans["vDBSNP_ID"]= "dbSNP ID"
             trans["vDIAGRAM"]= "DIAGRAM GWAS"
             trans["vGWAS_SIGMA1_mdv1"]= "GWAS SIGMA"
             trans["vGWAS_SIGMA1_mdv2"]= "GWAS SIGMA"
             trans["vGWAS_SIGMA1_mdv3"]= "GWAS SIGMA"
             trans["vDirection"]= "Direction of effect"
             trans["vEAC_PH"]= "Effect allele count"
             trans["vEAF"]= "Effect allele frequency"
             trans["vEast_Asian"]= "East Asian"
             trans["vEuropean"]= "European"
             trans["vExChip"]= "Exome chip"
             trans["vExChip_82k"]= "82k exome chip analysis"
             trans["vExChip_82k_mdv1"]= "82k exome chip analysis"
             trans["vExChip_82k_mdv2"]= "82k exome chip analysis"
             trans["vExSeq"]= "Exome sequencing"
             trans["vExSeq_13k"]= "13K exome sequence analysis"
             trans["vExSeq_13k_aa_genes_mdv1"]= "13K exome sequence analysis: African-Americans"
             trans["vExSeq_13k_aa_genes_mdv2"]= "13K exome sequence analysis: African-Americans"
             trans["vExSeq_13k_aa_genes_mdv3"]= "13K exome sequence analysis: African-Americans"
             trans["vExSeq_13k_ea_genes_mdv1"]= "13K exome sequence analysis: East Asians"
             trans["vExSeq_13k_ea_genes_mdv2"]= "13K exome sequence analysis: East Asians"
             trans["vExSeq_13k_ea_genes_mdv3"]= "13K exome sequence analysis: East Asians"
             trans["vExSeq_13k_eu_genes_mdv1"]= "13K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["vExSeq_13k_eu_go_mdv1"]= "13K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["vExSeq_13k_eu_mdv1"]= "13K exome sequence analysis: Europeans"
             trans["vExSeq_13k_eu_mdv2"]= "13K exome sequence analysis: Europeans"
             trans["vExSeq_13k_eu_mdv3"]= "13K exome sequence analysis: Europeans"
             trans["vExSeq_13k_hs_genes_mdv1"]= "13K exome sequence analysis: Latinos"
             trans["vExSeq_13k_hs_genes_mdv2"]= "13K exome sequence analysis: Latinos"
             trans["vExSeq_13k_hs_genes_mdv3"]= "13K exome sequence analysis: Latinos"
             trans["vExSeq_13k_mdv1"]= "13K exome sequence analysis"
             trans["vExSeq_13k_mdv2"]= "13K exome sequence analysis"
             trans["vExSeq_13k_mdv3"]= "13K exome sequence analysis"
             trans["vExSeq_13k_sa_genes_mdv1"]= "13K exome sequence analysis: South Asians"
             trans["vExSeq_13k_sa_genes_mdv2"]= "13K exome sequence analysis: South Asians"
             trans["vExSeq_13k_sa_genes_mdv3"]= "13K exome sequence analysis: South Asians"
             trans["vExSeq_17k"]= "17K exome sequence analysis"
             trans["vExSeq_17k_aa_genes_aj_mdv2"]= "17K exome sequence analysis: African-Americans, Jackson Heart Study cohort"
             trans["vExSeq_17k_aa_genes_aw_mdv2"]= "17K exome sequence analysis: African-Americans, Wake Forest Study cohort"
             trans["vExSeq_17k_aa_genes_mdv2"]= "17K exome sequence analysis: African-Americans, T2D-GENES cohorts"
             trans["vExSeq_17k_aa_mdv2"]= "17K exome sequence analysis: African-Americans"
             trans["vExSeq_17k_ea_genes_ek_mdv2"]= "17K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort"
             trans["vExSeq_17k_ea_genes_es_mdv2"]= "17K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort"
             trans["vExSeq_17k_ea_genes_mdv2"]= "17K exome sequence analysis: East Asians"
             trans["vExSeq_17k_eu_genes_mdv2"]= "17K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["vExSeq_17k_eu_genes_ua_mdv2"]= "17K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort"
             trans["vExSeq_17k_eu_genes_um_mdv2"]= "17K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort"
             trans["vExSeq_17k_eu_go_mdv2"]= "17K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["vExSeq_17k_eu_mdv2"]= "17K exome sequence analysis: Europeans"
             trans["vExSeq_17k_hs_genes_ha_mdv2"]= "17K exome sequence analysis: Latinos, San Antonio cohort"
             trans["vExSeq_17k_hs_genes_hs_mdv2"]= "17K exome sequence analysis: Latinos, Starr County cohort"
             trans["vExSeq_17k_hs_genes_mdv2"]= "17K exome sequence analysis: Latinos, T2D-GENES cohorts"
             trans["vExSeq_17k_hs_mdv2"]= "17K exome sequence analysis: Latinos"
             trans["vExSeq_17k_hs_sigma_mdv2"]= "17K exome sequence analysis: Latinos, SIGMA cohorts"
             trans["vExSeq_17k_hs_sigma_mec_mdv2"]= "17K exome sequence analysis: Multiethnic Cohort (MEC)"
             trans["vExSeq_17k_hs_sigma_mexb1_mdv2"]= "17K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort"
             trans["vExSeq_17k_hs_sigma_mexb2_mdv2"]= "17K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort"
             trans["vExSeq_17k_hs_sigma_mexb3_mdv2"]= "17K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort"
             trans["vExSeq_17k_mdv2"]= "17K exome sequence analysis"
             trans["vExSeq_17k_sa_genes_mdv2"]= "17K exome sequence analysis: South Asians"
             trans["vExSeq_17k_sa_genes_sl_mdv2"]= "17K exome sequence analysis: South Asians, LOLIPOP cohort"
             trans["vExSeq_17k_sa_genes_ss_mdv2"]= "17K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort"
             trans["vExSeq_26k_mdv3"]= "26K exome sequence analysis"
             trans["vExSeq_26k_aa_mdv3"]= "26K exome sequence analysis: all African-Americans"
             trans["vExSeq_26k_aa_esp_mdv3"]= "26K exome sequence analysis: African-Americans, all ESP cohorts"
             trans["vExSeq_26k_aa_genes_mdv3"]= "26K exome sequence analysis: African-Americans, T2D-GENES cohorts"
             trans["vExSeq_26k_aa_genes_aj_mdv3"]= "26K exome sequence analysis: African-Americans, Jackson Heart Study cohort"
             trans["vExSeq_26k_aa_genes_aw_mdv3"]= "26K exome sequence analysis: African-Americans, Wake Forest Study cohort"
             trans["vExSeq_26k_ea_genes_mdv3"]= "26K exome sequence analysis: East Asians"
             trans["vExSeq_26k_ea_genes_ek_mdv3"]= "26K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort"
             trans["vExSeq_26k_ea_genes_es_mdv3"]= "26K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort"
             trans["vExSeq_26k_eu_mdv3"]= "26K exome sequence analysis: Europeans"
             trans["vExSeq_26k_eu_esp_mdv3"]= "26K exome sequence analysis: Europeans, all ESP cohorts"
             trans["vExSeq_26k_eu_genes_mdv3"]= "26K exome sequence analysis: Europeans, T2D-GENES cohorts"
             trans["vExSeq_26k_eu_genes_ua_mdv3"]= "26K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort"
             trans["vExSeq_26k_eu_genes_um_mdv3"]= "26K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort"
             trans["vExSeq_26k_eu_go_mdv3"]= "26K exome sequence analysis: Europeans, GoT2D cohorts"
             trans["vExSeq_26k_eu_lucamp_mdv3"]= "26K exome sequence analysis: Europeans, LuCamp cohort"
             trans["vExSeq_26k_hs_mdv3"]= "26K exome sequence analysis: Latinos"
             trans["vExSeq_26k_hs_genes_mdv3"]= "26K exome sequence analysis: Latinos, T2D-GENES cohorts"
             trans["vExSeq_26k_hs_genes_ha_mdv3"]= "26K exome sequence analysis: Latinos, San Antonio cohort"
             trans["vExSeq_26k_hs_genes_hs_mdv3"]= "26K exome sequence analysis: Latinos, Starr County cohort"
             trans["vExSeq_26k_hs_sigma_mdv3"]= "26K exome sequence analysis: Latinos, SIGMA cohorts"
             trans["vExSeq_26k_hs_sigma_mec_mdv3"]= "26K exome sequence analysis: Multiethnic Cohort (MEC)"
             trans["vExSeq_26k_hs_sigma_mexb1_mdv3"]= "26K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort"
             trans["vExSeq_26k_hs_sigma_mexb2_mdv3"]= "26K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort"
             trans["vExSeq_26k_hs_sigma_mexb3_mdv3"]= "26K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort"
             trans["vExSeq_26k_sa_genes_mdv3"]= "26K exome sequence analysis: South Asians"
             trans["vExSeq_26k_sa_genes_sl_mdv3"]= "26K exome sequence analysis: South Asians, LOLIPOP cohort"
             trans["vExSeq_26k_sa_genes_ss_mdv3"]= "26K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort"
             trans["vExChip_SIGMA1_mdv1"]= "SIGMA exome chip analysis"
             trans["vExChip_SIGMA1_mdv2"]= "SIGMA exome chip analysis"
             trans["vExChip_SIGMA1_mdv3"]= "SIGMA exome chip analysis"
             trans["vFMISS_17k"]= "Missing genotype rate, 17K exome sequence analysis"
             trans["vFMISS_19k"]= "Missing genotype rate, 19K exome sequence analysis"
             trans["vF_MISS"]= "Missing genotype rate"
             trans["vGENE"]= "Gene"
             trans["vGENO_26k"]= "Call rate, 26K Exome sequencing analysis"
             trans["vGIANT"]= "GIANT GWAS"
             trans["vGLGC"]= "GLGC GWAS"
             trans["vGWAS"]= "GWAS"
             trans["vGWAS_CARDIoGRAM"]= "CARDIoGRAM GWAS"
             trans["vGWAS_CARDIoGRAM_mdv1"]= "CARDIoGRAM GWAS"
             trans["vGWAS_CARDIoGRAM_mdv2"]= "CARDIoGRAM GWAS"
             trans["vGWAS_CKDGenConsortium"]= "CKDGen GWAS"
             trans["vGWAS_CKDGenConsortium_mdv1"]= "CKDGen GWAS"
             trans["vGWAS_CKDGenConsortium_mdv2"]= "CKDGen GWAS"
             trans["vGWAS_DIAGRAM"]= "DIAGRAM GWAS"
             trans["vGWAS_DIAGRAM_mdv1"]= "DIAGRAM GWAS"
             trans["vGWAS_DIAGRAM_mdv2"]= "DIAGRAM GWAS"
             trans["vGWAS_GIANT"]= "GIANT GWAS"
             trans["vGWAS_GIANT_mdv1"]= "GIANT GWAS"
             trans["vGWAS_GIANT_mdv2"]= "GIANT GWAS"
             trans["vGWAS_GLGC"]= "GLGC GWAS"
             trans["vGWAS_GLGC_mdv1"]= "GLGC GWAS"
             trans["vGWAS_GLGC_mdv2"]= "GLGC GWAS"
             trans["vGWAS_MAGIC"]= "MAGIC GWAS"
             trans["vGWAS_MAGIC_mdv1"]= "MAGIC GWAS"
             trans["vGWAS_MAGIC_mdv2"]= "MAGIC GWAS"
             trans["vGWAS_PGC"]= "PGC GWAS"
             trans["vGWAS_PGC_mdv1"]= "PGC GWAS"
             trans["vGWAS_PGC_mdv2"]= "PGC GWAS"
             trans["vHETA"]= "Number of heterozygous cases"
             trans["vHETU"]= "Number of heterozygous controls"
             trans["vHOMA"]= "Number of homozygous cases"
             trans["vHOMU"]= "Number of homozygous controls"
             trans["vHispanic"]= "Latino"
             trans["vIN_EXSEQ"]= "In exome sequencing"
             trans["vIN_GENE"]= "Enclosing gene"
             trans["vLOG_P_HWE_MAX_ORIGIN"]= "Log(p-value), hardy-weinberg equilibrium"
             trans["vMAC"]= "Minor allele count"
             trans["vMAC_PH"]= "Minor allele count"
             trans["vMAF"]= "Minor allele frequency"
             trans["vMAGIC"]= "MAGIC GWAS"
             trans["vMINA"]= "Case minor allele counts"
             trans["vMINU"]= "Control minor allele counts"
             trans["vMOST_DEL_SCORE"]= "Deleteriousness category"
             trans["vMixed"]= "Mixed"
             trans["vNEFF"]= "Effective sample size"
             trans["vN_PH"]= "Sample size"
             trans["vOBSA"]= "Number of cases genotyped"
             trans["vOBSU"]= "Number of controls genotyped"
             trans["vODDS_RATIO"]= "Odds ratio"
             trans["vOR_FIRTH"]= "Odds ratio"
             trans["vOR_FIRTH_FE_IV"]= "Odds ratio"
             trans["vOR_FISH"]= "Odds ratio"
             trans["vOR_WALD"]= "Odds ratio"
             trans["vOR_WALD_DOS"]= "Odds ratio"
             trans["vOR_WALD_DOS_FE_IV"]= "Odds ratio"
             trans["vOR_WALD_FE_IV"]= "Odds ratio"
             trans["vPGC"]= "PGC GWAS"
             trans["vPOS"]= "Position"
             trans["vP_EMMAX"]= "P-value"
             trans["vP_EMMAX_FE_IV"]= "P-value"
             trans["vP_FIRTH"]= "P-value"
             trans["vP_FIRTH_FE_IV"]= "P-value"
             trans["vP_FIRTH_FE_IV_AW"]= "P-value"
             trans["vP_FE_INV"]= "P-value"
             trans["vP_VALUE"]= "P-value"
             trans["vPolyPhen_PRED"]= "PolyPhen prediction"
             trans["vProtein_change"]= "Protein change"
             trans["vQCFAIL"]= "Failed quality control"
             trans["vSE"]= "Std. Error"
             trans["vSIFT_PRED"]= "SIFT prediction"
             trans["vSouth_Asian"]= "South association"
             trans["vTRANSCRIPT_ANNOT"]= "Annotations across transcripts"
             trans["vVAR_ID"]= "Variant ID"
             trans["vmdv1"]= "Version 1"
             trans["vmdv2"]= "Version 2"
             trans["vmdv3"]= "Version 3"
         }
        if (trans.containsKey("v${stringToTranslate}".toString())){
            return trans ["v${stringToTranslate}".toString()]
        } else {
            return stringToTranslate
        }
    }

}







}
