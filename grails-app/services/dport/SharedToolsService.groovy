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
     private static final log = LogFactory.getLog(this)
    JSONObject sharedMetadata = null
    Integer forceMetadataOverride = -1
    Integer showGwas = -1
    Integer showExomeChip = -1
    Integer showExomeSequence = -1
    Integer showSigma = -1
    Integer showGene = -1
    Integer showBeacon = -1
    Integer showNewApi = -1
    Integer dataVersion = 2
    String warningText = ""
    String dataSetPrefix = "mdv"

    Integer helpTextSetting = 1 // 0== never display, 1== display conditionally, 2== always display

    public void setHelpTextSetting(int newHelpTextSetting){
        if ((newHelpTextSetting>-1) && (newHelpTextSetting < 3)) {
            helpTextSetting = newHelpTextSetting
        }else{
            log.error("Attempt to set help text to ${newHelpTextSetting}.  Should be 0, 1, or 2.")
        }
    }

    /**
     * Returns the full dataset version, for example "mdv2"
     */
    public String getDatasetVersion() {
        return dataSetPrefix + dataVersion
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
        showNewApi = (grailsApplication.config.portal.sections.show_new_api)?1:1

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


    public Boolean getMetadataOverrideStatus() {
        return (forceMetadataOverride==1)
    }


    public void setMetadataOverrideStatus(int metadataOverride) {
        this.forceMetadataOverride=metadataOverride
    }



    public Boolean getNewApi() {
        return (showNewApi==1)
    }


    public void setNewApi(showNewApi) {
        this.showNewApi=showNewApi
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
        }
        return sharedMetadata
    }

    /***
     * walk through the metadata tree and pull out things we need
     * @param metadata
     * @return
     */
    public LinkedHashMap processMetadata(JSONObject metadata){
        LinkedHashMap returnValue = [:]
        List <String> captured = []
        LinkedHashMap<String, List <String>> annotatedPhenotypes = [:]
        LinkedHashMap<String, List <String>> annotatedSampleGroups = [:]
        LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties = [:]
        String dataSetVersionThatWeWant = "${dataSetPrefix}${getDataVersion()}"
        if (metadata){
            for (def experiment in metadata.experiments){
                captured << experiment.name
                String dataSetVersion =  experiment.version
                if ((experiment.sample_groups) && (dataSetVersionThatWeWant == dataSetVersion)){
                    getDataSetsPerPhenotype (experiment.sample_groups, annotatedPhenotypes)
                    getPropertiesPerSampleGroupId (experiment.sample_groups, annotatedSampleGroups)
                    getPhenotypeSpecificPropertiesPerSampleGroupId (experiment.sample_groups, phenotypeSpecificSampleGroupProperties)
                }
            }
        }
        returnValue['rootSampleGroups'] = captured
        returnValue['sampleGroupsPerPhenotype'] = annotatedPhenotypes
        returnValue['propertiesPerSampleGroups'] = annotatedSampleGroups
        returnValue['phenotypeSpecificPropertiesPerSampleGroup'] = phenotypeSpecificSampleGroupProperties
        return returnValue
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
                    String propertyName = property.name
                    propertiesForTheSampleGroup << propertyName
                }

            }

//            // Does this sample group have an associated ancestry? If so then let's stick that in and treated as if it is another property
//            if (sampleGroup.ancestry){
//                propertiesForTheSampleGroup << "ANCESTRY= ${sampleGroup.ancestry}"
//            }

            // Finally, does this sample group have a sample group? If so then recursively descend
            if (sampleGroup.sample_groups){
                getPropertiesPerSampleGroupId (sampleGroup.sample_groups, annotatedSampleGroupIds)
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
                    LinkedHashMap<String,String> hashOfPhenotypeSpecificSampleGroups
                    if (annotatedPhenotypeSpecificSampleGroupIds.containsKey(phenotypeName)){
                        hashOfPhenotypeSpecificSampleGroups = annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]
                    } else {
                        hashOfPhenotypeSpecificSampleGroups = new LinkedHashMap()
                        annotatedPhenotypeSpecificSampleGroupIds[phenotypeName]  =  hashOfPhenotypeSpecificSampleGroups
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
                                propertyList<<propertyName
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







    public List <String> extractAPhenotypeList (LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties){
        List <String> listOfProperties = []
        if (phenotypeSpecificSampleGroupProperties){
            phenotypeSpecificSampleGroupProperties.each{ k, v -> listOfProperties <<  "${k}" }
            listOfProperties = listOfProperties.sort ()
        }
        return listOfProperties
    }



    /***
     * Start with a list of lists and manufactures some legal JSON.  Extract a single linear list of every experiment name
     * @param phenotype
     * @param annotatedList
     * @return
     */
    public List <String> extractASingleList (String phenotype, LinkedHashMap<String, List <String>> annotatedList){
        List <String> listOfProperties = []
        if (annotatedList){
            if (annotatedList.containsKey(phenotype)){
                List <String> listForThisPhenotype =  annotatedList [phenotype]
                if (listForThisPhenotype) {
                    for ( int  i = 0 ; i < listForThisPhenotype.size() ; i++ ){
                        listOfProperties << listForThisPhenotype[i]
                    }
                }
            }

        }
        return listOfProperties
    }




    public List <String> combineToCreateASingleList (String phenotype,String sampleGroup,
                                              LinkedHashMap<String, List <String>> annotatedList,
                                              LinkedHashMap<String, LinkedHashMap <String,List<String>>> phenotypeSpecificSampleGroupProperties ){
        // the list of properties specific to this data set
        List <String> listOfProperties = []
        int numrec = 0
        String retval
        if (annotatedList){
            if (annotatedList.containsKey(sampleGroup)){
                List <String> listForThisPhenotype =  annotatedList [sampleGroup]
                if (listForThisPhenotype) {
                    numrec = listForThisPhenotype.size()
                    for ( int  i = 0 ; i < listForThisPhenotype.size() ; i++ ){
                        listOfProperties << listForThisPhenotype[i]
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


    public LinkedHashMap<String, Integer> getGeneExtent (String geneName){
        LinkedHashMap<String, Integer> returnValue  = [startExtent:0,endExtent:3000000000]
        if (geneName)   {
            String geneUpperCase =   geneName.toUpperCase()
            Gene gene = Gene.findByName2(geneUpperCase)
            returnValue.startExtent= gene?.addrStart ?: 0
            returnValue.endExtent= gene?.addrEnd ?: 0
        }
        return returnValue
    }


    public LinkedHashMap<String, Integer> getGeneExpandedExtent (String geneName){
        LinkedHashMap<String, Integer> returnValue  = [startExtent:0,endExtent:3000000000]
        if (geneName)   {
            LinkedHashMap<String, Integer> geneExtent = getGeneExtent (geneName)
            Integer addrStart =  geneExtent.startExtent
            if (addrStart){
                returnValue.startExtent = ((addrStart > 100000)?(addrStart - 100000):0)
            }
            returnValue.endExtent= geneExtent.endExtent+ 100000
        }
        return returnValue
    }


    public String getGeneExpandedRegionSpec(String geneName){
        String returnValue = ""
        if (geneName)   {
            String geneUpperCase =   geneName.toUpperCase()
            Gene gene = Gene.findByName2(geneUpperCase)
            LinkedHashMap<String, Integer> geneExtent = getGeneExpandedExtent (geneName)
            returnValue = "chr${gene.chromosome}:${geneExtent.startExtent}-${geneExtent.endExtent}"
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










}
