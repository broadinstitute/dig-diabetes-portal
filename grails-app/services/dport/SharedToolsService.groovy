package dport

import dport.people.Role
import dport.people.User
import dport.people.UserRole
import dport.people.UserSession
import grails.plugin.mail.MailService
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import groovy.json.StringEscapeUtils
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.mapping.LinkGenerator


@Transactional
class SharedToolsService {

     MailService mailService
    GrailsApplication grailsApplication
    LinkGenerator grailsLinkGenerator
    RestServerService restServerService
    FilterManagementService filterManagementService
     private static final log = LogFactory.getLog(this)
    JSONObject sharedMetadata = null
    LinkedHashMap sharedProcessedMetadata = null
    Integer forceProcessedMetadataOverride = -1
    Integer forceMetadataOverride = -1
    Integer showGwas = -1
    Integer showExomeChip = -1
    Integer showExomeSequence = -1
    Integer showSigma = -1
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

    Integer helpTextSetting = 1 // 0== never display, 1== display conditionally, 2== always display

    public String retrieveCurrentGeneChromosome ()  {
        return  currentGeneChromosome
    }
    public String retrieveCurrentVariantChromosome ()  {
        return  currentVariantChromosome
    }


    public Integer getRecognizedStringsOnly() {
        return recognizedStringsOnly
    }

    public void setRecognizedStringsOnly(Integer recognizedStringsOnly) {
        this.recognizedStringsOnly = recognizedStringsOnly
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
        showSigma = (grailsApplication.config.portal.sections.show_sigma)?1:0
        showGene = (grailsApplication.config.portal.sections.show_gene)?1:0
        showBeacon = (grailsApplication.config.portal.sections.show_beacon)?1:0
        showNewApi = 1
        retrieveMetadata()  // may as well get this early.  The value is stored in
    }

    public enum TypeOfSection {
        show_gwas, show_exchp, show_exseq, show_sigma,show_gene, show_beacon
    }


    public Boolean getSectionToDisplay( typeOfSection) {
        showGwas = (showGwas==-1)?grailsApplication.config.portal.sections.show_gwas:showGwas
        showExomeChip = (showExomeChip==-1)?grailsApplication.config.portal.sections.show_exchp:showExomeChip
        showExomeSequence = (showExomeSequence==-1)?grailsApplication.config.portal.sections.show_exseq:showExomeSequence
        showSigma = (showSigma==-1)?grailsApplication.config.portal.sections.show_sigma:showSigma
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
            case TypeOfSection.show_sigma:
                returnValue = showSigma
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



    public Boolean setApplicationToSigma() {
        showGwas = 1
        showExomeChip = 0
        showExomeSequence = 0
        showSigma = 1
        showBeacon = 0
    }

    public Boolean getApplicationIsSigma() {
        return ((showSigma) &&
                (!showBeacon) &&
                (showGwas || showExomeChip  || showExomeSequence))
    }

    public Boolean setApplicationToT2dgenes() {
        showGwas = 1
        showExomeChip = 1
        showExomeSequence = 1
        showSigma = 0
        showBeacon = 0
    }


    public Boolean getApplicationIsT2dgenes() {
        return ((!showSigma) &&
                (!showBeacon) &&
                (showGwas || showExomeChip  || showExomeSequence))
    }


    public Boolean setApplicationToBeacon() {
        showGwas = 0
        showExomeChip = 0
        showExomeSequence = 0
        showSigma = 0
        showBeacon = 1
    }

    public Boolean getApplicationIsBeacon() {
        return ((showBeacon)   &&
                (!showSigma) )
    }

    public Boolean getNewApi() { // TODO wipe out
        return true
    }

    public Boolean getMetadataOverrideStatus() {
        return (forceMetadataOverride==1)
    }


    public void setMetadataOverrideStatus(int metadataOverride) {
        this.forceMetadataOverride=metadataOverride
    }


    public String  applicationName () {
        String returnValue = ""
        if (getApplicationIsT2dgenes())   {
            returnValue = "t2dGenes"
        }  else  if (getApplicationIsSigma())   {
            returnValue = "Sigma"
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

    /***
     * walk through the metadata tree and pull out things we need
     * @param metadata
     * @return
     */
    public LinkedHashMap processMetadata(JSONObject metadata) {
        if ((!sharedProcessedMetadata) ||
                (sharedProcessedMetadata.size() == 0) ||
                (forceProcessedMetadataOverride == 1)) {
            sharedProcessedMetadata = [:]
            List<String> captured = []
            LinkedHashMap<String, List <LinkedHashMap>>  gwasSpecificPhenotype = [:]
            LinkedHashMap<String, List<String>> annotatedPhenotypes = [:]
            LinkedHashMap<PhenoKey, List<PhenoKey>> temporaryAnnotatedPhenotypes = [:]
            LinkedHashMap<String, List<String>> annotatedSampleGroups = [:]
            LinkedHashMap<PhenoKey, List<String>> annotatedOrderedSampleGroups = [:]
            LinkedHashMap<String, LinkedHashMap<String, List<String>>> phenotypeSpecificSampleGroupProperties = [:]
            LinkedHashMap<String, LinkedHashMap<PhenoKey, List<String>>> phenotypeSpecificAnnotatedSampleGroupProperties = [:]
            LinkedHashMap<String, LinkedHashMap<String, List<String>>> experimentSpecificSampleGroupProperties = [:]
            LinkedHashMap<String, LinkedHashMap<String, String>> commonProperties = [:]
            String dataSetVersionThatWeWant = "${dataSetPrefix}${getDataVersion()}"
            if (metadata) {
                for (def experiment in metadata.experiments) {
                    captured << experiment.name
                    String dataSetVersion = experiment.version
                    if ((experiment.sample_groups) && (dataSetVersionThatWeWant == dataSetVersion)) {
                        getDataSetsPerPhenotype(experiment.sample_groups, annotatedPhenotypes)
                        getDataSetsPerAnnotatedPhenotype(experiment.sample_groups, temporaryAnnotatedPhenotypes,1)
                        getPropertiesPerSampleGroupId(experiment.sample_groups, annotatedSampleGroups)
                        getPropertiesPerAnnotatedSampleGroupId(experiment.sample_groups, annotatedOrderedSampleGroups)
                        getPhenotypeSpecificPropertiesPerSampleGroupId(experiment.sample_groups, phenotypeSpecificSampleGroupProperties)
                        getPhenotypeSpecificAnnotatedPropertiesPerSampleGroupId(experiment.sample_groups, phenotypeSpecificAnnotatedSampleGroupProperties)
                        if (experiment.technology == "GWAS"){
                            getTechnologySpecificPhenotype(experiment.sample_groups,gwasSpecificPhenotype)
                            getTechnologySpecificExperiment(experiment.sample_groups,experimentSpecificSampleGroupProperties)
                        }
                    }
                }
                for (def cProperty in metadata.properties) {
                    if (!commonProperties.containsKey(cProperty.name)){
                        if (cProperty.searchable){
                            LinkedHashMap cPropertyStuff = [:]
                            cPropertyStuff["type"] = cProperty.type
                            cPropertyStuff["sort_order"] = cProperty.sort_order
                            commonProperties [cProperty.name] = cPropertyStuff
                        }
                    }
                }
            }
            sharedProcessedMetadata['rootSampleGroups'] = captured
            sharedProcessedMetadata['gwasSpecificPhenotypes'] = gwasSpecificPhenotype
            sharedProcessedMetadata['sampleGroupsPerPhenotype'] = annotatedPhenotypes
            sharedProcessedMetadata['sampleGroupsPerAnnotatedPhenotype'] =  temporaryAnnotatedPhenotypes
            sharedProcessedMetadata['propertiesPerSampleGroups'] = annotatedSampleGroups
            sharedProcessedMetadata['propertiesPerOrderedSampleGroups'] = annotatedOrderedSampleGroups
            sharedProcessedMetadata['phenotypeSpecificPropertiesPerSampleGroup'] = phenotypeSpecificSampleGroupProperties
            sharedProcessedMetadata['phenotypeSpecificPropertiesAnnotatedPerSampleGroup'] = phenotypeSpecificAnnotatedSampleGroupProperties
            sharedProcessedMetadata['sampleGroupSpecificProperties'] = experimentSpecificSampleGroupProperties
            sharedProcessedMetadata['commonProperties'] = commonProperties
            forceProcessedMetadataOverride = 0
        }
        return sharedProcessedMetadata
    }


    public LinkedHashMap getProcessedMetadata(){
        JSONObject jsonObject = retrieveMetadata()
        return processMetadata(jsonObject)
    }

    /***
     * Start with a pointer to a sample group as we descend through the metadata tree.  Pullback a combined list
     * of every sample group ID grouped by phenotype.
     *
     * @param sampleGroups
     * @param annotatedPhenotypes
     * @return
     */
    public LinkedHashMap<String, List <String>> getDataSetsPerPhenotype (def sampleGroups,LinkedHashMap<String, List <String>> annotatedPhenotypes){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
             if (sampleGroup.phenotypes){
                 for (def phenotype in sampleGroup.phenotypes){
                     String phenotypeName = phenotype.name
                     List <String> listOfSampleGroups
                     if (annotatedPhenotypes.containsKey(phenotypeName)){
                         listOfSampleGroups = annotatedPhenotypes[phenotypeName]
                     } else {
                         listOfSampleGroups = new ArrayList<String>()
                         annotatedPhenotypes[phenotypeName]  =  listOfSampleGroups
                     }
                     // we have the list for this phenotype.  Add some more sample groups for it
                     if (listOfSampleGroups.contains(sampleGroupsId)){
                         // this should never happen, right? We have a second listing for this ID in this phenotype
                        // println "very strange : phenotype ${phenotypeName} already contained sample ID= ${sampleGroupsId}"
                     } else {
                         listOfSampleGroups << sampleGroupsId
                     }

                     if (sampleGroup.sample_groups){
                         getDataSetsPerPhenotype (sampleGroup.sample_groups, annotatedPhenotypes)
                     }

                     }

             }
        }
        return annotatedPhenotypes
    }



// make key LinkedHashMap, with (name:string,sort_order:int,depth:int)
    public LinkedHashMap<PhenoKey, List <PhenoKey>> getDataSetsPerAnnotatedPhenotype (def sampleGroups,LinkedHashMap<PhenoKey, List <PhenoKey>> annotatedPhenotypes, int currentDepth){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
            int sampleGroupsSortOrder = sampleGroup.sort_order
            if (sampleGroup.phenotypes){
                for (def phenotype in sampleGroup.phenotypes){
                    String phenotypeName = phenotype.name
                    int sortOrder = phenotype.sort_order
                    int depth = currentDepth
                    PhenoKey phenoKey = new PhenoKey(phenotypeName,sortOrder, depth)

                    List <PhenoKey> listOfSampleGroups
                    if (annotatedPhenotypes.containsKey((phenoKey))){
                        listOfSampleGroups = annotatedPhenotypes[(phenoKey)]
                    } else {
                        listOfSampleGroups = new ArrayList<PhenoKey>()
                        annotatedPhenotypes[(phenoKey)]  =  listOfSampleGroups
                    }

                    PhenoKey sampleGroupHolder = new PhenoKey(sampleGroupsId,sampleGroupsSortOrder, depth )
                    // we have the list for this phenotype.  Add some more sample groups for it
                    if (listOfSampleGroups.contains(sampleGroupHolder)){
                        // this should never happen, right? We have a second listing for this ID in this phenotype
                        // println "very strange : phenotype ${phenotypeName} already contained sample ID= ${sampleGroupsId}"
                    } else {
                        listOfSampleGroups <<  sampleGroupHolder
                    }

                    if (sampleGroup.sample_groups){
                        getDataSetsPerAnnotatedPhenotype (sampleGroup.sample_groups, annotatedPhenotypes,currentDepth+1)
                    }

                }

            }
        }
        return annotatedPhenotypes
    }






    /***
     *  Need a map where phenotypes point to data sets.  This will allow me to ask people what phenotype they want,
     *  and upon response = that phenotype to the data set we need
     *
     * @param sampleGroups
     * @param phenotypeMap
     * @return
     */
    public LinkedHashMap<String, List <LinkedHashMap>> getTechnologySpecificPhenotype (def sampleGroups, LinkedHashMap<String, List<String>> phenotypeMap){
        for (def sampleGroup in sampleGroups){
            if (sampleGroup.phenotypes){
                String sampleGroupName = sampleGroup.name
                String sampleGroupId = sampleGroup.id
                for (def phenotype in sampleGroup.phenotypes){
                    String phenotypeName = phenotype.name
                    String phenotypeGroup = phenotype.group
                    String phenotypeSortOrder = phenotype.sort_order
                    if (!phenotypeMap.containsKey (phenotypeName)){
                        phenotypeMap[phenotypeName] = [sampleGroupId:sampleGroupId,sampleGroupName:sampleGroupName]

                        // Build up a list of phenotype properties that we can store in one map
                        if (phenotype.properties) {
                            LinkedHashMap properties = [:]
                            for (def property in phenotype.properties){
                                String propertyName = property.name
                                String propertyType = property.type
                                if (!properties.containsKey(propertyName)){
                                    properties[propertyName] = propertyType
                                }
                            }
                            (phenotypeMap[phenotypeName])["properties"] = properties
                        }

                        // we want to store some properties that are specific to each phenotype. Let's create
                        // a special-purpose key called 'phenotypeProperties' which sits adjacent to all of the sample group names
                        // Inside we can have a map that holds these special-purpose properties
                        LinkedHashMap <String,String> phenotypeSpecificFields
                        if ((phenotypeMap[phenotypeName]).containsKey("phenotypeProperties")){
                            phenotypeSpecificFields = (phenotypeMap[phenotypeName])["phenotypeProperties"]
                        } else {
                            phenotypeSpecificFields = new LinkedHashMap <String,String> ()
                            (phenotypeMap[phenotypeName])["phenotypeProperties"] = phenotypeSpecificFields
                        }
                        // and let's fill this structure.  We should only have to do it once
                        if (phenotypeSpecificFields.size()==0){
                            phenotypeSpecificFields ["group"] = phenotypeGroup
                            phenotypeSpecificFields ["sort_order"] = phenotypeSortOrder
                        }


                    }
                    if (sampleGroup.sample_groups){
                        getTechnologySpecificPhenotype (sampleGroup.sample_groups,phenotypeMap)
                    }

                }

            }
        }
        return phenotypeMap
    }



    /***
     *  Need a map where phenotypes point to data sets.  This will allow me to ask people what phenotype they want,
     *  and upon response = that phenotype to the data set we need
     *
     * @param sampleGroups
     * @param phenotypeMap
     * @return
     */
    public LinkedHashMap<String, List <LinkedHashMap>> getTechnologySpecificExperiment (def sampleGroups, LinkedHashMap<String, List<String>> sampleGroupHolder){
        for (def sampleGroup in sampleGroups){
            String sampleGroupId = sampleGroup.id
            String sampleGroupName = sampleGroup.name
            LinkedHashMap sampleGroupMap = [sampleGroupId:sampleGroupId]
            if (sampleGroup.properties){
                for (def property in sampleGroup.properties){
                    String propertyName = property.name
                    String propertyType = property.type
                    if (!sampleGroupMap.containsKey(propertyName)){
                        sampleGroupMap[propertyName] = propertyType
                    }
                     if (sampleGroup.sample_groups){
                         getTechnologySpecificExperiment (sampleGroup.sample_groups,sampleGroupHolder)
                    }
                }
                if (sampleGroup.phenotypes){
                    sampleGroupMap["phenotypeList"] = []
                    for (def phenotype in sampleGroup.phenotypes){
                        sampleGroupMap["phenotypeList"] << phenotype.name
                    }
                }
            }
            if (!sampleGroupHolder.containsKey(sampleGroupName)){
                sampleGroupHolder[sampleGroupName] = sampleGroupMap
            }
        }
        return sampleGroupHolder
    }




    /***
     * We have a data structure indexed by phenotype where values correspond to maps. These maps at a minimum contain
     * a pointer to a sample group ID (key = sampleGroupId), but they may also contain an arbitrary number of other key value
     * pairs, where the key is the name of the property and the value is the property type. This structure should allow me to
     * ask questions such as "does this phenotype have a beta property? If so then tell me the sample ID.  Note that this
     * approach depends on the uniqueness of the phenotype/property combination, which is true only within a
     * specific version/technology combination.
     *
     * @param phenotype
     * @param property
     * @param holder
     * @return
     */
    public LinkedHashMap<String, String> pullBackSampleGroup (String phenotype,String property,LinkedHashMap<String, List<String>> holder)  {
        LinkedHashMap<String, String>  returnValue = [phenotypeFound: false]
        if (holder.containsKey (phenotype)){
            LinkedHashMap phenotypeSpecificHolder = holder [phenotype]
            returnValue ["phenotypeFound"] = true
            returnValue ["propertyFound"] = false
            returnValue ["sampleGroupId"] = phenotypeSpecificHolder.sampleGroupId
            if ((phenotypeSpecificHolder)&&(phenotypeSpecificHolder.size()>0)){
                LinkedHashMap phenotypeSpecificProperties = phenotypeSpecificHolder.properties
                if (phenotypeSpecificProperties.containsKey(property))  {
                    returnValue ["propertyFound"] = true
                    returnValue ["propertyType"] =  phenotypeSpecificProperties [property]
                }

            }
        }
        return returnValue
    }







    public LinkedHashMap<String, List <String>> getPropertiesPerSampleGroupId (def sampleGroups,LinkedHashMap<String, List <String>> annotatedSampleGroupIds){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
            List <String> propertiesForTheSampleGroup
            if (annotatedSampleGroupIds.containsKey(sampleGroupsId)){
                propertiesForTheSampleGroup = annotatedSampleGroupIds
            } else {
                propertiesForTheSampleGroup = new ArrayList<String>()
                annotatedSampleGroupIds [sampleGroupsId] = propertiesForTheSampleGroup
            }

            // we have a sample group with an associated list to fill. First let's put in all the properties
            if (sampleGroup.properties){
                for (def property in sampleGroup.properties){
                    if (property.searchable == "TRUE"){
                        String propertyName = property.name
                        propertiesForTheSampleGroup << propertyName
                    }
                }

            }

            // Finally, does this sample group have a sample group? If so then recursively descend
            if (sampleGroup.sample_groups){
                getPropertiesPerSampleGroupId (sampleGroup.sample_groups, annotatedSampleGroupIds)
            }

        }
        return annotatedSampleGroupIds
    }






    public LinkedHashMap<String, List <String>> getPropertiesPerAnnotatedSampleGroupId (def sampleGroups,LinkedHashMap<PhenoKey, List <String>> annotatedSampleGroupIds){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
            int  sortOrder = sampleGroup.sort_order
            List <String> propertiesForTheSampleGroup
            PhenoKey phenoKey = new PhenoKey(sampleGroupsId,sortOrder,1)
            if (annotatedSampleGroupIds.containsKey(phenoKey)){
                propertiesForTheSampleGroup = annotatedSampleGroupIds
            } else {
                propertiesForTheSampleGroup = new ArrayList<String>()
                annotatedSampleGroupIds [phenoKey] = propertiesForTheSampleGroup
            }

            // we have a sample group with an associated list to fill. First let's put in all the properties
            if (sampleGroup.properties){
                for (def property in sampleGroup.properties){
                    if (property.searchable == "TRUE"){
                        String propertyName = property.name
                        propertiesForTheSampleGroup << propertyName
                    }
                }

            }

            // Finally, does this sample group have a sample group? If so then recursively descend
            if (sampleGroup.sample_groups){
                getPropertiesPerAnnotatedSampleGroupId (sampleGroup.sample_groups, annotatedSampleGroupIds)
            }

        }
        return annotatedSampleGroupIds
    }







    public LinkedHashMap<String, List <String>> getPhenotypeSpecificPropertiesPerSampleGroupId (def sampleGroups,LinkedHashMap<String, LinkedHashMap <String,String>> annotatedPhenotypeSpecificSampleGroupIds){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
            if (sampleGroup.phenotypes){
                for (def phenotype in sampleGroup.phenotypes){
                    String phenotypeName = phenotype.name
                    String phenotypeGroup = phenotype.group
                    String phenotypeSortOrder = phenotype.sort_order
                    LinkedHashMap<String,String> hashOfPhenotypeSpecificSampleGroups
                    if (annotatedPhenotypeSpecificSampleGroupIds.containsKey(phenotypeName)){
                        hashOfPhenotypeSpecificSampleGroups = annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]
                    } else {
                        hashOfPhenotypeSpecificSampleGroups = new LinkedHashMap()
                        annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]  =  hashOfPhenotypeSpecificSampleGroups
                    }

                    // we want to store some properties that are specific to each phenotype. Let's create
                    // a special-purpose key called 'phenotypeProperties' which sits adjacent to all of the sample group names
                    // Inside we can have a map that holds these special-purpose properties
                    LinkedHashMap <String,String> phenotypeSpecificProperties
                    if (hashOfPhenotypeSpecificSampleGroups.containsKey("phenotypeProperties")){
                        phenotypeSpecificProperties = hashOfPhenotypeSpecificSampleGroups["phenotypeProperties"]
                    } else {
                        phenotypeSpecificProperties = new LinkedHashMap <String,String> ()
                        hashOfPhenotypeSpecificSampleGroups["phenotypeProperties"] = phenotypeSpecificProperties
                    }
                    // and let's fill this structure.  We should only have to do it once
                    if (phenotypeSpecificProperties.size()==0){
                        phenotypeSpecificProperties ["group"] = phenotypeGroup
                        phenotypeSpecificProperties ["sort_order"] = phenotypeSortOrder
                    }


                    // we have the list for this phenotype.  Add some more sample groups for it, along with
                    //  a place to put data set specific properties for each data set
                    List <String> propertyList
                    if (hashOfPhenotypeSpecificSampleGroups.containsKey(sampleGroupsId)){
                        propertyList = hashOfPhenotypeSpecificSampleGroups[sampleGroupsId]
                    } else {
                        propertyList = new ArrayList<String>()
                        hashOfPhenotypeSpecificSampleGroups[sampleGroupsId] = propertyList
                    }

                    // now let's store up the properties specific to this sample group & phenotype combination
                    def phenotypeProperties = phenotype.properties
                    if (phenotypeProperties){
                        for (def property in phenotypeProperties){
                            String propertyName = property.name
                            if (propertyList.contains(propertyName)){
                               // println "That is a little odd. Sample group=${sampleGroupsId} in phenotype=${phenotypeName} already had property=${propertyName}"
                            }else {
                                if (property.searchable == "TRUE") {
                                    propertyList << propertyName
                                }
                            }
                        }
                    }

                    // we can descend further if there are sample groups within the sample group
                    if (sampleGroup.sample_groups){
                        getPhenotypeSpecificPropertiesPerSampleGroupId (sampleGroup.sample_groups, annotatedPhenotypeSpecificSampleGroupIds)
                    }
                }

            }
        }
        return annotatedPhenotypeSpecificSampleGroupIds
    }
















    public LinkedHashMap<String, List <String>> getPhenotypeSpecificAnnotatedPropertiesPerSampleGroupId (def sampleGroups,LinkedHashMap<PhenoKey, LinkedHashMap <String,String>> annotatedPhenotypeSpecificSampleGroupIds){
        for (def sampleGroup in sampleGroups){
            String sampleGroupsId = sampleGroup.id
            int sampleGroupSortOrder = sampleGroup?.sort_order
            if (sampleGroup.phenotypes){
                for (def phenotype in sampleGroup.phenotypes){
                    String phenotypeName = phenotype.name
                    String phenotypeGroup = phenotype.group
                    String phenotypeSortOrder = phenotype.sort_order
                    LinkedHashMap<String,String> hashOfPhenotypeSpecificSampleGroups
                    if (annotatedPhenotypeSpecificSampleGroupIds.containsKey(phenotypeName)){
                        hashOfPhenotypeSpecificSampleGroups = annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]
                    } else {
                        hashOfPhenotypeSpecificSampleGroups = new LinkedHashMap()
                        annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]  =  hashOfPhenotypeSpecificSampleGroups
                    }

                    // we want to store some properties that are specific to each phenotype. Let's create
                    // a special-purpose key called 'phenotypeProperties' which sits adjacent to all of the sample group names
                    // Inside we can have a map that holds these special-purpose properties
                    LinkedHashMap <String,String> phenotypeSpecificProperties
                    PhenoKey sampleGroupPhenoKeyForProperties = new PhenoKey("phenotypeProperties", 99, 0)
                    if (hashOfPhenotypeSpecificSampleGroups.containsKey(sampleGroupPhenoKeyForProperties)){
                        phenotypeSpecificProperties = hashOfPhenotypeSpecificSampleGroups[(sampleGroupPhenoKeyForProperties)]
                    } else {
                        phenotypeSpecificProperties = new LinkedHashMap <String,String> ()
                        hashOfPhenotypeSpecificSampleGroups[(sampleGroupPhenoKeyForProperties)] = phenotypeSpecificProperties
                    }
                    // and let's fill this structure.  We should only have to do it once
                    if (phenotypeSpecificProperties.size()==0){
                        phenotypeSpecificProperties ["group"] = phenotypeGroup
                        phenotypeSpecificProperties ["sort_order"] = phenotypeSortOrder
                    }


                    // we have the list for this phenotype.  Add some more sample groups for it, along with
                    //  a place to put data set specific properties for each data set
                    List <String> propertyList
                    PhenoKey sampleGroupPhenoKey = new PhenoKey(sampleGroupsId, sampleGroupSortOrder, 0)
                    if (hashOfPhenotypeSpecificSampleGroups.containsKey(sampleGroupPhenoKey)){
                        propertyList = hashOfPhenotypeSpecificSampleGroups[(sampleGroupPhenoKey)]
                    } else {
                        propertyList = new ArrayList<String>()
                        hashOfPhenotypeSpecificSampleGroups[sampleGroupPhenoKey] = propertyList
                    }

                    // now let's store up the properties specific to this sample group & phenotype combination
                    def phenotypeProperties = phenotype.properties
                    if (phenotypeProperties){
                        for (def property in phenotypeProperties){
                            String propertyName = property.name
                            if (propertyList.contains(propertyName)){
                                // println "That is a little odd. Sample group=${sampleGroupsId} in phenotype=${phenotypeName} already had property=${propertyName}"
                            }else {
                                if (property.searchable == "TRUE") {
                                    propertyList << propertyName
                                }
                            }
                        }
                    }

                    // we can descend further if there are sample groups within the sample group
                    if (sampleGroup.sample_groups){
                        getPhenotypeSpecificPropertiesPerSampleGroupId (sampleGroup.sample_groups, annotatedPhenotypeSpecificSampleGroupIds)
                    }
                }

            }
        }
        return annotatedPhenotypeSpecificSampleGroupIds
    }


































    /***
     * Subset the metadata to only columns we want to display
     * @param processedMetadata The output of processMetadata
     * @param phenotypesToKeep The phenotypes to keep 
     * @param sampleGroupsToKeep The sample groups to keep 
     * @param propertiesToKeep The properties to keep 
     * @return
     */
    public LinkedHashMap getColumnsToDisplayStructure(LinkedHashMap processedMetadata, List <String> phenotypesToKeep=null,
                                                      List <String> sampleGroupsToKeep=null, List <String> propertiesToKeep=null,
                                                      List <String> commonProperties=null  ){

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

        if (processedMetadata) {
            if (phenotypesToKeep == null) {

                phenotypesToKeep = processedMetadata.sampleGroupsPerPhenotype.keySet()
            } else
            {
                phenotypesToKeep = phenotypesToKeep.findAll({processedMetadata.sampleGroupsPerPhenotype.containsKey(it)})
            }

            for (String phenotype in phenotypesToKeep) {
                returnValue.pproperty[phenotype] = [:]
                returnValue.dproperty[phenotype] = [:]
                List<String> curSampleGroups = []
                if (sampleGroupsToKeep == null) {
                    curSampleGroups.addAll(processedMetadata.sampleGroupsPerPhenotype[phenotype])
                } else {
                    curSampleGroups.addAll(sampleGroupsToKeep.findAll({processedMetadata.sampleGroupsPerPhenotype[phenotype].contains(it)}))
                }
                for (String sampleGroup in curSampleGroups) {
                    returnValue.dproperty[phenotype][sampleGroup] = []
                    returnValue.pproperty[phenotype][sampleGroup] = []
                    if (propertiesToKeep == null) {
                        returnValue.dproperty[phenotype][sampleGroup].addAll(processedMetadata.propertiesPerSampleGroups[sampleGroup])
                        if (processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[phenotype]) {
                            returnValue.pproperty[phenotype][sampleGroup].addAll(processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[phenotype][sampleGroup])
                        }
                    } else {
                        returnValue.dproperty[phenotype][sampleGroup].addAll(propertiesToKeep.findAll({processedMetadata.propertiesPerSampleGroups[sampleGroup].contains(it)}))
                        if (processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[phenotype]) {
                            returnValue.pproperty[phenotype][sampleGroup].addAll(propertiesToKeep.findAll({processedMetadata.phenotypeSpecificPropertiesPerSampleGroup[phenotype][sampleGroup].contains(it)}))
                        }
                    }
                }
            }
        }
        return returnValue
    }


    public List <String> extractAPhenotypeList (LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties){
        List <String> listOfProperties = []
        if (phenotypeSpecificSampleGroupProperties){
            phenotypeSpecificSampleGroupProperties.each{ k, v -> listOfProperties <<  "${k}".toString() }
            listOfProperties = listOfProperties.sort ()
        }
        int locationOfDiabetes = listOfProperties.indexOf("T2D")
        if (locationOfDiabetes>-1){
            listOfProperties.remove(locationOfDiabetes)
            listOfProperties.add(0,"T2D")
        }
        return listOfProperties
    }


    public LinkedHashMap <String,List<String>> extractAPhenotypeListofGroups (LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties){
        List <String> uniqueGroups = []
        LinkedHashMap <String,LinkedHashMap> listOfPhenotypesWithGroups = [:]
        LinkedHashMap <String,LinkedHashMap> intermediateStructure = [:]
        LinkedHashMap <String,List<String>> returnValue = [:]

        if (phenotypeSpecificSampleGroupProperties){
            // first collapse the data structure a little, make sure that we have group and sort order numbers for everything,
            // and generate a distinct list of groups
            phenotypeSpecificSampleGroupProperties.each { String k, LinkedHashMap v ->
                String groupName
                int sortOrder
                if (v.containsKey("phenotypeProperties")) {
                    LinkedHashMap<String> phenotypeSpecificProperties = v["phenotypeProperties"]
                    if (phenotypeSpecificProperties.containsKey("group")) {
                        groupName = phenotypeSpecificProperties["group"]
                    } else {
                        groupName = "default"
                    }
                    if (phenotypeSpecificProperties.containsKey("sort_order")) {
                        sortOrder = phenotypeSpecificProperties["sort_order"] as int
                    } else {
                        sortOrder = 1
                    }
                } else {
                    log.error("big trouble -- we found no phenotype properties in ${k}")
                }
                listOfPhenotypesWithGroups["${k}"] = [group: groupName, sortOrder: sortOrder]
                if (!uniqueGroups.contains(groupName)){
                    uniqueGroups <<  groupName
                }
            }

            // now walk through our intermediate data structure and group phenotypes together
            listOfPhenotypesWithGroups.each { String phenotypeName, LinkedHashMap v ->
                String groupName = v["group"]
                int sortOrder = v["sortOrder"]
                LinkedHashMap groupedPhenotypes
                if (intermediateStructure.containsKey(groupName)){
                    groupedPhenotypes = intermediateStructure[groupName]
                } else {
                    groupedPhenotypes = [:]
                    intermediateStructure[groupName] = groupedPhenotypes
                }
                if (!groupedPhenotypes.containsKey(phenotypeName)){
                    groupedPhenotypes[phenotypeName] = sortOrder
                }
            }

            // finally walk through the intermediate structure and sort within each group, assigning
            // the results to our return value
            intermediateStructure.each { String groupName, LinkedHashMap v ->
                LinkedHashMap sortedList = v.sort { a, b -> a.value <=> b.value }
                List sortedSubgroup = []
                sortedList.each { k, val -> sortedSubgroup << k }
                returnValue[groupName] = sortedSubgroup
            }
        }

        return returnValue
    }



    /***
     * Start with a list of lists and manufactures some legal JSON.  Extract a single linear list of every experiment name
     * @param phenotype
     * @param annotatedList
     * @return
     */
    public List <PhenoKey> extractASingleList (String phenotype, LinkedHashMap<PhenoKey, List <String>> annotatedList){
        LinkedHashMap<PhenoKey, List <String>> sortedAnnotatedList = annotatedList.sort{ it.key.sort_order }
        List <PhenoKey> listOfProperties = []
        if (annotatedList){
            PhenoKey phenoKey = new PhenoKey(phenotype,0,0)
            if (annotatedList.containsKey(phenoKey)){
                List <PhenoKey> listForThisPhenotype =  annotatedList [(phenoKey)]
                if (listForThisPhenotype) {
                    List <PhenoKey> sortedListForThisPhenotype = listForThisPhenotype.sort{ it.sort_order }
                    for ( int  i = 0 ; i < sortedListForThisPhenotype.size() ; i++ ){
                        listOfProperties << sortedListForThisPhenotype[i]
                    }
                }
            }

        }
        return listOfProperties
    }




    public List <String> combineToCreateASingleList (String phenotype,String sampleGroup,
                                                     LinkedHashMap<PhenoKey,List<String>> annotatedList,
                                                     LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties ){
        // the list of properties specific to this data set
        List <String> listOfProperties = []
        int numrec = 0
        String retval
        if (annotatedList){
            if (annotatedList.containsKey(sampleGroup)){
                List <PhenoKey> listForThisPhenotype =  annotatedList [sampleGroup]
                if (listForThisPhenotype) {
                    List <PhenoKey> orderedListOfSampleGroups = listForThisPhenotype.sort{ it.sort_order }
                    numrec = orderedListOfSampleGroups.size()
                    for ( int  i = 0 ; i < orderedListOfSampleGroups.size() ; i++ ){
                        listOfProperties << orderedListOfSampleGroups[i]
                    }
                }
            }

        }
        // now add in the properties that are specific to this phenotype for this data set
        if (phenotypeSpecificSampleGroupProperties){
            if (phenotypeSpecificSampleGroupProperties.containsKey(phenotype)){
                LinkedHashMap hashForThisPhenotype = phenotypeSpecificSampleGroupProperties[phenotype]
                if ((hashForThisPhenotype) && (hashForThisPhenotype.containsKey(sampleGroup))) {
                    List<String> listForThisPhenotype = hashForThisPhenotype[sampleGroup]
                    if (listForThisPhenotype) {
                        numrec += listForThisPhenotype.size()
                        for (int i = 0; i < listForThisPhenotype.size(); i++) {
                            listOfProperties << listForThisPhenotype[i]
                        }
                    }
                }
            }

        }

        return listOfProperties
    }




    //  Create a list, but shift over the elements to reflect depth
    public String packageUpAStaggeredListAsJson ( List <PhenoKey> listOfDataSets  ){
        // now that we have a list, build it into a string suitable for JSON
        int numrec = 0
        StringBuilder sb = new StringBuilder ()
        if ((listOfDataSets) && (listOfDataSets?.size() > 0)){
            numrec = listOfDataSets.size()
            for ( int  i = 0 ; i < numrec ; i++ ){

                StringBuffer scooterBuffer = new StringBuffer();
                for (int j = 0; j < listOfDataSets[i].depth; j++){
                    scooterBuffer.append("_");
                }

                sb << "\"${scooterBuffer.toString()+listOfDataSets[i].toString()}\"".toString()
                if (i < listOfDataSets.size() - 1) {
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



    public String sortAndPackageAMapOfListsAsJson (LinkedHashMap listOfCommonProperties,Boolean sortFirst ){
        // now that we have a list, build it into a string suitable for JSON
        int numberOfProperties = listOfCommonProperties.size()
        int numrec = 0
        StringBuilder sb = new StringBuilder ()
        LinkedHashMap mapToWorkThrough
        if (sortFirst){
            mapToWorkThrough = listOfCommonProperties.sort{it.value.sort_order}
        } else {
            mapToWorkThrough = listOfCommonProperties
        }
        mapToWorkThrough.each{String name, v->
            if (name){
                sb << "\"${name}\"".toString()
                if (numrec < numberOfProperties - 1) {
                    sb << ","
                }
            }
            numrec++

        }
        return  """
{"is_error": false,
"numRecords":${numrec},
"dataset":[${sb.toString()}]
}""".toString()
    }






    public String packageUpATreeAsJson (LinkedHashMap <String,LinkedHashMap<String,List<String>>> bigTree ){
        // now that we have a multilevel tree, build it into a string suitable for JSON
        StringBuilder returnValue = new StringBuilder ()
        if ((bigTree) && (bigTree?.size() > 0)){
            List <String> phenotypeHolder = []
            bigTree.each {String phenotype,  LinkedHashMap phenotypeSpecificSampleGroups->
                StringBuilder sb = new StringBuilder ()
                sb << """  \"${phenotype}\":
    {""".toString()
                if (phenotypeSpecificSampleGroups?.size() > 0){
                    int sampleGroupCount = 0
                    phenotypeSpecificSampleGroups.each { sampleGroupName, propertyNames ->
                        // there is one element that we always need to skip, namely "phenotypeProperties", which contains meta-properties not directly relevant to users
                        if (sampleGroupName == "phenotypeProperties"){
                            sampleGroupCount++
                        }else { // otherwise it's a property users might care about
                            sb << """        \"${sampleGroupName}\":[""".toString()
                            for ( int  i = 0 ; i < propertyNames.size() ; i++ ){
                                sb << "\"${propertyNames[i]}\"".toString()
                                if (i+1<propertyNames.size()){
                                    sb << ","
                                }
                            }
                            sb << """ ]""".toString()
                            sampleGroupCount++
                            if (sampleGroupCount<phenotypeSpecificSampleGroups?.size()){
                                sb << ",".toString()
                            }
                        }
                     }
                }
                sb << """
  }""".toString()
                phenotypeHolder << sb.toString()
            }
            returnValue << "{"
            for ( int  i = 0 ; i < phenotypeHolder.size() ; i++ ){
                returnValue << phenotypeHolder[i]
                if (i+1<phenotypeHolder.size()){
                    returnValue << ","
                }
            }
            returnValue << "}"
        }
        return returnValue.toString()
    }








    public String packageUpSortedHierarchicalListAsJson (LinkedHashMap mapOfStrings ){
        // now that we have a list, build it into a string suitable for JSON
        int numberOfGroups = 0
        StringBuilder sb = new StringBuilder ()

        if ((mapOfStrings) && (mapOfStrings?.size() > 0)){
            LinkedHashMap sortedMapOfStrings = mapOfStrings.sort{ it.key?.sort_order }
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









    /***
     *  urlEncodedListOfPhenotypes delivers the information in the Phenotype domain object
     *  for convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfPhenotypes() {
        List<Phenotype> phenotypeList=Phenotype.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfPhenotypes  =  phenotypeList.size()
        int iterationCount  = 0
        for (Phenotype phenotype in phenotypeList){
            sb<< (phenotype.databaseKey + ":" + phenotype.name )
            iterationCount++
            if (iterationCount  < numberOfPhenotypes){
                sb<< ","
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
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

/***
 * build up a phenotype list
 * @return
 */
    public LinkedHashMap<String,List<LinkedHashMap>> composePhenotypeOptions (){
        LinkedHashMap returnValue = [:]
        List cardioList = []
        Phenotype singlePhenotype = Phenotype.findByName('fasting glucose')
        cardioList << ['mkey':singlePhenotype.databaseKey,'name':singlePhenotype.name]
        for (Phenotype phenotype in Phenotype.list()){
            if ((phenotype.category == 'cardiometabolic') && (phenotype.name != 'fasting glucose')){
                cardioList << ['mkey':phenotype.databaseKey,'name':phenotype.name]
            }
        }
        returnValue ["cardio"] = cardioList
        List otherList = []
        for (Phenotype phenotype in Phenotype.list()){
            if ( phenotype.category == 'other'){
                otherList << ['mkey':phenotype.databaseKey,'name':phenotype.name]
            }
        }
        returnValue ["other"] = otherList
        return returnValue
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



    public String sendTestEmail(){
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to "t2d-error@googlegroups.com"
            subject "Hello"
            body "Test"
        }

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
        if (((parametersToEncode.containsKey("predictedEffects")) && (parametersToEncode["predictedEffects"]))) {
            sb << ("11="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["predictedEffects"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("esValue")) && (parametersToEncode["esValue"]))) {
            sb << ("12="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["esValue"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("esValueInequality")) && (parametersToEncode["esValueInequality"]))) {
            sb << ("13="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["esValueInequality"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("condelSelect")) && (parametersToEncode["condelSelect"]))) {
            sb << ("14="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["condelSelect"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("polyphenSelect")) && (parametersToEncode["polyphenSelect"]))) {
            sb << ("15="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["polyphenSelect"].toString())+"^")
        }
        if (((parametersToEncode.containsKey("siftSelect")) && (parametersToEncode["siftSelect"]))) {
            sb << ("16="+ StringEscapeUtils.escapeJavaScript(parametersToEncode["siftSelect"].toString())+"^")
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


    public LinkedHashMap<String,String>  decodeAFilterList(String encodedFilterString) {
        LinkedHashMap<String,String> returnValue= [:]
        if (encodedFilterString){
            List <String> parametersList =  encodedFilterString.split("\\^")
            int filterCount = 0
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
                    switch (parameterKey){
                        case 1:returnValue ["phenotype"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 2:returnValue ["dataSet"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 3:returnValue ["orValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 4:returnValue ["orValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 5:returnValue ["pValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 6:returnValue ["pValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 7:returnValue ["gene"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 8:returnValue ["regionChromosomeInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 9:returnValue ["regionStartInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 10:returnValue ["regionStopInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 11:returnValue ["predictedEffects"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 12:returnValue ["esValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 13:returnValue ["esValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 14:returnValue ["condelSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 15:returnValue ["polyphenSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 16:returnValue ["siftSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        case 17:returnValue ["filter${filterCount++}"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
                            break
                        default:
                            log.info("Unexpected parameter key  = ${parameterKey}")
                    }
                }
            }
        }
        return  returnValue
    }










public List <LinkedHashMap> convertFormOfFilters(String rawFilters){
    List <LinkedHashMap> returnValue = []
    if (rawFilters){
        List <String> filters = rawFilters.tokenize(',')
        int filterCount = 0
        for (String codedFilter in filters){
            LinkedHashMap dividedFilter = [:]
            List <String> filter = codedFilter.tokenize(':')
            switch (filter[0]){
                case "23":
                    if (filter[1]!="0"){
                        switch (filter[1]){
                            case "1":dividedFilter["predictedEffects"]="protein-truncating"; break;
                            case "2":dividedFilter["predictedEffects"]="missense"; break;
                            case "3":dividedFilter["predictedEffects"]="noEffectSynonymous"; break;
                            case "4":dividedFilter["predictedEffects"]="noEffectNoncoding"; break;
                            default:break
                        }
                    }
                    break;
                case "47":
                    dividedFilter["filter"+(filterCount++)] = filter[1];
                    break;
                default: break;
            }
            if (dividedFilter.size()>0){
                returnValue << dividedFilter
            }
        }
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



class PhenoKey {
    String name
    int sort_order
    int depth

    boolean equals(o) {
        if (this.is(o)) return true
        if (!(o instanceof PhenoKey)) return false

        PhenoKey phenoKey = (PhenoKey) o

        if (name != phenoKey.name) return false

        return true
    }

    int hashCode() {
        return name.hashCode()
    }

    PhenoKey(String name,int sort_order,int depth) {
        this.name=name
        this.sort_order=sort_order
        this.depth=depth
    }

    String toString(){
        return name.toString()
    }

}
